//
//  ST25TV16KTag.swift
//  NFCTap 
//
//  Created by STMicroelectronics on 27/07/2020.
//  Copyright © 2020 STMicroelectronics. All rights reserved.
//

import Foundation
import UIKit
import CoreNFC

@available(iOS 13, *)
class ST25TV16KTag: ComStSt25sdkType5St25dvST25TV16KTag {
    
    var mComStSt25sdkRFReaderInterface:iOSRFReaderInterface!
    
    
    init(RFReaderInterface:iOSRFReaderInterface,uid:Data) {
        super.init(comStSt25sdkRFReaderInterface: RFReaderInterface, with: IOSByteArray.init(nsData: uid))
        mComStSt25sdkRFReaderInterface = RFReaderInterface
    }
    
    func presentPassword(passwordNumber:UInt8, password: Data!) {
        let PwdIOSByteArray = IOSByteArray.init(nsData: password)

        presentPassword(with: jint(passwordNumber), with: PwdIOSByteArray)
        //mComStSt25sdkRFReaderInterface.miOSIso15693.customCommand(code: 0xB3, data: Data( [0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00]))
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
