//
//  NDEFUriRecord.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 13/10/2017.
//  Copyright © 2017 STMicroelectronics. All rights reserved.
//

import UIKit
import CoreNFC

class NDEFEmailRecords: NDEFRecords{
    
    var mComStSt25sdkNdefNDEFMail   : ComStSt25sdkNdefEmailRecord!
    
    override init() {
        super.init()
    }
    
    override init(ndefRecord:ComStSt25sdkNdefNDEFRecord){
        super.init()
        mComStSt25sdkNdefNDEFMail = ndefRecord as! ComStSt25sdkNdefEmailRecord
        create()
    }

    // designated initializer
    override init(ndefMsg:ComStSt25sdkNdefNDEFMsg,payload:NFCNDEFPayload){
        
        super.init(ndefMsg: ndefMsg,payload: payload)
        self.mRecordTypeString = "NDEF Email"
        self.mImage = UIImage(named: "mail")!
        
        mComStSt25sdkNdefNDEFMail =
            ndefMsg.getNDEFRecord(with: 0) as! ComStSt25sdkNdefEmailRecord
        
        mComStSt25sdkNdefNDEFMail.setIdWith(IOSByteArray(nsData: payload.identifier))
        create()
   }
    
    private func create(){
        let mailToString = mComStSt25sdkNdefNDEFMail!.getContact()
        let mailSubjectString = mComStSt25sdkNdefNDEFMail!.getSubject()
        let mailMessageString = mComStSt25sdkNdefNDEFMail!.getMessage()

        self.mRecordValue = "mailto:\(String(describing: mailToString))?subject=\(mailSubjectString!)&body=\(mailMessageString!)"
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
}


