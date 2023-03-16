//
//  TagInfoTypeX.swift
//  NFCTap 
//
//  Created by STMicroelectronics on 10/02/2021.
//  Copyright © 2021 STMicroelectronics. All rights reserved.
//

import Foundation

protocol TagInfoTypeX {
    var mProductId:ComStSt25sdkTagHelper_ProductID {get set}
    var mTagPropertiesInformationTableModel:TagInfoGenericModel {get set}
    var mTagSystemInfo:TagInfo {get set}
    var mUID: Data? {get set}
    
    func tagInformationProcess()->Bool;
    #if !APPCLIP
    func processReadNdef()->Bool;
    #endif
}
