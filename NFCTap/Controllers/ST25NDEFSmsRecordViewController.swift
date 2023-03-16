//
//  ST25NDEFSmsRecordViewController.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 02/04/2020.
//  Copyright © 2020 STMicroelectronics. All rights reserved.
//

import UIKit

class ST25NDEFSmsRecordViewController: ST25UIViewController {

    var delegate:NdefRecordReady?
    
    // ST25SDK NDEF Records
    var mComStSt25sdkNdefSmsRecord:ComStSt25sdkNdefSmsRecord!
    var mAction: actionOnRecordToDo = .add
    
    @IBOutlet weak var mTelTextView: UITextView!
    @IBOutlet weak var mMessageTextView: UITextView!
    
    @IBAction func ValidateRecord(_ sender: UIButton) {
        if isNDEFRecordReady() {
            delegate?.onRecordReady(action: mAction, record: updateNDEFRecordMessage())
            self.dismiss(animated: false, completion: nil)
        } else {
            warningAlert(message: "At least Tel field must not be empty ")
        }
        
    }
    
    @IBAction func CancelRecord(_ sender: UIButton) {
        delegate?.onRecordReady(action: .cancelled, record: updateNDEFRecordMessage())
         self.dismiss(animated: false, completion: nil)
         
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mTelTextView.keyboardType = .phonePad
        mMessageTextView.keyboardType = .asciiCapable
        // Do any additional setup after loading the view.
        if mComStSt25sdkNdefSmsRecord != nil {
            
            mTelTextView.text = mComStSt25sdkNdefSmsRecord.getContact()

            mMessageTextView.text = mComStSt25sdkNdefSmsRecord.getMessage()
            
        }
    }
    
    
    private func updateNDEFRecordMessage() -> ComStSt25sdkNdefSmsRecord {
        
        mComStSt25sdkNdefSmsRecord = ComStSt25sdkNdefSmsRecord()
        mComStSt25sdkNdefSmsRecord.setContactWith(mTelTextView.text)
        mComStSt25sdkNdefSmsRecord.setMessageWith(mMessageTextView.text)
        
        return mComStSt25sdkNdefSmsRecord
    }
    
    private func isNDEFRecordReady() -> Bool {
        if (mTelTextView.text != "")  {
            return true
        } else {
            return false
        }
    }

    private func warningAlert(message : String) {
        UIHelper.warningAlert(viewController: self, title : "Sms record" , message: message)
    }

}
