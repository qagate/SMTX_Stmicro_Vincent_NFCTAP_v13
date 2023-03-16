//
//  iOSCCFileType5.swift
//  ST25NFCApp
//
//  Created by STMicroelectronics on 10/11/19.
//  Copyright © 2019 STMicroelectronics. All rights reserved.
//

import Foundation


class iOSCCFileType5: ComStSt25sdkType5CCFile {
    
    var mBuffer:[UInt8]!
    override init() {
        super.init()
    }
    
    init(buffer: [UInt8] ){
        mBuffer = buffer
    }
    
    func parseCCFile() -> () {
        parseCCFile(with: getBuffer()!)
    }
    
    override func read() -> IOSByteArray! {
        return getBuffer()
    }
    
    private func getBuffer() -> IOSByteArray! {
        let ccFileData = NSData(bytes: mBuffer, length: mBuffer.count)
        let ccFileDataIOSByteArray = IOSByteArray.init(nsData: ccFileData as Data)
        return ccFileDataIOSByteArray
    }
   
}
