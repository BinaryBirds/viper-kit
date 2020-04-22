//
//  ViperModule.swift
//  ViperKit
//
//  Created by Tibor Bodecs on 2020. 04. 22..
//

import Vapor
import Fluent
import Leaf

/// module component
public protocol ViperModule: AnyObject {
    /// name of the module
    static var name: String { get }
    var name: String { get }
    
    /// relative path of the module
    static var path: String { get }
    var path: String { get }

    /// returned routes will be registered
    var routes: RouteCollection? { get }
    /// returned Fluent database migrations will be registered
    var migrations: [Migration] { get }
    /// returned command  will be registered
    var command: AnyCommand? { get }
    /// returned lifecycle handler will be registered
    var lifecycleHandler: LifecycleHandler? { get }
    /// returned middlewares will be registered
    var middlewares: [Middleware] { get }
    /// returned tags will be registered using Leaf
    var tags: [ViperLeafTag] { get }

    /// configure components in the following order using the app
    /// tags, lifecycleHandler, middlewares, migrations, command, router
    func configure(_ app: Application) throws
    
    /// calls a specific hook function and returns the response as a future
    func invoke(name: String, req: Request, params: [String: Any]) -> EventLoopFuture<Any?>?
}

///default module implementation
public extension ViperModule {

    // name of the module
    var name: String { Self.name }

    /// path of the module is based on the name by default
    static var path: String { Self.name + "/" }
    var path: String { Self.path }

    /// route collection returned by the module
    var routes: RouteCollection? { nil }
    /// migrations returned by the module
    var migrations: [Migration] { [] }
    /// command returned by the module
    var command: AnyCommand? { nil }
    /// lifecycle handler returned by the module
    var lifecycleHandler: LifecycleHandler? { nil }
    /// middlewares returned by the module
    var middlewares: [Middleware] { [] }
    /// returned tags will be registered using Leaf
    var tags: [ViperLeafTag] { [] }
    
    func configure(_ app: Application) throws {
        for tag in self.tags {
            app.leaf.tags[tag.name] = tag
        }
        if let handler = self.lifecycleHandler {
            app.lifecycle.use(handler)
        }
        for middleware in self.middlewares {
            app.middleware.use(middleware)
        }
        for migration in self.migrations {
            app.migrations.add(migration)
        }
        if let command = self.command {
            app.commands.use(command, as: self.name)
        }
        if let router = self.routes {
            try router.boot(routes: app.routes)
        }
    }
    
    /// by default invoke returns nil
    func invoke(name: String, req: Request, params: [String: Any] = [:]) -> EventLoopFuture<Any?>? { nil }
}
