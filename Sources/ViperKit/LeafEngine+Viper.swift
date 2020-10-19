//
//  Application+Leaf.swift
//  ViperKit
//
//  Created by Tibor Bodecs on 2020. 04. 22..
//

import Vapor
import Leaf

protocol FileIOLeafSource: LeafSource {

    var fileio: NonBlockingFileIO { get }
    
    func read(path: String, on eventLoop: EventLoop) -> EventLoopFuture<ByteBuffer>
}

extension FileIOLeafSource {
    func read(path: String, on eventLoop: EventLoop) -> EventLoopFuture<ByteBuffer> {
        fileio.openFile(path: path, eventLoop: eventLoop)
        .flatMapErrorThrowing { _ in throw LeafError(.noTemplateExists(path)) }
        .flatMap { handle, region in
            fileio.read(fileRegion: region, allocator: .init(), eventLoop: eventLoop)
            .flatMapThrowing { buffer in
                try handle.close()
                return buffer
            }
        }
    }
}

struct ModuleViewsLeafSource: FileIOLeafSource {

    let workingDirectory: String
    let modulesLocation: String
    let moduleViewsLocation: String
    let fileExtension: String
    let fileio: NonBlockingFileIO

    func file(template: String, escape: Bool = false, on eventLoop: EventLoop) -> EventLoopFuture<ByteBuffer> {
        let ext = "." + fileExtension
        let components = template.split(separator: "/")
        let pathComponents = [String(components.first!), moduleViewsLocation] + components.dropFirst().map { String($0) }
        let moduleFile = modulesLocation + "/" + pathComponents.joined(separator: "/") + ext
        return read(path: workingDirectory + moduleFile, on: eventLoop)
    }
}

public extension LeafEngine {
    
    static var modulesSourceKey = "modules"

    static func useViperViews(viewsDirectory: String,
                              workingDirectory: String,
                              modulesLocation: String = "Sources/App/Modules",
                              moduleViewsLocation: String = "Views",
                              fileExtension: String = "leaf",
                              fileio: NonBlockingFileIO) throws {

        rootDirectory = viewsDirectory

        
        let defaultSource = NIOLeafFiles(fileio: fileio,
                                         limits: .default,
                                         sandboxDirectory: viewsDirectory,
                                         viewDirectory: viewsDirectory,
                                         defaultExtension: fileExtension)

        let modulesSource = ModuleViewsLeafSource(workingDirectory: workingDirectory,
                                                  modulesLocation: modulesLocation,
                                                  moduleViewsLocation: moduleViewsLocation,
                                                  fileExtension: fileExtension,
                                                  fileio: fileio)

        let multipleSources = LeafSources()
        try multipleSources.register(using: defaultSource)
        try multipleSources.register(source: modulesSourceKey, using: modulesSource)

        sources = multipleSources
    }
}

