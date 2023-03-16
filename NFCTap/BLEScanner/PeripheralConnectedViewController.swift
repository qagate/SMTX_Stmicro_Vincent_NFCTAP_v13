//
//  PeripheralConnectedViewController.swift
//  ST25NFCApp
//
//  Created by STMicroelectronics on 13/06/2017.
//  Copyright © 2017 STMicroelectronics. All rights reserved.
//

import UIKit
import CoreBluetooth

class PeripheralConnectedViewController: UIViewController {

	@IBOutlet weak var peripheralName: UILabel!
	@IBOutlet weak var rssiLabel: UILabel!
    @IBOutlet weak var batteryLabel: UILabel!
    
	var peripheral: CBPeripheral?
	var reloadTimer: Timer?
	var services: [CBService] = []
    var centralManager: CBCentralManager?
	
    override func viewDidLoad() {
        super.viewDidLoad()

		peripheral?.delegate = self
		peripheralName.text = peripheral?.name
        
        reloadTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(PeripheralConnectedViewController.refreshValues), userInfo: nil, repeats: true)
        
        
	}
    
    @objc func refreshValues(){
        // Read RSSI Value
        peripheral?.readRSSI()
        
        // Read Battery Value
        services.forEach({ (service) in
            if (service.uuid == CBUUID(string: "180F")) {
                service.characteristics?.forEach({ (characteristic) in
                    switch characteristic.uuid.uuidString {
                    case "2A19":
                        // Read battery level
                        peripheral?.readValue(for: characteristic)
                        break
                    default:
                        break
                    }
                })
            }
        })
    }

	@IBAction func disconnectButtonPressed(_ sender: AnyObject) {
        reloadTimer?.invalidate()
        centralManager?.cancelPeripheralConnection(peripheral!)
        self.dismiss(animated: false, completion: nil)
	}
}

extension PeripheralConnectedViewController: CBPeripheralDelegate {
    
    func centralManager(_ central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        print("Error connecting peripheral: \(String(describing: error?.localizedDescription))")
	}

	func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
		if error != nil {
            print("Error discovering services: \(String(describing: error?.localizedDescription))")
		}
        
        peripheral.services?.forEach({ (service) in
            print("Service = "+service.uuid.uuidString)
            if (service.uuid == CBUUID(string: "180F")) {
                services.append(service)
                peripheral.discoverCharacteristics(nil, for: service)
            }
        })
	}
	
	func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
		if error != nil {
            print("Error discovering service characteristics: \(String(describing: error?.localizedDescription))")
		}
        for characteristic in (service.characteristics as [CBCharacteristic]?)!{
            peripheral.setNotifyValue(true, for: characteristic)
        }
	}
    
    // didReadRSSI
	func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
		
		switch RSSI.intValue {
		case -90 ... -60:
			rssiLabel.textColor = UIColor.bluetoothOrangeColor()
			break
		case -200 ... -90:
			rssiLabel.textColor = UIColor.bluetoothRedColor()
			break
		default:
			rssiLabel.textColor = UIColor.bluetoothGreenColor()
		}
		rssiLabel.text = "\(RSSI)dB"
	}
    
    // didUpdateValueFor
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print ("UUID Caracteristic = ",characteristic.uuid.uuidString)
        
         if let e = error {
            print("ERROR didUpdateValue \(e)")
            batteryLabel.textColor = UIColor.bluetoothRedColor()
            batteryLabel.text = "xx".localized
        }
        else{
            guard let data = characteristic.value else { return }
            batteryLabel.textColor = UIColor.bluetoothGreenColor()
            batteryLabel.text = "\(data.toHexString())"
        }
    }
}
