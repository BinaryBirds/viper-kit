//
//  ViperMigration.swift
//  ViperKit
//
//  Created by Tibor Bodecs on 2020. 04. 29..
//

/// Fluent migration extension with version and priority support
public protocol ViperMigration: Migration {
    /// migration version, defaults to 1.0.0
    var version: String { get }
    
    /// migration priority, defaults to 1000
    var priority: Int { get }
}

public extension ViperMigration {
    var version: String { "1.0.0" }
    var priority: Int { 1000 }

    var name: String { "\(priority)_\(Self.self)_v\(version)" }
}

