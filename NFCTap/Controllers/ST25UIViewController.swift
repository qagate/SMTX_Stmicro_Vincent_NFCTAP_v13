//
//  ST25UIViewController.swift
//  NFCTap
//
//  Created by STMICROELECTRONICS on 30/09/2019.
//  Copyright © 2019 STMicroelectronics. All rights reserved.
//

import UIKit
import CoreNFC

class ST25UIViewController: UIViewController {
    
    // to store the current active textfield
    var activeTextField : UITextField? = nil
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewDidAppear(_ animated: Bool) {
   }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.view.backgroundColor = UIColor.stDarkBlueColor()
    }

   func isSameTag(uid : Data) -> Bool {
     return (TabItem.TagInfo.mainVC as! ST25TagInformationViewController).uid == uid
    }


}

extension ST25UIViewController: UITextFieldDelegate {
    // UITextFieldDelegate method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
     {
        textField .resignFirstResponder()
        return true;
     }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField

    }
    // when user click 'done' or dismiss the keyboard
    func textFieldDidEndEditing(_ textField: UITextField) {
      self.activeTextField = nil
    }
    
}
