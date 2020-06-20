//
//  ViperViewFiles.swift
//  ViperKit
//
//  Created by Tibor Bodecs on 2020. 04. 22..
//

struct ViperViewFiles: LeafSource {
    /// root directory of the project
    let rootDirectory: String
    /// modules directory
    let modulesDirectory: String
    /// resources directory name
    let resourcesDirectory: String
    /// views folder name
    let viewsFolderName: String
    /// file extension
    let fileExtension: String
    /// fileio used to read files
    let fileio: NonBlockingFileIO

    /// standard init method
    init(rootDirectory: String,
         modulesDirectory: String,
         resourcesDirectory: String,
         viewsFolderName: String,
         fileExtension: String,
         fileio: NonBlockingFileIO) {

        self.rootDirectory = rootDirectory
        self.modulesDirectory = modulesDirectory
        self.resourcesDirectory = resourcesDirectory
        self.viewsFolderName = viewsFolderName
        self.fileExtension = fileExtension
        self.fileio = fileio
    }

    /// file template function implementation
    func file(template: String, escape: Bool = false, on eventLoop: EventLoop) -> EventLoopFuture<ByteBuffer> {
        let resourcesPath = self.resourcesDirectory + "/" + self.viewsFolderName + "/"
        let ext = "." + self.fileExtension
        let resourceFile = resourcesPath + template + ext
        if FileManager.default.fileExists(atPath: resourceFile) {
            return self.read(path: self.rootDirectory + resourceFile, on: eventLoop)
        }
        let components = template.split(separator: "/")
        let pathComponents = [String(components.first!), self.viewsFolderName] + components.dropFirst().map { String($0) }
        let moduleFile = self.modulesDirectory + "/" + pathComponents.joined(separator: "/") + ext
        return self.read(path: self.rootDirectory + moduleFile, on: eventLoop)
    }

    /// reads an existing file and returns a byte buffer future
    private func read(path: String, on eventLoop: EventLoop) -> EventLoopFuture<ByteBuffer> {
        self.fileio.openFile(path: path, eventLoop: eventLoop)
        .flatMapErrorThrowing { _ in throw LeafError(.noTemplateExists(path)) }
        .flatMap { handle, region in
            self.fileio.read(fileRegion: region, allocator: .init(), eventLoop: eventLoop)
            .flatMapThrowing { buffer in
                try handle.close()
                return buffer
            }
        }
    }
}
