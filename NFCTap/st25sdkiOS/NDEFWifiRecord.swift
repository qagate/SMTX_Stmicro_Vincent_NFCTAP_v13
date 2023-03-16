//
//  NDEFUriRecord.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 13/10/2017.
//  Copyright © 2017 STMicroelectronics. All rights reserved.
//

import UIKit
import CoreNFC

class NDEFWifiRecords: NDEFRecords{
    
    var mComStSt25sdkNdefNDEFWifi   : ComStSt25sdkNdefWifiRecord!
    
    override init() {
        super.init()
    }

    override init(ndefRecord:ComStSt25sdkNdefNDEFRecord){
        super.init()
        mComStSt25sdkNdefNDEFWifi = ndefRecord as! ComStSt25sdkNdefWifiRecord
        create()
    }

    // designated initializer
    override init(ndefMsg:ComStSt25sdkNdefNDEFMsg,payload:NFCNDEFPayload){
        
        super.init(ndefMsg: ndefMsg,payload: payload)
        self.mRecordTypeString = "NDEF WIFI"
        self.mImage = UIImage(named: "wifi")!
        
        mComStSt25sdkNdefNDEFWifi =
            ndefMsg.getNDEFRecord(with: 0) as! ComStSt25sdkNdefWifiRecord
       
        mComStSt25sdkNdefNDEFWifi.setIdWith(IOSByteArray(nsData: payload.identifier))
        
    }

    private func create(){
        let SSIDString = mComStSt25sdkNdefNDEFWifi.getSSID()!
        let authentificationTypeInt = mComStSt25sdkNdefNDEFWifi.getAuthType()
        let keyString=mComStSt25sdkNdefNDEFWifi.getEncrKey()!
        self.mRecordValue = SSIDString+"\n"
        self.mRecordValue.append(authentificationTypeInt.description+"\n")
        self.mRecordValue.append(keyString+"\n")
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
}




