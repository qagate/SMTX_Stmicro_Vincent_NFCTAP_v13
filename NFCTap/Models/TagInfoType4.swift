//
//  TagInfoType4.swift
//  NFCTap 
//
//  Created by STMICROELECTRONICS on 08/09/2021.
//  Copyright © 2021 STMicroelectronics. All rights reserved.
//

import Foundation
import UIKit
import CoreNFC
import CoreLocation

class TagInfoType4: NSObject,TagInfoTypeX {
    // From Protocole TagInfoTypeX
    var mUID: Data?
    var mTagSystemInfo: TagInfo
    var mProductId:ComStSt25sdkTagHelper_ProductID = ComStSt25sdkTagHelper_ProductID.PRODUCT_UNKNOWN
    var mTagPropertiesInformationTableModel = TagInfoGenericModel()

    #if !APPCLIP
    let miOSNdef:iOSNdef?
    #endif
    
    // CCFile
    var miOSCCFileType4:Data?
    var mCCFileType4:CCFileType4!
    
    // ST25SDK
    let miOSReaderInterface:iOSRFReaderInterface!
    var mType4ATag:ComStSt25sdkType4aType4Tag!
    
    init (aiOSReaderInterface:iOSRFReaderInterface) {
        mTagPropertiesInformationTableModel.resetInformation()
        miOSReaderInterface = aiOSReaderInterface
        #if !APPCLIP
        miOSNdef = iOSNdef.init(miOSReaderInterface.mIso7816Tag)
        #endif
        mUID = miOSReaderInterface.mIso7816Tag.identifier
        self.mTagSystemInfo = TagInfo(uid : mUID!, dfsid: 0x00, afi: 0x00, blockSize: 0x00, numberOfBlocks: 0x00, icRef: 0x02)
        mType4ATag = ComStSt25sdkType4aType4Tag(comStSt25sdkRFReaderInterface: miOSReaderInterface, with: IOSByteArray.init(nsData: mUID))
    }
 
    func tagInformationProcess()->Bool {
        // tag infos for UI are directly retrieved from tag object
        mTagPropertiesInformationTableModel.buildTagInformationFromTag(tag: miOSReaderInterface.mIso7816Tag!)
        mProductId = ComStSt25sdkTagHelper_ProductID.PRODUCT_UNKNOWN
        return (informationProcess())
    }
    
    private func informationProcess()->Bool {
        self.processTagForProductID()
        self.instantiateTagForProductID()
        if self.processCCFile() == true {
            return true
        }
        return false
    }
    
    /// Handle CC file information
    func processCCFile()->Bool {
        // CC File
        self.miOSCCFileType4 = mType4ATag?.readCCFile().toNSData()
        if (self.miOSCCFileType4 != nil){
            self.buildUiCCFileStructureData()
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
            let response = miOSReaderInterface.miOSIso7816?.queryNDEF()
            
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
            pdt = ComStSt25sdkTagHelper.identifyType4Product(with: self.miOSReaderInterface , with: IOSByteArray.init(nsData: mUID))
            self.mProductId = pdt
            self.mTagSystemInfo.setProductID(productID: self.mProductId)
        }
        self.mProductId = pdt
    }
  
   private func buildUiSystemFileStructureData() {
        self.mTagPropertiesInformationTableModel.buildSystemInfo(tagInfo: self.mTagSystemInfo)
    }
 
   private func buildUiCCFileStructureData() {
        // Analyse CC Files informations.
        mCCFileType4 = CCFileType4(ccfileData: [UInt8](self.miOSCCFileType4![0...self.miOSCCFileType4!.count-1]))
    
        do {
            try self.mCCFileType4.decode()
            self.mTagPropertiesInformationTableModel.buildCCFileInfo(ccFile:self.mCCFileType4!)

         } catch {
             print("CC file error: \(error)")
         }
    }

}
