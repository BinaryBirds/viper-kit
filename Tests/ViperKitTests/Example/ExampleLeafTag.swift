//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 04. 30..
//

import Leaf
@testable import ViperKit

struct ExampleLeafTag: ViperLeafTag {
    static let name = "example"
    
    func render(_ ctx: LeafContext) throws -> LeafData {
        return .string("example")
    }
}
