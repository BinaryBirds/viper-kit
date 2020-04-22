//
//  ViewContexts.swift
//  ViperKit
//
//  Created by Tibor Bodecs on 2020. 04. 22..
//

import Foundation

/// returns a contexts for the rendered views
public protocol ViewContextRepresentable {
    /// generic context type
    associatedtype Context: Encodable

    /// returns the context object
    var context: Context { get }
}

/// a generic list context for rendering list items
public struct ListContext<T: Encodable>: Encodable {
    /// encodable list property
    public var list: [T]
    
    public init(_ list: [T]) {
        self.list = list
    }
}

/// a generic edit context for rendering forms
public struct EditContext<T: Encodable>: Encodable {
    /// encodable edit property
    public var edit: T
    
    public init(_ edit: T) {
        self.edit = edit
    }
}
