//
//  stringLocalizationWithoutComments.swift
//  NFCTap
//
//  Created by STMICROELECTRONICS on 30/01/2018.
//  Copyright © 2018 STMicroelectronics. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        // don’t deserve comments
        return NSLocalizedString(self, comment: "")
    }
}
