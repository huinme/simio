//
//  ConsoleIO.swift
//  simio
//
//  Created by k-sakata on 2018/01/08.
//

import Foundation

class ConsoleIO {

    func waitInput() -> String? {
        while true {
            let inputData = FileHandle.standardInput.availableData
            let string = String(data: inputData, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines)

            if let string = string, !string.isEmpty {
                return string
            }
        }
    }
}
