//
//  ExampleLeafFunction.swift
//  ViperKitTests
//
//  Created by Tibor Bodecs on 2020. 04. 30..
//

import Leaf
@testable import ViperKit

struct ExampleLeafFunction: ViperLeafFunction, LeafUnsafeEntity, StringReturn {
    static let name = "example"

    static var callSignature: [LeafCallParameter]  { [] }
    
    var externalObjects: ExternalObjects? = nil
    
    func evaluate(_ params: LeafCallValues) -> LeafData { .string("example") }
}
