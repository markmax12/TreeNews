//
//  API.swift
//  Telegram Bot
//
//  Created by Maxim Ivanov on 18.04.2023.
//

import Foundation

public protocol Endpoint {
    var scheme: String { get }
    var baseURL: String { get }
    var path: String { get }
    var parameters: [URLQueryItem] { get }
    var method: String { get }
}

public enum TelegramEndpoint: Endpoint {
    case sendMessage(news: AnyNews, credentials: Credentials)
}

public extension TelegramEndpoint {
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
        case .sendMessage(_, let credentials):
            return "/bot\(credentials.botKey)/sendMessage"
        }
    }
    
    var parameters: [URLQueryItem] {
        switch self {
        case .sendMessage(let news, let credentials):
            var parameters = [
                URLQueryItem(name: "chat_id", value: credentials.chatID),
                URLQueryItem(name: "parse_mode", value: "MarkdownV2")
            ]
            let message = prepareMessage(with: news)
            parameters.append(URLQueryItem(name: "text", value: message))
            return parameters
        }
    }
}

extension TelegramEndpoint {
    
    public func prepareMessage(with news: AnyNews) -> String {
        var text = ""
        
        switch news {
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
        let _ = tweet.time
        
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
        let _ = post.time
        
        text = "⚡️ " + title.bolded().newLine().newLine() + "[👉 Read full story](\(link))"
        
        if let coin = post.coin {
            text = ("$" + coin).bolded().newLine().newLine() + text
        }
        
        return text
    }
}
