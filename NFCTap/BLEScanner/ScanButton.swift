//
//  ScanButton.swift
//  ST25NFCApp
//
//  Created by STMicroelectronics on 13/06/2017.
//  Copyright © 2017 STMicroelectronics. All rights reserved.
//

import UIKit

class ScanButton: UIButton {
	
	required init?(coder aDecoder: NSCoder){
		super.init(coder: aDecoder)
	}
	
	func buttonColorScheme(_ isScanning: Bool){
		let title = isScanning ? "Stop Scanning".localized : "Start Scanning".localized
        setTitle(title, for: UIControl.State())
		
		let titleColor = isScanning ? UIColor.bluetoothBlueColor() : UIColor.white
        setTitleColor(titleColor, for: UIControl.State())

		//backgroundColor = isScanning ? UIColor.clear : UIColor.bluetoothBlueColor()
	}
}
