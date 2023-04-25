//
//  Utils.swift
//  Telegram Bot
//
//  Created by Maxim Ivanov on 18.04.2023.
//

import Foundation
//TODO: Implement separate files for utils
extension String {
    public func bolded() -> String {
        return "*" + self + "*"
    }
    
    public func newLine() -> String {
        return self + "\n"
    }
    
    //TODO: Provide a better implementation
    public func escapeMarkdown() -> String {
        let arr: [Character] = ["*", "_", "[", "]", "(", ")", "~", "`", ">", "#", "+", "-", "=", "|", "{", "}", ".", "!", "@"]
        let charsToEscape = Set(arr)
        
        var res = ""
        for i in self {
            if charsToEscape.contains(i) {
                if i == "@" { res += "\u{200B}@"; continue }
                res += "\\\(i)"
                continue
            }
            res += String(i)
        }
        return res
    }
    
    public func splitQuote() -> String {
        var body = ""
        if #available(macOS 13.0, *) {
            let initialTextArray = self.split(separator: "Quote")
            body = String(initialTextArray[0]).escapeMarkdown()
            let quoteTextArray = initialTextArray[1].split(separator: "\n", maxSplits: 1)
            let link = String(quoteTextArray[0])
            let quoteBody = String(quoteTextArray[1]).escapeMarkdown()
            body += link; body += quoteBody
        } else {
            fatalError("for now, only macOS 13 only")
        }
        
        return body
    }
}

extension URLSessionWebSocketTask {
    public func sendPing() async throws -> String {
        func helper(_ completionHandler: @escaping (Result<String, Error>) ->()) {
            self.sendPing { error in
                if let error {
                    completionHandler(.failure(error))
                } else {
                    let postTime = Date()
                    let formattedTime = DateFormatterSingleton.shared.formatter.string(from: postTime)
                    completionHandler(.success("Ping sent succesfully at: \(formattedTime)"))
                }
            }
        }
        
     return try await withCheckedThrowingContinuation { continuation in
            helper { result in
                continuation.resume(with: result)
            }
        }
    }
}

class DateFormatterSingleton {
    
    public static let shared = DateFormatterSingleton()
    
    public let formatter = DateFormatter()
    
    private init() {
        formatter.dateStyle = .none
        formatter.timeStyle = .full
    }
}
