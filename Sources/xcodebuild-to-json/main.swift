//
//  main.swift
//  xcodebuild-to-json
//
//  Created by David House on 09/25/20.
//  Copyright © 2020 davidahouse. All rights reserved.
//

import Foundation
import XCResultKit

let commandLine = CommandLineArguments()
guard let path = commandLine.derivedDataFolder else {
    print("-derivedDataFolder is required, unable to continue")
    exit(1)
}

guard let output = commandLine.output else {
    print("-output is required, unable to continue")
    exit(1)
}

let derivedData = DerivedData()
derivedData.location = URL(fileURLWithPath: path)
guard let resultKit = derivedData.recentResultFile() else {
    print("Unable to find XCResult file!")
    exit(1)
}

let testSummary = gatherTestSummary(from: resultKit)

let jsonEncoder = JSONEncoder()
do {
    let encodedData = try jsonEncoder.encode(testSummary)
    try encodedData.write(to: URL(fileURLWithPath: output))
} catch {
    print("Error encoding the json output")
}
