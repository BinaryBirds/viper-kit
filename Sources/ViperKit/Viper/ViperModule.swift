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

    /// module priority
    var priority: Int { get }

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
    
    static var bundleUrl: URL? { get }
    var bundleUrl: URL? { get }

    /// configure components in the following order using the app
    /// leaf functions, lifecycleHandler, middlewares, migrations, command, router
    func configure(_ app: Application) throws

    /// boots the module as the first step of the configuration flow
    func boot(_ app: Application) throws
    
    static func sample(asset name: String) -> String
}

///default module implementation
public extension ViperModule {

    // name of the module
    var name: String { Self.name }
    
    /// default module priority 
    var priority: Int { 1000 }

    /// path of the module is based on the name by default
    static var path: String { Self.name + "/" }
    var path: String { Self.path }
    
    /// path component based on the module name
    static var pathComponent: PathComponent { .init(stringLiteral: name) }

    var router: ViperRouter? { nil }
    /// migrations returned by the module
    var migrations: [Migration] { [] }
    /// command returned by the module
    var commandGroup: CommandGroup? { nil }
    /// lifecycle handler returned by the module
    var lifecycleHandler: LifecycleHandler? { nil }
    /// middlewares returned by the module
    var middlewares: [Middleware] { [] }

    /// bundle url of the module
    static var bundleUrl: URL? { nil }
    var bundleUrl: URL? { Self.bundleUrl }

    /// boots the module as the first step of the configuration flow
    func boot(_ app: Application) throws {}

    func configure(_ app: Application) throws {
        try self.boot(app)

        if let handler = lifecycleHandler {
            app.lifecycle.use(handler)
        }
        for middleware in middlewares {
            app.middleware.use(middleware)
        }
        for migration in migrations {
            app.migrations.add(migration)
        }
        if let commandGroup = commandGroup {
            app.commands.use(commandGroup, as: name)
        }
        if let router = router {
            try router.boot(routes: app.routes)
        }
    }
    
    static func sample(asset name: String) -> String {
        guard let bundleUrl = self.bundleUrl else {
            fatalError("Missing module bundle")
        }
        do {
            let fileUrl = bundleUrl.appendingPathComponent("Samples").appendingPathComponent(name)
            return try String(contentsOf: fileUrl, encoding: .utf8)
        }
        catch {
            fatalError(error.localizedDescription)
        }
    }
}
