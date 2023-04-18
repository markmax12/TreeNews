//
//  main.swift
//  Telegram Bot
//
//  Created by Maxim Ivanov on 13.04.2023.
//

import Foundation

func main() {
    
    let jsonString = """
{"title":"COINDESK: Lido Considers Using Its ARB Airdrop to Boost Activity on Arbitrum","source":"Blogs","url":"https://www.coindesk.com/business/2023/04/18/lido-considers-using-its-arb-airdrop-to-boost-activity-on-arbitrum/","time":1681851104139,"symbols":["ARB_USDT","ARB_BTC"],"en":"COINDESK: Lido Considers Using Its ARB Airdrop to Boost Activity on Arbitrum","firstPrice":{"ARBUSDT":1.673,"ARBBTC":0.00005515},"_id":"1681851104138CLCUIAAtBAoA","suggestions":[{"found":["Arbitrum","ARB"],"coin":"ARB","symbols":[{"exchange":"binance-futures","symbol":"ARBUSDT"},{"exchange":"binance","symbol":"ARBUSDT"},{"exchange":"binance","symbol":"ARBBTC"},{"exchange":"bybit-perps","symbol":"ARBUSDT"}]},{"found":["Lido"],"coin":"LDO","symbols":[{"exchange":"binance-futures","symbol":"LDOUSDT"},{"exchange":"binance","symbol":"LDOUSDT"},{"exchange":"binance","symbol":"LDOBTC"},{"exchange":"binance","symbol":"LDOBUSD"},{"exchange":"bybit-perps","symbol":"LDOUSDT"}]}],"actions":[{"action":"BINFUT_ARBUSDT","title":"ARBUSDT PERP","icon":"https://news.treeofalpha.com/static/images/binance_icon.png"},{"action":"BIN_ARB_USDT","title":"ARB/USDT","icon":"https://news.treeofalpha.com/static/images/binance_icon.png"},{"action":"BIN_ARB_BTC","title":"ARB/BTC","icon":"https://news.treeofalpha.com/static/images/binance_icon.png"},{"action":"BYBIT_ARBUSDT","title":"ARBUSDT PERP","icon":"https://news.treeofalpha.com/static/images/bybit.png"}],"delay":5000}
"""
    let data = Data(jsonString.utf8)
    let news = try? JSONDecoder().decode(News.self, from: data)
    if let news = news {
        print("Parsed")
        let endpoint = TelegramEndpoint.sendMessage(news: news)
        func buildURL(endpoint: Endpoint) -> URL {
            var components = URLComponents()
            components.scheme = "https"
            print(components.scheme)
            components.host = "api.telegram.org"
            print(components.host)
            components.path = "bot6279864266:AAH1AfstVh4A9IXjN-pEMRB_IyY12mGNmuo/sendMessage"
            print(components.path)
            components.queryItems = [
            URLQueryItem(name: "chat_id", value: "@treenewsc"),
            URLQueryItem(name: "text", value: "\(news.title ?? "fuck")"),
            URLQueryItem(name: "parse_mode", value: "MarkdownV2")
            ]
            guard let url = components.url else { fatalError() }
            return url
        }
        print(buildURL(endpoint: endpoint))
    }
    
//    let websocketManager = WSManager()
//    Task {
//        try await websocketManager.subscribe()
//         try await websocketManager.recieveMessage()
//    }
//    print("A")
//    while true {
//
//    }
}

main()
