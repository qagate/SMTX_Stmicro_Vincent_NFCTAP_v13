//
//  NDEFUriRecord.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 13/10/2017.
//  Copyright © 2017 STMicroelectronics. All rights reserved.
//

import UIKit
import CoreNFC

class NDEFBtleRecords: NDEFRecords{
    
    var mComStSt25sdkNdefNDEFBtLe:ComStSt25sdkNdefBtLeRecord!
    
    override init() {
        super.init()
    }
    
    override init(ndefRecord:ComStSt25sdkNdefNDEFRecord){
        super.init()
        mComStSt25sdkNdefNDEFBtLe = ndefRecord as! ComStSt25sdkNdefBtLeRecord
        create()
    }

    // designated initializer
    override init(ndefMsg:ComStSt25sdkNdefNDEFMsg,payload:NFCNDEFPayload){
        
        super.init(ndefMsg: ndefMsg,payload: payload)
        self.mRecordTypeString = "NDEF BTLE"
        self.mImage = UIImage(named: "bluetoothAppli")!
        
        mComStSt25sdkNdefNDEFBtLe =
            ndefMsg.getNDEFRecord(with: 0) as! ComStSt25sdkNdefBtLeRecord
        
        mComStSt25sdkNdefNDEFBtLe.setIdWith(IOSByteArray(nsData: payload.identifier))
        
    }
    
    private func create(){
        if (mComStSt25sdkNdefNDEFBtLe?.getBTDeviceName() != nil){
            print("BTLE Device Name = "+(mComStSt25sdkNdefNDEFBtLe?.getBTDeviceName())!)
        }
        
        let getDeviceMacAddrNSData = mComStSt25sdkNdefNDEFBtLe?.getBTDeviceMacAddr().toNSData()
        print("BTLE Device Mac  = ",getDeviceMacAddrNSData?.toHexString() as Any)
        for item in getDeviceMacAddrNSData! {
            let itemHex = String(item, radix: 16)
            print(itemHex)
        }
        self.mRecordValue=(mComStSt25sdkNdefNDEFBtLe?.getBTDeviceName()!)!+"\n"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
}



