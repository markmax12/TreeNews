//
//  NWManager.swift
//  Telegram Bot
//
//  Created by Maxim Ivanov on 13.04.2023.
//

import Foundation

final class TelegramAPI: API {
    
    private let session: URLSession
    private let credentials: Credentials
    
    public init(with credentials: Credentials, urlSession: URLSession = URLSession(configuration: .default)) {
        self.credentials = credentials
        self.session = urlSession
    }
    
    public func onRecieve(news: AnyNews) async throws {
        let tgEndpoint = TelegramEndpoint.sendMessage(news: news, credentials: credentials)
        guard let url = buildURL(endpoint: tgEndpoint) else { throw
            RunTimeError("Can't build URL")
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
