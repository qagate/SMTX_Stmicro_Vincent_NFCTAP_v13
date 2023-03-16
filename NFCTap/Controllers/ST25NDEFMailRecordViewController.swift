//
//  ST25NDEFMailRecordViewController.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 31/03/2020.
//  Copyright © 2020 STMicroelectronics. All rights reserved.
//

import UIKit

class ST25NDEFMailRecordViewController: ST25UIViewController {

    var delegate:NdefRecordReady?
    
    // ST25SDK NDEF Records
    var mComStSt25sdkNdefMailRecord:ComStSt25sdkNdefEmailRecord!
    var mAction: actionOnRecordToDo = .add
    
    
    @IBOutlet weak var mContactTextView: UITextView!
    @IBOutlet weak var mSubjectTextView: UITextView!
    @IBOutlet weak var mMessageTextView: UITextView!
    
    @IBAction func ValidateRecord(_ sender: Any) {
        if isNDEFRecordReady() {
            delegate?.onRecordReady(action: mAction, record: updateNDEFRecordMessage())
            self.dismiss(animated: false, completion: nil)
        } else {
            warningAlert(message: "At least Contact and Subject fields must not be empty ")
        }

    }
    

    @IBAction func CancelRecord(_ sender: Any) {
        delegate?.onRecordReady(action: .cancelled, record: updateNDEFRecordMessage())
        self.dismiss(animated: false, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if mComStSt25sdkNdefMailRecord != nil {
            
            mContactTextView.text = mComStSt25sdkNdefMailRecord.getContact()
            mSubjectTextView.text = mComStSt25sdkNdefMailRecord.getSubject()
            mMessageTextView.text = mComStSt25sdkNdefMailRecord.getMessage()
            
        }
    }
    
    private func isNDEFRecordReady() -> Bool {
        if (mContactTextView.text != "" && mSubjectTextView.text != "")  {
            return true
        } else {
            return false
        }
    }

    private func updateNDEFRecordMessage() -> ComStSt25sdkNdefEmailRecord {
        
        mComStSt25sdkNdefMailRecord = ComStSt25sdkNdefEmailRecord()
        mComStSt25sdkNdefMailRecord.setContactWith(mContactTextView.text)
        mComStSt25sdkNdefMailRecord.setSubjectWith(mSubjectTextView.text)
        mComStSt25sdkNdefMailRecord.setMessageWith(mMessageTextView.text)
        return mComStSt25sdkNdefMailRecord

    }
    
    private func warningAlert(message : String) {
        UIHelper.warningAlert(viewController: self, title : "Mail record" , message: message)
    }
}
