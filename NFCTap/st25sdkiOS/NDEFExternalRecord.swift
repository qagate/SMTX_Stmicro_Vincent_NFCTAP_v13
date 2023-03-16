//
//  NDEFExternalRecord.swift
//  NFCTap
//
//  Created by STMICROELECTRONICS on 30/10/2017.
//  Copyright © 2017 STMicroelectronics. All rights reserved.
//

import UIKit
import CoreNFC

class NDEFExternalRecords: NDEFRecords{
    
    var mComStSt25sdkNdefExternal:ComStSt25sdkNdefExternalRecord?
    var mDomainId:String!
    var mTypeId:String!
    var mContent:String!
    
    override init() {
        super.init()
        mComStSt25sdkNdefExternal = nil
        create()
    }
    
    override init(ndefRecord:ComStSt25sdkNdefNDEFRecord){
        super.init()
        mComStSt25sdkNdefExternal = (ndefRecord as! ComStSt25sdkNdefExternalRecord)
        create()
    }

    // designated initializer
    override init(ndefMsg:ComStSt25sdkNdefNDEFMsg,payload:NFCNDEFPayload){
        
        super.init(ndefMsg: ndefMsg,payload: payload)
        
        mComStSt25sdkNdefExternal =
            ndefMsg.getNDEFRecord(with: 0) as? ComStSt25sdkNdefExternalRecord
        
        mComStSt25sdkNdefExternal!.setIdWith(IOSByteArray(nsData: payload.identifier))
        create()
    }
    
    private func create(){
        self.mImage = UIImage(named: "tools")
        self.mRecordTypeString = "External Record"
        
        if (mComStSt25sdkNdefExternal != nil){
            mDomainId   = mComStSt25sdkNdefExternal?.getExternalDomain()
            mTypeId     = mComStSt25sdkNdefExternal?.getExternalType()
            mContent    = String(data: (mComStSt25sdkNdefExternal?.getContent().toNSData())!,encoding:.ascii)

            self.mRecordValue = mDomainId+":"+mTypeId+":"+mContent
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        mDomainId = aDecoder.decodeObject(forKey: "externalDomainId") as! String
        mTypeId = aDecoder.decodeObject(forKey: "externalTypeId") as! String
        mContent = aDecoder.decodeObject(forKey: "externalContent") as! String
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(mTypeId, forKey: "externalTypeId")
        aCoder.encode(mDomainId, forKey: "externalDomainId")
        aCoder.encode(mContent, forKey: "externalContent")
    }
    
}



