//
//  NDEFUriRecord.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 13/10/2017.
//  Copyright © 2017 STMicroelectronics. All rights reserved.
//

import UIKit
import CoreNFC

class NDEFSmsRecords: NDEFRecords{
    
    var mComStSt25sdkNdefNDEFSms   : ComStSt25sdkNdefSmsRecord!
    
    override init() {
        super.init()
    }
    
    override init(ndefRecord:ComStSt25sdkNdefNDEFRecord){
        super.init()
        mComStSt25sdkNdefNDEFSms = ndefRecord as! ComStSt25sdkNdefSmsRecord
        create()
    }

    // designated initializer
    override init(ndefMsg:ComStSt25sdkNdefNDEFMsg,payload:NFCNDEFPayload){
        
        super.init(ndefMsg: ndefMsg,payload: payload)
        self.mRecordTypeString = "NDEF SMS"
        self.mImage = UIImage(named: "sms")!
        
        mComStSt25sdkNdefNDEFSms =
            ndefMsg.getNDEFRecord(with: 0) as! ComStSt25sdkNdefSmsRecord
        
        mComStSt25sdkNdefNDEFSms.setIdWith(IOSByteArray(nsData: payload.identifier))
   }
    
    private func create(){
        let contact = mComStSt25sdkNdefNDEFSms.getContact()!
        let body = mComStSt25sdkNdefNDEFSms.getMessage()!

        self.mRecordValue = "sms:\(contact)&body=\(body)"

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
}



