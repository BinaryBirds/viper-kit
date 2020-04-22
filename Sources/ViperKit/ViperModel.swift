//
//  ViperModel.swift
//  ViperKit
//
//  Created by Tibor Bodecs on 2020. 04. 22..
//

import Vapor
import Fluent

/// viper model
public protocol ViperModel: Model {
    /// associated viper module
    associatedtype Module: ViperModule

    /// pluar name of the model
    static var name: String { get }
    
    /// path of the model relative to the module (e.g. Module/Model/) can be used as a location or key
    static var path: String { get }
    
    /// geneates a new identifier for the model
    func generateId()

    /// returns the identifier as a raw string
    var rawIdentifier: String { get }
}

/// default viper model extension
public extension ViperModel {
    /// schema is always prefixed with the module name
    static var schema: String { Module.name + "_" + Self.name }
    
    /// path of the model relative to the module (e.g. Module/Model/)
    static var path: String { Module.path + Self.name + "/" }
}

/// ViperModel works with UUID based id values by default
public extension ViperModel where Self.IDValue == UUID {

    /// returns the UUID as a string value
    var rawIdentifier: String {
        self.id!.uuidString
    }

    /// sets a new randomly generated UUID as the id
    func generateId() {
        self.id = UUID()
    }
}
