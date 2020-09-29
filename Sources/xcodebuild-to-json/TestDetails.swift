//
//  TestDetails.swift
//  Chute
//
//  Created by David House on 7/6/19.
//  Copyright © 2019 repairward. All rights reserved.
//

import Foundation
import XCResultKit

struct TestClass: Codable, Identifiable {
    let id: String
    let className: String
    let testCases: [TestCase]
}

struct TestCase: Codable, Identifiable {
    let id: String
    let testName: String
    let status: String
    let failureMessage: String?
}

struct TestDetails: Codable {
    
    var classes: [TestClass] = []
    
    mutating func updateSummaries(_ summaries: [ActionTestPlanRunSummary], issues: ResultIssueSummaries) {
        let tests = gatherTests(summaries: summaries)
        
        // get the class names
        var classNames = Set<String>()
        for test in tests {
            let parts = test.identifier.split(separator: "/")
            classNames.insert(String(parts[0]))
        }
        
        var gathered = [TestClass]()
        for testClass in classNames {
            let testsForClass = tests.filter { $0.identifier.hasPrefix(testClass) }
            gathered.append(TestClass(id: testClass, className: testClass, testCases: testsForClass.map { TestCase(id: $0.name, testName: $0.name, status: $0.testStatus, failureMessage: failureMessageFor(test: $0, in: issues))}))
        }
        classes = gathered
    }
    
    func gatherTests(summaries: [ActionTestPlanRunSummary]) -> [ActionTestMetadata] {
        var foundTests = [ActionTestMetadata]()
        for summary in summaries {
            for testableSummary in summary.testableSummaries {
                for testGroup in testableSummary.tests {
                    foundTests += gatherTests(group: testGroup)
                }
            }
        }
        return foundTests
    }
    
    func gatherTests(group: ActionTestSummaryGroup) -> [ActionTestMetadata] {
        var tests = group.subtests
        for group in group.subtestGroups {
            tests += gatherTests(group: group)
        }
        return tests
    }
    
    func failureMessageFor(test: ActionTestMetadata, in issues: ResultIssueSummaries) -> String? {
        
        let testClassName = test.identifier.split(separator: "/")[0]
        let testCaseName = test.identifier.split(separator: "/")[1]
        
        for testFailure in issues.testFailureSummaries {
            if testFailure.testCaseName == testClassName + "." + testCaseName {
                return testFailure.message
            }
        }
        return nil
    }
}
