//
//  AnyNews.swift
//  Telegram Bot
//
//  Created by Maxim Ivanov on 27.04.2023.
//

import Foundation
//TODO: ADD TIME DATA, COMPARE TO POST TIME
public enum AnyNews {
    
                //title, link, time, coin
    case blogPost(String, String, Int, String?)
                //title, body, link, time, coin, type
    case tweet(String, String, String, Int, String?, TweetType)
    
    private enum CodingKeys: CodingKey {
        case title
        case body
        case url, link
        case coin
        case suggestions
        case info
        case time
    }
        
    private struct Suggestions: Decodable {
        let coin: String
    }
    
    private struct Info: Decodable {
        let isQuote: Bool
        let isRetweet: Bool
    }
    
    
    private enum SuggestionsKeys: CodingKey {
        case coin
    }
    
}

extension AnyNews: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let containerKeys = Set(container.allKeys)
        let blogPostKeys = Set<CodingKeys>([.title, .url, .suggestions])
        let tweetKeys = Set<CodingKeys>([.title, .body, .link, .info, .suggestions])
        
        guard containerKeys.isSuperset(of: blogPostKeys) || containerKeys.isSuperset(of: tweetKeys) else {
            let context = DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Keys don't match")
            throw DecodingError.dataCorrupted(context)
        }
        
        //TODO: MAKE WRAPPER FUNCTION FOR COIN DECODING
        if containerKeys.isSuperset(of: blogPostKeys) {
            let title = try container.decode(String.self, forKey: .title)
            let url = try container.decode(String.self, forKey: .url)
            let time = try container.decode(Int.self, forKey: .time)
            let selfCoin = try decodeCoinIfPresent(container: container)
            self = .blogPost(title, url, time, selfCoin)
        } else {
            let title = try container.decode(String.self, forKey: .title)
            let body = try container.decode(String.self, forKey: .body)
            let link = try container.decode(String.self, forKey: .link)
            let time = try container.decode(Int.self, forKey: .time)
            let selfCoin = try decodeCoinIfPresent(container: container)
            let info = try container.decode(Info.self, forKey: .info)
            
            let tweetType: TweetType
            if info.isQuote {
                tweetType = .quoteTweet
            } else if info.isRetweet {
                tweetType = .retweet
            } else {
                tweetType = .regularTweet
            }
            
            self = .tweet(title, body, link, time, selfCoin, tweetType)
        }
        
        func decodeCoinIfPresent(container: KeyedDecodingContainer<AnyNews.CodingKeys>) throws -> String? {
            let selfCoin: String?
            if let coin = try container.decodeIfPresent(String.self, forKey: .coin) {
                selfCoin = coin
            } else if container.contains(.suggestions) {
                var suggestionsContainer = try container.nestedUnkeyedContainer(forKey: .suggestions)
                if suggestionsContainer.count ?? 0 > 0 {
                    let suggestions = try suggestionsContainer.decode(Suggestions.self)
                    selfCoin = suggestions.coin
                } else {
                    selfCoin = nil
                }
            } else {
                selfCoin = nil
            }
            
            return selfCoin
        }
    }
}


