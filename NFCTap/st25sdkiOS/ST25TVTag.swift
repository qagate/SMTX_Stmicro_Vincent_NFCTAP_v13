//
//  ST25TVTag.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 9/9/19.
//  Copyright © 2019 STMicroelectronics. All rights reserved.
//

import Foundation
import UIKit
import CoreNFC

@available(iOS 13, *)
class ST25TVTag: ComStSt25sdkType5St25tvST25TVTag {
    
    var mComStSt25sdkRFReaderInterface:iOSRFReaderInterface!
    
    init(RFReaderInterface:iOSRFReaderInterface,uid:Data) {
        super.init(comStSt25sdkRFReaderInterface: RFReaderInterface, with: IOSByteArray.init(nsData: uid))
        mComStSt25sdkRFReaderInterface = RFReaderInterface
    }
    
    init(RFReaderInterface:iOSRFReaderInterface,uid:Data,checkEasStatus:Bool,sendInitCommand:Bool) {
        super.init(comStSt25sdkRFReaderInterface: RFReaderInterface, with: IOSByteArray.init(nsData: uid),withBoolean:checkEasStatus,withBoolean:sendInitCommand)
        mComStSt25sdkRFReaderInterface = RFReaderInterface
    }

    
    func readCCFile() -> Data! {
        return(readCCFile()?.toNSData())!
    }
    
    func getRandomNumber() -> Data! {
        return getRandomNumber()?.toNSData()
    }
    
    func presentPassword(passwordNumber:UInt8, password: Data!) {
        let PwdIOSByteArray = IOSByteArray.init(nsData: password)
        presentPassword(with: jint(passwordNumber), with: PwdIOSByteArray)
    }
         
    func readCounter() -> UInt8 {
        return(UInt8(readCounterValue()))
    }
        
    func enableCounter(boolean:Bool) {
        enableCounter(withBoolean: boolean)
    }
    
    func isTamperDetected()->Bool {
        return (getRegisterTamperConfiguration()?.isTamperDetected())!
    }
    
    func isSignatureOk() throws -> Bool {
        let KeyId = getKeyIdNDA()
        let SignatureIOSByteArray = readSignatureNDA()
        let SignatureByte:[UInt8] = [UInt8]((SignatureIOSByteArray!.toNSData()!))
        let UidByte:[UInt8] = [UInt8](getUid()!.toNSData()!)
        let checkSign:CheckSign = CheckSign()
        let signatureCheck = try checkSign.isSignatureValid(keyID: UInt8(KeyId), signature: SignatureByte, uid: UidByte)
        return signatureCheck
    }
    
}

