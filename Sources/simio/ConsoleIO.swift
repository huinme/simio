//
//  ConsoleIO.swift
//  simio
//
//  Created by k-sakata on 2018/01/08.
//

import Foundation

class ConsoleIO {

    class func waitInput(_ message: String = "", handler: ((String?) -> Void)?) {
        print(message)

        var shouldWait = true
        while shouldWait {
            let inputData = FileHandle.standardInput.availableData
            let inputString = String(data: inputData, encoding: .utf8)?.trimmingCharacters(in: .newlines)

            if let inputString = inputString, !inputString.isEmpty {
                handler?(inputString)                
                shouldWait = false
            }
        }
    }
}
