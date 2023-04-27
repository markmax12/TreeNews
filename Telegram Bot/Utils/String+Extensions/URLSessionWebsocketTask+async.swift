//
//  URLSessionWebsocketTask+async.swift
//  Telegram Bot
//
//  Created by Maxim Ivanov on 27.04.2023.
//

import Foundation

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
