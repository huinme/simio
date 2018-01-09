import Foundation
import CoreFoundation

// Apple's new Utility library will power up command-line apps
// - https://www.hackingwithswift.com/articles/44/apple-s-new-utility-library-will-power-up-command-line-apps
//
// Command Line Programs on macOS Tutorial
// - https://www.raywenderlich.com/163134/command-line-programs-macos-tutorial-2

var simctl: Simctl?

private func main(arguments: [String]) {
    let bootedDevices = Simctl().bootedDevices()

    if bootedDevices.isEmpty {
        print("No simulators are running.")
        exit(EXIT_FAILURE)
    }

    bootedDevices.enumerated().forEach {
        print("\($0): \($1.name) (\($1.runtime))")
    }
    print("")

    print("Choose device: ")
    let inputText = ConsoleIO().waitInput()

    if let index = Int(inputText ?? "") {
        if index < 0 || bootedDevices.count <= index {
            print("Input number was wrong.")
            exit(EXIT_FAILURE)
        }

        let device = bootedDevices[index]
        simctl = Simctl()
        simctl?.startRecording(device)

        // Keep running until user send SIGINT(CTRL+C) signal.
        while true { }
    } else {
        print("Input valid value")
        exit(EXIT_FAILURE)
    }
}

signal(SIGINT) { signal in
    simctl?.stopRecording()
    exit(EXIT_SUCCESS)
}

main(arguments: CommandLine.arguments)
