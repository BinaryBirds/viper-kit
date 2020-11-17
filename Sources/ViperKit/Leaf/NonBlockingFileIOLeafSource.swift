//
//  NonBlockingFileIOLeafSource.swift
//  ViperKit
//
//  Created by Tibor Bodecs on 2020. 11. 18..
//

import Leaf

public protocol NonBlockingFileIOLeafSource: LeafSource {

    var fileio: NonBlockingFileIO { get }
    
    func read(path: String, on eventLoop: EventLoop) -> EventLoopFuture<ByteBuffer>
}

public extension NonBlockingFileIOLeafSource {

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
