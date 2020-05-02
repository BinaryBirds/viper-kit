//
//  Application+Leaf.swift
//  
//
//  Created by Tibor Bodecs on 2020. 04. 22..
//

public extension Application.Leaf {

    func useViperViews(modulesDirectory: String = "Sources/App/Modules") {
        self.configuration.rootDirectory = "/"
        self.files = ViperViewFiles(modulesDirectory: modulesDirectory,
                                    using: self.application)
    }
}
