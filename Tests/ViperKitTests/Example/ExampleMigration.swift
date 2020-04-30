//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 04. 30..
//

import Fluent
@testable import ViperKit

struct ExampleMigration: ViperMigration {

    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.eventLoop.future()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.eventLoop.future()
    }   
}
