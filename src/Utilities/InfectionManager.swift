//
//  InfectionManager.swift
//  MySharedAir
//
//  Created by Axel Backlund on 2020-04-05.
//

import Foundation
import Firebase

class InfectionManager {
    var db: Firestore
    
    init() {
        db = Firestore.firestore()
    }
    
    /*func downloadInfectedInteractions() {
        let
    }*/
    
    func uploadInfectedInteractions() {
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
                } else {
                    print("Batch write succeeded.")
                    LastUpdated().lastUpdatedDate = Date()
                }
            }
        } catch let e {
            print(e.localizedDescription)
        }
    }
    
    //func hasMatch
}
