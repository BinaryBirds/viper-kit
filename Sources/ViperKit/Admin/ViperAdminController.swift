//
//  ViperAdminController.swift
//  ViperKit
//
//  Created by Tibor Bodecs on 2020. 04. 22..
//

import Vapor
import Fluent

/// Web-based generic CRUD support
public protocol ViperAdminController: ViperController {

    /// the associated model, it should also be able to represent a view context
    associatedtype Model: ViperModel & ViewContextRepresentable
    
    /// the associated edit form
    associatedtype EditForm: Form

    /// id parameter's name in the route
    var idParameterKey: String { get }

    /// this is called before the form rendering happens (used both in createView and updateView)
    func beforeRender(req: Request, form: EditForm) -> EventLoopFuture<Void>
    /// renders the form using the given template
    func render(req: Request, form: EditForm) -> EventLoopFuture<View>
    
    /// the name of the list view template
    var listView: String { get }
    /// builds the query in order to list objects in the admin interface
    func listBuilder(req: Request, queryBuilder: QueryBuilder<Model>) throws -> QueryBuilder<Model>

    /// the name of the edit view template
    var editView: String { get }
    
    /// returns the model based on the id parameter from the request
    func findByIdParameter(_ req: Request) throws -> EventLoopFuture<Model>

    /// setup necessary CRUD routes for the web admin CMS
    func setup(routes: RoutesBuilder, on endpoint: String) -> RoutesBuilder

    /// renders the create form
    func createView(req: Request) throws -> EventLoopFuture<View>
    /// this will be called before the model is saved to the database during the create event
    func beforeCreate(req: Request, model: Model, form: EditForm) -> EventLoopFuture<Model>
    /// create handler for the form submission
    func create(req: Request) throws -> EventLoopFuture<Response>
    
    /// renders the update form filled with the entity
    func updateView(req: Request) throws -> EventLoopFuture<View>
    /// this will be called before the model is updated
    func beforeUpdate(req: Request, model: Model, form: EditForm) -> EventLoopFuture<Model>
    /// update handler for the form submission
    func update(req: Request) throws -> EventLoopFuture<Response>

    /// this will be called before the model is deleted
    func beforeDelete(req: Request, model: Model) -> EventLoopFuture<Model>
    /// deletes a model from the database
    func delete(req: Request) throws -> EventLoopFuture<String>
}

public extension ViperAdminController {
    var idParameterKey: String { "id" }

    var listView: String { "\(Module.name.capitalized)/Admin/\(Model.name.capitalized)/List" }
    var editView: String { "\(Module.name.capitalized)/Admin/\(Model.name.capitalized)/Edit" }

    func listBuilder(req: Request, queryBuilder: QueryBuilder<Model>) throws -> QueryBuilder<Model> {
        queryBuilder
    }
    
    func beforeCreate(req: Request, model: Model, form: EditForm) -> EventLoopFuture<Model> {
        req.eventLoop.future(model)
    }
    
    func beforeUpdate(req: Request, model: Model, form: EditForm) -> EventLoopFuture<Model> {
        req.eventLoop.future(model)
    }

    func beforeDelete(req: Request, model: Model) -> EventLoopFuture<Model> {
        req.eventLoop.future(model)
    }
}

public extension ViperAdminController {
    // MARK: - api

    @discardableResult
    func setup(routes: RoutesBuilder, on endpoint: String) -> RoutesBuilder {
        let base = routes.grouped(.init(stringLiteral: endpoint))
        let idPathComponenet = PathComponent(stringLiteral: ":" + self.idParameterKey)
        let uploadLimit = 10_000_000 //10MB
        base.get(use: self.listView)
        base.get("new", use: self.createView)
        base.on(.POST, "new", body: .collect(maxSize: uploadLimit), use: self.create)
        base.get(idPathComponenet, use: self.updateView)
        base.on(.POST, idPathComponenet, body: .collect(maxSize: uploadLimit), use: self.update)
        base.post(idPathComponenet, "delete", use: self.delete)
        return base
    }

    // MARK: - render

    func beforeRender(req: Request, form: EditForm) -> EventLoopFuture<Void> {
        req.eventLoop.future(())
    }

    func render(req: Request, form: EditForm) -> EventLoopFuture<View> {
        return self.beforeRender(req: req, form: form)
        .flatMap {
            req.view.render(self.editView, EditContext(form))
        }
    }
        
    // MARK: - list

    func listView(req: Request) throws -> EventLoopFuture<View> {
        return try self.listBuilder(req: req, queryBuilder: Model.query(on: req.db)).all()
            .mapEach(\.context)
            .flatMap { req.view.render(self.listView, ListContext($0)) }
    }

    // MARK: - create
    
    func createView(req: Request) throws -> EventLoopFuture<View>  {
        self.render(req: req, form: .init())
    }

    func create(req: Request) throws -> EventLoopFuture<Response> {
        let form = try EditForm(req: req)
        return form.validate(req: req).flatMap { isValid in
            guard isValid else {
                //form.notification = "Could not save model"
                return self.render(req: req, form: form).encodeResponse(for: req)
            }
            let model = Model()
            model.generateId()
            return self.beforeCreate(req: req, model: model, form: form)
            .flatMap { model in
                form.write(to: model as! Self.EditForm.Model)
                return model.create(on: req.db).map {
                    req.redirect(to: model.rawIdentifier)
                }
            }
        }
    }
    // MARK: - update
    
    func updateView(req: Request) throws -> EventLoopFuture<View>  {
        try self.findByIdParameter(req).flatMap { model in
            let form = EditForm()
            form.read(from: model as! Self.EditForm.Model)
            return self.render(req: req, form: form)
        }
    }

    func update(req: Request) throws -> EventLoopFuture<Response> {
        let form = try EditForm(req: req)
        return form.validate(req: req).flatMap { isValid in
            guard isValid else {
                //form.notification = "Could not save model"
                return self.render(req: req, form: form).encodeResponse(for: req)
            }
            do {
                return try self.findByIdParameter(req)
                .flatMap { self.beforeUpdate(req: req, model: $0, form: form) }
                .flatMap { model -> EventLoopFuture<Model> in
                    form.write(to: model as! Self.EditForm.Model)
                    return model.update(on: req.db).map { model }
                }
                .flatMap { model in
                    form.read(from: model as! Self.EditForm.Model)
                    //form.notification = "Model saved"
                    return self.render(req: req, form: form).encodeResponse(for: req)
                }
            }
            catch {
               return req.eventLoop.future(error: error)
            }
        }
    }
    
    // MARK: - delete

    func delete(req: Request) throws -> EventLoopFuture<String> {
        try self.findByIdParameter(req)
            .flatMap { self.beforeDelete(req: req, model: $0) }
            .flatMap { model in model.delete(on: req.db).map { model.rawIdentifier } }
    }
}

public extension ViperAdminController where Model.IDValue == UUID {

    func findByIdParameter(_ req: Request) throws -> EventLoopFuture<Model> {
        guard
            let id = req.parameters.get(self.idParameterKey),
            let uuid = UUID(uuidString: id)
        else {
            throw Abort(.badRequest)
        }

        return Model.find(uuid, on: req.db).unwrap(or: Abort(.notFound))
    }
}
