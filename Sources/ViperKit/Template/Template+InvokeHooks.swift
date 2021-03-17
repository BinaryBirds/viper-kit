//
//  +InvokeHooks.swift
//  ViperKit
//
//  Created by Tibor Bodecs on 2020. 11. 21..
//


public struct InvokeHookEntity: UnsafeEntity, NonMutatingMethod, StringReturn {

    public var unsafeObjects: UnsafeObjects? = nil

    public static var callSignature: [CallParameter] { [.string] }

    public init() {}
    
    public func evaluate(_ params: CallValues) -> TemplateData {
        guard let app = app else { return .error("Needs unsafe access to Application") }
        let name = "template-\(params[0].string!)"
        let result: TemplateDataRepresentable? = app.invoke(name)
        return result?.templateData ?? .trueNil
    }
}

public struct InvokeAllHooksEntity: UnsafeEntity, NonMutatingMethod, StringReturn {
    public var unsafeObjects: UnsafeObjects? = nil

    public static var callSignature: [CallParameter] { [.string] }

    public init() {}
    
    public func evaluate(_ params: CallValues) -> TemplateData {
        guard let app = app else { return .error("Needs unsafe access to Application") }
        let name = "template-\(params[0].string!)"
        let result: [TemplateDataRepresentable] = app.invokeAll(name)
        return .array(result.map(\.templateData))
    }
}
