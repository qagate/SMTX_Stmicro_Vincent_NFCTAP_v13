//
//  TagInfoHelper.swift
//  NFCTap
//
//  Created by STMICROELECTRONICS on 03/10/2019.
//  Copyright © 2019 STMicroelectronics. All rights reserved.
//

import Foundation
import UIKit
import CoreNFC

let mUIDUnTraceable:Data = Data([0xE0,0x02,0x00,0x00,0x00,0x00,0x00,0x00])

public class TagInfo {
    var uid : Data
    var dfsid: Int
    var afi: Int
    var blockSize: Int
    var numberOfBlocks: Int
    var icRef: Int
    var productID: ComStSt25sdkTagHelper_ProductID
    var mCurrentST25SdkTagInstance : ComStSt25sdkNFCTag!
    var miOSCCFileType5:CCFileType5? = CCFileType5.init(firstBlock: [0x00,0x00,0x00,0x00], secondBlock: [0x00,0x00,0x00,0x00])
    
    init(uid : Data, dfsid: Int, afi: Int, blockSize: Int, numberOfBlocks: Int, icRef: Int) {
        if #available(iOS 14.0, *) {
            self.blockSize = blockSize
            self.numberOfBlocks = numberOfBlocks
            self.productID = ComStSt25sdkTagHelper_ProductID.PRODUCT_UNKNOWN

        } else {
            // Fallback on earlier versions
            // Patch for iOS API regarding extendedGetSystemInfo .... High density Tags
            // force values of numberOfBlock and BblockSize returned as -1 by get system info
            // TV
            if icRef == 0x48 {
                self.blockSize = 4
                self.numberOfBlocks = 512
                self.productID = ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_ST25TV16K
            }else{
                self.blockSize = blockSize
                self.numberOfBlocks = numberOfBlocks
                self.productID = ComStSt25sdkTagHelper_ProductID.PRODUCT_UNKNOWN
            }
        }

        self.icRef = icRef
        self.uid = uid
        self.dfsid = dfsid
        self.afi = afi
        
    }
    
    func setCCFileType5(ccfileType5:CCFileType5){
        self.miOSCCFileType5 = ccfileType5
    }
    
    func getCCFileType5() -> CCFileType5 {
        
        return self.miOSCCFileType5!
    }
    
    func setProductID (productID: ComStSt25sdkTagHelper_ProductID) {
        self.productID = productID
    }
    func getProductID () -> ComStSt25sdkTagHelper_ProductID {
        return productID
    }
    
    // instantiate ST25SDKTag according to ProductID
    func instantiateTag(RFReaderInterface: iOSRFReaderInterface)  {
        #if !APPCLIP
        switch productID {
        case ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_ST25TV02K, ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_ST25TV512:
                instantiateST25TVTag(RFReaderInterface: RFReaderInterface)
        case ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_ST25TV04K_P:
            mCurrentST25SdkTagInstance = ST25TV04KPTag(RFReaderInterface: RFReaderInterface, uid: self.uid)
        case ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_ST25TV02KC:
            instantiateST25TVCTag(RFReaderInterface: RFReaderInterface)
        case ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_ST25TV512C:
            instantiateST25TVCTag(RFReaderInterface: RFReaderInterface)
        case ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_ST25DV04K_I, ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_ST25DV04K_J,ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_ST25DV16K_I, ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_ST25DV16K_J, ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_ST25DV64K_I, ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_ST25DV64K_J:
            instantiateST25DVTag(RFReaderInterface: RFReaderInterface)

        case ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_ST25DV04KC_I, ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_ST25DV16KC_I, ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_ST25DV64KC_I,
             ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_ST25DV04KC_J, ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_ST25DV16KC_J, ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_ST25DV64KC_J:
            instantiateST25DVCTag(RFReaderInterface: RFReaderInterface)

        case ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_ST25DV02K_W1, ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_ST25DV02K_W2:
            instantiateST25DVPwmTag(RFReaderInterface: RFReaderInterface)

        case ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_ST25TV16K:
            mCurrentST25SdkTagInstance = ST25TV16KTag(RFReaderInterface: RFReaderInterface, uid: self.uid)
        case ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_ST25TV64K:
            mCurrentST25SdkTagInstance = ST25TV64KTag(RFReaderInterface: RFReaderInterface, uid: self.uid)
        
            //case ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_STM_UNTRACEABLE:
            //instantiateST25TVUntraceableTag(RFReaderInterface: RFReaderInterface)
       
        case ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_ST25TN01K:
            instantiateST25NTag(RFReaderInterface: RFReaderInterface)
            
        case ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_ST25TA02K_P,
             ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_ST25TA02KB_P,
             ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_ST25TA02KB_D,
             ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_ST25TA16K,
             ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_ST25TA512,
             ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_ST25TA64K:
            instantiateST25Type4aTag(RFReaderInterface: RFReaderInterface)

        case    ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_M24SR02_Y,
                ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_M24SR04_G,
                ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_M24SR04_Y,
                ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_M24SR16_Y,
                ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_M24SR64_Y:
            instantiateST25Type4aM24SRTag(RFReaderInterface: RFReaderInterface)

        default:
            mCurrentST25SdkTagInstance = Type5Tag(RFReaderInterface: RFReaderInterface, uid: self.uid)
        }
        #endif
    }
    
    func getTagInstance() -> ComStSt25sdkNFCTag{
        return mCurrentST25SdkTagInstance
    }

    #if !APPCLIP
    private func instantiateST25TVTag(RFReaderInterface: iOSRFReaderInterface) {
        mCurrentST25SdkTagInstance = ST25TVTag(RFReaderInterface: RFReaderInterface, uid: self.uid)
    }
    private func instantiateST25DVTag(RFReaderInterface: iOSRFReaderInterface) {
        mCurrentST25SdkTagInstance = ST25DVTag(RFReaderInterface: RFReaderInterface, uid: self.uid)
    }
    private func instantiateST25DVCTag(RFReaderInterface: iOSRFReaderInterface) {
        mCurrentST25SdkTagInstance = ST25DVCTag(RFReaderInterface: RFReaderInterface, uid: self.uid)
    }
    private func instantiateST25DVPwmTag(RFReaderInterface: iOSRFReaderInterface) {
        mCurrentST25SdkTagInstance = ST25DVPwmTag(RFReaderInterface: RFReaderInterface, uid: self.uid)
    }
    private func instantiateST25TVCTag(RFReaderInterface: iOSRFReaderInterface) {
        mCurrentST25SdkTagInstance = ST25TVCTag(RFReaderInterface: RFReaderInterface, uid: self.uid)
    }
    private func instantiateST25TVUntraceableTag(RFReaderInterface: iOSRFReaderInterface) {
        mCurrentST25SdkTagInstance = ST25TVCTag(RFReaderInterface: RFReaderInterface, uid: self.uid,sendInitCommand: false)
    }
    private func instantiateST25NTag(RFReaderInterface: iOSRFReaderInterface) {
        mCurrentST25SdkTagInstance = ST25TNTag(RFReaderInterface: RFReaderInterface, uid: self.uid)
    }
    
    private func instantiateST25Type4aTag(RFReaderInterface: iOSRFReaderInterface) {
        mCurrentST25SdkTagInstance = ComStSt25sdkType4aSt25taST25TATag.init(comStSt25sdkRFReaderInterface: RFReaderInterface, with: IOSByteArray.init(nsData: self.uid))
    }
    
    private func instantiateST25Type4aM24SRTag(RFReaderInterface: iOSRFReaderInterface) {        
        mCurrentST25SdkTagInstance = ComStSt25sdkType4aM24srtahighdensityM24SRTAHighDensityTag.init(comStSt25sdkRFReaderInterface: RFReaderInterface, with: IOSByteArray.init(nsData: self.uid))
     }
    
    #endif
}


    public func getProductCode(uid : Data, tag : NFCTag) -> UInt8 {
        var productCode : UInt8 = 0;
        var tagType:ComStSt25sdkNFCTag_NfcTagTypes
        tagType = getTagType(tag: tag)
        var iso15693Tag: NFCISO15693Tag!
        var manufCode:UInt8 = 0

        switch tagType {
        case .NFC_TAG_TYPE_V:
            switch tag {
            case let .iso7816(tag):
                break
            case let .feliCa(tag):
                break
            case let .iso15693(tag):
                iso15693Tag = tag.asNFCISO15693Tag()
                // Retrieve manuf code
                iso15693Tag.identifier.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) -> Void in
                           let rawPointer = UnsafeRawPointer(bytes)
                           manufCode = rawPointer.load(fromByteOffset: 1, as: UInt8.self)
                       }
                
                // Retrieve product code
                if manufCode == ComStSt25sdkCommandIso15693Protocol_STM_MANUFACTURER_CODE {
                    iso15693Tag.icSerialNumber.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) -> Void in
                               let rawPointer = UnsafeRawPointer(bytes)
                               productCode = rawPointer.load(fromByteOffset: 0, as: UInt8.self)
                    
                           }
                }
            case let .miFare(tag):
                break
            @unknown default:
                break
            }

        case .NFC_TAG_TYPE_4A:
            break
        default:
            break
        }
        return productCode;
    }

public func getTagType(tag : NFCTag) -> ComStSt25sdkNFCTag_NfcTagTypes  {
    var tagType : ComStSt25sdkNFCTag_NfcTagTypes = .NFC_TAG_TYPE_UNKNOWN;
    switch tag {
     case let .iso7816(tag):
        tagType = .NFC_TAG_TYPE_4A
     case let .feliCa(tag):
        tagType = .NFC_TAG_ISO18092
         break
     case let .iso15693(tag):
        tagType = .NFC_TAG_TYPE_V
     case let .miFare(tag):
        tagType = .NFC_TAG_TYPE_2
        break
    @unknown default: break
     }
    return tagType;
}

public func decodeProductID(uid : Data, tag : NFCTag, icRef:Int, _ nbrOfBlocks : Int) -> ComStSt25sdkTagHelper_ProductID  {
    var pdt : ComStSt25sdkTagHelper_ProductID = ComStSt25sdkTagHelper_ProductID.PRODUCT_UNKNOWN
    let productCode = getProductCode(uid: uid, tag: tag)
    switch tag {
     case let .iso7816(tag):
        pdt = decodeTagType(uid: uid, tag: tag.asNFCISO7816Tag()!, icRef: icRef)
     case let .iso15693(tag):
        pdt = decodeTagType(uid: uid, icRef: icRef, productCode: productCode, nbrOfBlocks)
     case let .miFare(tag):
        pdt = decodeTagType(uid: uid, tag: tag.asNFCMiFareTag()!)
        break
    case let .feliCa(tag):
        break
    @unknown default: break
     }
    return pdt;
}


// Type5
private func decodeTagType(uid : Data, icRef:Int, productCode: UInt8, _ nbrOfBlocks : Int)  -> ComStSt25sdkTagHelper_ProductID {
    return getType5ProductId(uid, icRef, productCode, nbrOfBlocks)
}

// Type4
private func decodeTagType(uid : Data, tag : NFCISO7816Tag, icRef:Int)  -> ComStSt25sdkTagHelper_ProductID {
    let productId : ComStSt25sdkTagHelper_ProductID = ComStSt25sdkTagHelper_ProductID.PRODUCT_UNKNOWN
    return productId
}

// Type2
private func decodeTagType(uid : Data, tag : NFCMiFareTag)  -> ComStSt25sdkTagHelper_ProductID {
    let productId : ComStSt25sdkTagHelper_ProductID = ComStSt25sdkTagHelper_ProductID.PRODUCT_GENERIC_TYPE2
    if (uid[0] == 0x02){
        // STM tag
        // Read the block 2 which contains SYSBL Code
        let iOSMifareTagTmp = iOSMifare.init(tag)
        var response:Data? = iOSMifareTagTmp.readBlock(blockNumber: 0x02)
        if (response != nil){
            let sysbl:UInt8 = (response?[1])!
            
            // on ST product, ICREF and product code are in block "sysbl+1"
            var response:Data? = iOSMifareTagTmp.readBlock(blockNumber: sysbl+1)
            if (response != nil){
                let productCode:Int = Int(response![1] & 0xFF)
                switch productCode {
                case 0x90:
                    return .PRODUCT_ST_ST25TN01K
                default:
                    break
                }
            }
        }
    }
    return productId
}

private func getType5ProductId(_ uid : Data, _ icRef : Int, _ productCode : UInt8, _ nbrOfBlocks : Int) -> ComStSt25sdkTagHelper_ProductID {
     var productId : ComStSt25sdkTagHelper_ProductID;

     switch icRef {
         // LRi and LRiS family
     case 0x14..<0x17:
        productId = ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_LRi64;
     case 0x20..<0x23:
             productId = ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_LRi2K;
     case 0x28..<0x2B:
             productId = ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_LRiS2K;
     case 0x40..<0x43:
             productId = ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_LRi1K;
         case 0x44:
             productId = ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_LRiS64K;

             // M24LR family
         case 0x2C:
             productId = ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_M24LR64_R;
         case 0x5E:
             productId = ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_M24LR64E_R;
         case 0x4E:
             productId = ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_M24LR16E_R;
         case 0x5A:
             productId = ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_M24LR04E_R;

             // ST25DV family
        case 0x24..<0x27:
             // For ST25DV, the memory size is needed to conclude. It should be obtained from "extended get system info"
             productId = identifyST25DVProduct(productCode: productCode, nbrOfBlocks: nbrOfBlocks)
        case 0x50..<0x53:
             // For ST25DVC, the memory size is needed to conclude. It should be obtained from "extended get system info"
             productId = identifyST25DVCProduct(productCode: productCode, nbrOfBlocks: nbrOfBlocks)
         case 0x23:
             // For ST25TV, the memory size is needed to conclude
             if(nbrOfBlocks == 64) {
                 productId = ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_ST25TV02K;
             } else if (nbrOfBlocks == 16) {
                 productId = ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_ST25TV512;
             } else {
                 productId = ComStSt25sdkTagHelper_ProductID.PRODUCT_UNKNOWN;
             }
            // ST25TV ANDEF
         case 0x08:
            //productId = ProductID.PRODUCT_ST_ST25TV02KC;
            productId = identifyST25TVCProduct(productCode: productCode, nbrOfBlocks: nbrOfBlocks)

            
            // ST25DV-PWM family
         case 0x38:
             productId = ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_ST25DV02K_W1;
         case 0x39:
             productId = ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_ST25DV02K_W2;

             // ST25TV04K-P / ST25TV16K / ST25TV64K
         case 0x35:
            // For ST25DV, the memory size is needed to conclude. It should be obtained from "extended get system info"
            productId = identifyST25TVProduct(productCode: productCode, nbrOfBlocks: nbrOfBlocks)
         case 0x48:
             // For ST25DV, the memory size is needed to conclude. It should be obtained from "extended get system info"
             productId = identifyST25TVProduct(productCode: productCode, nbrOfBlocks: nbrOfBlocks)

         default:
             productId = ComStSt25sdkTagHelper_ProductID.PRODUCT_GENERIC_TYPE5_AND_ISO15693;
     }

     return productId;
 }


private func identifyST25TVProduct(productCode: UInt8, nbrOfBlocks: Int) -> ComStSt25sdkTagHelper_ProductID {
    var productId : ComStSt25sdkTagHelper_ProductID;
        // Default is Unknown
    productId = ComStSt25sdkTagHelper_ProductID.PRODUCT_UNKNOWN;
        if (productCode == 0x48) {
            if (nbrOfBlocks == (0x1FF + 1)) {
                productId = ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_ST25TV16K;
            } else if (nbrOfBlocks == (0x7FF + 1)) {
                productId = ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_ST25TV64K;
            } else {
                productId = ComStSt25sdkTagHelper_ProductID.PRODUCT_UNKNOWN;
            }
        } else if (productCode == 0x35) {
            productId = ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_ST25TV04K_P;
        }

    return productId;
}


private func identifyST25TVCProduct(productCode: UInt8, nbrOfBlocks: Int) -> ComStSt25sdkTagHelper_ProductID {
    var productId : ComStSt25sdkTagHelper_ProductID;
        // Default is Unknown
    productId = ComStSt25sdkTagHelper_ProductID.PRODUCT_UNKNOWN;
        if (productCode == 0x08) {
            if (nbrOfBlocks == (0x0F + 1)) {
                productId = ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_ST25TV512C;
            } else {
                productId = ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_ST25TV02KC;
            }
        }

    return productId;
}


private func identifyST25DVProduct(productCode: UInt8, nbrOfBlocks: Int) -> ComStSt25sdkTagHelper_ProductID {
    var productId : ComStSt25sdkTagHelper_ProductID
    // patched seen from Android and info returned by GetExtendedSystemInfo with APDU cmd
    // Exemple:IOS return 128 from getSystemInfo function in parameters instead of 127 returned by APDU cmd
    let nbrOfBlocksPatched = nbrOfBlocks - 1

    // Default is Unknown
    productId = ComStSt25sdkTagHelper_ProductID.PRODUCT_UNKNOWN;
        if (nbrOfBlocksPatched == 0x7F) {
            if (productCode == 0x24) {
                productId = ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_ST25DV04K_I;
            } else if(productCode == 0x25) {
                productId = ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_ST25DV04K_J;
            }
        } else if (nbrOfBlocksPatched == 0x1FF) {
            if (productCode == 0x26) {
                productId = ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_ST25DV16K_I;
            } else if (productCode == 0x27) {
                productId = ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_ST25DV16K_J;
            }
        } else if (nbrOfBlocksPatched == 0x7FF) {
            if (productCode == 0x26) {
                productId = ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_ST25DV64K_I;
            } else if (productCode == 0x27) {
                productId = ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_ST25DV64K_J;
            }
        }
    return productId;
}

private func identifyST25DVCProduct(productCode: UInt8, nbrOfBlocks: Int) -> ComStSt25sdkTagHelper_ProductID {
    var productId : ComStSt25sdkTagHelper_ProductID
    // patched seen from Android and info returned by GetExtendedSystemInfo with APDU cmd
    // Exemple:IOS return 128 from getSystemInfo function in parameters instead of 127 returned by APDU cmd
    let nbrOfBlocksPatched = nbrOfBlocks - 1

    // Default is Unknown
    productId = ComStSt25sdkTagHelper_ProductID.PRODUCT_UNKNOWN;
        if (nbrOfBlocksPatched == 0x7F) {
            if productCode == 0x50 {
                productId = ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_ST25DV04KC_I;
            } else if productCode == 0x52 {
                productId = ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_ST25DV04KC_J;
            }
            
        } else if (nbrOfBlocksPatched == 0x1FF) {
            if productCode == 0x51 {
                productId = ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_ST25DV16KC_I;
            } else if productCode == 0x53 {
                productId = ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_ST25DV16KC_J;
            }

        } else if (nbrOfBlocksPatched == 0x7FF) {
            if productCode == 0x51 {
                productId = ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_ST25DV64KC_I;
            } else if productCode == 0x53 {
                productId = ComStSt25sdkTagHelper_ProductID.PRODUCT_ST_ST25DV64KC_J;
            }

        }
    return productId;
}

/**
 * IC Manufacturers codes, as defined in ISO/IEC 7816-6
 */
public let ICManufacturers : [String] = [ /* 0x00 */ "Unknown", /* 0x01 */ "Motorola",
        /* 0x02 */ "STMicroelectronics", /* 0x03 */ "Hitachi Ltd", /* 0x04 */ "NXP Semiconductors",
        /* 0x05 */ "Infineon Technologies", /* 0x06 */ "Cylink", /* 0x07 */ "Texas Instruments",
        /* 0x08 */ "Fujitsu Limited", /* 0x09 */ "Matsushita Electronics Corporation", /* 0x0A */ "NEC",
        /* 0x0B */ "Oki Electric Industry Co. Ltd", /* 0x0C */ "Toshiba Corp.",
        /* 0x0D */ "Mitsubishi Electric Corp.", /* 0x0E */ "Samsung Electronics Co. Ltd",
        /* 0x0F */ "Hyundai Electronics Industries Co. Ltd", /* 0x10 */ "LG-Semiconductors Co. Ltd",
        /* 0x11 */ "Emosyn-EM Microelectronics", /* 0x12 */ "Inside Technology",
        /* 0x13 */ "ORGA Kartensysteme GmbH", /* 0x14 */ "SHARP Corporation", /* 0x15 */ "ATMEL",
        /* 0x16 */ "EM Microelectronic-Marin SA", /* 0x17 */ "KSW Microtec GmbH", /* 0x18 */ "Unknown",
        /* 0x19 */ "XICOR, Inc.", /* 0x1A */ "Sony Corporation",
        /* 0x1B */ "Malaysia Microelectronic Solutions Sdn Bhd (MY)", /* 0x1C */ "Emosyn (US)",
        /* 0x1D */ "Shanghai Fudan Microelectronics Co Ltd (CN)", /* 0x1E */ "Magellan Technology Pty Limited (AU)",
        /* 0x1F */ "Melexis NV BO (CH)", /* 0x20 */ "Renesas Technology Corp (JP)", /* 0x21 */ "TAGSYS (FR)",
        /* 0x22 */ "Transcore (US)", /* 0x23 */ "Shanghai Belling Corp Ltd (CN)",
        /* 0x24 */ "Masktech Germany GmbH (DE)", /* 0x25 */ "Innovision Research and Technology",
        /* 0x26 */ "Hitachi ULSI Systems Co Ltd (JP)", /* 0x27 */ "Cypak AB (SE)", /* 0x28 */ "Ricoh (JP)",
        /* 0x29 */ "ASK (FR)", /* 0x2A */ "Unicore Microsystems LLC (RU)",
        /* 0x2B */ "Dallas semiconductor/Maxim (US)", /* 0x2C */ "Impinj Inc (US)",
        /* 0x2D */ "RightPlug Alliance (US)", /* 0x2E */ "Broadcom Corporation (US)",
        /* 0x2F */ "MStar Semiconductor Inc (TW)", /* 0x30 */ "BeeDar Technology Inc (US)",
        /* 0x31 */ "RFIDsec (DK)", /* 0x32 */ "Schweizer Electronic AG (DE)",
        /* 0x33 */ "AMIC Technology Corp (TW)", /* 0x34 */ "Mikron JSC (RU)",
        /* 0x35 */ "Fraunhofer Institute for Photonic Microsystems (DE)", /* 0x36 */ "IDS Microship AG (CH)",
        /* 0x37 */ "Kovio (US)", /* 0x38 */ "AHMT Microelectronic Ltd (CH)",
        /* 0x39 */ "Silicon Craft Technology (TH)", /* 0x3A */ "Advanced Film Device Inc. (JP)",
        /* 0x3B */ "Nitecrest Ltd (UK)", /* 0x3C */ "Verayo Inc. (US)", /* 0x3D */ "HID Global (US)",
        /* 0x3E */ "Productivity Engineering Gmbh (DE)", /* 0x3F */ "AMS (Austria Microsystems)",
        /* 0x40 */ "Gemalto SA (FR)", /* 0x41 */ "Renesas Electronics Corporation (JP)",
        /* 0x42 */ "3Alogics Inc (KR)", /* 0x43 */ "Top TroniQ Asia Limited (Hong Kong)",
        /* 0x44 */ "Gentag Inc (USA)", /* 0x45 */ "Invengo Information Technology Co.Ltd (CN)",
        /* 0x46 */ "Guangzhou Sysur Microelectronics, Inc (CN)", /* 0x47 */ "CEITEC S.A. (BR)",
        /* 0x48 */ "Shanghai Quanray Electronics Co. Ltd. (CN)", /* 0x49 */ "MediaTek Inc (TW)",
        /* 0x4A */ "Angstrem PJSC (RU)", /* 0x4B */ "Celisic Semiconductor (Hong Kong) Limited (CN)",
        /* 0x4C */ "LEGIC Identsystems AG (CH)", /* 0x4D */ "Balluff GmbH (DE)",
        /* 0x4E */ "Oberthur Technologies (FR)", /* 0x4F */ "Silterra Malaysia Sdn. Bhd. (MY)",
        /* 0x50 */ "DELTA Danish Electronics, Light & Acoustics (DK)", /* 0x51 */ "Giesecke & Devrient GmbH (DE)",
        /* 0x52 */ "Shenzhen China Vision Microelectronics Co., Ltd. (CN)", /* 0x53 */ "Shanghai Feiju Microelectronics Co. Ltd. (CN)",
        /* 0x54 */ "Intel Corporation (US)", /* 0x55 */ "Microsensys GmbH (DE)",
        /* 0x56 */ "Sonix Technology Co., Ltd. (TW)", /* 0x57 */ "Qualcomm Technologies Inc (US)",
        /* 0x58 */ "Realtek Semiconductor Corp (TW)", /* 0x59 */ "Freevision Technologies Co. Ltd (CN)",
        /* 0x5A */ "Giantec Semiconductor Inc. (CN)", /* 0x5B */ "JSC Angstrem-T (RU)",
        /* 0x5C */ "STARCHIP France", /* 0x5D */ "SPIRTECH (FR)",
        /* 0x5E */ "GANTNER Electronic GmbH (AT)", /* 0x5F */ "Nordic Semiconductor (NO)",
        /* 0x60 */ "Verisiti Inc (US)", /* 0x61 */ "Wearlinks Technology Inc. (CN)",
        /* 0x62 */ "Userstar Information Systems Co., Ltd (TW)", /* 0x63 */ "Pragmatic Printing Ltd. (UK)",
        /* 0x64 */ "Associacao do Laboratorio de Sistemas Integraveis Tecnologico - LSI-TEC (BR)", /* 0x65 */ "Tendyron Corporation (CN)",
        /* 0x66 */ "MUTO Smart Co., Ltd.(KR)", /* 0x67 */ "ON Semiconductor (US)",
        /* 0x68 */ "TUBITAK BILGEM (TR)", /* 0x69 */ "Huada Semiconductor Co., Ltd (CN)",
        /* 0x6A */ "SEVENEY (FR)", /* 0x6B */ "ISSM (FR)",
        /* 0x6C */ "Wisesec Ltd (IL)"
]



