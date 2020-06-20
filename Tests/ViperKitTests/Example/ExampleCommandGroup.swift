//
//  ExampleCommandGroup.swift
//  ViperKitTests
//
//  Created by Tibor Bodecs on 2020. 04. 30..
//

import Foundation
import Vapor
@testable import ViperKit

final class ExampleCommandGroup: CommandGroup {
    static let name = "example"
    var help: String = "This is just an example"
    var commands: [String : AnyCommand] = [:]   
}
