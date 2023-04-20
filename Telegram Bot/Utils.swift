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
    
    //TODO: Provide a better implementation
    public func escapeMarkdown() -> String {
        let arr: [Character] = ["*", "_", "[", "]", "(", ")", "~", "`", ">", "#", "+", "-", "=", "|", "{", "}", ".", "!"]
        let charsToEscape = Set(arr)
        
        var res = ""
        for i in self {
            if charsToEscape.contains(i) {
                res += "\\\(i)"
                continue
            }
            res += String(i)
        }
        return res
    }
}
