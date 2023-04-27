//
//  NWManager.swift
//  Telegram Bot
//
//  Created by Maxim Ivanov on 13.04.2023.
//

import Foundation

final class TelegramNWMngr {
    
    private let session = URLSession(configuration: .default)
    
    public func onRecieve(message: String) async throws {
        let tgEndpoint = TelegramEndpoint.sendMessage(message: message)
        guard let url = buildURL(endpoint: tgEndpoint) else {
            fatalError("cannot make URL")
        }
        try await self.sendRequest(with: url)
    }
    
    public func sendRequest(with url: URL) async throws {
        let (_, response) = try await session.data(from: url)
        print(url)
        //TODO: Error response handling
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            print("failed to post, URL: ", url, response.description)
            return
        }
        let postTime = Date()
        let formattedTime = DateFormatterSingleton.shared.formatter.string(from: postTime)
        print("posted succesfully at: \(formattedTime)")
    }
    
    private func buildURL(endpoint: Endpoint) -> URL? {
        var components = URLComponents()
        components.scheme = endpoint.scheme
        components.host = endpoint.baseURL
        components.path = endpoint.path
        components.queryItems = endpoint.parameters
        return components.url
    }
    
}
