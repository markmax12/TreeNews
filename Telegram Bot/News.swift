//
//  News.swift
//  Telegram Bot
//
//  Created by Maxim Ivanov on 13.04.2023.
//

import Foundation

struct News: Decodable {
    let title, body: String?
    let link: String?
    let coin: String?
    let time: Int
    let isQuote: Bool
    
    private enum CodingKeys: CodingKey {
        case title, body
        case link, url
        case coin
        case time
        case suggestions
        case info
    }
        
    struct Suggestions: Decodable {
        let coin: String
    }
    
    private enum SuggestionsKeys: CodingKey {
        case coin
    }
    
    private enum InfoKeys: CodingKey {
        case isQuote
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.body = try container.decodeIfPresent(String.self, forKey: .body)
        
        if let link = try container.decodeIfPresent(String.self, forKey: .link) {
            self.link = link
        } else if let url = try container.decodeIfPresent(String.self, forKey: .url) {
            self.link = url
        } else {
            self.link = nil
        }
        
        if let coin = try container.decodeIfPresent(String.self, forKey: .coin) {
            self.coin = coin
        } else if container.contains(.suggestions) {
            var suggestionsContainer = try container.nestedUnkeyedContainer(forKey: .suggestions)
            if suggestionsContainer.count ?? 0 > 0 {
                let suggestions = try suggestionsContainer.decode(Suggestions.self)
                self.coin = suggestions.coin
            } else {
                self.coin = nil
            }
        } else {
            self.coin = nil
        }
        
        if container.contains(.info) {
            let infoContainer = try container.nestedContainer(keyedBy: InfoKeys.self, forKey: .info)
            self.isQuote = try infoContainer.decode(Bool.self, forKey: .isQuote)
        } else {
            self.isQuote = false
        }
        
        self.time = try container.decode(Int.self, forKey: .time)
    }
}
