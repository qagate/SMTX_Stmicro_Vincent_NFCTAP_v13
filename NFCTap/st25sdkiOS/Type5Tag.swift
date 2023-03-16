//
//  Type5Tag.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 06/03/2020.
//  Copyright © 2020 STMicroelectronics. All rights reserved.
//

import Foundation
class Type5Tag: ComStSt25sdkType5Type5Tag {
    var mComStSt25sdkRFReaderInterface:iOSRFReaderInterface!
    
    init(RFReaderInterface:iOSRFReaderInterface,uid:Data) {
        super.init(comStSt25sdkRFReaderInterface: RFReaderInterface, with: IOSByteArray.init(nsData: uid))
        mComStSt25sdkRFReaderInterface = RFReaderInterface
    }

}
