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
    @Published var signalStrength: NSNumber?
    let peripheral: CBPeripheral
    let foundTimestamp: Date
    @Published var sentHandshakeToken: String?
    @Published var receivedHandshakeToken: String?
    @Published var lastSeenTimestamp: Date
    let id: String
    
    init(signalStrength: NSNumber, peripheral: CBPeripheral, foundTimestamp: Date, lastSeenTimestamp: Date) {
        self.signalStrength = signalStrength
        self.peripheral = peripheral
        self.foundTimestamp = foundTimestamp
        self.lastSeenTimestamp = lastSeenTimestamp
        self.id = peripheral.identifier.uuidString
    }
}

extension ActivePeripheral: Equatable {
    static func ==(lhs: ActivePeripheral, rhs: ActivePeripheral) -> Bool {
        return lhs.peripheral == rhs.peripheral
    }
}
