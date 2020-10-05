//
//  Application+Leaf.swift
//  ViperKit
//
//  Created by Tibor Bodecs on 2020. 04. 22..
//

public extension LeafEngine {

    static func useViperViews(rootDirectory: String,
                              modulesDirectory: String = "Sources/App/Modules",
                              resourcesDirectory: String = "Resources",
                              viewsFolderName: String = "Views",
                              fileExtension: String = "leaf",
                              fileio: NonBlockingFileIO) {

        self.sources = .singleSource(ViperViewFiles(rootDirectory: rootDirectory,
                                                    modulesDirectory: modulesDirectory,
                                                    resourcesDirectory: resourcesDirectory,
                                                    viewsFolderName: viewsFolderName,
                                                    fileExtension: fileExtension,
                                                    fileio: fileio))
    }
}
