//
//  Application+Leaf.swift
//  
//
//  Created by Tibor Bodecs on 2020. 04. 22..
//

public extension Application.Leaf {

    func useViperViews(modulesDirectory: String = "Sources/App/Modules",
                       viewsDirectory: String = "Views",
                       resourcesDirectory: String = "Resources",
                       fileExtension: String = "leaf") {
        self.configuration.rootDirectory = "/"
        self.files = ViperViewFiles(modulesDirectory: modulesDirectory,
                                    viewsDirectory: viewsDirectory,
                                    resourcesDirectory: resourcesDirectory,
                                    fileExtension: fileExtension,
                                    using: self.application)
    }
}
