//
//  UserDefaults.swift
//  MySharedAir
//
//  Created by Axel Backlund on 2020-04-05.
//

import Foundation

class LastUpdated {
    var lastUpdatedDate: Date? {
        get {
            return UserDefaults.standard.object(forKey: #function) as? Date
        } set {
            UserDefaults.standard.set(newValue, forKey: #function)
        }
    }
}

class Authentication {
    var userID: String? {
        get {
            return UserDefaults.standard.string(forKey: #function)
        } set {
            UserDefaults.standard.set(newValue, forKey: #function)
        }
    }
}

class InfectedEvents {
    var shouldBeWarned: Bool? {
        get {
            return UserDefaults.standard.bool(forKey: #function)
        } set {
            UserDefaults.standard.set(newValue, forKey: #function)
        }
    }
    
    var isInfected: Bool? {
        get {
            return UserDefaults.standard.bool(forKey: #function)
        } set {
            UserDefaults.standard.set(newValue, forKey: #function)
        }
    }
    
    var hasUploadedData: Bool? {
        get {
            return UserDefaults.standard.bool(forKey: #function)
        } set {
            UserDefaults.standard.set(newValue, forKey: #function)
        }
    }
}
