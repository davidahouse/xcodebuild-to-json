import XCTest

import xcodebuild_to_jsonTests

var tests = [XCTestCaseEntry]()
tests += xcodebuild_to_jsonTests.allTests()
XCTMain(tests)
