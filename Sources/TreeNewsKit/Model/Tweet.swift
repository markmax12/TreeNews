//
//  Tweet.swift
//  Telegram Bot
//
//  Created by Maxim Ivanov on 27.04.2023.
//

import Foundation

public enum TweetType {
    case regularTweet
    case retweet
    case quoteTweet
}

public struct Tweet: News {
    public let title: String
    public let body: String
    public let link: String
    public let time: Int
    public let coin: String?
    public let type: TweetType
}
