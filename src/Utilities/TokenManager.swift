//
//  TokenManager.swift
//  MySharedAir
//
//  Created by Axel Backlund on 2020-04-04.
//

import Foundation

struct Token {
    let timestamp: TimeInterval
    let uuid: String
}

struct TokenManager {
    func createStringToken() -> String {
        let date = Date().timeIntervalSince1970
        let randID = UUID().uuidString
        
        let token = String(date) + "_" + randID
        return token
    }
    
    func tokenFrom(string: String) -> Token? {
        let tokenComponents = string.components(separatedBy: "_")
        
        if tokenComponents.count == 2 {
            guard let timestamp = TimeInterval(tokenComponents[0]) else { return nil }
            let uuid = tokenComponents[1]
            return Token(timestamp: timestamp, uuid: uuid)
        } else {
            return nil
        }
    }
}
