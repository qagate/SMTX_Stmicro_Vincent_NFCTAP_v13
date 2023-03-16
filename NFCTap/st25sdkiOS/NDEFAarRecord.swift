//
//  NDEFAarRecord.swift
//  NFCTap 
//
//  Created by STMicroelectronics on 03/08/2021.
//  Copyright © 2021 STMicroelectronics. All rights reserved.
//

import Foundation
import UIKit
import CoreNFC

class NDEFAarRecord: NDEFRecords{
    
    var mComStSt25sdkNdefAar:ComStSt25sdkNdefAarRecord?
    var mContent:String!
    
    override init() {
        super.init()
        mComStSt25sdkNdefAar = nil
        create()
    }
    
    override init(ndefRecord:ComStSt25sdkNdefNDEFRecord){
        super.init()
        mComStSt25sdkNdefAar = (ndefRecord as! ComStSt25sdkNdefAarRecord)
        create()
    }

    // designated initializer
    override init(ndefMsg:ComStSt25sdkNdefNDEFMsg,payload:NFCNDEFPayload){
        super.init(ndefMsg: ndefMsg,payload: payload)
        
        mComStSt25sdkNdefAar =
            ndefMsg.getNDEFRecord(with: 0) as? ComStSt25sdkNdefAarRecord
        
        mComStSt25sdkNdefAar!.setIdWith(IOSByteArray(nsData: payload.identifier))
        create()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    private func create(){
        self.mImage = UIImage(named: "tools")
        self.mRecordTypeString = "AAR Record"
        if (mComStSt25sdkNdefAar != nil){
            self.mRecordValue = mComStSt25sdkNdefAar!.getAar()
        }
    }
}



