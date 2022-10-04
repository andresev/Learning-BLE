//
//  ContentView.swift
//  Learning-BLE
//
//  Created by Andres Valdez on 9/27/22.
//

import SwiftUI
import CoreBluetooth

class BluetoothViewModel: NSObject, ObservableObject {
    private var centralManager: CBCentralManager?
    var peripherals: [CBPeripheral] = []
    @Published var peripheralNames: [String] = []
    
    override init() {
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: .main)
    }
    
    func connectToPeripheral(UUID: String) {
        if let peripheral = peripherals.filter({$0.identifier.uuidString == UUID}).first {
            self.centralManager?.connect(peripheral)
        }
    }
    
    func disconnectPeripheral(UUID: String) {
        if let peripheral = peripherals.filter({$0.identifier.uuidString == UUID}).first {
            self.centralManager?.cancelPeripheralConnection(peripheral)
        }
    }
}

extension BluetoothViewModel: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            self.centralManager?.scanForPeripherals(withServices: [CBUUID(string: "0x00FF")])
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !peripherals.contains(peripheral) {
            self.peripherals.append(peripheral)
            self.peripheralNames.append(peripheral.name ?? "unnamed device")
//            self.centralManager?.connect(peripheral)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected!")
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected!")
    }
}


struct ContentView: View {
    @ObservedObject private var bluetoothViewModel = BluetoothViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                ForEach(bluetoothViewModel.peripherals, id: \.self) { peripheral in
                    
                    HStack {
                        Button {
                            bluetoothViewModel.connectToPeripheral(UUID: peripheral.identifier.uuidString)
                        } label: {
                            Text(peripheral.name ?? "unnamed device")
                        }
                        
                        Spacer()
                        
                        Button {
                            bluetoothViewModel.disconnectPeripheral(UUID: peripheral.identifier.uuidString)
                        } label: {
                            Text("Disconnect")
                        }
                    }
                    .padding(10)
                    Divider()
                     .frame(height: 1)
                     .padding(.horizontal, 30)
                     .background(Color.gray)
                }
                Spacer()
            }
            .navigationTitle("Peripherals")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
