//
//  News.swift
//  Telegram Bot
//
//  Created by Maxim Ivanov on 13.04.2023.
//

import Foundation

// MARK: - News
struct News: Codable {
    let title, body: String?
    let icon, image: String?
    let requireInteraction: Bool?
    let type: String?
    let link: String?
    let info: Info?
    let coin: String?
    let actions: [Action]?
    let suggestions: [Suggestion]?
    let time: Int?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case title, body, icon, image, requireInteraction, type, link, info, coin, actions, suggestions, time
        case id
    }
}

// MARK: - Action
struct Action: Codable {
    let action, title: String
    let icon: String
}

// MARK: - Info
struct Info: Codable {
    let twitterID: String?
    let isReply, isRetweet, isQuote: Bool

    enum CodingKeys: String, CodingKey {
        case twitterID
        case isReply, isRetweet, isQuote
    }
}

// MARK: - Suggestion
struct Suggestion: Codable {
    let found: [String]
    let coin: String
    let symbols: [Symbol]
}

// MARK: - Symbol
struct Symbol: Codable {
    let exchange, symbol: String
}

