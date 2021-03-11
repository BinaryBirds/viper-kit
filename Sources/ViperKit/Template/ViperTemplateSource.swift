//
//  ViperTemplateSource.swift
//  ViperKit
//
//  Created by Tibor Bodecs on 2020. 11. 18..
//

public struct ViperTemplateSource: NonBlockingFileIOSource {

    /// application working directory
    public let workingDirectory: String
    /// parent location of the module directory (e.g. Sources/App/Modules)
    public let modulesLocation: String
    /// name of the templates dir
    public let templatesDirectory: String
    /// default file extension
    public let fileExtension: String
    /// fileio handle
    public let fileio: NonBlockingFileIO
    
    public init(workingDirectory: String,
                modulesLocation: String,
                templatesDirectory: String,
                fileExtension: String,
                fileio: NonBlockingFileIO)
    {
        self.workingDirectory = workingDirectory
        self.modulesLocation = modulesLocation
        self.templatesDirectory = templatesDirectory
        self.fileExtension = fileExtension
        self.fileio = fileio
    }

    public func file(template: String, escape: Bool = false, on eventLoop: EventLoop) -> EventLoopFuture<ByteBuffer> {
        let ext = "." + fileExtension
        let components = template.split(separator: "/")
        let pathComponents = [String(components.first!), templatesDirectory] + components.dropFirst().map { String($0) }
        let moduleFile = modulesLocation + "/" + pathComponents.joined(separator: "/") + ext
        return read(path: workingDirectory + moduleFile, on: eventLoop)
    }
}
