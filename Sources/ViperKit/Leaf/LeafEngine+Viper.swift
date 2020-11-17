//
//  Application+Leaf.swift
//  ViperKit
//
//  Created by Tibor Bodecs on 2020. 04. 22..
//

import Vapor
import Leaf

public extension LeafEngine {
    
    static var modulesSourceKey = "modules"

    static func useViperViews(viewsDirectory: String,
                              workingDirectory: String,
                              modulesLocation: String = "Sources/App/Modules",
                              templatesDirectory: String = "Templates",
                              fileExtension: String = "html",
                              fileio: NonBlockingFileIO) throws {

        rootDirectory = viewsDirectory

        
        let defaultSource = NIOLeafFiles(fileio: fileio,
                                         limits: .default,
                                         sandboxDirectory: viewsDirectory,
                                         viewDirectory: viewsDirectory,
                                         defaultExtension: fileExtension)

        let modulesSource = ViperLeafSource(workingDirectory: workingDirectory,
                                            modulesLocation: modulesLocation,
                                            templatesDirectory: templatesDirectory,
                                            fileExtension: fileExtension,
                                            fileio: fileio)

        let multipleSources = LeafSources()
        try multipleSources.register(using: defaultSource)
        try multipleSources.register(source: modulesSourceKey, using: modulesSource)

        sources = multipleSources
    }
}






