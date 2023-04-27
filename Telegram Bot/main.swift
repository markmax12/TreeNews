//
//  main.swift
//  Telegram Bot
//
//  Created by Maxim Ivanov on 13.04.2023.
//

import Foundation

func main() {
    let websocketManager = WSManager()
    
    Task {
        try await websocketManager.subscribe()
        try await websocketManager.recieveMessage()
    }
    
    Task {
        try await websocketManager.sendPing()
    }
}

main()

while true {
    try! await Task.sleep(nanoseconds: 1_000_000_000)
}
