//
//  SimDevice.swift
//  simio
//
//  Created by k-sakata on 2018/01/08.
//

import Foundation

class SimDevice {
    let name: String
    let udid: String

    private let availability: String
    private let state: String

    let runtime: String

    var isBooted: Bool {
        let state = self.state.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        return state == "booted"
    }
    var filename: String {
        return "\(name)_\(runtime)".lowercased()
            .replacingOccurrences(of: " ", with: "_")
            .replacingOccurrences(of: ".", with: "_")
    }

    init?(_ dictionary: [String: String], runtime: String) {
        guard let name = dictionary["name"] as String?,
              let udid = dictionary["udid"] as String?,
              let availability = dictionary["availability"] as String?,
              let state = dictionary["state"] as String? else {
                return nil
        }

        self.name = name
        self.udid = udid
        self.availability = availability
        self.state = state
        self.runtime = runtime
    }
}
