//
//  API.swift
//  Telegram Bot
//
//  Created by Maxim Ivanov on 28.04.2023.
//

import Foundation

public protocol API {
    func onRecieve(news: AnyNews) async throws
}
