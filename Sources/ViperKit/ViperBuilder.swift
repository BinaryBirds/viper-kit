//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 05. 02..
//

import Vapor

open class ViperBuilder {

    public init() {}
    
    open func build() -> ViperModule {
        fatalError("The abstract ViperBuilder can't build any modules.")
    }
}
