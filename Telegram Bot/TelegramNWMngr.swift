//
//  NWManager.swift
//  Telegram Bot
//
//  Created by Maxim Ivanov on 13.04.2023.
//

import Foundation

final class TelegramNWMngr {
    
    private let session = URLSession(configuration: .default)
    
    public func onRecieve(endpoint: Endpoint) async throws {
        print(endpoint.parameters)
        guard let url = buildURL(endpoint: endpoint) else {
            fatalError("cannot make URL")
        }
        
        try await self.sendRequest(with: url)
    }
    
    public func sendRequest(with url: URL) async throws {
        
        let (_, response) = try await session.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            return
        }
        
        print("posted succesfully")
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
