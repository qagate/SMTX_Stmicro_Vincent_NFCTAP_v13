//
//  TableGenericModel.swift
//  NFCTap
//
//  Created by STMICROELECTRONICS on 01/10/2019.
//  Copyright © 2019 STMicroelectronics. All rights reserved.
//

import Foundation
import CoreNFC

class TagInfoGenericModel {
    
    var tagType:ComStSt25sdkNFCTag_NfcTagTypes_Enum = .NFC_TAG_TYPE_UNKNOWN
    
    var tagInfo = [[[String:String]]]()
    var ccFileInfo = [[[String:String]]]()
    var systemFileInfo = [[[String:String]]]()
    
    public static let infoFileSectionName = "Tag info"
    public static let ccFileSectionName = "CC file"
    public static let systemFileSectionName = "System file"
    
    func addItemsToInfoGroup(item:String, value:String) {
        tagInfo.append(buildData(item: item, value: value))
    }
    
    func addItemsToccFileGroup(item:String, value:String) {
        ccFileInfo.append(buildData(item: item, value: value))
    }

    func addItemsToSystemFileGroup(item:String, value:String) {
        systemFileInfo.append(buildData(item: item, value: value))
    }
    
    private func buildData(item:String, value:String) -> [[String: String]] {
        let itemDict: [String: String] = ["Item":item]
        let itemIdDict: [String: String] = ["ItemId":value]
        let data: [[String: String]] = [itemDict,itemIdDict]
        return data
    }
    
    func resetInformation() {
        tagInfo.removeAll()
        addItemsToInfoGroup(item: "Information", value: "Not available")
        ccFileInfo.removeAll()
        addItemsToccFileGroup(item: "Information", value: "Not available")
        systemFileInfo.removeAll()
        addItemsToSystemFileGroup(item: "Information", value: "Not available")
    }
    func clearSystemInformation() {
        systemFileInfo.removeAll()
    }
    func clearCCInformation() {
        ccFileInfo.removeAll()
    }
    func clearTagInformation() {
        tagInfo.removeAll()
    }
    
    func buildTagInformationFromTag (tag: NFCISO15693Tag) {
        tagType = .NFC_TAG_TYPE_V
        
        // first clean all values to avoid duplicates
        tagInfo.removeAll()
        ccFileInfo.removeAll()
        systemFileInfo.removeAll()
        var ManufCode = String(NSString(format:"%2X", tag.icManufacturerCode))
        if tag.icManufacturerCode < ICManufacturers.count && tag.icManufacturerCode >= 0 {
            ManufCode = ICManufacturers[tag.icManufacturerCode]
        }
        // Exemple of required data
        //    var infoItems = [["Item": "item A","ItemId" : "1"],["Item": "item B","ItemId" : "2"],["Item": "item C","ItemId" : "3"]]
        // --------------------------
        addItemsToInfoGroup(item: "Manuf code", value: "\(ManufCode)")
        
        let icSerial = tag.icSerialNumber
        let icSerialString: String = icSerial.hexEncodedString()
        addItemsToInfoGroup(item: "Serial Number", value: icSerialString)
        
        // Retrieve product code
        tag.icSerialNumber.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) -> Void in
            let rawPointer = UnsafeRawPointer(bytes)
            let productCode = rawPointer.load(fromByteOffset: 0, as: UInt8.self)
 
        }
        
        let identifier = tag.identifier
        let identifierString: String = identifier.hexEncodedString()
        addItemsToInfoGroup(item: "UID", value: identifierString.capitalized)
        //addItemsToInfoGroup(item: "Tag type", value: tag.type)
        let ndefCompatible = tag.conforms(to:NFCNDEFTag.self)
        if ndefCompatible {
            addItemsToInfoGroup(item: "Compatibility protocol", value: "NFCNDEFTag")
        }
        let nfcISO15693Compatible = tag.conforms(to:NFCISO15693Tag.self)
        if nfcISO15693Compatible {
            addItemsToInfoGroup(item: "Compatibility protocol", value: "NFCISO15693Tag")
        }
        let nfcISO7816Compatible = tag.conforms(to:NFCISO7816Tag.self)
        if nfcISO7816Compatible {
            addItemsToInfoGroup(item: "Compatibility protocol", value: "NFCISO7816")
        }

    }
    
    func buildTagInformationFromTag (tag: NFCMiFareTag) {

        tagType = .NFC_TAG_TYPE_2
        
        // first clean all values to avoid duplicates
        tagInfo.removeAll()
        ccFileInfo.removeAll()
        systemFileInfo.removeAll()
        
        var ManufCode = "NXP Semiconductors";
        
        // Exemple of required data
        //    var infoItems = [["Item": "item A","ItemId" : "1"],["Item": "item B","ItemId" : "2"],["Item": "item C","ItemId" : "3"]]
        // --------------------------
        //addItemsToInfoGroup(item: "Manuf code", value: "\(ManufCode)")
        
        let icSerial = tag.identifier
        let icSerialString: String = icSerial.hexEncodedString()
        
        // Retrieve product code
        tag.identifier.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) -> Void in
            let rawPointer = UnsafeRawPointer(bytes)
            let productCode = rawPointer.load(fromByteOffset: 0, as: UInt8.self)
 
        }
        
        let identifier = tag.identifier
        let identifierString: String = identifier.hexEncodedString()
         tag.identifier[0]
        if tag.identifier[0] < ICManufacturers.count && tag.identifier[0] >= 0 {
            ManufCode = ICManufacturers[Int(tag.identifier[0])]
        }
        addItemsToInfoGroup(item: "Manuf code", value: "\(ManufCode)")
        addItemsToInfoGroup(item: "UID", value: identifierString.capitalized)
        //addItemsToInfoGroup(item: "Tag type", value: tag.type)
        let ndefCompatible = tag.conforms(to:NFCNDEFTag.self)
        if ndefCompatible {
            addItemsToInfoGroup(item: "Compatibility protocol", value: "NFCNDEFTag")
        }
        let nfcMiFareCompatible = tag.conforms(to:NFCMiFareTag.self)
        if nfcMiFareCompatible {
            addItemsToInfoGroup(item: "Compatibility protocol", value: "NFCType2Tag")
        }
    }
    
    func buildTagInformationFromTag (tag: NFCISO7816Tag) {

        tagType = .NFC_TAG_TYPE_4A
        
        // first clean all values to avoid duplicates
        tagInfo.removeAll()
        ccFileInfo.removeAll()
        systemFileInfo.removeAll()
        
        var ManufCode = "STMicroelectronics";
        
        // Exemple of required data
        //    var infoItems = [["Item": "item A","ItemId" : "1"],["Item": "item B","ItemId" : "2"],["Item": "item C","ItemId" : "3"]]
        // --------------------------
        addItemsToInfoGroup(item: "Manuf code", value: "\(ManufCode)")
        
        let icSerial = tag.identifier
        let icSerialString: String = icSerial.hexEncodedString()
        
        // Retrieve product code
        tag.identifier.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) -> Void in
            let rawPointer = UnsafeRawPointer(bytes)
            let productCode = rawPointer.load(fromByteOffset: 0, as: UInt8.self)
 
        }
        
        let identifier = tag.identifier
        let identifierString: String = identifier.hexEncodedString()
        addItemsToInfoGroup(item: "UID", value: identifierString.capitalized)
        //addItemsToInfoGroup(item: "Tag type", value: tag.type)
        let ndefCompatible = tag.conforms(to:NFCNDEFTag.self)
        if ndefCompatible {
            addItemsToInfoGroup(item: "Compatibility protocol", value: "NFCNDEFTag")
        }
        let nfcCompatible = tag.conforms(to:NFCISO7816Tag.self)
        if nfcCompatible {
            addItemsToInfoGroup(item: "Compatibility protocol", value: "NFCIso7816Tag")
        }
    }
    
    func buildSystemInfo(tagInfo: TagInfo) {
        clearSystemInformation()
        if (tagType == .NFC_TAG_TYPE_V){
            addItemsToSystemFileGroup(item: "DFSID ", value: String(format: "0x%X", tagInfo.dfsid))
            addItemsToSystemFileGroup(item: "AFI ", value: String(format: "0x%X", tagInfo.afi))
            addItemsToSystemFileGroup(item: "Block Size ", value: String(format: "%d", tagInfo.blockSize))
            addItemsToSystemFileGroup(item: "Memory Size in blocks", value: String(format: "%d", tagInfo.numberOfBlocks))
            let memorysize = tagInfo.numberOfBlocks * tagInfo.blockSize
            addItemsToSystemFileGroup(item: "Memory Size in bytes", value: String(format: "%d", memorysize))
            addItemsToInfoGroup(item: "Memory Size in bytes", value: String(format: "%d", memorysize))
            addItemsToSystemFileGroup(item: "IC ref", value: String(format: "%d", tagInfo.icRef))
        }else if (tagType == .NFC_TAG_TYPE_2){
            let memorysize = tagInfo.numberOfBlocks * tagInfo.blockSize
            addItemsToInfoGroup(item: "Memory Size in bytes", value: String(format: "%d", memorysize))
        }else if (tagType == .NFC_TAG_TYPE_4A ){
            let memorysize = 256
            addItemsToInfoGroup(item: "Memory Size in bytes", value: String(format: "%d", memorysize))
        }
    }

    func buildCCFileInfo(ccFile: CCFile) {
        clearCCInformation()
        addItemsToccFileGroup(item: "CC File length", value: String(format: "%d\n",ccFile.getCCLength()))
        addItemsToccFileGroup(item: "Mapping version", value: String(format: "0x%02X\n",ccFile.getCCMappingVersion()))

        if (tagType != .NFC_TAG_TYPE_4A){
            addItemsToccFileGroup(item: "Magic number", value: String(format: "0x%02X\n",ccFile.getMagicNumber()))

        }
        
        if (tagType == .NFC_TAG_TYPE_2){
            addItemsToccFileGroup(item: "Type2 area Size in bytes", value: String(format: "%d\n",ccFile.getDataAreaSize()))
        }
        
        if (tagType == .NFC_TAG_TYPE_4A){
            addItemsToccFileGroup(item: "Type4 area Size in bytes", value: String(format: "%d\n",ccFile.getDataAreaSize()))
        }

        addItemsToccFileGroup(item: "Read access", value: String(format: "%d\n",ccFile.getCCReadAccess()))
        addItemsToccFileGroup(item: "Write access", value: String(format: "%d\n",ccFile.getCCWriteAccess()))

    }
    
}

struct Category {
   var name : String
   var items : [[[String:Any]]]
}


