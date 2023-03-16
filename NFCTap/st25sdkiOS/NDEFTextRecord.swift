//
//  NDEFUriRecord.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 13/10/2017.
//  Copyright © 2017 STMicroelectronics. All rights reserved.
//

import UIKit
import CoreNFC

class NDEFTextRecords: NDEFRecords{
    
    var mComStSt25sdkNdefNDEFText   : ComStSt25sdkNdefTextRecord!
   
    override init() {
        super.init()
    }
    
    override init(ndefRecord:ComStSt25sdkNdefNDEFRecord){
        super.init()
        mComStSt25sdkNdefNDEFText = ndefRecord as! ComStSt25sdkNdefTextRecord
        create()
    }
    
    override init(ndefMsg:ComStSt25sdkNdefNDEFMsg,payload:NFCNDEFPayload){
        
        super.init(ndefMsg: ndefMsg,payload: payload)
        self.mRecordTypeString = "NDEF Text"
        self.mImage = UIImage(named: "text")!
        
        mComStSt25sdkNdefNDEFText =
            ndefMsg.getNDEFRecord(with: 0) as! ComStSt25sdkNdefTextRecord
        mComStSt25sdkNdefNDEFText.setIdWith(IOSByteArray(nsData: payload.identifier))
        create()
        
     }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    private func create(){
       self.mRecordValue = mComStSt25sdkNdefNDEFText!.getText()+"\n"
    }
}

