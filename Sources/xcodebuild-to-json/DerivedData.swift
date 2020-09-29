//
//  DerivedData.swift
//  Chute
//
//  Created by David House on 7/3/19.
//  Copyright © 2019 repairward. All rights reserved.
//

import Foundation
import XCResultKit

class DerivedData {
    
    var location: URL? {
        didSet {
            testResultFiles = self.findTestResultFiles()
        }
    }
    var testResultFiles: [XCResultFile] = []
    
    func recentResultFile() -> XCResultFile? {
        // TODO: eventually sort by date/time, but for now just pick one
        if testResultFiles.count > 0 {
            return testResultFiles[testResultFiles.count - 1]
        } else {
            return nil
        }
    }
    
//    public func populateCurrentTestResult(testResult: CurrentTestResult, from url: URL) {
//
//        testResult.path = url
//
//        guard let invocation = getInvocationRecord(url) else {
//            print("Unable to get invocation record, nothing else we can do")
//            return
//        }
//        testResult.invocation = invocation
//
//        // Gather up any test run summaries
//        var testRunSummaries: [ActionTestPlanRunSummary] = []
//        for action in invocation.actions {
//            if let testRef = action.actionResult.testsRef {
//                if let runSummaries = getTestPlanRunSummaries(url, id: testRef.id) {
//                    for summary in runSummaries.summaries {
//                        testRunSummaries.append(summary)
//                    }
//                }
//            }
//        }
//        testResult.testPlanRunSummaries = testRunSummaries
//    }
//
//    private func getInvocationRecord(_ url: URL) -> ActionsInvocationRecord? {
//
//        // execute the command line to return us the xcresulttool output
//        guard let getOutput = Execute.shell(command: ["-l", "-c", "xcrun xcresulttool get --path \(url.path) --format json"]) else {
//            return nil
//        }
//
//        print("get output:")
//        print(getOutput)
//
//        do {
//            guard let data = getOutput.data(using: .utf8) else {
//                print("Unable to turn string into data, must not be a utf8 string")
//                return nil
//            }
//
//            guard let rootJSON = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: AnyObject] else {
//                print("Expecting top level dictionary but didn't find one")
//                return nil
//            }
//
//            let invocation = ActionsInvocationRecord(rootJSON)
//            return invocation
//        } catch {
//            print("Error deserializing JSON: \(error)")
//            return nil
//        }
//    }
//
//    private func getTestPlanRunSummaries(_ url: URL, id: String) -> ActionTestPlanRunSummaries? {
//
//        guard let getOutput = Execute.shell(command: ["-l", "-c", "xcrun xcresulttool get --path \(url.path) --id \(id) --format json"]) else {
//            return nil
//        }
//
//        print("get output:")
//        print(getOutput)
//
//        do {
//            guard let data = getOutput.data(using: .utf8) else {
//                print("Unable to turn string into data, must not be a utf8 string")
//                return nil
//            }
//
//            guard let rootJSON = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: AnyObject] else {
//                print("Expecting top level dictionary but didn't find one")
//                return nil
//            }
//
//            let runSummaries = ActionTestPlanRunSummaries(rootJSON)
//            return runSummaries
//        } catch {
//            print("Error deserializing JSON: \(error)")
//            return nil
//        }
//    }
    
    private func findTestResultFiles() -> [XCResultFile] {
        
        guard let location = location else {
            return []
        }
        
        guard let folders = try? FileManager.default.contentsOfDirectory(atPath: location.path) else {
            return []
        }

        var found: [URL] = []
        for folder in folders {
            let folderURL = location.appendingPathComponent(folder).appendingPathComponent("Logs").appendingPathComponent("Test")
            if FileManager.default.fileExists(atPath: folderURL.path, isDirectory: nil) {
                if let allFiles = try? FileManager.default.contentsOfDirectory(atPath: folderURL.path) {
                    found += allFiles.filter { $0.hasSuffix(".xcresult") }.map { folderURL.appendingPathComponent($0) }
                }
            }
        }
        return found.sorted { (lhs, rhs) -> Bool in
            lhs.lastPathComponent < rhs.lastPathComponent
        }.map { XCResultFile(url: $0) }
    }
}
