//
//  News.swift
//  Telegram Bot
//
//  Created by Maxim Ivanov on 27.04.2023.
//

import Foundation

protocol News {
    var title: String { get }
    var link: String { get }
    var time: Int { get }
}
