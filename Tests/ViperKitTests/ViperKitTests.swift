//
//  ViperKitTests.swift
//  ViperKitTests
//
//  Created by Tibor Bodecs on 2020. 04. 30..
//

import XCTest
@testable import ViperKit

final class ViperKitTests: XCTestCase {
   
    func testExample() throws {
        let module = ExampleModule()
        _ = try XCTUnwrap(module.router)
        XCTAssertTrue(true)
    }

    func testViperViewFilesConfig() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        app.directory.workingDirectory = Environment.get("WORKING_DIR")!
        app.views.use(.leaf)
        app.leaf.useViperViews(modulesDirectory: "Tests/ViperKitTests",
                               resourcesDirectory: "Resources",
                               viewsFolderName: "Views",
                               fileExtension: "html")

        let view = try app.view.render("Example/Test").wait()
        let output = view.data.getString(at: 0, length: view.data.readableBytes, encoding: .utf8)
        XCTAssertEqual("Hello VIPER!\n", output)
    }
}
