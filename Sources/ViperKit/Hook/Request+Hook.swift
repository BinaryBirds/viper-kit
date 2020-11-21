//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 11. 21..
//

public extension Request {

    /// invokes the first hook function with a given name and inserts the app & req pointers as arguments
    func invoke<ReturnType>(_ name: String, args: HookArguments = [:]) -> ReturnType? {
        let ctxArgs = args.merging(["req": self, "app": application]) { (_, new) in new }
        return application.hooks.invoke(name, args: ctxArgs)
    }

    /// invokes all the available hook functions with a given name and inserts the app & req pointers as arguments
    func invokeAll<ReturnType>(_ name: String, args: HookArguments = [:]) -> [ReturnType] {
        let ctxArgs = args.merging(["req": self, "app": application]) { (_, new) in new }
        return application.hooks.invokeAll(name, args: ctxArgs)
    }
}
