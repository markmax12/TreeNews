//
//  String+Markup.swift
//  Telegram Bot
//
//  Created by Maxim Ivanov on 26.04.2023.
//

import Foundation

public extension String {
    func bolded() -> String {
        return "*" + self + "*"
    }
    
    func newLine() -> String {
        return self + "\n"
    }
    
    //TODO: Provide a better implementation
    func escapeMarkdown() -> String {
        let arr: [Character] = ["*", "_", "[", "]", "(", ")", "~", "`", ">", "#", "+", "-", "=", "|", "{", "}", ".", "!", "@"]
        let charsToEscape = Set(arr)
        
        var res = ""
        for i in self {
            if charsToEscape.contains(i) {
                //TODO: REPLACE @ WITH LINKS TO TWITTER PROFILES
                if i == "@" { res += "@\u{200B}"; continue }
                res += "\\\(i)"
                continue
            }
            res += String(i)
        }
        return res
    }
}
