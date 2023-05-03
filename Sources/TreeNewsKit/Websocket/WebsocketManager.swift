//
//  Network Manager.swift
//  Telegram Bot
//
//  Created by Maxim Ivanov on 13.04.2023.
//

import Foundation

public final class WebsocketManager<T> where T: API {
    //TODO: CHECK PING FUNCTION, TIME TO SLEEP ALSO
    private let api: T
    private let url = URL(string: "wss://news.treeofalpha.com/ws")
    private let urlsession: URLSession
    
    public init(with api: T, urlsession: URLSession = URLSession(configuration: .default)) {
        self.api = api
        self.urlsession = urlsession
    }
    
    private lazy var websocketTask: URLSessionWebSocketTask = {
        let task = urlsession.webSocketTask(with: url!)
        task.resume()
        return task
    }()
    
    
    public func subscribe() async throws {
        let msg = URLSessionWebSocketTask.Message.string("open")
        
        do {
            try await websocketTask.send(msg)
            print("subscribed")
        } catch {
            throw RunTimeError("Can not subscribe, error: \(error)")
        }
    }
    
    public func unsubscribe() async throws {
        let msg = URLSessionWebSocketTask.Message.string("close")
        
        do {
            try await websocketTask.send(msg)
        } catch {
            throw RunTimeError("Can not unsubscribe, error: \(error)")
        }
        
        websocketTask.cancel()
    }
    
    public func sendPing() async throws {
        do {
            let response = try await websocketTask.sendPing()
            print(response)
        } catch {
            throw RunTimeError("Can not send ping, error: \(error)")
        }
        
        try await Task.sleep(nanoseconds: 600_000_000_000)
        try await sendPing()
    }
    
    //TODO: MOVE RECIEVING LOGIC IN EXTENSION, REWORK PROCESSING
    public func recieveMessage() async throws {
        do {
            let data = try await websocketTask.receive()
            switch data {
            case .string(let string):
                print(string)
                let data = Data(string.utf8)
                try sendRequest(with: data)
                
            case .data(let data):
                try sendRequest(with: data)
                
            @unknown default:
                fatalError()
            }
            try await Task.sleep(nanoseconds: 1_000_000_000)
            try await recieveMessage()
        } catch {
            throw RunTimeError("Can not recieve message, error: \(error)")
        }
    }
}

private extension WebsocketManager {
    func sendRequest(with data: Data) throws {
        let news = try JSONDecoder()
            .decode(AnyNews.self, from: data)
        let recievedTime = Date()
        let formattedTime = DateFormatterSingleton.shared.formatter.string(from: recievedTime)
        print("Recieved at: \(formattedTime)")
        Task {
            try await api.onRecieve(news: news)
        }
    }
}
