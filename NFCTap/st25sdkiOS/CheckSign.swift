//
//  CheckSign.swift
//  ST25NFCApp
//
//  Created by STMicroelectronics on 11/4/19.
//  Copyright © 2019 STMicroelectronics. All rights reserved.
//

import Foundation

import UIKit
import CoreNFC

public enum MyError: Error {
    case ComStSt25sdkSTException(code:UInt8)
}


@available(iOS 13, *)

class CheckSign: NSObject {
    
    func isSignatureValid(keyID:UInt8, signature:[UInt8] , uid:[UInt8]) throws -> Bool {
        throw MyError.ComStSt25sdkSTException(code: UInt8(ComStSt25sdkSTException_STExceptionCode_Enum.IMPLEMENTED_IN_NDA_VERSION.rawValue))
    }
    
    func getDecodedCertificateNDA(ketID:UInt8) throws -> Bool {
        throw MyError.ComStSt25sdkSTException(code: UInt8(ComStSt25sdkSTException_STExceptionCode_Enum.IMPLEMENTED_IN_NDA_VERSION.rawValue))
    }
}
