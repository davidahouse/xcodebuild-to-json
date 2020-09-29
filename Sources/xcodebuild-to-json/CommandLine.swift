//
//  CommandLine.swift
//  xcodebuild-to-md
//
//  Created by David House on 9/10/17.
//  Copyright © 2017 David House. All rights reserved.
//
import Foundation
import ArgumentParser

struct CommandLineArguments: ParsableArguments {

    @Option(help: ArgumentHelp("Spefify the folder where the DerivedData is for the app"))
    var derivedDataFolder: String
    
    @Option(help: ArgumentHelp("Specify the output file name for the JSON output"))
    var output: String
}
