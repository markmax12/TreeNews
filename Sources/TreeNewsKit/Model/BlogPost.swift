//
//  BlogPost.swift
//  Telegram Bot
//
//  Created by Maxim Ivanov on 27.04.2023.
//

import Foundation

public struct BlogPost: News {
    public let title: String
    public let link: String
    public let time: Int
    public let coin: String?
}
