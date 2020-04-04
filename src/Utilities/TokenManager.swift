//
//  TokenManager.swift
//  MySharedAir
//
//  Created by Axel Backlund on 2020-04-04.
//

import Foundation


struct TokenManager {
    func createToken() -> String {
        let date = Date().timeIntervalSince1970
        let randID = UUID().uuidString
        
        let token = String(date) + "_" + randID
        return token
    }
    
    /*func shouldUseDeviceToken(deviceToken: String, remoteToken: String) -> Bool {
        
    }*/
}
