//
//  Application+Leaf.swift
//  ViperKit
//
//  Created by Tibor Bodecs on 2020. 04. 22..
//

public extension Application.Leaf {

    func useViperViews(modulesDirectory: String = "Sources/App/Modules",
                       resourcesDirectory: String = "Resources",
                       viewsFolderName: String = "Views",
                       fileExtension: String = "leaf") {

        self.sources = .singleSource(ViperViewFiles(rootDirectory: self.application.directory.workingDirectory,
                                                    modulesDirectory: modulesDirectory,
                                                    resourcesDirectory: resourcesDirectory,
                                                    viewsFolderName: viewsFolderName,
                                                    fileExtension: fileExtension,
                                                    fileio: self.application.fileio))
    }
}
