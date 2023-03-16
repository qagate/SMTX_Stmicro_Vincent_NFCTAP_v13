//
//  NDEFUriRecord.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 13/10/2017.
//  Copyright © 2017 STMicroelectronics. All rights reserved.
//

import UIKit
import CoreNFC

class NDEFMimeRecords: NDEFRecords{
    
    var mComStSt25sdkNdefMime:ComStSt25sdkNdefMimeRecord!
    var mMimeId:String!
    var mMimeContent:String!
    
    private var arrayMimeId:[String] = [String]()
    
    override init() {
        super.init()
    }

    override init(ndefRecord:ComStSt25sdkNdefNDEFRecord){
        super.init()
        mComStSt25sdkNdefMime = (ndefRecord as! ComStSt25sdkNdefMimeRecord)
        create()
    }
    
    // designated initializer
    override init(ndefMsg:ComStSt25sdkNdefNDEFMsg,payload:NFCNDEFPayload){
        
        super.init(ndefMsg: ndefMsg,payload: payload)
        mComStSt25sdkNdefMime =
            (ndefMsg.getNDEFRecord(with: 0) as! ComStSt25sdkNdefMimeRecord)
        
        mComStSt25sdkNdefMime.setIdWith(IOSByteArray(nsData: payload.identifier))
        create()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        mMimeId = (aDecoder.decodeObject(forKey: "mimeId") as! String)
        mMimeContent = (aDecoder.decodeObject(forKey: "mimeContent") as! String)
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(mMimeId, forKey: "mimeId")
        aCoder.encode(mMimeContent, forKey: "mimeContent")
    }
    
    private func create() {
        self.mImage = UIImage(named: "mime")
        self.mRecordTypeString = "Mime Record"
        self.arrayMimeId = NDEFRecords().getRecordsListCode(listCode: ComStSt25sdkNdefMimeRecord.getMimeCodesList())
        
        let mimeId = mComStSt25sdkNdefMime.getMimeID()
        mMimeId = self.arrayMimeId[Int(ComStSt25sdkNdefMimeRecord.getMimeCodePositionInList(with: mimeId!))]
        mMimeContent = String(data: mComStSt25sdkNdefMime.getContent().toNSData(),encoding: .ascii)
        self.mRecordValue = mMimeId+":"+mMimeContent
    }

}


