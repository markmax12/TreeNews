//
//  Utils.swift
//  Telegram Bot
//
//  Created by Maxim Ivanov on 18.04.2023.
//

import Foundation

extension String {
    public func bolded() -> String {
        return "*" + self + "*"
    }
    
    public func newLine() -> String {
        return self + "\n"
    }
}
