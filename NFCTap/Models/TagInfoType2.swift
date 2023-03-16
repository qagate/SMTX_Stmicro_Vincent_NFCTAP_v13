//
//  TagInfoType2.swift
//  NFCTap 
//
//  Created by STMicroelectronics on 09/02/2021.
//  Copyright © 2021 STMicroelectronics. All rights reserved.
//

import Foundation
import UIKit
import CoreNFC
import CoreLocation

class TagInfoType2: NSObject,TagInfoTypeX {
    // From Protocole TagInfoTypeX
    var mUID: Data?
    var mTagSystemInfo: TagInfo
    var mProductId:ComStSt25sdkTagHelper_ProductID = ComStSt25sdkTagHelper_ProductID.PRODUCT_UNKNOWN
    var mTagPropertiesInformationTableModel = TagInfoGenericModel()

    let mNFCTag:NFCTag?
    let mNFCMiFareTag:NFCMiFareTag?
    let miOSMifareTag:iOSMifare?
    #if !APPCLIP
    let miOSNdef:iOSNdef?
    #endif
    let miOSReaderInterface:iOSRFReaderInterface?
    
    var miOSCCFileType2:CCFileType2?
    
    init (aNFCTag: NFCTag,aNFCMiFareTag:NFCMiFareTag,aiOSReaderInterface:iOSRFReaderInterface) {
        mTagPropertiesInformationTableModel.resetInformation()
        mNFCTag = aNFCTag
        mNFCMiFareTag = aNFCMiFareTag
        miOSMifareTag = iOSMifare.init(mNFCMiFareTag!)
        #if !APPCLIP
        miOSNdef = iOSNdef.init(aNFCMiFareTag)
        #endif
        miOSReaderInterface = aiOSReaderInterface
        mUID = mNFCMiFareTag?.identifier
        self.mTagSystemInfo = TagInfo(uid : mUID!, dfsid: 0x00, afi: 0x00, blockSize: 0x00, numberOfBlocks: 0x00, icRef: 0x02)
    }
 
    func tagInformationProcess()->Bool {
        // tag infos for UI are directly retrieved from tag object
        mTagPropertiesInformationTableModel.buildTagInformationFromTag(tag: mNFCMiFareTag!)
        mProductId = ComStSt25sdkTagHelper_ProductID.PRODUCT_UNKNOWN
        return (informationProcess())
    }
    
    private func informationProcess()->Bool {
        if self.processCCFile() == true {
            self.processTagForProductID()
            self.instantiateTagForProductID()
            return true
        }
        return false
    }
    
    /// Handle CC file information
    func processCCFile()->Bool {
        // CC File
        var firstBlock: [UInt8] = [UInt8]()
 
        let response:Data! = miOSMifareTag?.readBlock(blockNumber: 0x03)
        if (response != nil){
            firstBlock = [UInt8](response[0...3])
                self.miOSCCFileType2 = CCFileType2(firstBlock: firstBlock)
                self.buildUiCCFileStructureData()
                self.mTagSystemInfo.blockSize = 1
                self.mTagSystemInfo.numberOfBlocks = Int(self.miOSCCFileType2!.mDataAreaSize)
                self.buildUiSystemFileStructureData()
        }else{
           return false
        }
        return true
    }

    #if !APPCLIP
    func processReadNdef()->Bool {
        if (self.mUID == mUIDUnTraceable){
            return true
        }else{
            let response = miOSMifareTag?.queryNDEF()
            
            if (response?.ndefStatus == .notSupported ){
                return false
            }else{
                let responseReadNdef = miOSNdef?.readNdef()
                if responseReadNdef?.error != nil || responseReadNdef?.message == nil {
                    return false
                }else{
                    var NDEFMessage:[NFCNDEFMessage] = []
                    NDEFMessage.append((responseReadNdef?.message)!)
                    self.addMessage(messages:NDEFMessage)
                    return true
                }
            }
            return true
        }
    }

   // addMessage(fromUserActivity or from readerSession)
    func addMessage(messages: [NFCNDEFMessage]) {
        var tmpRecords:[NDEFRecords] = []

        for message in messages{
            for record in message.records {
                
                print(record)
                print("Identifier: \(record.identifier)")
                print("PayloadSize: \(record.payload)")
                print("type: \(record.type)")
                print("type format: \(record.typeNameFormat)")
                if let dataPayload = String(data: record.payload,encoding:.utf8){
                    print("Payload Data:"+dataPayload)
                }
                let mNDEFManager = NDEFManager(payload: record)
                let mNDEFRecord = mNDEFManager.getNDEFRecord()
                tmpRecords.append(mNDEFRecord)
            }
        }
    }
    #endif
    
    
    func instantiateTagForProductID() {
        if (self.miOSReaderInterface != nil && self.mTagSystemInfo != nil){
            self.mTagSystemInfo.instantiateTag(RFReaderInterface: self.miOSReaderInterface!)
        }
    }
    
    private func processTagForProductID() {
        var pdt : ComStSt25sdkTagHelper_ProductID = ComStSt25sdkTagHelper_ProductID.PRODUCT_UNKNOWN
        if self.mTagSystemInfo != nil {
            self.mTagSystemInfo.setProductID(productID: pdt)
            pdt = decodeProductID(uid: self.mTagSystemInfo.uid, tag: mNFCTag!, icRef: self.mTagSystemInfo.icRef, self.mTagSystemInfo.numberOfBlocks)
            self.mProductId = pdt
            self.mTagSystemInfo.setProductID(productID: self.mProductId)
        }
        self.mProductId = pdt
    }
  
   private func buildUiSystemFileStructureData() {
        self.mTagPropertiesInformationTableModel.buildSystemInfo(tagInfo: self.mTagSystemInfo)
    }
 
   private func buildUiCCFileStructureData() {
        do {
            let ccBlockData = try self.miOSCCFileType2!.decode()
            self.mTagPropertiesInformationTableModel.buildCCFileInfo(ccFile:self.miOSCCFileType2!)

         } catch {
             print("CC file error: \(error)")
         }
    }

}

