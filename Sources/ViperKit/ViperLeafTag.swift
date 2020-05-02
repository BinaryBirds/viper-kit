//
//  ViperLeafTag.swift
//  ViperKit
//
//  Created by Tibor Bodecs on 2020. 04. 22..
//

/// named viper leaf tag
public protocol ViperLeafTag: LeafTag {
    /// name of the tag, you should prefix with the module name (e.g #user_tag)
    static var name: String { get }
    var name: String { get }
}

public extension ViperLeafTag {
    /// name of the tag
    var name: String { Self.name }
}
