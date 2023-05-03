//
//  DateFormatter Singleton.swift
//  Telegram Bot
//
//  Created by Maxim Ivanov on 26.04.2023.
//

import Foundation

public class DateFormatterSingleton {
    
    public static let shared = DateFormatterSingleton()
    
    public let formatter = DateFormatter()
    
    private init() {
        formatter.dateStyle = .none
        formatter.timeStyle = .full
    }
}
