//
//  STType5Tag.swift
//  NFCTap 
//
//  Created by Frederic BERT on 30/11/2020.
//  Copyright © 2020 STMicroelectronics. All rights reserved.
//

import Foundation
class STType5Tag: ComStSt25sdkType5STType5Tag {
    var mComStSt25sdkRFReaderInterface:iOSRFReaderInterface!
    
    init(RFReaderInterface:iOSRFReaderInterface,uid:Data) {
        super.init(comStSt25sdkRFReaderInterface: RFReaderInterface, with: IOSByteArray.init(nsData: uid))
        mComStSt25sdkRFReaderInterface = RFReaderInterface
    }

}
