//
//  ViperController.swift
//  ViperKit
//
//  Created by Tibor Bodecs on 2020. 04. 22..
//

import Vapor
import Fluent

/// viper controller
public protocol ViperController {
    /// associated viper module
    associatedtype Module: ViperModule
    
    /// standard init method
    init()
}
