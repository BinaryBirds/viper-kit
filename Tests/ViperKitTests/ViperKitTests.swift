//
//  ViperKitTests.swift
//  ViperKitTests
//
//  Created by Tibor Bodecs on 2020. 04. 30..
//

import XCTest
@testable import ViperKit

final class ViperKitTests: XCTestCase {
   
    private var workingDirectory: String {
        "/" + #file.split(separator: "/").dropLast(3).joined(separator: "/") + "/"
    }
    
    func testExample() throws {
        let module = ExampleModule()
        _ = try XCTUnwrap(module.router)
        XCTAssertTrue(true)
    }
    
    func testHooks() throws {
        let hooks = HookStorage()

        hooks.register("foo") { args -> String in
            "foo"
        }
        hooks.register("foo") { args -> String in
            "bar"
        }
        hooks.register("bar") { args -> Int in
            args["number"] as! Int
        }
        
        let result1: String? = hooks.invoke("foo")
        XCTAssertEqual(result1, "foo")
        
        let result2: [String] = hooks.invokeAll("foo")
        XCTAssertEqual(result2, ["foo", "bar"])
        
        let result3: Int? = hooks.invoke("foo")
        XCTAssertEqual(result3, nil)
        
        let result4: Int? = hooks.invoke("bar", args: ["number": 123])
        XCTAssertEqual(result4, 123)
    }

    func testViperViewFilesConfig() throws {
        let app = Application(.testing)
        defer { app.shutdown() }

        app.directory.workingDirectory = workingDirectory

        try TemplateEngine.useViperViews(viewsDirectory: app.directory.viewsDirectory,
                                         workingDirectory: app.directory.workingDirectory,
                                         modulesLocation: "Tests/ViperKitTests",
                                         templatesDirectory: "Templates",
                                         fileExtension: "html",
                                         fileio: app.fileio)

        app.views.use(.tau)

        let view = try app.tau.render(template: "Example/Test").wait()
        let output = view.data.getString(at: 0, length: view.data.readableBytes, encoding: .utf8)
        XCTAssertEqual("Hello VIPER!\n", output)
    }
}
