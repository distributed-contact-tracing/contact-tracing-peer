//
//  UserDefaultsManager.swift
//  MySharedAir
//
//  Created by Axel Backlund on 2020-04-05.
//

import Foundation

class Authentication {
    var userID: String? {
        get {
            return UserDefaults.standard.string(forKey: #function)
        } set {
            UserDefaults.standard.set(newValue, forKey: #function)
        }
    }
}
