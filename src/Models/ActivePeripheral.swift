//
//  ActivePeripheral.swift
//  DistContactTracing
//
//  Created by Axel Backlund on 2020-04-04.
//

import Foundation
import CoreBluetooth
import Combine

class ActivePeripheral: Identifiable, ObservableObject {
    let objectWillChange = ObservableObjectPublisher()
    let storageManager: StorageManager
    
    let peripheral: CBPeripheral
    let id: String
    var interaction: Interaction?
    
    var sentHandshakeToken: String? {
        didSet {
            objectWillChange.send()
            addToCoreData()
        }
    }
    var receivedHandshakeToken: String? {
        didSet {
            objectWillChange.send()
            addToCoreData()
        }
    }
    var signalStrengths: [NSNumber] {
        didSet {
            objectWillChange.send()
            updateCoreData()
        }
    }
    var timestamps: [Date] {
        didSet {
            objectWillChange.send()
            updateCoreData()
        }
    }
    
    init(signalStrength: NSNumber, peripheral: CBPeripheral, initialTimestamp: Date, storageManager: StorageManager) {
        self.peripheral = peripheral
        self.timestamps = [initialTimestamp]
        self.signalStrengths = [signalStrength]
        self.id = peripheral.identifier.uuidString
        self.storageManager = storageManager
    }
    
    func shouldUseSentToken() -> Bool? {
        if sentHandshakeToken != nil || receivedHandshakeToken != nil {
            // TODO: Are we sure the sent token is received?
            guard let sentToken = sentHandshakeToken else { return false }
            guard let receivedToken = receivedHandshakeToken else { return true }
            
            guard let sentTokenObject = TokenManager().tokenFrom(string: sentToken) else { return nil }
            guard let receivedTokenObject = TokenManager().tokenFrom(string: receivedToken) else { return nil }
            
            return sentTokenObject.timestamp >= receivedTokenObject.timestamp
        } else {
            return nil
        }
    }
    
    func severity() -> Float {
        return 0
    }
    
    private func addToCoreData() {
        if (sentHandshakeToken != nil || receivedHandshakeToken != nil) && interaction == nil {
            do {
                if let useSentToken = shouldUseSentToken() {
                    let tokenToUse = useSentToken ? sentHandshakeToken : receivedHandshakeToken
                    guard let hash = tokenToUse?.sha256() else { return }
                    print("HASH:", hash)
                    let storedInteraction = try storageManager.insertInteraction(id: hash, severity: severity())
                    interaction = storedInteraction
                }
            } catch (let e) {
                print(e.localizedDescription)
            }
        }
    }
    
    private func updateCoreData() {
        if let storedInteraction = interaction {
            do {
                try storageManager.update(storedInteraction, with: severity())
            } catch let e {
                print(e.localizedDescription)
            }
        }
    }
}

extension ActivePeripheral: Equatable {
    static func ==(lhs: ActivePeripheral, rhs: ActivePeripheral) -> Bool {
        return lhs.peripheral == rhs.peripheral
    }
}
