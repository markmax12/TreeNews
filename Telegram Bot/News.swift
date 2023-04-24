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
    
    private enum CodingKeys: CodingKey {
        case title, body
        case link, url
        case coin
        case time
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
        
        self.coin = try container.decodeIfPresent(String.self, forKey: .coin)
        self.time = try container.decode(Int.self, forKey: .time)
    }
}
