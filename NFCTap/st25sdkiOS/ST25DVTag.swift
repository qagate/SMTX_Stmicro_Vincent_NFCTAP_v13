//
//  ST25DVTag.swift
//  NFCTap
//
//  Created by STMICROELECTRONICS on 29/10/2019.
//  Copyright © 2019 STMicroelectronics. All rights reserved.
//

import Foundation
import UIKit
import CoreNFC

@available(iOS 13, *)

enum AreaError: Error {
    case invalid(String)
}

class ST25DVTag: ComStSt25sdkType5St25dvST25DVTag {
    
    var mComStSt25sdkRFReaderInterface:iOSRFReaderInterface!
    
    
    init(RFReaderInterface:iOSRFReaderInterface,uid:Data) {
        super.init(comStSt25sdkRFReaderInterface: RFReaderInterface, with: IOSByteArray.init(nsData: uid))
        mComStSt25sdkRFReaderInterface = RFReaderInterface
    }
    
    func readCCFile() -> Data! {
        return(readCCFile()?.toNSData())!
    }
    
    
    func presentPassword(passwordNumber:UInt8, password: Data!) {
        let PwdIOSByteArray = IOSByteArray.init(nsData: password)

        presentPassword(with: jint(passwordNumber), with: PwdIOSByteArray)
        //mComStSt25sdkRFReaderInterface.miOSIso15693.customCommand(code: 0xB3, data: Data( [0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00]))
    }


    /**
     * Check if Vcc is ON - Dynamic EH control register value is used
     * @return True if Vcc ON otherwise False
     * @throws STException
     */
    override func isVccOn() -> Bool {
        return isVccOn()
    }

    /**
     * Refresh Mail box status register - invalidate the cache and retrieve register content
     * Use standards commands
     * @throws STException
     */
    override func refreshMailboxStatus() {
        refreshMailboxStatus(withBoolean: false);
    }

    /**
     * Refresh Mail box status register - invalidate the cache and retrieve register content
     * @param useFastCommand use fast command or standard one
     * @throws STException
     */
    func refreshMailboxStatus(useFastCommand: Bool) {
        refreshMailboxStatus(useFastCommand: useFastCommand)
    }



    /**
     * Check if Host has put a message
     * @param refresh force sending command to Tag through an invalidate of cache.
     * @return true if Host has put a message
     * @throws STException
     */
    func hasHostPutMsg(refresh: Bool) -> Bool {
        hasHostPutMsg(withBoolean: refresh, withBoolean: false)
    }


    /**
     * Check if RF has put a message
     * @param refresh force sending command to Tag through an invalidate of cache.
     * @return true if RF has put a message
     * @throws STException
     */
    func hasRFPutMsg(refresh: Bool) -> Bool {
        hasRFPutMsg(withBoolean: refresh, withBoolean: false)
    }


    /**
     * Check if Host missed message - see also Watch dog register
     * @param refresh force sending command to Tag through an invalidate of cache.
     * @return true if Host has missed a message
     * @throws STException
     */
    func hasHostMissMsg(refresh: Bool) -> Bool {
        hasHostMissMsg(withBoolean: refresh, withBoolean: false)
    }


    /**
     * Check if RF missed message - see also Watch dog register
     * @param refresh force sending command to Tag through an invalidate of cache.
     * @return true if RF has missed a message
     * @throws STException
     */
    func hasRFMissMsg(refresh: Bool) -> Bool {
        hasRFMissMsg(withBoolean: refresh, withBoolean: false)
    }
    
    func setAreaEndValuesForHighDensityTags(endOfArea1 : UInt8, endOfArea2 : UInt8, endOfArea3 : UInt8) throws {
        let maxEndOfAreaValue : Int = Int(ComStSt25sdkHelper.convertByteToUnsignedInt(withByte: jbyte(getMaxEndOfAreaValue())))
        let endA1 : Int = Int(endOfArea1);
        let endA2 : Int = Int(endOfArea2);
        let endA3 : Int = Int(endOfArea3);


        if (endA1 > endA2 || endA2 > endA3) {
            //throw ComStSt25sdkSTException(comStSt25sdkSTException_STExceptionCode: ComStSt25sdkSTException_STExceptionCode_get_BAD_PARAMETER()) as! Error
            throw AreaError.invalid("Bad parameter")
        }

        if (endOfArea1 == endOfArea2) {
            // This is allowed only if they are equal to maxEndOfAreaValue
            if (endOfArea1 != maxEndOfAreaValue) {
                //throw ComStSt25sdkSTException(comStSt25sdkSTException_STExceptionCode: ComStSt25sdkSTException_STExceptionCode_get_BAD_PARAMETER()) as! Error
                throw AreaError.invalid("Bad parameter")
            }
        }

        if (endOfArea2 == endOfArea3) {
            // This is allowed only if they are equal to maxEndOfAreaValue
            if (endOfArea2 != maxEndOfAreaValue) {
                //throw ComStSt25sdkSTException(comStSt25sdkSTException_STExceptionCode: ComStSt25sdkSTException_STExceptionCode_get_BAD_PARAMETER()) as! Error
                throw AreaError.invalid("Bad parameter")
            }
        }

        /* Proceed with EndArea programming as described in ST25DV datasheet */
        if (getRegisterEndArea3().getValue() != maxEndOfAreaValue) {
            getRegisterEndArea3()?.setRegisterValueWith(jint(maxEndOfAreaValue))
        }
        if (getRegisterEndArea2().getValue() != maxEndOfAreaValue) {
            getRegisterEndArea2()?.setRegisterValueWith(jint(maxEndOfAreaValue))
        }

        getRegisterEndArea1().setRegisterValueWith(jint(endA1));

        if (endA2 > endA1) {
            getRegisterEndArea2().setRegisterValueWith(jint(endA2));
        }

        if (endA3 > endA2) {
            getRegisterEndArea3().setRegisterValueWith(jint(endA3));
        }
    }

    
}
