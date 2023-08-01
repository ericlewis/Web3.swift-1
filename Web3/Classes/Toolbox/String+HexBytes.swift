//
//  String+HexBytes.swift
//  Web3
//
//  Created by Koray Koska on 10.02.18.
//

import Foundation
import VaporBytes

extension String {

    func hexBytes() throws -> Bytes {
        guard self.count % 2 == 0 else {
            throw StringHexBytesError.hexStringMalformed
        }
        var bytes = Bytes()

        var string = self

        guard string.count >= 2 else {
            return bytes
        }

        let pre = string.startIndex
        let post = string.index(string.startIndex, offsetBy: 2)
        if String(string[pre..<post]) == "0x" {
            // Remove prefix
            string = String(string[post...])
        }

        for i in stride(from: 0, to: string.count, by: 2) {
            let start = string.index(string.startIndex, offsetBy: i)
            let end = string.index(string.startIndex, offsetBy: i + 2)

            guard let byte = Byte(String(string[start..<end]), radix: 16) else {
                throw StringHexBytesError.hexStringMalformed
            }
            bytes.append(byte)
        }

        return bytes
    }

    func quantityHexBytes() throws -> Bytes {
        var bytes = Bytes()

        var string = self

        guard string.count >= 2 else {
            if string == "0" {
                return bytes
            }

            throw StringHexBytesError.hexStringMalformed
        }

        let pre = string.startIndex
        let post = string.index(string.startIndex, offsetBy: 2)
        if String(string[pre..<post]) == "0x" {
            // Remove prefix
            string = String(string[post...])
        }

        if string.count % 2 != 0 {
            let newStart = string.index(after: string.startIndex)

            guard let byte = Byte(String(string[string.startIndex]), radix: 16) else {
                throw StringHexBytesError.hexStringMalformed
            }
            bytes.append(byte)

            // Remove already appended byte so we have an even number of characters for the next step
            string = String(string[newStart...])
        }

        for i in stride(from: 0, to: string.count, by: 2) {
            let start = string.index(string.startIndex, offsetBy: i)
            let end = string.index(string.startIndex, offsetBy: i + 2)

            guard let byte = Byte(String(string[start..<end]), radix: 16) else {
                throw StringHexBytesError.hexStringMalformed
            }
            bytes.append(byte)
        }

        return bytes
    }
}

enum StringHexBytesError: Error {

    case hexStringMalformed
}
