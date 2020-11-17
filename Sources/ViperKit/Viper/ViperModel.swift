//
//  ViperModel.swift
//  ViperKit
//
//  Created by Tibor Bodecs on 2020. 04. 22..
//

/// viper model
public protocol ViperModel: Model {
    /// associated viper module
    associatedtype Module: ViperModule

    /// pluar name of the model
    static var name: String { get }
    
    /// path of the model relative to the module (e.g. Module/Model/) can be used as a location or key
    static var path: String { get }
    
    /// path component
    static var pathComponent: PathComponent { get }
}

/// default viper model extension
public extension ViperModel {
    /// schema is always prefixed with the module name
    static var schema: String { Module.name + "_" + Self.name }
    
    /// path of the model relative to the module (e.g. Module/Model/)
    static var path: String { Module.path + Self.name + "/" }
    
    /// path component based on the model name
    static var pathComponent: PathComponent { .init(stringLiteral: name) }
}
