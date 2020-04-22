//
//  ViperApiController.swift
//  ViperKit
//
//  Created by Tibor Bodecs on 2020. 04. 22..
//

import Vapor
import Fluent

/// Api-based generic CRUD support
public protocol ViperApiController {
    var idParamKey: String { get }

    associatedtype Model: ViperModel & ApiRepresentable

    func getModelID(_: String) throws -> Model.IDValue

    func setup(routes: RoutesBuilder, on endpoint: String)

    func create(_: Request) throws -> EventLoopFuture<Model.Output>
    func retrieve(_: Request) throws -> EventLoopFuture<[Model.Output]>
    func read(_: Request) throws -> EventLoopFuture<Model.Output>
    func update(_: Request) throws -> EventLoopFuture<Model.Output>
    func delete(_: Request) throws -> EventLoopFuture<HTTPStatus>
}

public extension ViperApiController {

    private func find(_ req: Request) throws -> EventLoopFuture<Model> {
        guard let rawValue = req.parameters.get(self.idParamKey) else {
            throw Abort(.badRequest)
        }
        let id = try self.getModelID(rawValue)
        return Model.find(id, on: req.db).unwrap(or: Abort(.notFound))
    }

    func setup(routes: RoutesBuilder, on endpoint: String) {
        let base = routes.grouped(PathComponent(stringLiteral: endpoint))
        let idPathComponent = PathComponent(stringLiteral: ":\(self.idParamKey)")
        
        base.post(use: self.create)
        base.get(use: self.retrieve)
        base.get(idPathComponent, use: self.read)
        base.put(idPathComponent, use: self.update)
        base.delete(idPathComponent, use: self.delete)
    }

    var idParamKey: String { "id" }

    func create(_ req: Request) throws -> EventLoopFuture<Model.Output> {
        let input = try req.content.decode(Model.Input.self)
        let model = try Model(input)
        return model.save(on: req.db).map { _ in
            return model.output
        }
    }
    
    func retrieve(_ req: Request) throws -> EventLoopFuture<[Model.Output]> {
        Model.query(on: req.db).all().mapEach(\.output)
    }

    func read(_ req: Request) throws -> EventLoopFuture<Model.Output> {
        try self.find(req).map(\.output)
    }

    func update(_ req: Request) throws -> EventLoopFuture<Model.Output> {
        let input = try req.content.decode(Model.Input.self)
        return try self.find(req)
        .flatMapThrowing { model -> Model in
            try model.update(input)
            return model
        }
        .flatMap { model -> EventLoopFuture<Model.Output> in
            return model.update(on: req.db).map { model.output }
        }
    }
    
    func delete(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        try self.find(req).flatMap { $0.delete(on: req.db) }.map { .ok }
    }
}

public extension ViperApiController where Model.IDValue == UUID {

    func getModelID(_ rawValue: String) throws -> Model.IDValue {
        guard let id = UUID(uuidString: rawValue) else {
            throw Abort(.badRequest)
        }
        return id
    }
}
