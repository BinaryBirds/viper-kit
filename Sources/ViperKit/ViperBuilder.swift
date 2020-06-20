//
//  ViperBuilder.swift
//  ViperKit
//
//  Created by Tibor Bodecs on 2020. 05. 02..
//

open class ViperBuilder {

    public init() {}
    
    open func build() -> ViperModule {
        fatalError("The abstract ViperBuilder can't build any modules.")
    }
}
