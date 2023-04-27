//
//  AnyNews.swift
//  Telegram Bot
//
//  Created by Maxim Ivanov on 27.04.2023.
//

import Foundation
//TODO: ADD TIME DATA, COMPARE TO POST TIME
enum AnyNews {
    
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
    init(from decoder: Decoder) throws {
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
            
            self = .blogPost(title, url, time, selfCoin)
        } else {
            let title = try container.decode(String.self, forKey: .title)
            let body = try container.decode(String.self, forKey: .body)
            let link = try container.decode(String.self, forKey: .link)
            let time = try container.decode(Int.self, forKey: .time)

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
    }
}
extension AnyNews {
    
    public func prepareMessage() -> String {
        var text = ""
        
        switch self {
        case .blogPost(let title, let link, let time, let coin):
            let blogPost =  BlogPost(title: title, link: link, time: time, coin: coin)
            text = processBlogPost(with: blogPost)
        case .tweet(let title, let body, let link, let time, let coin, let tweetType):
            let tweet = Tweet(title: title, body: body, link: link, time: time, coin: coin, type: tweetType)
            text = processTweet(with: tweet)
        }
    
        return text
    }
    
    private func processTweet(with tweet: Tweet) -> String {
        var text = ""
        let title = tweet.title.escapeMarkdown()
        let link = tweet.link
        let time = tweet.time
        
        let body = processTweetBody(with: tweet.body, type: tweet.type)
        text = "[⚡️ \(title)](\(link)):".bolded().newLine() + body
        
        if let coin = tweet.coin {
            text = ("$" + coin).bolded().newLine().newLine() + text
        }
        
        return text
    }
    
    private func processTweetBody(with body: String, type: TweetType) -> String {
        var body = body
        
        switch type {
        case .quoteTweet:
            body = body.processQuoteTweet()
        case .retweet:
            body = body.processRetweet()
        case .regularTweet:
            body = body.processRegularTweet()
        }
        
        return body
    }
    
    private func processBlogPost(with post: BlogPost) -> String {
        var text = ""
        let title = post.title.escapeMarkdown()
        let link = post.link
        let time = post.time
        
        text = "⚡️ " + title.bolded().newLine().newLine() + "[👉 Read full story](\(link))"
        
        if let coin = post.coin {
            text = ("$" + coin).bolded().newLine().newLine() + text
        }
        
        return text
    }
}

