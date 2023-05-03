//
//  Credentials.swift
//  Telegram Bot
//
//  Created by Maxim Ivanov on 03.05.2023.
//

import Foundation

public struct Credentials {
    public let botKey: String
    public let chatID: String
    
    public init(botKey: String, chatID: String) throws {
        guard botKey.contains(":") else { throw RunTimeError("Invalid bot token") }
        guard chatID.contains("@") else { throw RunTimeError("Invalid chatID") }
        self.botKey = botKey
        self.chatID = chatID
    }
}
