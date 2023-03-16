//
//  ST25TV04KPTag.swift
//  NFCTap 
//
//  Created by STMicroelectronics on 28/07/2020.
//  Copyright © 2020 STMicroelectronics. All rights reserved.
//

import Foundation
import UIKit
import CoreNFC

@available(iOS 13, *)
class ST25TV04KPTag: ComStSt25sdkType5St25dvST25TV04KPTag{
    
    var mComStSt25sdkRFReaderInterface:iOSRFReaderInterface!
    
    
    init(RFReaderInterface:iOSRFReaderInterface,uid:Data) {
        super.init(comStSt25sdkRFReaderInterface: RFReaderInterface, with: IOSByteArray.init(nsData: uid))
        mComStSt25sdkRFReaderInterface = RFReaderInterface
    }
    
    func presentPassword(passwordNumber:UInt8, password: Data!) {
        let PwdIOSByteArray = IOSByteArray.init(nsData: password)

        presentPassword(with: jint(passwordNumber), with: PwdIOSByteArray)
        //mComStSt25sdkRFReaderInterface.miOSIso15693.customCommand(code: 0xB3, data: Data( [0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00]))
    }

}
