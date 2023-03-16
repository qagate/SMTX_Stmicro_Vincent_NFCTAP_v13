//
//  CCFileType4.swift
//  NFCTap 
//
//  Created by STMICROELECTRONICS on 09/09/2021.
//  Copyright © 2021 STMicroelectronics. All rights reserved.
//

import Foundation

public class CCFileType4 : CCFile {
 
    var mCCFileData:[UInt8] = []

    public init(ccfileData:[UInt8]!) {
        super.init();
        self.mCCFileData = ccfileData
    }
    
    public func decode() throws  {

        let ccFileLenght = mCCFileData[0]+mCCFileData[1]

        if(ccFileLenght >= 15) {
            self.mCCLength = Int(ccFileLenght)
            self.mMappingVersion = mCCFileData[2]
            self.mMagicNumber = 0x00
            self.mDataAreaSize = Int32(mCCFileData[11])<<8 + Int32(mCCFileData[12])
            self.mReadAccess  = mCCFileData[13]
            self.mWriteAccess = mCCFileData[14]
            isValid = true

        }else{
            throw NSError(domain: "IMPLEMENTATION", code: 32, userInfo: ["CCFile type4":"Invalid length"] )
        }
    }

}
