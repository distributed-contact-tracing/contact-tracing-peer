//
//  BluetoothManager.swift
//  DistContactTracing
//
//  Created by Axel Backlund on 2020-04-03.
//

import Foundation
import CoreBluetooth
import Combine

final class BluetoothManager: NSObject, ObservableObject {
    private var centralManager: CBCentralManager?
    private var peripheralManager = CBPeripheralManager()
    private var uuid = CBUUID(string: "29927D08-7D4B-4CAC-B10A-8BBF882395D1")
    
    @Published var activePeripherals: [ActivePeripheral] = []
    
    let WR_UUID = CBUUID(string: "0437D2AC-A560-413E-BE04-A75E4FA5BBAE")
    let WR_PROPERTIES: CBCharacteristicProperties = .write
    let WR_PERMISSIONS: CBAttributePermissions = .writeable
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
}

extension BluetoothManager: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if (peripheral.state == .poweredOn){
            let serialService = CBMutableService(type: uuid, primary: true)
            let writeCharacteristics = CBMutableCharacteristic(type: WR_UUID,
                                             properties: WR_PROPERTIES, value: nil,
                                             permissions: WR_PERMISSIONS)
            serialService.characteristics = [writeCharacteristics]
            peripheralManager.add(serialService)
            
            peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey: [uuid]])
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        for request in requests {
            if let value = request.value {
                let messageText = String(data: value, encoding: String.Encoding.utf8)
                if let centralReference = activePeripherals.first(where: { $0.peripheral.identifier == request.central.identifier }) {
                    centralReference.receivedHandshakeToken = messageText
                }
            }
            self.peripheralManager.respond(to: request, withResult: .success)
        }
    }
}

extension BluetoothManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if (central.state == .poweredOn) {
          centralManager?.scanForPeripherals(withServices: [uuid], options: [CBCentralManagerScanOptionAllowDuplicatesKey: false])
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        let activePeripheral = ActivePeripheral(signalStrength: RSSI, peripheral: peripheral, foundTimestamp: Date(), lastSeenTimestamp: Date())
        
        if !activePeripherals.contains(activePeripheral) {
            // New object found
            activePeripherals.append(activePeripheral)
            if let lastAdded = activePeripherals.last {
                centralManager?.connect(lastAdded.peripheral, options: nil)
            }
        } else {
            // Update proximity
            activePeripherals.first(where: { $0.peripheral == peripheral })?.signalStrength = RSSI
            activePeripherals.first(where: { $0.peripheral == peripheral })?.lastSeenTimestamp = Date()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
}

extension BluetoothManager: CBPeripheralDelegate {
    func peripheral( _ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in peripheral.services! {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral( _ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for characteristic in service.characteristics! {
            let characteristic = characteristic as CBCharacteristic
            if (characteristic.uuid.isEqual(WR_UUID)) {
                let token = TokenManager().createToken()
                activePeripherals.first(where: { $0.peripheral == peripheral })?.sentHandshakeToken = token
                
                if let data = token.data(using: .utf8) {
                    peripheral.writeValue(data, for: characteristic, type: CBCharacteristicWriteType.withResponse)
                }
            }
        }
    }
}
