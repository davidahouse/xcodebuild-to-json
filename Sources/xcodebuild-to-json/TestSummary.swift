//
//  TestSummary.swift
//  Chute
//
//  Created by David House on 7/5/19.
//  Copyright © 2019 repairward. All rights reserved.
//

import Foundation
import XCResultKit

class TestSummary: Codable {
    
    var allTests: Int = 0
    var successTests: Int = 0
    var failedTests: Int = 0
    var coverage: Int = 0
    var filesWithGoodCoverage: Int = 0
    var filesWithNoCoverage: Int = 0
    var viewsCaptured: Int = 0
    let details: TestDetails
    let codeCoverage: CodeCoverage?
    
    init(details: TestDetails, coverage: CodeCoverage?) {
        self.details = details
        self.codeCoverage = coverage
    }
    
    func updateSummary(_ summaries: [ActionTestPlanRunSummary], codeCoverage: CodeCoverage?) {
        var totalTests = 0
        var totalSuccessTests = 0
        var totalFailedTests = 0
        
        for summary in summaries {
            for testableSummary in summary.testableSummaries {
                for testGroup in testableSummary.tests {
                    totalTests += testCount(from: testGroup)
                    totalSuccessTests += testCount(from: testGroup, status: "Success")
                    totalFailedTests += testCount(from: testGroup, status: "Failure")
                }
            }
        }
       
        allTests = totalTests
        successTests = totalSuccessTests
        failedTests = totalFailedTests
        
        if let codeCoverage = codeCoverage {
            coverage = Int(codeCoverage.lineCoverage * 100.0)
            filesWithNoCoverage = codeCoverage.filesWithNoCoverage().count
        }
    }
    
    private func testCount(from: ActionTestSummaryGroup) -> Int {
        var count = 0
        count = from.subtests.count
        for group in from.subtestGroups {
            count += testCount(from: group)
        }
        return count
    }
    
    private func testCount(from: ActionTestSummaryGroup, status: String) -> Int {
        var count = 0
        count = from.subtests.filter { $0.testStatus == status }.count
        for group in from.subtestGroups {
            count += testCount(from: group, status: status)
        }
        return count
    }
}

func gatherTestSummary(from xcresult: XCResultFile) -> TestSummary {
    
    guard let invocationRecord = xcresult.getInvocationRecord() else {
        print("Unable to find invocation record in XCResult file!")
        exit(1)
    }

    var testRunSummaries: [ActionTestPlanRunSummary] = []
    for action in invocationRecord.actions {
        if let testRef = action.actionResult.testsRef {
            if let runSummaries = xcresult.getTestPlanRunSummaries(id: testRef.id) {
                for summary in runSummaries.summaries {
                    testRunSummaries.append(summary)
                }
            }
        }
    }

    // Get the test details
    var testDetails = TestDetails()
    testDetails.updateSummaries(testRunSummaries, issues: invocationRecord.issues)
    
    let codeCoverage = xcresult.getCodeCoverage()
    
    let summary = TestSummary(details: testDetails, coverage: codeCoverage)
    summary.updateSummary(testRunSummaries, codeCoverage: nil)
    return summary
}
