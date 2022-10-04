//
//  BluetoothService.swift
//  Learning-BLE
//
//  Created by Andres Valdez on 9/27/22.
//

import Foundation
import CoreBluetooth

class BluetoothService: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    var centralManager: CBCentralManager!
    
    override init() {
        super.init()
        
        self.centralManager = CBCentralManager(delegate: self, queue: nil);
        self.centralManager.delegate = self
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            centralManager.scanForPeripherals(withServices: nil)
        default:
            break
        }
    }
    
    func printName(name: String) {
        print("PERIPHERAL: \(name)")
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        //
        
        printName(name: peripheral.identifier.uuidString)
    }
    
}
