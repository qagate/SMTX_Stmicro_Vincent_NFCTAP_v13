//
//  NDEFUriRecord.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 13/10/2017.
//  Copyright © 2017 STMicroelectronics. All rights reserved.
//

import UIKit
import CoreNFC

class NDEFBtRecords: NDEFRecords{
    
    var mComStSt25sdkNdefNDEFBt:ComStSt25sdkNdefBtRecord!
    
    override init() {
        super.init()
    }
    
    override init(ndefRecord:ComStSt25sdkNdefNDEFRecord){
        super.init()
        mComStSt25sdkNdefNDEFBt = ndefRecord as! ComStSt25sdkNdefBtRecord
        create()
    }
    
    // designated initializer
    override init(ndefMsg:ComStSt25sdkNdefNDEFMsg,payload:NFCNDEFPayload){
        
        super.init(ndefMsg: ndefMsg,payload: payload)
        self.mRecordTypeString = "NDEF BT"
        self.mImage = UIImage(named: "bluetoothAppli")!
        
        mComStSt25sdkNdefNDEFBt =
            ndefMsg.getNDEFRecord(with: 0) as! ComStSt25sdkNdefBtRecord
        
        mComStSt25sdkNdefNDEFBt.setIdWith(IOSByteArray(nsData: payload.identifier))
    }

    private func create(){
       if (mComStSt25sdkNdefNDEFBt?.getBTDeviceName() != nil){
           print("BTLE Device Name = "+(mComStSt25sdkNdefNDEFBt?.getBTDeviceName())!)
       }
       
       if mComStSt25sdkNdefNDEFBt?.getBTDeviceMacAddr() != nil {
           let getDeviceMacAddrNSData = mComStSt25sdkNdefNDEFBt?.getBTDeviceMacAddr().toNSData()
           print("BTLE Device Mac  = ",getDeviceMacAddrNSData?.toHexString() as Any)
           for item in getDeviceMacAddrNSData! {
               let itemHex = String(item, radix: 16)
               print(itemHex)
           }

       }
       if mComStSt25sdkNdefNDEFBt.getBTDeviceName() != nil {
           self.mRecordValue=(mComStSt25sdkNdefNDEFBt?.getBTDeviceName()!)!+"\n"
       }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
}




