//
//  CCFileType2.swift
//  NFCTap 
//
//  Created by STMICROELECTRONICS on 10/02/2021.
//  Copyright © 2021 STMicroelectronics. All rights reserved.
//

import Foundation


public class CCFileType2 : CCFile {
 
    var firstBlock: [UInt8] = []

    public init(firstBlock: [UInt8]) {
        super.init();
        self.firstBlock = firstBlock
    }
    
    public func decode() throws -> [UInt8]  {

        var buffer : [UInt8];

        buffer = self.firstBlock;

        // buffer contains the block's data
        // Test buffer size versus the minimum possible value allowed by the ISO standard
        if (buffer.count < 4) {
            throw NSError(domain: "IMPLEMENTATION", code: 32, userInfo: ["ui1":"Invalid data"] )
        }

        if(mBlockSize == 0) {
            // This is the first CCFile block that we read for this tag.
            // We use the length of the response to know the size of a block.
            // The block size is the size of the data array in the response.
            mBlockSize = buffer.count;
            let txt : String = "mBlockSize = " + String(mBlockSize)
            ComStSt25sdkSTLog.i(with: txt);
        }

        // No exception -> The command was successful
        // Now check the message content
        if(buffer[0] == CCFILE_SHORT_IDENTIFIER) {
            mCCLength = 4;
        } else {
            // This is NOT a valid CCFile
            //throwException() /* throw STException(INVALID_CCFILE, buffer); */
            throw NSError(domain: "IMPLEMENTATION", code: 32, userInfo: ["ui1":"This is NOT a valid CCFile"] )
        }

        // We now know the CCFile length
        //var ccFileContent = [UInt8](count: Int(mCCLength), repeatedValue: 0)
        var ccFileContent = [UInt8]()
        // Copy the first block of the CCFile
        //ccFileContent.put(buffer, 0, mBlockSize);
        for value in buffer
        {
           ccFileContent.append( UInt8(value))
        }

        try parseCCFile(buffer: ccFileContent)
        isValid = true
        return ccFileContent
    }

}
