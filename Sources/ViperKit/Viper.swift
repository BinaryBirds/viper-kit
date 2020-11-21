//
//  Viper.swift
//  ViperKit
//
//  Created by Tibor Bodecs on 2020. 04. 22..
//

///modular viper architecture handler
open class Viper {

    public static var modulesLocation: String = "Sources/App/Modules/"

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
            try module.configure(app)
        }
        let _: [Void] = app.invokeAll("routes", args: ["routes": app.routes])
    }
}
