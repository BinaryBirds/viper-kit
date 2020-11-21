//
//  Leaf+InvokeHooks.swift
//  ViperKit
//
//  Created by Tibor Bodecs on 2020. 11. 21..
//

import Leaf

public struct InvokeHookLeafEntity: LeafUnsafeEntity, LeafNonMutatingMethod, StringReturn {

    public var unsafeObjects: UnsafeObjects? = nil

    public static var callSignature: [LeafCallParameter] { [.string] }

    public init() {}
    
    public func evaluate(_ params: LeafCallValues) -> LeafData {
        guard let app = app else { return .error("Needs unsafe access to Application") }
        let name = "leaf-\(params[0].string!)"
        let result: LeafDataRepresentable? = app.hooks.invoke(name)
        return result?.leafData ?? .trueNil
    }
}

public struct InvokeAllHooksLeafEntity: LeafUnsafeEntity, LeafNonMutatingMethod, StringReturn {
    public var unsafeObjects: UnsafeObjects? = nil

    public static var callSignature: [LeafCallParameter] { [.string] }

    public init() {}
    
    public func evaluate(_ params: LeafCallValues) -> LeafData {
        guard let app = app else { return .error("Needs unsafe access to Application") }
        let name = "leaf-\(params[0].string!)"
        let result: [LeafDataRepresentable] = app.hooks.invokeAll(name)
        return .array(result.map(\.leafData))
    }
}
