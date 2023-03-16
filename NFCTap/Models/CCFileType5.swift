//
//  CCFileType5.swift
//  NFCTap
//
//  Created by STMICROELECTRONICS on 10/10/2019.
//  Copyright © 2019 STMicroelectronics. All rights reserved.
//

import Foundation
/**
 * Defines methods to handle a NFC Forum Type5 Capability Container file
 */

public class CCFileType5 : CCFile {
    var firstBlock: [UInt8] = []
    var secondBlock: [UInt8] = []
    /**
     * Constructor for a CCFileType5 object
     * @param type5Command Command object to be used to access this CCFile
     */
    public init(firstBlock: [UInt8], secondBlock: [UInt8]) {
        super.init();
        self.firstBlock = firstBlock
        self.secondBlock = secondBlock
    }

    public func decode() throws -> [UInt8]  {

        if (!mCacheActivated || mCacheInvalidated) {
            var buffer : [UInt8];

            buffer = self.firstBlock;

            // buffer contains the block's data
            // Test buffer size versus the minimum possible value allowed by the ISO standard
            if (buffer.count < 4) {
                //throwException() /* throw STException(INVALID_DATA); */
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
            if(buffer[0] == CCFILE_SHORT_IDENTIFIER || buffer[0] == CCFile.CCFILE_LONG_IDENTIFIER) {
                if (buffer[2] == 0x00) {
                    mCCLength = 8;
                } else {
                    mCCLength = 4;
                }
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
            if (mBlockSize < mCCLength) {
                // More data in CCFile than a block can contain.
                // Read the second block of the CC File
                //readResponse = mType5Command.readBlocks(0x01, 1);
                //buffer = readResponse.data;

                // Copy the data to ccFileContent
                //ccFileContent.put(buffer, 0, mBlockSize);
                for value in self.secondBlock
                {
                   ccFileContent.append( UInt8(value))
                }
            }

            try parseCCFile(buffer: ccFileContent)
            isValid = true
            return ccFileContent
        }

        return try rebuildBuffer();
    }


    public func getCC() throws  -> [UInt8] {
        return try rebuildBuffer()
    }


    public func rebuildCC(buffer : [UInt8]) throws -> [UInt8] {
        try parseCCFile(buffer: buffer);
        return try rebuildBuffer();
    }

    public override func isVicinityHighDensityOverflow() throws -> Bool  {
        //throwException() /* throw STException(NOT_IMPLEMENTED); */
        throw NSError(domain: "IMPLEMENTATION", code: 32, userInfo: ["ui1":"NOT_IMPLEMENTED"] )
    }

    /**
     * Set the bit indicating if the use of readMultipleBlock command is allowed
     * @param supportMultipleBlockReadCommand
     */
    public func setSupportMultipleBlockReadCommand(supportMultipleBlockReadCommand : Bool) {
        self.mSupportMultipleBlockReadCommand = supportMultipleBlockReadCommand;
    }
}
