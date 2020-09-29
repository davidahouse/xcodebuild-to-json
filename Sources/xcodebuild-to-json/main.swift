//
//  main.swift
//  xcodebuild-to-json
//
//  Created by David House on 09/25/20.
//  Copyright © 2020 davidahouse. All rights reserved.
//

import Foundation
import XCResultKit


let arguments = CommandLineArguments.parseOrExit()

let derivedData = DerivedData()
derivedData.location = URL(fileURLWithPath: arguments.derivedDataFolder)
guard let resultKit = derivedData.recentResultFile() else {
    print("Unable to find XCResult file!")
    exit(1)
}

let testSummary = gatherTestSummary(from: resultKit)

let jsonEncoder = JSONEncoder()
do {
    let encodedData = try jsonEncoder.encode(testSummary)
    try encodedData.write(to: URL(fileURLWithPath: arguments.output))
} catch {
    print("Error encoding the json output")
}
