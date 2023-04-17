//
//  NWManager.swift
//  Telegram Bot
//
//  Created by Maxim Ivanov on 13.04.2023.
//

import Foundation

final class TelegramNWMngr {
    
    private static let botkey = APIKey.key
    private static let channelID = "@treenewsc"
    private let session = URLSession(configuration: .default)
    
    public func onRecieve(news: News) async throws {
        let title = news.title ?? ""
        let body = news.body ?? ""
        try await self.sendRequest(message: title)
    }
    
    public func sendRequest(message: String) async throws {
        let urlString =  "https://api.telegram.org/bot\(TelegramNWMngr.botkey)/sendMessage?chat_id=\(TelegramNWMngr.channelID)&text=\(message)"
        
        guard let urlString = URL(string: urlString) else { return }
        
        let (_, response) = try await session.data(from: urlString)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            return
        }
        
        print("posted succesfully")
    }
}
