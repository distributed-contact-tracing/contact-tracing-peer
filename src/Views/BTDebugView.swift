//
//  BTDebugView.swift
//  MySharedAir
//
//  Created by Axel Backlund on 2020-04-04.
//

import SwiftUI

struct BTDebugView: View {
    @ObservedObject var btManager = BluetoothManager()
    
    var body: some View {
        List(btManager.activePeripherals) { peripheral in
            PeripheralRow(peripheral: peripheral)
        }
    }
}

struct PeripheralRow: View {
    @ObservedObject var peripheral: ActivePeripheral
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(peripheral.peripheral.identifier)").fontWeight(.semibold)
            Text("Found \(peripheral.foundTimestamp)")
            Text("Last seen \(peripheral.lastSeenTimestamp)")
            Text("Signal strength \(peripheral.signalStrength ?? 0)")
            Text("Received token: \(peripheral.receivedHandshakeToken ?? "nil")")
            Text("Sent token: \(peripheral.sentHandshakeToken ?? "nil")")
            Text("Agreed on sent token: \(peripheral.shouldUseSentToken() ?? false ? "yes" : "no")")
        }
    }
}

struct BTDebugView_Previews: PreviewProvider {
    static var previews: some View {
        BTDebugView()
    }
}
