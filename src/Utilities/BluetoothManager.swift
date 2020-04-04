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
    
    let objectWillChange = PassthroughSubject<Void, Never>()
    @Published var activePeripherals: [ActivePeripheral] = [] {
        willSet { objectWillChange.send() }
    }
    
    let WR_UUID = CBUUID(string: "0437D2AC-A560-413E-BE04-A75E4FA5BBAE")
    let WR_PROPERTIES: CBCharacteristicProperties = .write
    let WR_PERMISSIONS: CBAttributePermissions = .writeable
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        
        //let descString = "dist-contact-tracing-client"
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
            
            let advertisementData = String(format: "Hello from lenas iphone")
            print("Start advertising")
            peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey: [uuid], CBAdvertisementDataLocalNameKey: advertisementData])
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        for request in requests {
            if let value = request.value {
                //here is the message text that we receive, use it as you wish.
                let messageText = String(data: value, encoding: String.Encoding.utf8)
                print("RECEIVED MESSAGE", messageText)
            }
            self.peripheralManager.respond(to: request, withResult: .success)
        }
    }
}

extension BluetoothManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if (central.state == .poweredOn) {
            
          //here we scan for the devices with a UUID that is specific to our app, which filters out other BLE devices.
          centralManager?.scanForPeripherals(withServices: [uuid], options: [CBCentralManagerScanOptionAllowDuplicatesKey: false])
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        // Here we can read peripheral.identifier as UUID, and read our advertisement data by the key CBAdvertisementDataLocalNameKey.
        print("DISCOVERED PERIPHERAL:")
        print(peripheral.identifier)
        print(RSSI)
        if let advertisementName = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
            print("NAME:", advertisementName)
        }
        
        let activePeripheral = ActivePeripheral(signalStrength: RSSI, peripheral: peripheral, foundTimestamp: Date(), lastSeenTimestamp: Date())
        
        if !activePeripherals.contains(activePeripheral) {
            print("New object found")
            activePeripherals.append(activePeripheral)
            print("Added to list")
        } else {
            // Update proximity
            print("Update proximity")
            /*activePeripherals = activePeripherals.map { peripheralItem in
                if peripheralItem.peripheral == peripheral {
                    var updatedPeripheral = activePeripheral
                    updatedPeripheral.lastSeenTimestamp = Date()
                    updatedPeripheral.signalStrength = RSSI
                    return updatedPeripheral
                } else {
                    return peripheralItem
                }
            }*/
            
            //activePeripherals[0].lastSeenTimestamp = Date()
            //activePeripherals[0].signalStrength = RSSI
            activePeripherals.first(where: { $0.peripheral == peripheral })?.signalStrength = RSSI
            activePeripherals.first(where: { $0.peripheral == peripheral })?.lastSeenTimestamp = Date()
            for item in activePeripherals {
                print("PERS:", item.signalStrength)
                print("PERS:", item.lastSeenTimestamp)
            }
            //activePeripherals.first { $0.peripheral == peripheral }?.signalStrength = RSSI
        }
        connectOnce()
        //print("DATA:", advertisementData)
    }
    
    func connectOnce() {
        struct Holder { static var called = false }

        if !Holder.called {
            Holder.called = true
            //centralManager?.connect(activePeripherals[0], options: nil)
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
                print("HAS DEM THING")
                let data = "Here you go with unique ID".data(using: .utf8)
                peripheral.writeValue(data!, for: characteristic, type: CBCharacteristicWriteType.withResponse)
            }
            
        }
    }
}
