//
//  ViperLeafFunction.swift
//  ViperKit
//
//  Created by Tibor Bodecs on 2020. 04. 22..
//

/// named viper leaf function
public protocol ViperLeafFunction: LeafFunction {
    /// name of the function, you should prefix with the module name (e.g #user_function)
    static var name: String { get }
    var name: String { get }
}

public extension ViperLeafFunction {
    /// name of the function
    var name: String { Self.name }
}
