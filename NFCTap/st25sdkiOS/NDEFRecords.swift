//
//  NDEFRecords.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 13/10/2017.
//  Copyright © 2017 STMicroelectronics. All rights reserved.
//
import UIKit
import CoreNFC

class NDEFRecords: NSObject,NSCoding{
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(mImage, forKey: "image")
        aCoder.encode(mPayload, forKey: "payload")
        aCoder.encode(mRecordValue, forKey: "value")
        aCoder.encode(mPayloadAscii, forKey: "payloadAscii")
        aCoder.encode(mPayloadHex, forKey: "payloadHex")
    }
    
    required init?(coder aDecoder: NSCoder) {
        mImage = aDecoder.decodeObject(forKey: "image") as! UIImage
        mPayload = aDecoder.decodeObject(forKey: "payload") as? NFCNDEFPayload
        mRecordValue = aDecoder.decodeObject(forKey: "value") as? String
        mPayloadHex = aDecoder.decodeObject(forKey: "payloadHex") as? String
        mPayloadAscii = aDecoder.decodeObject(forKey: "payloadAscii") as? String
    }
    
    var mNdefRecord:ComStSt25sdkNdefNDEFRecord!
    var mNdefMsg:ComStSt25sdkNdefNDEFMsg!
    var mPayload:NFCNDEFPayload!
    var mImage = UIImage(named: "AppIcon")
    var mRecordTypeString = String("NDEF Unknown")
    
    // convert NFCCore NDEF payload into Ascii
    var mPayloadAscii:String!
    var mPayloadHex:String!
    var mPayloadRecordType:String!
    var mPayloadRecordTIdentifier:String!
    
    // Decoded Record Value depending on Type
    var mRecordValue:String!
    
    override init() {
        super.init()
    }
    
    // designated initializer
    init(ndefMsg:ComStSt25sdkNdefNDEFMsg, payload:NFCNDEFPayload){
        self.mNdefMsg = ndefMsg
        self.mNdefRecord = ndefMsg.getNDEFRecord(with: 0)
        self.mPayload = payload
        self.mRecordValue = "Unknown"
        
        self.mPayloadHex = self.mPayload.payload.toHexString()
        self.mPayloadAscii = String(data: self.mPayload.payload,encoding:.ascii)
        self.mPayloadRecordType = String(data: self.mPayload.type,encoding:.utf8)
        self.mPayloadRecordTIdentifier = String(data:self.mPayload.identifier,encoding:.utf8)
    }
    
    init(ndefRecord:ComStSt25sdkNdefNDEFRecord){
        self.mNdefRecord = ndefRecord
    }
    
    func getRecordsListCode(listCode:JavaUtilList) -> [String]{
        var arrayString:[String] = [String]()
        let arrayCode : IOSObjectArray = (listCode.toArray())
        for index in 0..<(arrayCode.length()-1) {
            let codeId:String = (arrayCode.object(at: UInt(index)) ?? 0) as! String
            arrayString.append(codeId)
        }
        return arrayString
    }
    
}


