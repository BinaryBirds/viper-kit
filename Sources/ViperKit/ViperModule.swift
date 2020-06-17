//
//  ViperModule.swift
//  ViperKit
//
//  Created by Tibor Bodecs on 2020. 04. 22..
//

/// module component
public protocol ViperModule {
    /// name of the module
    static var name: String { get }
    var name: String { get }
    
    /// relative path of the module
    static var path: String { get }
    var path: String { get }
    
    /// path component based
    static var pathComponent: PathComponent { get }

    /// viper router object
    var router: ViperRouter? { get }
    /// returned Fluent database migrations will be registered
    var migrations: [Migration] { get }
    /// returned command  will be registered
    var commandGroup: CommandGroup? { get }
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
    
    /// transforms a content value into something else
    func contentFilter(_ input: String) -> String
}

///default module implementation
public extension ViperModule {

    // name of the module
    var name: String { Self.name }

    /// path of the module is based on the name by default
    static var path: String { Self.name + "/" }
    var path: String { Self.path }
    
    /// path component based on the module name
    static var pathComponent: PathComponent { .init(stringLiteral: self.name) }

    var router: ViperRouter? { nil }
    /// migrations returned by the module
    var migrations: [Migration] { [] }
    /// command returned by the module
    var commandGroup: CommandGroup? { nil }
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
        if let commandGroup = self.commandGroup {
            app.commands.use(commandGroup, as: self.name)
        }
        if let router = self.router {
            try router.boot(routes: app.routes, app: app)
        }
    }
    
    /// by default invoke returns nil
    func invoke(name: String, req: Request, params: [String: Any] = [:]) -> EventLoopFuture<Any?>? { nil }
    
    /// content filter returns the input by default
    func contentFilter(_ input: String) -> String { input }
}
