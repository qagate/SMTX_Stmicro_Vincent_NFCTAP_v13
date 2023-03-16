//
//  NDEFUriRecord.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 13/10/2017.
//  Copyright © 2017 STMicroelectronics. All rights reserved.
//


import UIKit
import CoreNFC
import Contacts
import ContactsUI

class NDEFVcardRecords: NDEFRecords{
    
    var mComStSt25sdkNdefNDEFVCard  : ComStSt25sdkNdefVCardRecord!
    var mVcardInfo:String!
    
    override init() {
        super.init()
    }
    
    override init(ndefRecord:ComStSt25sdkNdefNDEFRecord){
        super.init()
        mComStSt25sdkNdefNDEFVCard = ndefRecord as! ComStSt25sdkNdefVCardRecord
        create()
    }

    override init(ndefMsg:ComStSt25sdkNdefNDEFMsg,payload:NFCNDEFPayload){
        
        super.init(ndefMsg: ndefMsg,payload: payload)
        self.mRecordTypeString = "NDEF Vcard"
        self.mImage = UIImage(named: "vcard")!
        
        
        mComStSt25sdkNdefNDEFVCard =
            ndefMsg.getNDEFRecord(with: 0) as! ComStSt25sdkNdefVCardRecord
        
        mComStSt25sdkNdefNDEFVCard.setIdWith(IOSByteArray(nsData: payload.identifier))
        create()
    }
    
    private func create(){
        self.mRecordValue = mComStSt25sdkNdefNDEFVCard.getName()+"\n"
        self.mVcardInfo = mComStSt25sdkNdefNDEFVCard.getVcard()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        mVcardInfo = aDecoder.decodeObject(forKey: "vcardInfo") as! String
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(mVcardInfo, forKey: "vcardInfo")
    }
}





