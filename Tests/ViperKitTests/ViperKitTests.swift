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

        try LeafEngine.useViperViews(viewsDirectory: app.directory.viewsDirectory,
                                     workingDirectory: app.directory.workingDirectory,
                                     modulesLocation: "Tests/ViperKitTests",
                                     templatesDirectory: "Templates",
                                     fileExtension: "html",
                                     fileio: app.fileio)

        app.views.use(.leaf)

        let view = try app.leaf.render(template: "Example/Test").wait()
        let output = view.data.getString(at: 0, length: view.data.readableBytes, encoding: .utf8)
        XCTAssertEqual("Hello VIPER!\n", output)
    }
}
