//
//  ST25DVPwmTag.swift
//  ST25NFCApp
//
//  Created by STMicroelectronics on 30/04/2020.
//  Copyright © 2020 STMicroelectronics. All rights reserved.
//

import Foundation
import UIKit
import CoreNFC

@available(iOS 13, *)
class ST25DVPwmTag: ComStSt25sdkType5St25dvpwmST25DVPwmTag {
    
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
