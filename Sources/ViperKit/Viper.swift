//
//  Viper.swift
//  ViperKit
//
//  Created by Tibor Bodecs on 2020. 04. 22..
//

///modular viper architecture handler
open class Viper {

    public private(set) var modules: [ViperModule]
    private unowned var app: Application

    /// initialize with viper modules
    public init(app: Application) {
        self.modules = []
        self.app = app
    }

    /// set viper modules
    open func use(_ modules: [ViperModule]) throws {
        self.modules = modules.sorted { $0.priority > $1.priority }
        for module in self.modules {
            try module.configure(self.app)
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
    
    /// invokes a sync hook function and merges the results returned by every module hook function
    open func invokeAllSyncHooks<T>(name: String, req: Request? = nil, type: T.Type, params: [String: Any] = [:]) -> [T] {
        self.modules.map { $0.invokeSync(name: name, req: req, params: params) }.compactMap { $0 as? T }
    }

    /// invokes a sync hook function, returns the first response
    open func invokeSyncHook<T>(name: String, req: Request? = nil, type: T.Type, params: [String: Any] = [:]) -> T? {
        for module in self.modules {
            if let result = module.invokeSync(name: name, req: req, params: params) as? T {
                return result
            }
        }
        return nil
    }
}
