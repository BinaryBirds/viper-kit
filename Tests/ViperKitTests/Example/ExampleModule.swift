//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 04. 30..
//

import Vapor
import Fluent
@testable import ViperKit

final class ExampleModule: ViperModule {
    static let name = "example"

    var router: ViperRouter? = ExampleRouter()
    var commandGroup: CommandGroup? = ExampleCommandGroup()
    var migrations: [Migration] = [ ExampleMigration() ]
    var tags: [ViperLeafTag] = [ ExampleLeafTag() ]
    
}
