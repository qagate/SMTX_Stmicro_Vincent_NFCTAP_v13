//
//  DeviceTableViewCell.swift
//  ST25NFCApp
//
//  Created by STMicroelectronics on 13/06/2017.
//  Copyright © 2017 STMicroelectronics. All rights reserved.
//

import UIKit
import CoreBluetooth

protocol DeviceCellDelegate: class {
	func connectPressed(_ peripheral: CBPeripheral)
}

class DeviceTableViewCell: UITableViewCell {

	@IBOutlet weak var deviceNameLabel: UILabel!
	@IBOutlet weak var deviceRssiLabel: UILabel!
	@IBOutlet weak var connectButton: UIButton!
	
	var delegate: DeviceCellDelegate?
	
	var displayPeripheral: DisplayPeripheral? {
		didSet {
			if let deviceName = displayPeripheral!.peripheral?.name{
				deviceNameLabel.text = deviceName.isEmpty ? "No Device Name".localized : deviceName
            }else{
				deviceNameLabel.text = "No Device Name".localized
			}
			
			if let rssi = displayPeripheral!.lastRSSI {
				deviceRssiLabel.text = "\(rssi)dB"
			}
			
			connectButton.isHidden = !(displayPeripheral?.isConnectable!)!
		}
	}
	
	@IBAction func connectButtonPressed(_ sender: AnyObject) {
		delegate?.connectPressed((displayPeripheral?.peripheral)!)
	}
}
