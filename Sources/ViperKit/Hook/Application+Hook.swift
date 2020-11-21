//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 11. 21..
//

public extension Application {

    // MARK: - shared hook storage

    private struct HookStorageKey: StorageKey {
        typealias Value = HookStorage
    }

    /// the gobal hooks storage object shared within the entire application
    var hooks: HookStorage {
        get {
            if let existing = storage[HookStorageKey.self] {
                return existing
            }
            let new = HookStorage()
            storage[HookStorageKey.self] = new
            return new
        }
        set {
            storage[HookStorageKey.self] = newValue
        }
    }

    // MARK: - invoke methods with app context

    /// invokes the first hook function with a given name and inserts the app pointer as argument
    func invoke<ReturnType>(_ name: String, args: HookArguments = [:]) -> ReturnType? {
        let ctxArgs = args.merging(["app": self]) { (_, new) in new }
        return hooks.invoke(name, args: ctxArgs)
    }

    /// invokes all the available hook functions with a given name and inserts the app pointer as argument
    func invokeAll<ReturnType>(_ name: String, args: HookArguments = [:]) -> [ReturnType] {
        let ctxArgs = args.merging(["app": self]) { (_, new) in new }
        return hooks.invokeAll(name, args: ctxArgs)
    }
}
