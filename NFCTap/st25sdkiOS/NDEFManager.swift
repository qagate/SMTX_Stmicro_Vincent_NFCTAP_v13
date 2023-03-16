//
//  NDEFManager.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 13/10/2017.
//  Copyright © 2017 STMicroelectronics. All rights reserved.
//

import UIKit
import CoreNFC

class NDEFManager: NSObject{
    
    var mNDEFRecord:NDEFRecords!
    var mComStSt25sdkNdefNDEFRecord:ComStSt25sdkNdefNDEFRecord!
    
    override init() {
        super.init()
    }
    
    // designated initializer 
    init(payload:NFCNDEFPayload){
        super.init()
        createRecordsFromNFCNDEFPayload(payload: payload)
    }

    private func createRecordsFromNFCNDEFPayload( payload:NFCNDEFPayload ){
        
        // convert NFCNDEFPayload into Array for ST25SDK
        let TypeArray = IOSByteArray.init(nsData: payload.type)
        let IdArray = IOSByteArray.init(nsData: payload.identifier)
        let PayloadArray = IOSByteArray.init(nsData: payload.payload)
        let Tnf = payload.typeNameFormat
        
        // Create a comStSt25sdkNdefNDEFRecordTmp
        let comStSt25sdkNdefNDEFRecordTmp = ComStSt25sdkNdefNDEFRecord()
        
        comStSt25sdkNdefNDEFRecordTmp.setTypeWith(TypeArray)
        comStSt25sdkNdefNDEFRecordTmp.setIdWith(IdArray)
        comStSt25sdkNdefNDEFRecordTmp.setPayloadWith(PayloadArray!)
        comStSt25sdkNdefNDEFRecordTmp.setTnfWithShort(jshort(Tnf.rawValue))
        let recordBufferStream:IOSByteArray = comStSt25sdkNdefNDEFRecordTmp.serialize()
        
        // Create a ComStSt25sdkNdefNDEFMsg and Add record
        mComStSt25sdkNdefNDEFRecord = ComStSt25sdkNdefNdefRecordFactory.getNdefRecord(with: recordBufferStream) as ComStSt25sdkNdefNDEFRecord
        
        let mComStSt25sdkNdefNDEFMsg:ComStSt25sdkNdefNDEFMsg = ComStSt25sdkNdefNDEFMsg.init(byteArray: recordBufferStream)
        
        // Check record type
        switch (mComStSt25sdkNdefNDEFRecord)
        {
            
        case  is ComStSt25sdkNdefEmptyRecord :
            mNDEFRecord = NDEFEmptyRecords(ndefMsg: mComStSt25sdkNdefNDEFMsg,payload:payload)
            mComStSt25sdkNdefNDEFRecord = (mNDEFRecord as! NDEFEmptyRecords).mComStSt25sdkNdefEmptyRecord
            break

        case  is ComStSt25sdkNdefUriRecord :
            mNDEFRecord = NDEFUriRecords(ndefMsg: mComStSt25sdkNdefNDEFMsg,payload:payload)
            mComStSt25sdkNdefNDEFRecord = (mNDEFRecord as! NDEFUriRecords).mComStSt25sdkNdefNDEFUri
            break
            
        case  is  ComStSt25sdkNdefTextRecord :
             mNDEFRecord = NDEFTextRecords(ndefMsg: mComStSt25sdkNdefNDEFMsg,payload:payload)
             mComStSt25sdkNdefNDEFRecord = (mNDEFRecord as! NDEFTextRecords).mComStSt25sdkNdefNDEFText
            break
        
        case  is  ComStSt25sdkNdefBtRecord :
            mNDEFRecord = NDEFBtRecords(ndefMsg: mComStSt25sdkNdefNDEFMsg,payload:payload)
            mComStSt25sdkNdefNDEFRecord = (mNDEFRecord as! NDEFBtRecords).mComStSt25sdkNdefNDEFBt
            break
            
        case  is  ComStSt25sdkNdefBtLeRecord :
            mNDEFRecord = NDEFBtleRecords(ndefMsg: mComStSt25sdkNdefNDEFMsg,payload:payload)
            mComStSt25sdkNdefNDEFRecord = (mNDEFRecord as! NDEFBtleRecords).mComStSt25sdkNdefNDEFBtLe
            break
            
        case  is  ComStSt25sdkNdefEmailRecord :
            mNDEFRecord = NDEFEmailRecords(ndefMsg: mComStSt25sdkNdefNDEFMsg,payload:payload)
            mComStSt25sdkNdefNDEFRecord = (mNDEFRecord as! NDEFEmailRecords).mComStSt25sdkNdefNDEFMail
            break
        
        case  is  ComStSt25sdkNdefSmsRecord :
            mNDEFRecord = NDEFSmsRecords(ndefMsg: mComStSt25sdkNdefNDEFMsg,payload:payload)
            mComStSt25sdkNdefNDEFRecord = (mNDEFRecord as! NDEFSmsRecords).mComStSt25sdkNdefNDEFSms
            break
            
        case  is  ComStSt25sdkNdefVCardRecord :
            mNDEFRecord = NDEFVcardRecords(ndefMsg: mComStSt25sdkNdefNDEFMsg,payload:payload)
            mComStSt25sdkNdefNDEFRecord = (mNDEFRecord as! NDEFVcardRecords).mComStSt25sdkNdefNDEFVCard
            break
            
        case  is  ComStSt25sdkNdefWifiRecord :
            mNDEFRecord = NDEFWifiRecords(ndefMsg: mComStSt25sdkNdefNDEFMsg,payload:payload)
            mComStSt25sdkNdefNDEFRecord = (mNDEFRecord as! NDEFWifiRecords).mComStSt25sdkNdefNDEFWifi
            break
            
        case  is  ComStSt25sdkNdefMimeRecord :
            mNDEFRecord = NDEFMimeRecords(ndefMsg: mComStSt25sdkNdefNDEFMsg,payload:payload)
            mComStSt25sdkNdefNDEFRecord = (mNDEFRecord as! NDEFMimeRecords).mComStSt25sdkNdefMime
        break
            
        case  is  ComStSt25sdkNdefExternalRecord :
             mNDEFRecord = NDEFExternalRecords(ndefMsg: mComStSt25sdkNdefNDEFMsg,payload:payload)
             mComStSt25sdkNdefNDEFRecord = (mNDEFRecord as! NDEFExternalRecords).mComStSt25sdkNdefExternal
            break

        case  is  ComStSt25sdkNdefAarRecord :
             mNDEFRecord = NDEFAarRecord(ndefMsg: mComStSt25sdkNdefNDEFMsg,payload:payload)
             mComStSt25sdkNdefNDEFRecord = (mNDEFRecord as! NDEFAarRecord).mComStSt25sdkNdefAar
            break

        default:
            mNDEFRecord = NDEFEmptyRecords(ndefMsg: mComStSt25sdkNdefNDEFMsg,payload:payload)
            mComStSt25sdkNdefNDEFRecord = ComStSt25sdkNdefEmptyRecord()
            break
        }
    }
    
    func getNDEFRecord() -> NDEFRecords {
        return mNDEFRecord
    }
    
    func getComStSt25sdkNdefNDEFRecord() -> ComStSt25sdkNdefNDEFRecord {
        return mComStSt25sdkNdefNDEFRecord
    }
    
    func convertiOSNdefToSt25Ndef(message: NFCNDEFMessage) -> ComStSt25sdkNdefNDEFMsg {
         let tmpComStSt25sdkNdefNDEFMsg:ComStSt25sdkNdefNDEFMsg = ComStSt25sdkNdefNDEFMsg()
         for record in message.records {
            self.createRecordsFromNFCNDEFPayload(payload: record)
            let mNDEFRecord = self.getComStSt25sdkNdefNDEFRecord()
            tmpComStSt25sdkNdefNDEFMsg.addRecord(with: mNDEFRecord)
         }
         return tmpComStSt25sdkNdefNDEFMsg
     }
    
    func convertSt25NdefToiOSNdef(message: ComStSt25sdkNdefNDEFMsg ) -> NFCNDEFMessage {
        var recordiOS:[NFCNDEFPayload] = []
        
        // check nb of record before. Create empty if no records
        if (message.getNbrOfRecords() <= 0){
            let Payload = NFCNDEFPayload.init(format: .empty, type: Data(), identifier: Data(), payload: Data())
            recordiOS.append(Payload)
        }else{
            for i in 0...message.getNbrOfRecords()-1 {
                let recordSt25:ComStSt25sdkNdefNDEFRecord = message.getNDEFRecord(with: i)
                
                // Check if empty record
                if (recordSt25 is ComStSt25sdkNdefEmptyRecord){
                    let Payload = NFCNDEFPayload.init(format: .empty, type: Data(), identifier: Data(), payload: Data())
                    recordiOS.append(Payload)
                }else{
                    
                    // Create coreNFC NDEF Message
                    let TypeArray = (recordSt25.getType()?.toNSData())!
                    var IdArray:Data!
                    let PayloadArray = (recordSt25.getPayload()?.toNSData())!
                    var Format:NFCTypeNameFormat = .nfcWellKnown
                    

                    // Check record type
                    switch (recordSt25)
                    {
                    case  is ComStSt25sdkNdefUriRecord :
                        IdArray = (recordSt25 as! ComStSt25sdkNdefUriRecord).getID()?.toNSData()
                        break
                        
                    case  is  ComStSt25sdkNdefTextRecord :
                         IdArray = (recordSt25 as! ComStSt25sdkNdefTextRecord).getID()?.toNSData()
                        break
                    
                    case  is  ComStSt25sdkNdefBtRecord :
                        Format  = .media
                        IdArray = (recordSt25 as! ComStSt25sdkNdefBtRecord).getID()?.toNSData()
                        break
                        
                    case  is  ComStSt25sdkNdefBtLeRecord :
                        Format  = .media
                        IdArray = (recordSt25 as! ComStSt25sdkNdefBtLeRecord).getID()?.toNSData()
                        break
                        
                    case  is  ComStSt25sdkNdefEmailRecord :
                        IdArray = (recordSt25 as! ComStSt25sdkNdefEmailRecord).getID()?.toNSData()
                        break
                    
                    case  is  ComStSt25sdkNdefSmsRecord :
                        IdArray = (recordSt25 as! ComStSt25sdkNdefSmsRecord).getID()?.toNSData()
                        break
                        
                    case  is  ComStSt25sdkNdefVCardRecord :
                        Format  = .media
                        IdArray = (recordSt25 as! ComStSt25sdkNdefVCardRecord).getID()?.toNSData()
                        break
                        
                    case  is  ComStSt25sdkNdefWifiRecord :
                        Format  = .media
                        IdArray = (recordSt25 as! ComStSt25sdkNdefWifiRecord).getID()?.toNSData()
                        break
                        
                    case  is  ComStSt25sdkNdefMimeRecord :
                        Format  = .media
                        IdArray = (recordSt25 as! ComStSt25sdkNdefMimeRecord).getID()?.toNSData()
                    break
                        
                    case  is  ComStSt25sdkNdefExternalRecord :
                        Format  = .nfcExternal
                        IdArray = (recordSt25 as! ComStSt25sdkNdefExternalRecord).getID()?.toNSData()
                    break
                        
                    case  is  ComStSt25sdkNdefAarRecord:
                        Format  = .nfcExternal
                        IdArray = (recordSt25 as! ComStSt25sdkNdefAarRecord).getID()?.toNSData()
                    break

                    default:
                        break
                    }
                    
                    let payload = NFCNDEFPayload.init(format: Format, type: TypeArray, identifier: IdArray, payload: PayloadArray)
                    recordiOS.append(payload)
                }
            }
        }
        return NFCNDEFMessage(records: recordiOS)
    }
    
    func printNFCDEFMessage(message: NFCNDEFMessage) {
        for record in message.records {
            printNFCNDEFRecord(record: record)
        }
    }
    
    func printNFCNDEFRecord(record:NFCNDEFPayload){
        NSLog("\(record)")
        if let dataPayload = String(data: record.payload,encoding:.utf8){
            NSLog("Payload Data:"+dataPayload)
        }
    }

    
}
