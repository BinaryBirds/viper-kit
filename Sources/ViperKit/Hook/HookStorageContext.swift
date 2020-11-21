//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 11. 21..
//


public final class HookStorage {
    
    private var pointers: [HookFunctionPointer]

    public init() {
        self.pointers = []
    }

    public func register<ReturnType>(_ name: String, use block: @escaping HookFunctionSignature<ReturnType>) {
        let function = AnonymousHookFunction { args -> Any in
            block(args)
        }
        let pointer = HookFunctionPointer(name: name, function: function, returnType: ReturnType.self)
        pointers.append(pointer)
    }

    /// invokes the first hook function with a given name and the provided arguments
    public func invoke<ReturnType>(_ name: String, args: HookArguments = [:]) -> ReturnType? {
        pointers.first { $0.name == name && $0.returnType == ReturnType.self }?.pointer.invoke(args) as? ReturnType
    }

    /// invokes all the available hook functions with a given name 
    public func invokeAll<ReturnType>(_ name: String, args: HookArguments = [:]) -> [ReturnType] {
        pointers.filter { $0.name == name && $0.returnType == ReturnType.self }.compactMap { $0.pointer.invoke(args) as? ReturnType }
    }
}
