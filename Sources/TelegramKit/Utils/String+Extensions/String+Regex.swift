//
//  String+Regex.swift
//  Telegram Bot
//
//  Created by Maxim Ivanov on 26.04.2023.
//

import Foundation

extension String {
    
    private enum TweetRegexPattern: String {
        case quteLink = " https://\\S+\nQuote "
        case trailingLink = " https://t.co\\S+$"
        case retweetHeader = "^.+retweeted\\s@\\w+:"
    }
    
    //TODO: NOT SAFE METHODS, IMPLEMENT ERROR HANDLING
    public func processQuoteTweet() -> String {
        if #available(macOS 13.0, *) {
            let regexPattern = try! Regex(TweetRegexPattern.quteLink.rawValue)
            return self.splitQuote(using: regexPattern)
        } else {
            fatalError("for now, macOS 13 only")
        }
    }
    
    public func processRegularTweet() -> String {
        if #available(macOS 13.0, *) {
            let regexPattern = try! Regex(TweetRegexPattern.trailingLink.rawValue)
            var body = self.removeTrailingLink(using: regexPattern)
            body = body.escapeMarkdown()
            return body
        } else {
            fatalError("for now, macOS 13 only")
        }
    }
    
    public func processRetweet() -> String {
        if #available(macOS 13.0, *) {
            var body = ""
            let retweetHeaderPattern = try! Regex(TweetRegexPattern.retweetHeader.rawValue)
            var header = ""
            if let match = self.prefixMatch(of: retweetHeaderPattern) {
                header = String(self[match.range])
            }
            let trailingLinkPattern = try! Regex(TweetRegexPattern.trailingLink.rawValue)
            body = body.removeTrailingLink(using: trailingLinkPattern)
            body = body.escapeMarkdown()
            return header.bolded() + "`\(body)`"
        } else {
            fatalError("for now, macOS only")
        }
    }
    
    @available(macOS 13.0, *)
    private func splitQuote(using pattern: Regex<AnyRegexOutput>) -> String {
        let initialTextArray = self.split(separator: pattern)
        var body = String(initialTextArray[0]).escapeMarkdown().newLine().newLine()
        let quoteTextArray = initialTextArray[1].split(separator: "\n", maxSplits: 1)
        let link = String(quoteTextArray[0])
        body += "\\>Quotes tweet, read it ⬇️".bolded().newLine() + link.newLine()
        return body
    }
    
    @available(macOS 13.0, *)
    private func removeTrailingLink(using pattern: Regex<AnyRegexOutput>) -> String {
        return self.replacing(pattern, with: "")
    }
}

