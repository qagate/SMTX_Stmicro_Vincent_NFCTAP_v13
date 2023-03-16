//
//  ST25NDEFCallRecordViewController.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 20/04/2020.
//  Copyright © 2020 STMicroelectronics. All rights reserved.
//

import UIKit

class ST25NDEFCallRecordViewController: ST25UIViewController {

    var delegate:NdefRecordReady?
    
    // ST25SDK NDEF Records
    var mComStSt25sdkNdefUriRecord:ComStSt25sdkNdefUriRecord!
    
    var mAction: actionOnRecordToDo = .add
    
    @IBOutlet weak var mTelTextField: UITextField!
    
    @IBAction func ValidateRecord(_ sender: UIButton) {
        if isNDEFRecordReady() {
            delegate?.onRecordReady(action: mAction, record: updateNDEFRecordMessage())
            self.dismiss(animated: false, completion: nil)
        } else {
            warningAlert(message: "Telephone number must not be empty ")
        }
        
    }
    
    @IBAction func CancelRecord(_ sender: UIButton) {
        delegate?.onRecordReady(action: .cancelled, record: updateNDEFRecordMessage())
         self.dismiss(animated: false, completion: nil)
         
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mTelTextField.keyboardType = .phonePad
        // Do any additional setup after loading the view.
        if mComStSt25sdkNdefUriRecord != nil {
            mTelTextField.text = mComStSt25sdkNdefUriRecord.getContent()
        }
    }
    
    
    private func updateNDEFRecordMessage() -> ComStSt25sdkNdefUriRecord {
        
        mComStSt25sdkNdefUriRecord = ComStSt25sdkNdefUriRecord()
        let uriCode = ComStSt25sdkNdefUriRecord_NdefUriIdCode_valueOfWithNSString_("NDEF_RTD_URI_ID_TEL")
        mComStSt25sdkNdefUriRecord.setUriIDWith(uriCode)
        mComStSt25sdkNdefUriRecord.setContentWith(mTelTextField.text)

        return mComStSt25sdkNdefUriRecord
    }
    
    private func isNDEFRecordReady() -> Bool {
        if (mTelTextField.text != "")  {
            return true
        } else {
            return false
        }
    }

    private func warningAlert(message : String) {
        UIHelper.warningAlert(viewController: self, title : "Sms record" , message: message)
    }

}
