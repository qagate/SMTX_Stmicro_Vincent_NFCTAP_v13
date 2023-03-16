//
//  ST25TNTag.swift
//  NFCTap 
//
//  Created by STMICROELECTRONICS on 10/02/2021.
//  Copyright © 2021 STMicroelectronics. All rights reserved.
//
import Foundation
import UIKit
import CoreNFC

@available(iOS 13, *)
class ST25TNTag: ComStSt25sdkType2St25tnST25TNTag {
    
    var mComStSt25sdkRFReaderInterface:iOSRFReaderInterface!
    
    init(RFReaderInterface:iOSRFReaderInterface,uid:Data) {
        super.init(comStSt25sdkRFReaderInterface: RFReaderInterface, with: IOSByteArray.init(nsData: uid))
        mComStSt25sdkRFReaderInterface = RFReaderInterface
    }
    
    
    func readCCFile() -> Data! {
        return(readCCFile()?.toNSData())!
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

