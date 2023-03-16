//
//  CCFile.swift
//  NFCTap
//
//  Created by STMICROELECTRONICS on 09/10/2019.
//  Copyright © 2019 STMicroelectronics. All rights reserved.
//

import Foundation
/**
 * Defines methods to handle a NFC Forum Capability Container file
 */
public class CCFile {
    /**
     * Cache management
     */
    internal var mCCLength : Int = 0;
    internal var mMagicNumber : UInt8 = 0
    internal var mMappingVersion : UInt8 = 0
    internal var mReadAccess : UInt8 = 0
    internal var mWriteAccess : UInt8 = 0
    internal var mDataAreaSize : Int32 = 0;
    internal var mBlockSize : Int = 0;

    // Indicates if the tag suppports the Extended commands with 2 Bytes address mode
    internal var mSupport2ByteAddressMode : Bool = false

    // If the T5T does not support the READ_MULTIPLE_BLOCKS or EXTENDED_READ_MULTIPLE_BLOCKS commands,
    // b0 of Byte 3 of the CC File SHALL be set to 0b.
    internal var mSupportMultipleBlockReadCommand : Bool = false

    // If the T5T does not support the LOCK_SINGLE_BLOCK or the EXTENDED_LOCK_SINGLE_BLOCK commands,
    // b3 of Byte 3 of the CC File SHALL be set to 0b.
    internal var mSupportLockBlockCommand : Bool = false

    // If the T5T needs the Special Frame format as defined within [DIGITAL] for Write-Alike commands,
    // b4 of Byte 3 of the CC File SHALL be set to 1b.
    internal var mSupportSpecialFrameCommand : Bool = false

    // For Vicinity Tags, b2 of Byte 3 of the CC File SHALL be set to 1b.
    internal var mVicinityHighDensityOverflow : Bool = false

    internal var mCacheActivated : Bool = false
    internal var mCacheInvalidated : Bool = false

    var isValid: Bool = false;

    
    /**
     * Short capability container magic number
     */
    public let CCFILE_SHORT_IDENTIFIER : UInt8 =  0xE1
    /**
     * Long capability container magic number
     */
    public static var CCFILE_LONG_IDENTIFIER : UInt8 = 0xE2
    /**
     * Multiplier used to compute the Type5 Tag area size (in bytes) from CCFile MLEN field
     */
    public static var CCFILE_DATA_AREA_SIZE_MULTIPLIER : Int = 8;

    // NFC CC file byte 3 bits
    private static  var SUPPORT_MULTIPLE_BLOCK_READ_CMD_MASK : UInt8 = 0x01;
    private static  var SUPPORT_LOCK_BLOCK_CMD_MASK : UInt8 = 0x08;
    private static  var SUPPORT_SPECIAL_FRAME_CMD_MASK : UInt8 = 0x10;
    // Specific Vicinity High Density CC file byte 3
    private static  var VICINITY_HIGH_DENSITY_CMD_MASK : UInt8 = 0x04;

    /**
     * Reads this CCfile
     * @return this CCfile content
     * @throws STException
     */
    //public abstract func read() -> [UInt8] throws STException;

    /**
     * Writes this CCfile
     * @throws STException
     */
    //public abstract func write() throws STException;

    /**
     * Writes this CCfile
     * @param buffer byte array containing CC file data
     * @throws STException
     */
    //public abstract func write(buffer : [UInt8]) throws STException;

    internal func initEmptyCCFile(memSizeInBytes : Int){
        // If number of (bytes/8) > 256, code CC File on 2 bytes
        if (memSizeInBytes > 2040) {
            // CC File on 8 Bytes
            mCCLength = 8;
            mMagicNumber = CCFile.CCFILE_LONG_IDENTIFIER;
            mMappingVersion =  0x40;
            mReadAccess = 0x00;
            mWriteAccess = 0x00;
            mDataAreaSize = Int32(memSizeInBytes);

            mSupport2ByteAddressMode = true;

            // Read multiple blocks (mask 0x01)
            mSupportMultipleBlockReadCommand = true;
            mSupportLockBlockCommand = false;
            mSupportSpecialFrameCommand = false;
            // RFU mask (0x04) for android native support of Vicinity tags
            mVicinityHighDensityOverflow = false;
        } else {
            // CC File on 4 Bytes
            mCCLength = 4;
            mMagicNumber = CCFILE_SHORT_IDENTIFIER;
            mMappingVersion = 0x40;
            mReadAccess = 0x00;
            mWriteAccess = 0x00;
            mDataAreaSize = Int32(memSizeInBytes);

            mSupport2ByteAddressMode = false;

            //Read multiple blocks (mask 0x01)
            mSupportMultipleBlockReadCommand = true;
            mSupportLockBlockCommand = false;
            mSupportSpecialFrameCommand = false;
            // RFU mask (0x04) for android native support of Vicinity tags
            mVicinityHighDensityOverflow = false;
        }
    }

    /**
     * Constructor for a CCFile object
     */
    init() {
    }

    /**
     * This function will indicate the expected CCFile length (in Bytes) for a given memory size.
     * This function is deprecated. Please use getExpectedCCFileLength() of Type5Tag instead.
     *
     * @param dataAreaSizeInBytes Type5 Tag area length (in bytes)
     * @return the CCFile length (4 or 8 bytes)
     */
    public func getExpectedCCFileLength(dataAreaSizeInBytes : Int) -> Int {
        // A CCFile on 4 bytes can manage tags with up to 255 * 8 = 2040 Bytes of memory
        if (dataAreaSizeInBytes > 2040) {
            // CCFile on 8 Bytes
            return 8;
        } else {
            // CCFile on 4 Bytes
            return 4;
        }
    }

    /**
     * Returns info on CC length (4 or 8 bytes)
     * @return the CCLength
     * @throws STException
     */
    public func getCCLength() -> Int  {
        return mCCLength;
    }

    /**
     * Getter for this CCFile's magic number
     * @return this CCFile's magic number
     * @throws STException
     */
    public func getMagicNumber() -> UInt8 {
        return mMagicNumber;
    }

    /**
     * Getter for this CCFile's mapping version
     * @return this CCFile's mapping version
     * @throws STException
     */
    public func getCCMappingVersion() -> UInt8  {
        return mMappingVersion;
    }

    /**
     * Getter for this CCFile's read access
     * @return this CCFile's read access
     * @throws STException
     */
    public func getCCReadAccess() -> UInt8  {
        return mReadAccess;
    }

    /**
     * Getter for this CCFile's write access
     * @return this CCFile's write access
     * @throws STException
     */
    public func getCCWriteAccess() -> UInt8  {
        return mWriteAccess;
    }

    /**
     * Getter for this CCFile's write access
     * @return this CCFile's data area size
     * @throws STException
     */
    public func getDataAreaSize() -> Int  {
        return Int(mDataAreaSize)
    }

    /**
     * Getter for this CCFile's support 2-byte address mode
     * @return True if 2-byte address mode supported
     * @throws STException
     */
    public func is2ByteAddressModeSupported() throws -> Bool  {
        return mSupport2ByteAddressMode;
    }

    /**
     * Getter for this CCFile's Multiple Block Read Command supported
     * @return True if Multiple block read command supported
     * @throws STException
     */
    public func isMultipleBlockReadCommandSupported() throws -> Bool  {
        return mSupportMultipleBlockReadCommand;
    }

    /**
     * Getter for this CCFile's Lock Block Command supported
     * @return True if Lock block command supported
     * @throws STException
     */
    public func isLockBlockCommandSupported() throws -> Bool {
        return mSupportLockBlockCommand;
    }

    /**
     * Getter for this CCFile's Special Frame Command supported
     * @return True if special frame command supported
     * @throws STException
     */
    public func isSpecialFrameCommandSupported() throws -> Bool  {
        return mSupportSpecialFrameCommand;
    }

    /**
     * Getter for this CCFile's Vicinity High Density memory size Overflow
     * @return True if Vicinity High Density memory size overflow
     * @throws STException
     */
    public func isVicinityHighDensityOverflow() throws -> Bool  {
        return mVicinityHighDensityOverflow;
    }


    /**
     * Parses the CCFile data to extract its fields
     * @param buffer Raw data of the CCFile
     * @throws STException
     */
    public func parseCCFile(buffer : [UInt8]) throws {

        if (buffer.count < 3) {
            //throwException() /* throw STException(INVALID_CCFILE); */
            throw NSError(domain: "IMPLEMENTATION", code: 32, userInfo: ["ui1":"Invalid CC file"] )
        }

        if (buffer[2] == 0x00) {
            if (buffer.count != 8) {
                //throwException() /* throw STException(INVALID_CCFILE); */
                throw NSError(domain: "IMPLEMENTATION", code: 32, userInfo: ["ui1":"Invalid CC file"] )

            }

            // 8-byte CC, extract data area size from bytes 6 and 7
            mCCLength = buffer.count;
            mDataAreaSize = Int32(Int(CCFile.CCFILE_DATA_AREA_SIZE_MULTIPLIER * Int((buffer[6] << 8) + buffer[7])))
        } else {
            if(buffer.count != 4) {
                //throwException() /* throw STException(INVALID_CCFILE); */
            }
            // 4-byte CC, extract data area size from byte 2
            mCCLength = buffer.count;
            mDataAreaSize = Int32(Int(CCFile.CCFILE_DATA_AREA_SIZE_MULTIPLIER * Int(Int(buffer[2]))))
            //ComStSt25sdkHelper.convertByteToUnsignedInt(withByte: jbyte(buffer[2]))
            //convertByteToUnsignedInt(buffer[2]);
        }

        mMagicNumber = buffer[0];
        mSupport2ByteAddressMode = (buffer[0] == CCFile.CCFILE_LONG_IDENTIFIER);

        mMappingVersion = (UInt8) (buffer[1] & 0xF0);
        mReadAccess = (UInt8) (buffer[1] & 0x0C);
        mWriteAccess = (UInt8) (buffer[1] & 0x03);

        // NFC Forum CC File
        mSupportMultipleBlockReadCommand = ((buffer[3] & CCFile.SUPPORT_MULTIPLE_BLOCK_READ_CMD_MASK) == CCFile.SUPPORT_MULTIPLE_BLOCK_READ_CMD_MASK);
        mSupportLockBlockCommand = ((buffer[3] & CCFile.SUPPORT_LOCK_BLOCK_CMD_MASK) == CCFile.SUPPORT_LOCK_BLOCK_CMD_MASK);
        mSupportSpecialFrameCommand = ((buffer[3] & CCFile.SUPPORT_SPECIAL_FRAME_CMD_MASK) == CCFile.SUPPORT_SPECIAL_FRAME_CMD_MASK);

        // Vicinity High Density tags
        mVicinityHighDensityOverflow = ((buffer[3] & CCFile.VICINITY_HIGH_DENSITY_CMD_MASK) == CCFile.VICINITY_HIGH_DENSITY_CMD_MASK);
    }

    /**
     * Re-build the CCFile from the cached data
     * @return CC file buffer
     * @throws STException
     */
    public func rebuildBuffer() throws -> [UInt8]  {

        if (mCCLength != 4 && mCCLength != 8) {
            //throwException() /* throw STException(INVALID_CCFILE); */
            throw NSError(domain: "IMPLEMENTATION", code: 32, userInfo: ["ui1":"Invalid CC file"] )

        }

        var buffer : [UInt8] = [UInt8]()

        buffer.insert(UInt8(mMagicNumber), at: 0)
        buffer.insert(UInt8(mMappingVersion | mReadAccess | mWriteAccess), at: 1)
        
        var bufferTmp:UInt8 = 0
        if (mSupportMultipleBlockReadCommand) {
            bufferTmp |= CCFile.SUPPORT_MULTIPLE_BLOCK_READ_CMD_MASK;
        }
        if (mSupportLockBlockCommand) {
            bufferTmp |= CCFile.SUPPORT_LOCK_BLOCK_CMD_MASK;
        }
        if (mSupportSpecialFrameCommand) {
            bufferTmp |= CCFile.SUPPORT_SPECIAL_FRAME_CMD_MASK;
        }
        if (mVicinityHighDensityOverflow) {
            bufferTmp |= CCFile.VICINITY_HIGH_DENSITY_CMD_MASK;
        }
        
        
        if(mCCLength == 4) {
            buffer.insert(UInt8(Int(mDataAreaSize) / CCFile.CCFILE_DATA_AREA_SIZE_MULTIPLIER), at: 2)
            buffer.insert(UInt8(bufferTmp), at: 3)
        } else {
            buffer.insert(0x00, at: 2)
            buffer.insert(UInt8(bufferTmp), at: 3)
            buffer.insert(0x00, at: 4)
            buffer.insert(0x00, at: 5)
            buffer.insert((UInt8) (((Int(mDataAreaSize) / CCFile.CCFILE_DATA_AREA_SIZE_MULTIPLIER) & 0xFF00) >> 8), at: 6)
            buffer.insert((UInt8) ((Int(mDataAreaSize) / CCFile.CCFILE_DATA_AREA_SIZE_MULTIPLIER) & 0xFF), at: 7)
        }

        return buffer;
    }

    public func isValidCCFile() -> Bool  {
        return isValid;
    }
}
