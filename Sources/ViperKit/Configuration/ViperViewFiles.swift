//
//  ViperViewFiles.swift
//  ViperKit
//
//  Created by Tibor Bodecs on 2020. 04. 22..
//

import Vapor
import Leaf

struct ViperViewFiles: LeafFiles {

    var rootDirectory: String
    var modulesDirectory: String
    var nioLeafFiles: NIOLeafFiles
    
    init(modulesDirectory: String, using app: Application) {
        self.rootDirectory = app.directory.workingDirectory
        self.modulesDirectory = modulesDirectory
        self.nioLeafFiles = NIOLeafFiles(fileio: app.fileio)
    }

    func file(path: String, on eventLoop: EventLoop) -> EventLoopFuture<ByteBuffer> {
        let viewsDir = "Views"
        let resourcesPath = "Resources/" + viewsDir
        let ext = ".leaf"

        let name = path.replacingOccurrences(of: ext, with: "")
        let resourceFile = resourcesPath + name + ext
        if FileManager.default.fileExists(atPath: resourceFile) {
            return self.nioLeafFiles.file(path: self.rootDirectory + resourceFile, on: eventLoop)
        }
        let components = name.split(separator: "/")
        let pathComponents = [String(components.first!), viewsDir] + components.dropFirst().map { String($0) }
        let moduleFile = self.modulesDirectory + "/" + pathComponents.joined(separator: "/") + ext

        return self.nioLeafFiles.file(path: self.rootDirectory + moduleFile, on: eventLoop)
    }
}
