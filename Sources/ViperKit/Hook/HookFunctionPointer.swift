//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 11. 21..
//

public final class HookFunctionPointer {

    public var name: String
    public var pointer: HookFunction
    public var returnType: Any.Type
    
    public init(name: String, function: HookFunction, returnType: Any.Type) {
        self.name = name
        self.pointer = function
        self.returnType = returnType
    }
}
