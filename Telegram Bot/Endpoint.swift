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
    case sendMessage(news: News)
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
        case .sendMessage(let news):
            var parameters = [
                URLQueryItem(name: "chat_id", value: APIKey.chatID),
                URLQueryItem(name: "parse_mode", value: "MarkdownV2")
            ]
            
            let text = self.formatText(news)
            parameters.append(URLQueryItem(name: "text", value: text))
            return parameters
        }
    }
    
    private func formatText(_ news: News) -> String {
        var text = ""
        let title = news.title?.escapeMarkdown() ?? ""
        let url = news.link ?? ""
        //TODO: CHECK IF THE @ ARE ESCAPED PROPERLY
        //TODO: PROPOSE A QUOTE TWEET SOLUTION
        if var body = news.body {
            if news.isQuote {
                if #available(macOS 13.0, *) {
                    let arr = body.split(separator: "Quote")
                    body = String(arr[0]).escapeMarkdown()
                    let arr2 = arr[1].split(separator: "\n", maxSplits: 1)
                    let link = String(arr2[0])
                    let quoteBody = String(arr2[1]).escapeMarkdown()
                    body += link; body += "`\(quoteBody)`"
                } else {
                    fatalError("for now, only macOS 13 only")
                }
            } else {
                body = body.escapeMarkdown()
            }
            text = "[\(title)](\(url))".bolded().newLine() + body.escapeMarkdown()
        } else {
            text = title.bolded().newLine().newLine() + "[Read full story](\(url))"
        }
        
        if let coin = news.coin {
            text = "$" + coin.bolded().newLine().newLine() + text
        }
        
        return text
    }
}

