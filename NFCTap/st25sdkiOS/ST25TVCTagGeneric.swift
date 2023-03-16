//
//  ST25TVCTagGeneric.swift
//  ST25NFCAppSla
//
//  Created by STMICROELECTRONICS on 15/12/2020.
//  Copyright © 2020 STMicroelectronics. All rights reserved.
//

import Foundation
@available(iOS 13, *)
class ST25TVCTagGeneric: ComStSt25sdkType5St25tvcST25TVCTag {
    
    var mComStSt25sdkRFReaderInterface:iOSRFReaderInterface!
    
    init(RFReaderInterface:iOSRFReaderInterface,uid:Data) {
        super.init(comStSt25sdkRFReaderInterface: RFReaderInterface, with: IOSByteArray.init(nsData: uid))
        mComStSt25sdkRFReaderInterface = RFReaderInterface
    }
    
    init(RFReaderInterface:iOSRFReaderInterface,uid:Data,sendInitCommand:Bool) {
        super.init(comStSt25sdkRFReaderInterface: RFReaderInterface, with: IOSByteArray.init(nsData: uid),withBoolean:sendInitCommand)
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
    
    func readUniqueTapCode() -> String {
        return (String(getUniqueTapCodeString()))
    }
        
    func enableUniqueTapCode(boolean:Bool) {
        enableUniqueTapCode(withBoolean: boolean)
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
