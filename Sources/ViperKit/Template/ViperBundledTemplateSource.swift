//
//  ViperBundledTemplateSource.swift
//  ViperKit
//
//  Created by Tibor Bodecs on 2020. 11. 21..
//

public struct ViperBundledTemplateSource: NonBlockingFileIOSource {

    let module: String
    /// root directory
    let rootDirectory: String
    /// root directory
    let templatesDirectory: String
    /// file extension
    let fileExtension: String
    /// fileio used to read files
    public let fileio: NonBlockingFileIO
    
    public init(module: String,
                rootDirectory: String,
                templatesDirectory: String,
                fileExtension: String,
                fileio: NonBlockingFileIO) {
        self.module = module
        self.rootDirectory = rootDirectory
        self.templatesDirectory = templatesDirectory
        self.fileExtension = fileExtension
        self.fileio = fileio
    }

    /// file template function implementation
    public func file(template: String, escape: Bool = false, on eventLoop: EventLoop) -> EventLoopFuture<ByteBuffer> {
        let name = template.split(separator: "/").first!.lowercased()
        let path = template.split(separator: "/").dropFirst().map { String($0) }.joined(separator: "/")
        
        let fileUrl = URL(fileURLWithPath: rootDirectory)
            .appendingPathComponent(templatesDirectory)
            .appendingPathComponent(path)
            .appendingPathExtension(fileExtension)

        if module == name {
            return read(path: fileUrl.path, on: eventLoop)
        }
        return eventLoop.future(error: TemplateError(.noTemplateExists(path)))
    }
}
