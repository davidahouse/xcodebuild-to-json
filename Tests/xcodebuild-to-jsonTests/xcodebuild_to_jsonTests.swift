import XCTest
import class Foundation.Bundle
@testable import xcodebuild_to_json

final class xcodebuild_to_jsonTests: XCTestCase {
    
    func testExample() throws {
        XCTAssertTrue(true)
    }

    /// Returns path to the built products directory.
    var productsDirectory: URL {
      #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
      #else
        return Bundle.main.bundleURL
      #endif
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
