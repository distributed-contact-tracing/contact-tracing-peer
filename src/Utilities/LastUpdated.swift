//
//  LastUpdated.swift
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
