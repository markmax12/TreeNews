//
//  DateFormatterSingleton.swift
//  Telegram Bot
//
//  Created by Maxim Ivanov on 21.04.2023.
//

import Foundation

class DateFormatterSingleton {
    
    public static let shared = DateFormatterSingleton()
    
    public let formatter = DateFormatter()
    
    private init() {
        formatter.dateStyle = .none
        formatter.timeStyle = .full
    }
}
