//
//  ViperRouter.swift
//  ViperKit
//
//  Created by Tibor Bodecs on 2020. 04. 29..
//

/// custom router protocol
public protocol ViperRouter: RouteCollection {

    
}

public extension ViperRouter {
    func boot(routes: RoutesBuilder) throws {}
}
