# xcodebuild-to-json

This command line application can provide a simplified JSON output from an Xcode test execution, using xcresult files as the source. While `xcresulttool` and `xccov` both provide JSON output, the format is full of detail that might not be needed for displaying the basic status of the tests. So this application provides a more simplified JSON output, combining both test execution as well as code coverage in a single JSON output file.

## Install

To install, use the `brew` formula:

```
brew install davidahouse/formulae/xcodebuild-to-json
```
