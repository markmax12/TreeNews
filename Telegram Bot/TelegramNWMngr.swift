//
//  NWManager.swift
//  Telegram Bot
//
//  Created by Maxim Ivanov on 13.04.2023.
//

import Foundation

final class TelegramNWMngr {
    
    private let session = URLSession(configuration: .default)
    
    public func onRecieve(news: News) async throws {
        let tgEndpoint = TelegramEndpoint.sendMessage(news: news)
        guard let url = buildURL(endpoint: tgEndpoint) else {
            fatalError("cannot make URL")
        }
        try await self.sendRequest(with: url)
    }
    
    public func sendRequest(with url: URL) async throws {
        let (_, response) = try await session.data(from: url)
        print(response.url)
        //TODO: Error response handling
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            if let url = response.url {
                print("failed to post, URL: ", url)
            } else {
                print("failed to post, no URL")
            }
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
