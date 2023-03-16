//
//  ST25NDEFTextViewController.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 16/01/2020.
//  Copyright © 2020 STMicroelectronics. All rights reserved.
//

import UIKit

class ST25NDEFTextRecordViewController: ST25UIViewController  {
    
    var delegate:NdefRecordReady?
    
    // ST25SDK NDEF Records
    var mComStSt25sdkNdefTextRecord:ComStSt25sdkNdefTextRecord!
    var mAction: actionOnRecordToDo = .add
    
    @IBOutlet weak var mTextPayloadTextView: UITextView!
    
    @IBAction func ValidateRecord(_ sender: UIButton) {
        delegate?.onRecordReady(action: mAction, record: updateNDEFRecordMessage())
        self.dismiss(animated: false, completion: nil)
        
    }
    
    @IBAction func CancelRecord(_ sender: UIButton) {
        delegate?.onRecordReady(action: .cancelled, record: updateNDEFRecordMessage())
        self.dismiss(animated: false, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if mComStSt25sdkNdefTextRecord != nil {
            
            mTextPayloadTextView.text = mComStSt25sdkNdefTextRecord.getText()
            
        }
    }
    
    
    private func updateNDEFRecordMessage() -> ComStSt25sdkNdefTextRecord {
        
        // Create ST25SDK NDEF Text
        mComStSt25sdkNdefTextRecord = ComStSt25sdkNdefTextRecord()
        mComStSt25sdkNdefTextRecord.setTextWith(mTextPayloadTextView.text)
        
        return mComStSt25sdkNdefTextRecord
    }
    
    
}
