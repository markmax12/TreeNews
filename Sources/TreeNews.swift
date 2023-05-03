//
//  main.swift
//  Telegram Bot
//
//  Created by Maxim Ivanov on 13.04.2023.
//

import Foundation
import ArgumentParser

@main
struct TreeNews: AsyncParsableCommand {
    
    @Option(name: [.short, .customLong("bot")], help: "Telegram Bot token in the format of 110201543:AAHdqTcvCH1vGWJxfSeofSAs0K5PALDsaw. Ask @BotFather for it.")
    var botKey: String
    
    @Option(name: [.short, .customLong("chat")], help: "The ID of a chat or a channel to be sent a message.")
    var chatID: String
    
    func run() async throws {
        
        do {
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
            throw error
        }
        
        while true {
            try! await Task.sleep(nanoseconds: 1_000_000_000)
        }
    }
}





