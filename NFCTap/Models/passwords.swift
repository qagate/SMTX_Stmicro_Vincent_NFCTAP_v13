//
//  passwords.swift
//  ST25NFCApp
//
//  Created by STMicroelectronics on 10/24/19.
//  Copyright © 2019 STMicroelectronics. All rights reserved.
//

import Foundation
import UIKit


class password: NSObject {

    override init(){
        super.init()
    }

    enum pwdAlertStatus: Error {
        case OK
        case Cancel
    }
    
    typealias pwdResults = (_ pwdBuffer : Data?, _ pwdStatus: pwdAlertStatus?)->()
    

    func password(aViewController : UIViewController, aMessage:String, aNumberOfDigit:UInt8, onComplete:@escaping pwdResults) {
    
       // Create a standard UIAlertController
        let alertController = UIAlertController(title: "Password Entry", message: aMessage, preferredStyle: .alert)

        // Add a textField to your controller, with a placeholder value & secure entry enabled
        alertController.addTextField { textField in
            textField.keyboardType = .default
            textField.delegate = aViewController as! UITextFieldDelegate
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
            textField.textAlignment = .center
        }

        // A cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancelled")
            onComplete(nil,pwdAlertStatus.Cancel)
        }

        // This action handles your confirmation action
        let confirmAction = UIAlertAction(title: "OK", style: .default) { _ in
            print("Current password value: \(alertController.textFields?.first?.text ?? "None")")
            onComplete(nil,pwdAlertStatus.OK)
        }

        // Add the actions, the order here does not matter
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        //
        aViewController.present(alertController, animated: true, completion:nil)
    }
}
