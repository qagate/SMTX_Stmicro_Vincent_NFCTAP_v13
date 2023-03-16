//
//  NDEFUriRecord.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 13/10/2017.
//  Copyright © 2017 STMicroelectronics. All rights reserved.
//

import UIKit
import CoreNFC

class NDEFEmptyRecords: NDEFRecords{
    
    var mComStSt25sdkNdefEmptyRecord   : ComStSt25sdkNdefEmptyRecord!
   
    override init() {
        super.init()
    }
    
    // designated initializer
    override init(ndefMsg:ComStSt25sdkNdefNDEFMsg,payload:NFCNDEFPayload){
        
        super.init(ndefMsg: ndefMsg,payload: payload)
        self.mRecordTypeString = "NDEF Empty"
        self.mImage = UIImage(named: "AppIcon")!
        
        mComStSt25sdkNdefEmptyRecord =
            ndefMsg.getNDEFRecord(with: 0) as? ComStSt25sdkNdefEmptyRecord
     }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
}

