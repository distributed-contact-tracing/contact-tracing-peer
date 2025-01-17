//
//  InfectionManager.swift
//  MySharedAir
//
//  Created by Axel Backlund on 2020-04-05.
//

import Foundation
import Firebase

class InfectionManager {
    static let shared = InfectionManager()
    private init() {}
    
    lazy var db: Firestore = {
        return Firestore.firestore()
    }()
    
    func downloadInfectedInteractions(completionHandler: @escaping (_ result: [String]?, _ error: Error?) -> Void) {
        let interactionsRef = db.collection("contactEvents")
        let lastFetch = LastUpdated().lastUpdatedDate ?? Date(timeIntervalSince1970: 0)
        
        interactionsRef.whereField("added", isGreaterThan: lastFetch).getDocuments() { querySnapshot, err in
            if let err = err {
                print("Error getting documents: \(err)")
                completionHandler(nil, err)
            } else {
                if let querySnapshot = querySnapshot {
                    let interactionList = querySnapshot.documents.compactMap { $0.data()["token"] as? String }
                    LastUpdated().lastUpdatedDate = Date()
                    completionHandler(interactionList, nil)
                }
            }
        }
    }
    
    func uploadInfectedInteractions(completionHandler: @escaping (_ error: Error?) -> Void) {
        let batch = db.batch()
        
        do {
            let interactions = try StorageManager.shared.fetchInteractions()
            interactions.forEach { interaction in
                let docRef = db.collection("contactEvents").document()
                let data = [
                    "token": interaction.id as Any,
                    "severity": interaction.severity,
                    "added": FieldValue.serverTimestamp()
                ] as [String : Any]
                batch.setData(data, forDocument: docRef)
            }
            
            batch.commit() { err in
                if let err = err {
                    print("Error writing batch \(err.localizedDescription)")
                    completionHandler(err)
                } else {
                    print("Batch write succeeded.")
                    completionHandler(nil)
                }
            }
        } catch let e {
            print(e.localizedDescription)
            completionHandler(e)
        }
    }
    
    func findMatch(from array: [String]) -> Bool {
        do {
            let savedItems = try StorageManager.shared.fetchInteractions()
            let keys = savedItems.compactMap { $0.id }
            let keysSet = Set(keys)
            let compareSet = Set(array)
            
            let intersect = Array(keysSet.intersection(compareSet))
            return intersect.count != 0
        } catch let e {
            print("Error getting data:", e.localizedDescription)
            return false
        }
    }
    
    func uploadDeviceNotificationToken(_ token: String, for uid: String, completionHandler: @escaping (_ error: Error?) -> Void) {
        let documentRef = db.collection("deviceRegistrationTokens").document(uid)
        documentRef.setData(["fcmToken": token]) { err in
            if let err = err {
                print("Error writing token \(err.localizedDescription)")
                completionHandler(err)
            } else {
                print("Token write succeeded.")
                completionHandler(nil)
            }
        }
    }
}
