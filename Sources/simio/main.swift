import Foundation
import CoreFoundation

// Apple's new Utility library will power up command-line apps
// - https://www.hackingwithswift.com/articles/44/apple-s-new-utility-library-will-power-up-command-line-apps
//
// Command Line Programs on macOS Tutorial
// - https://www.raywenderlich.com/163134/command-line-programs-macos-tutorial-2

var process: Process?

private func main(arguments: [String]) {

    do {
        let availableDevices = try Simctl.availableDevices()
        availableDevices.enumerated().forEach {
            print("\($0): \($1.name) (\($1.runtime))")
        }
        print("")

        if availableDevices.isEmpty {
            print("Error: No simulators are running.")
            exit(EXIT_FAILURE)
        }

        ConsoleIO.waitInput("Choose device number: ") { input in
            guard let index = Int(input ?? "") else {
                print("Error: Input valid number of device!!")
                exit(EXIT_FAILURE)
            }

            if index < 0 || availableDevices.count <= index {
                print("Error: Input valid number of device!!")
                exit(EXIT_FAILURE)
            }

            let device = availableDevices[index]
            process = Simctl.startRecording(device)
        }
    } catch {
        print("Error: \(error)")
    }
}

main(arguments: CommandLine.arguments)

signal(SIGINT) { signal in
    process?.interrupt()
    exit(EXIT_SUCCESS)
}
while true { }
