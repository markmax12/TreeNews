//
//  String+Regex.swift
//  Telegram Bot
//
//  Created by Maxim Ivanov on 26.04.2023.
//

import Foundation

extension String {
    
    private enum TweetRegexPattern: String {
        case quoteLink = " https://\\S+\nQuote "
        case trailingLink = " https://t.co\\S+$"
        case retweetHeader = "^.+retweeted\\s@\\w+:"
    }
    
    //TODO: NOT SAFE METHODS, IMPLEMENT ERROR HANDLING
    public func processQuoteTweet() -> String {
        if #available(macOS 13.0, *) {
            let regexPattern = try! Regex(TweetRegexPattern.quoteLink.rawValue)
            return self.splitQuote(using: regexPattern)
        } else {
            let range = self.range(of: TweetRegexPattern.quoteLink.rawValue, options: .regularExpression)!
            return self.splitQuote(using: range)
        }
    }
    
    public func processRegularTweet() -> String {
        if #available(macOS 13.0, *) {
            let regexPattern = try! Regex(TweetRegexPattern.trailingLink.rawValue)
            var body = self.removeTrailingLink(using: regexPattern)
            body = body.escapeMarkdown()
            return body
        } else {
            var body = self.removeTrailingLink(using: TweetRegexPattern.trailingLink.rawValue)
            body = body.escapeMarkdown()
            return body
        }
    }
    
    public func processRetweet() -> String {
        if #available(macOS 13.0, *) {
            let retweetHeaderPattern = try! Regex(TweetRegexPattern.retweetHeader.rawValue)
            return self.splitRetweet(using: retweetHeaderPattern)
        } else {
            let range = self.range(of: TweetRegexPattern.retweetHeader.rawValue, options: .regularExpression)!
            return self.splitRetweet(using: range)
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
    
    private func splitQuote(using range: Range<String.Index>) -> String {
        var body = String(self[self.startIndex ..< range.lowerBound]).escapeMarkdown().newLine().newLine()
        let textAfterQuote = self[range.upperBound ..< self.endIndex]
        if let rng = textAfterQuote.range(of: "\n") {
            let link = self[range.upperBound ..< rng.lowerBound]
            body += "\\>Quotes tweet, read it ⬇️".bolded().newLine() + String(link).newLine()
        }
        return body
    }
    
    @available(macOS 13.0, *)
    private func removeTrailingLink(using pattern: Regex<AnyRegexOutput>) -> String {
        return self.replacing(pattern, with: "")
    }
    
    private func removeTrailingLink(using pattern: String) -> String {
        return self.replacingOccurrences(of: pattern, with: "", options: .regularExpression)
    }
    
    @available(macOS 13.0, *)
    private func splitRetweet(using pattern: Regex<AnyRegexOutput>) -> String {
        var body = ""
        var header = ""
        if let match = self.prefixMatch(of: pattern) {
            header = String(self[match.range])
            body = String(self[match.range.upperBound ..< endIndex])
        }
        let trailingLinkPattern = try! Regex(TweetRegexPattern.trailingLink.rawValue)
        body = body.removeTrailingLink(using: trailingLinkPattern)
        body = body.escapeMarkdown()
        return header.bolded() + "`\(body)`"
    }
    
    private func splitRetweet(using range: Range<String.Index>) -> String {
        var header = String(self[range])
        var body = String(self[range.upperBound ..< endIndex])
        body = body.removeTrailingLink(using: TweetRegexPattern.trailingLink.rawValue)
        body = body.escapeMarkdown()
        return header.bolded() + "`\(body)`"
    }
}

