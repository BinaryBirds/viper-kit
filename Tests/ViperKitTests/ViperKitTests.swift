import XCTest
@testable import ViperKit

final class ViperKitTests: XCTestCase {
    
    static var allTests = [
        ("testExample", testExample),
    ]
    
    func testExample() throws {
        let module = ExampleModule()
        _ = try XCTUnwrap(module.router)
        XCTAssertTrue(true)
    }
}
