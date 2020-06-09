//
//  ViperViewFiles.swift
//  ViperKit
//
//  Created by Tibor Bodecs on 2020. 04. 22..
//

struct ViperViewFiles: LeafFiles {

    /// root directory of the project
    private(set) var rootDirectory: String
    /// modules directory
    private(set) var modulesDirectory: String
    /// views directory name
    private(set) var viewsDirectory: String
    /// resources directory name
    private(set) var resourcesDirectory: String
    /// file extension
    private(set) var fileExtension: String
    /// nio leaf files pointer
    private(set) var nioLeafFiles: NIOLeafFiles

    init(modulesDirectory: String,
         viewsDirectory: String,
         resourcesDirectory: String,
         fileExtension: String,
         using app: Application) {

        self.rootDirectory = app.directory.workingDirectory
        self.modulesDirectory = modulesDirectory
        self.viewsDirectory = viewsDirectory
        self.resourcesDirectory = resourcesDirectory
        self.fileExtension = fileExtension
        self.nioLeafFiles = NIOLeafFiles(fileio: app.fileio)
    }

    func file(path: String, on eventLoop: EventLoop) -> EventLoopFuture<ByteBuffer> {
        let resourcesPath = self.resourcesDirectory + "/" + self.viewsDirectory
        let ext = "." + self.fileExtension
        let name = path.replacingOccurrences(of: ".leaf", with: "")
        let resourceFile = resourcesPath + name + ext
        if FileManager.default.fileExists(atPath: resourceFile) {
            return self.nioLeafFiles.file(path: self.rootDirectory + resourceFile, on: eventLoop)
        }
        let components = name.split(separator: "/")
        let pathComponents = [String(components.first!), self.viewsDirectory] + components.dropFirst().map { String($0) }
        let moduleFile = self.modulesDirectory + "/" + pathComponents.joined(separator: "/") + ext
        return self.nioLeafFiles.file(path: self.rootDirectory + moduleFile, on: eventLoop)
    }
}
