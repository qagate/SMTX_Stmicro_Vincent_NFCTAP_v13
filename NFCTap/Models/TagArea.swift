//
//  TagArea.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 07/01/2020.
//  Copyright © 2020 STMicroelectronics. All rights reserved.
//

import Foundation


struct TagArea: Equatable, CustomStringConvertible {
    static func == (lhs: TagArea, rhs: TagArea) -> Bool {
        if lhs.mArea !=  rhs.mArea {
            return false
        }
        if lhs.style !=  rhs.style {
            return false
        }
        if lhs.mSize !=  rhs.mSize {
            return false
        }
        
        if lhs.mNdefMsg != rhs.mNdefMsg {
            return false
        }
        return true
    }
    
    
    var description: String {
        return "Area\(mArea)  Size: \(mSize) bytes"
    }
    
    var content: String {
        if mNdefMsg != nil {
            let nbRecords = mNdefMsg.getNbrOfRecords()
            return "NDEF message contains \(nbRecords) record(s)"
        } else {
            return "No NDEF message or \(style.description)"
        }
    }
    //raw value
    enum AreaStyle: String, CustomStringConvertible, CaseIterable, Codable {
        case UNKNOWN_DATA
        case NDEF
        case INVALID_CC_FILE
        case BLOCK_LOCKED
        case PWD_NEEDED

        var description: String {
            return self.rawValue
        }
    }
    
    var style: AreaStyle
    var mArea: Int
    var mSize: Int
    var mNdefMsg : ComStSt25sdkNdefNDEFMsg!
    
    
    init(area: Int, style: AreaStyle, size: Int, ndefMessage: ComStSt25sdkNdefNDEFMsg) {
        self.mArea = area
        self.style = style
        self.mSize = size
        self.mNdefMsg = ndefMessage

    }
    init(area: Int, style: AreaStyle, size: Int) {
        self.mArea = area
        self.style = style
        self.mSize = size
    }
}

class AreaLibrary: NSObject {
    
    static let shared = AreaLibrary()
    
    private(set) var areas: [TagArea] = []
    
    func add(_ area: TagArea) {
        areas.append(area)
        print(areas.description)
    }
    
    func clear() {
        areas.removeAll()
    }
    func updateNdefInArea(area: Int, ndef: ComStSt25sdkNdefNDEFMsg)  {
        areas[area].mNdefMsg = ndef
    }
}
