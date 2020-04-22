//
//  Viper.swift
//  ViperKit
//
//  Created by Tibor Bodecs on 2020. 04. 22..
//

import Vapor

///modular viper architecture handler
open class Viper {

    public let modules: [ViperModule]

    /// initialize with viper modules
    public init(_ modules: [ViperModule]) {
        self.modules = modules
    }
    
    /// configures all the modules using the app
    open func configure(_ app: Application) throws {
        for module in modules {
            try module.configure(app)
        }
    }

    /// invokes a hook function and merges the results returned by every module hook function
    open func invokeAllHooks<T>(name: String, req: Request, type: T.Type, params: [String: Any] = [:]) -> EventLoopFuture<[T]> {
        let result = self.modules.map { $0.invoke(name: name, req: req, params: params) }
        return req.eventLoop.flatten(result.compactMap { $0 })
            .map { items -> [T] in
                return items.compactMap { $0 as? [T] }.flatMap { $0 }
            }
    }

    /// invokes a hook function, returns the first response
    open func invokeHook<T>(name: String, req: Request, type: T.Type, params: [String: Any] = [:]) -> EventLoopFuture<T?> {
        let result = self.modules.map { $0.invoke(name: name, req: req, params: params) }

        let initial: EventLoopFuture<T?> = req.eventLoop.future(nil)
        let folded = initial.fold(result.compactMap { $0 }) { (response: T?, value: Any?) -> EventLoopFuture<T?> in
            if let newResponse = value as? T {
                return req.eventLoop.future(newResponse)
            }
            return req.eventLoop.future(response)
        }
        return folded
    }

}
