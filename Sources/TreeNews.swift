//
//  main.swift
//  Telegram Bot
//
//  Created by Maxim Ivanov on 13.04.2023.
//

import Foundation

@main
struct TreeNews {
    
    static func main() async throws {
        
        do {
            guard let botKey = ProcessInfo().environment["BOT_KEY"] else {
                let error = RunTimeError("Error, no bot key provided")
                TreeNews.exit(withError: error)
            }
            guard let chatID = ProcessInfo().environment["CHAT_ID"] else {
                let error = RunTimeError("Error, no chat ID provided")
                TreeNews.exit(withError: error)
            }
            
            let credentials = try Credentials(botKey: botKey, chatID: chatID)
            let telegramAPI = TelegramAPI(with: credentials)
            let websocketManager = WebsocketManager(with: telegramAPI)
            
            Task {
                try await websocketManager.subscribe()
                try await websocketManager.recieveMessage()
            }
            
            Task {
                try await websocketManager.sendPing()
            }
            
        } catch {
            TreeNews.exit(withError: error)
        }
        
        while true {
            try! await Task.sleep(nanoseconds: 1_000_000_000)
        }
    }
}





