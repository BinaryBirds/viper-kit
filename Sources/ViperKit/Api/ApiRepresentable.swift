//
//  ApiRepresentable.swift
//  ViperKit
//
//  Created by Tibor Bodecs on 2020. 04. 22..
//

import Vapor

public protocol ApiRepresentable {
    associatedtype Input: Content
    associatedtype Output: Content

    init(_: Input) throws
    var output: Output { get }
    func update(_: Input) throws
}
