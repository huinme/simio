//
//  Simctl.swift
//  simio
//
//  Created by k-sakata on 2018/01/08.
//

import Foundation

class Simctl {

    class func availableDevices() throws -> [SimDevice] {
        let simctl = Process()
        simctl.launchPath = "/usr/bin/env"
        simctl.arguments = ["xcrun", "simctl", "list", "--json"]

        let pipe = Pipe()
        simctl.standardOutput = pipe
        simctl.launch()

        let readHandle = pipe.fileHandleForReading
        let data = readHandle.readDataToEndOfFile()

        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
        let devicesForRuntimes = (json["devices"] as? [String: [[String: String]]]) ?? [:]

        var avaialbleDevices: [SimDevice] = []
        devicesForRuntimes.forEach {
            let runtime = $0.key
            let device = $0.value.map({ SimDevice($0, runtime: runtime) })
                .flatMap({ $0 })
                .filter({ $0.isBooted })
            avaialbleDevices.append(contentsOf: device)
        }
        return avaialbleDevices
    }

    class func startRecording(_ device: SimDevice) -> Process {
        let filePath = "~/Desktop/\(device.filename).mp4"

        let simctl = Process()
        simctl.launchPath = "/usr/bin/env"
        simctl.arguments = ["xcrun", "simctl", "io", device.udid, "recordVideo", filePath]

        let pipe = Pipe()
        simctl.standardOutput = pipe
        simctl.launch()

        return simctl
    }
}
