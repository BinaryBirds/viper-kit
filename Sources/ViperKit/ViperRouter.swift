//
//  ViperRouter.swift
//  ViperKit
//
//  Created by Tibor Bodecs on 2020. 04. 29..
//

import Vapor

/// custom router protocol
public protocol ViperRouter {
    /// boots the routes when the application starts
    func boot(routes: RoutesBuilder, using: Application) throws

    /// hooks given routes based on the given name
    func hook(name: String, routes: RoutesBuilder, using: Application) throws
}

public extension ViperRouter {
    func hook(name: String, routes: RoutesBuilder, using: Application) throws {}
}
