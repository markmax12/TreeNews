//
//  API.swift
//  Telegram Bot
//
//  Created by Maxim Ivanov on 18.04.2023.
//

import Foundation

protocol Endpoint {
    var scheme: String { get }
    var baseURL: String { get }
    var path: String { get }
    var parameters: [URLQueryItem] { get }
    var method: String { get }
}

enum TelegramEndpoint: Endpoint {
    case sendMessage(message: String)
}

extension TelegramEndpoint {
    var method: String {
        return "POST"
    }
    
    var scheme: String {
        return "https"
    }
    var baseURL: String {
        return "api.telegram.org"
    }
    
    var path: String {
        switch self {
        case .sendMessage:
            return "/bot\(APIKey.key)/sendMessage"
        }
    }
    
    var parameters: [URLQueryItem] {
        switch self {
        case .sendMessage(let message):
            var parameters = [
                URLQueryItem(name: "chat_id", value: APIKey.chatID),
                URLQueryItem(name: "parse_mode", value: "MarkdownV2")
            ]
            
            parameters.append(URLQueryItem(name: "text", value: message))
            return parameters
        }
    }
}

