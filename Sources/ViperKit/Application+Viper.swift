//
//  Application+Viper.swift
//  ViperKit
//
//  Created by Tibor Bodecs on 2020. 04. 23..
//

public extension Application {

    private struct ViperKey: StorageKey {
        typealias Value = Viper
    }

    /// storage for the viper component
    var viper: Viper {
        get {
            if let existing = storage[ViperKey.self] {
                return existing
            }
            let new = Viper(app: self)
            storage[ViperKey.self] = new
            return new
        }
        set {
            storage[ViperKey.self] = newValue
        }
    }
}


