//
//  StColors.swift
//  NFCTap
//
//  Created by STMicroelectronics on 16/10/2019.
//  Copyright © 2019 STMicroelectronics. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
    
    
    class func stRedColor() -> UIColor {
        return UIColor(red: 255, green: 0, blue: 0)
    }
    // Blue
    class func stDarkBlueColor() -> UIColor {
        return UIColor(red: 3, green: 35, blue: 75)
    }
    class func stLightBlueColor() -> UIColor {
        return UIColor(red: 60, green: 180, blue: 230)
    }
    class func stVeryLightBlueColor() -> UIColor {
        return UIColor(red: 215, green: 238, blue: 248)
    }
    // Colors
    class func stLightRedColor() -> UIColor {
        return UIColor(red: 212, green: 0, blue: 122)
    }
    class func stLightGreenColor() -> UIColor {
        return UIColor(red: 187, green: 204, blue: 0)
    }
    class func stGreenColor() -> UIColor {
        return UIColor(red: 0, green: 61, blue: 20)
    }
    class func stVioletColor() -> UIColor {
        return UIColor(red: 89, green: 13, blue: 88)
    }
    
    class func stLightYellowColor() -> UIColor {
        return UIColor(red: 255, green: 210, blue: 0)
    }


    class func stBrownColor() -> UIColor {
        return UIColor(red: 92, green: 9, blue: 21)
    }
    
    // grey
    class func stDarkGreyColor() -> UIColor {
        return UIColor(red: 79, green: 82, blue: 81)
    }
    class func stGreyColor() -> UIColor {
        return UIColor(red: 144, green: 152, blue: 158)
    }
    class func stLightGreyColor() -> UIColor {
        return UIColor(red: 185, green: 196, blue: 202)
    }
    class func stLightVioletColor() -> UIColor {
        return UIColor(red: 212, green: 0, blue: 87)
    }
}
