//
//  RunTimeError.swift
//  Telegram Bot
//
//  Created by Maxim Ivanov on 03.05.2023.
//

import Foundation

public struct RunTimeError: Error, CustomStringConvertible {
    public var description: String
    
    public init(_ description: String) {
        self.description = description
    }
}
