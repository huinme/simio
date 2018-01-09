//
//  Simctl.swift
//  simio
//
//  Created by k-sakata on 2018/01/08.
//

import Foundation

class Simctl {

    let process: Process

    init() {
        self.process = Process()
        self.process.launchPath = "/usr/bin/env"
    }

    func bootedDevices() -> [SimDevice] {
        process.arguments = ["xcrun", "simctl", "list", "--json"]

        let pipe = Pipe()
        process.standardOutput = pipe
        process.launch()

        let readHandle = pipe.fileHandleForReading
        let data = readHandle.readDataToEndOfFile()

        let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
        let devicesForRuntimes = (json?["devices"] as? [String: [[String: String]]]) ?? [:]

        var bootedDevices: [SimDevice] = []
        devicesForRuntimes.forEach {
            let runtime = $0.key
            let device = $0.value.map({ SimDevice($0, runtime: runtime) })
                .flatMap({ $0 })
                .filter({ $0.isBooted })
            bootedDevices.append(contentsOf: device)
        }
        return bootedDevices
    }

    func startRecording(_ device: SimDevice) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyyMMddhhmmss"
        let timestamp = dateFormatter.string(from: Date())

        let filePath = "~/Desktop/\(device.filename)_\(timestamp).mp4"
        process.arguments = ["xcrun", "simctl", "io", device.udid, "recordVideo", filePath]

        let pipe = Pipe()
        process.standardOutput = pipe
        process.launch()

        let readHandle = pipe.fileHandleForReading
        let data = readHandle.readDataToEndOfFile()
        if let string = String(data: data, encoding: .utf8) {
            print(string)
        }
    }

    func stopRecording() {
        process.interrupt()
    }
}
