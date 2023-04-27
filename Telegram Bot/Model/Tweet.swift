//
//  Tweet.swift
//  Telegram Bot
//
//  Created by Maxim Ivanov on 27.04.2023.
//

import Foundation

enum TweetType {
    case regularTweet
    case retweet
    case quoteTweet
}

struct Tweet: News {
    let title: String
    let body: String
    let link: String
    let time: Int
    let coin: String?
    let type: TweetType
}
