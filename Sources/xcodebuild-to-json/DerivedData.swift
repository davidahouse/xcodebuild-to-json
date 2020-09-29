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
