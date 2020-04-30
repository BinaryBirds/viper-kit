//
//  ViperRouter.swift
//  ViperKit
//
//  Created by Tibor Bodecs on 2020. 04. 29..
//

import Vapor

/// custom router protocol
public protocol ViperRouter {
    
    func boot(routes: RoutesBuilder, app: Application) throws

    /// hooks to a given set of routes based on the name
    func hook(name: String, routes: RoutesBuilder, app: Application) throws

    /// invokes the hook functions, with the given name
    func invoke(name: String, routes: RoutesBuilder, app: Application) throws
}

public extension ViperRouter {
    
    func hook(name: String, routes: RoutesBuilder, app: Application) throws {
        
    }

    func invoke(name: String, routes: RoutesBuilder, app: Application) throws {
        for module in app.viper.modules {
            try module.router?.hook(name: name, routes: routes, app: app)
        }
    }
    
}
