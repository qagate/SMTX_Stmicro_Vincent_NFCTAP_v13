//
//  ST25TATag.swift
//  NFCTap 
//
//  Created by STMICROELECTRONICS on 10/02/2021.
//  Copyright © 2021 STMicroelectronics. All rights reserved.
//
import Foundation
import UIKit
import CoreNFC

@available(iOS 13, *)
class ST25TA02KBTag: ComStSt25sdkType4aSt25taST25TA02KBTag {
    
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

