//
//  CommandLine.swift
//  xcodebuild-to-md
//
//  Created by David House on 9/10/17.
//  Copyright © 2017 David House. All rights reserved.
//

//
//  xcodebuild-to-md
//      -derivedDataFolder      The folder that the code was built into
//      -output                 The type of output (summary or text)
//      -repositoryURL          The URL for the repository
//      -sha                    The sha of the code that was compiled
//      -includeWarnings        If text output should include compiler warnings
import Foundation
import ArgumentParser

struct CommandLineArguments: ParsableArguments {

    @Option(help: ArgumentHelp("Spefify the folder where the DerivedData is for the app"))
    var derivedDataFolder: String
    
    @Option(help: ArgumentHelp("Specify the output file name for the JSON output"))
    var output: String

//    init(arguments: [String] = CommandLine.arguments) {
//
//        var foundArguments: [String: String] = [:]
//        for (index, value) in arguments.enumerated() {
//
//            if value.hasPrefix("-") && index < (arguments.count - 1) && !arguments[index+1].hasPrefix("-") {
//                let parameter = String(value.suffix(value.count - 1))
//                foundArguments[parameter] = arguments[index+1]
//            }
//        }
//
//        derivedDataFolder = foundArguments["derivedDataFolder"]
//        output = foundArguments["output"]
//    }
//
//    func printInstructions() {
//        var instructions = "Usage: xcodebuild-to-md -derivedDataFolder <path>"
//        instructions += " -output <path>"
//        print(instructions)
//    }
}
