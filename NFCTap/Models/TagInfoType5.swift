//
//  TagInfoType5.swift
//  ST25NFCAppClip
//
//  Created by STMicroelectronics on 15/09/2020.
//  Copyright © 2020 STMicroelectronics. All rights reserved.
//

import UIKit
import CoreNFC
import CoreLocation

class TagInfoType5: NSObject,TagInfoTypeX {
    // From Protocole TagInfoTypeX
    var mUID: Data?
    var mTagSystemInfo: TagInfo
    var mProductId:ComStSt25sdkTagHelper_ProductID = ComStSt25sdkTagHelper_ProductID.PRODUCT_UNKNOWN
    var mTagPropertiesInformationTableModel = TagInfoGenericModel()

    let mNFCTag:NFCTag?
    let mNFCISO15693Tag:NFCISO15693Tag?
    let miOSIso15693Tag:iOSIso15693?
    #if !APPCLIP
    let miOSNdef:iOSNdef?
    #endif
    let miOSReaderInterface:iOSRFReaderInterface?

    var miOSCCFileType5:CCFileType5?
    
    init (aNFCTag: NFCTag,aNFCISO15693Tag:NFCISO15693Tag,aiOSReaderInterface:iOSRFReaderInterface) {
        mTagPropertiesInformationTableModel.resetInformation()
        mNFCTag = aNFCTag
        mNFCISO15693Tag = aNFCISO15693Tag
        miOSIso15693Tag = iOSIso15693.init(mNFCISO15693Tag!)
        #if !APPCLIP
        miOSNdef = iOSNdef.init(aNFCISO15693Tag)
        #endif
        miOSReaderInterface = aiOSReaderInterface
        mUID = mNFCISO15693Tag?.identifier
        self.mTagSystemInfo = TagInfo(uid : mUID!, dfsid: 0x00, afi: 0x00, blockSize: 0x00, numberOfBlocks: 0x00, icRef: 0x00)

    }
 
    func tagInformationProcess()->Bool {
        // tag infos for UI are directly retrieved from tag object
        mTagPropertiesInformationTableModel.buildTagInformationFromTag(tag: mNFCISO15693Tag!)
        mProductId = ComStSt25sdkTagHelper_ProductID.PRODUCT_UNKNOWN
        if mNFCISO15693Tag!.icManufacturerCode == ComStSt25sdkCommandIso15693Protocol_STM_MANUFACTURER_CODE {
            return (informationProcess())
        } else {
            // No sysFile for Tags not ST = Re-initialize item
            return (informationProcess())
        }
    }
    
    private func informationProcess()->Bool {
        if (self.mUID == mUIDUnTraceable){
            self.mTagSystemInfo = TagInfo(uid : mUID!, dfsid: 0x00, afi: 0x00, blockSize: 0x00, numberOfBlocks: 0x00, icRef: mNFCISO15693Tag!.icManufacturerCode)
            self.processTagForProductSTMUntracebale()
            self.instantiateTagForProductID()

            return true
        }else{
        
            if (self.processSystemFile() == true){
                self.processTagForProductID()
                self.instantiateTagForProductID()
                if self.processCCFile() == true {
                    return true
                }
            }
            return false
        }
    }


    func processSystemFile()->Bool {
        // System File
        let response:Data = (miOSIso15693Tag?.getSystemInfo())!
        if (response[0] == 0x00){
            let dfsid:Int = Int(response[10])
            let afi:Int = Int(response[11])
            let numberOfBlocks:Int = Int(response[12])+1
            let blockSize:Int = Int(response[13])
            let icRef:Int = Int(response[14])

            self.mTagSystemInfo = TagInfo(uid : mUID!, dfsid: dfsid, afi: afi, blockSize: blockSize, numberOfBlocks: numberOfBlocks, icRef: icRef)
            self.processExtendedSystemFile()            
            self.buildUiSystemFileStructureData()
        }else{
            return false
        }
        return true
    }
 
    private func processExtendedSystemFile()->Bool {
        if self.mTagSystemInfo.numberOfBlocks-1 == 0xFF {
            // Process extended get system info
            let response:Data? = (miOSIso15693Tag?.getExtendedSystemInfo())!
            if (response != nil && response![0] == 0x00){
                var viccMemSizeOffset:Int = 10
                let responseCommand:Data = response![1...response!.count-1]
                let infoFlag = response![1]
                if ((infoFlag & 0x01) == 0x01){
                    viccMemSizeOffset += 1
                }
                if ((infoFlag & 0x02) == 0x02){
                    viccMemSizeOffset += 1
                }
                let numberOfBlock:Int = Int(Int(responseCommand[viccMemSizeOffset+1]) << 8)+Int(responseCommand[viccMemSizeOffset])
                let blockSize:Int = Int(responseCommand[viccMemSizeOffset+2])+1
                self.mTagSystemInfo.numberOfBlocks = numberOfBlock+1
                self.mTagSystemInfo.blockSize = blockSize
                return true
            }else{
                //Error getExtended
                return false
            }
        }
        return true
    }
    
    /// Handle CC file information
    func processCCFile()->Bool {
        var status:Bool = false
        let type5Tag:ComStSt25sdkType5Type5Tag = ComStSt25sdkType5Type5Tag.init(comStSt25sdkRFReaderInterface: miOSReaderInterface, with: IOSByteArray.init(nsData: mUID))
        var response:Data = Data.init()
        SwiftTryCatch.try({
                do {
                    response = try type5Tag.readCCFile().toNSData()
                    status = true
                } catch {
                    // Catch something here if not handling throw from ObjC
                }
            }
            , catch: { (errorNSException) in
            }
            , finallyBlock: {
                // Does Nothing
            })
        
        var firstBlock: [UInt8] = [UInt8]()
        var secondBlock: [UInt8] = [UInt8]()

        // Error CCFile
        if (!status){
            response = miOSIso15693Tag!.readSingleBlock(address: 0x00)!
            firstBlock = [UInt8](response[1...response.count-1])
        }else{
            // CC File
            if (response.count == 4){
                firstBlock = [UInt8](response[0...response.count-1])
            }else{
                firstBlock = [UInt8](response[0...3])
                secondBlock = [UInt8](response[4...response.count-1])
            }
        }
        self.miOSCCFileType5 = CCFileType5(firstBlock: firstBlock, secondBlock: secondBlock)
        self.mTagSystemInfo.setCCFileType5(ccfileType5: self.miOSCCFileType5!)
        self.buildUiCCFileStructureData()

        return status
    }

    #if !APPCLIP
    func processReadNdef()->Bool {
        if (self.mUID == mUIDUnTraceable){
            return true
        }else{
            let response = miOSIso15693Tag?.queryNDEF()
            
            if (response?.ndefStatus == .notSupported ){
                return false
            }else{
                let responseReadNdef = miOSNdef?.readNdef()
                if responseReadNdef?.message == nil {
                    return false
                }
            }
            return true
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

    private func processTagForProductSTMUntracebale() {
        /*
        var pdt : ComStSt25sdkTagHelper_ProductID = ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_STM_UNTRACEABLE
        if self.mTagSystemInfo != nil {
            self.mTagSystemInfo.setProductID(productID: pdt)
        }
        self.mProductId = pdt
 */
    }
    
    private func buildUiSystemFileStructureData() {
        self.mTagPropertiesInformationTableModel.buildSystemInfo(tagInfo: self.mTagSystemInfo)
    }
    
    private func buildUiCCFileStructureData() {
        do {
            let ccBlockData = try self.miOSCCFileType5!.decode()
            self.mTagPropertiesInformationTableModel.buildCCFileInfo(ccFile:self.miOSCCFileType5!)
         } catch {
             print("CC file error: \(error)")
         }
    }

}

