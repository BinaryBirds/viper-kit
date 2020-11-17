//
//  ViperInstaller.swift
//  ViperKit
//
//  Created by Tibor Bodecs on 2020. 11. 17..
//

public protocol ViperInstaller {
    func variables() -> [[String: Any]]
    func createModels(_: Request) -> EventLoopFuture<Void>?
}

public extension ViperInstaller {
    func variables() -> [[String: Any]] { [] }
    func createModels(_: Request) -> EventLoopFuture<Void>? { nil }
}
