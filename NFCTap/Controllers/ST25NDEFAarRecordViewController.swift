//
//  ST25NDEFAarRecordViewController.swift
//  NFCTap 
//
//  Created by STMicroelectronics on 04/08/2021.
//  Copyright © 2021 STMicroelectronics. All rights reserved.
//

class ST25NDEFAarRecordViewController: ST25UIViewController {

    var delegate:NdefRecordReady?
    
    // ST25SDK NDEF Records
    var mComStSt25sdkNdefAarRecord:ComStSt25sdkNdefAarRecord!
    
    var mAction: actionOnRecordToDo = .add
    
    @IBOutlet weak var mAarTextField: UITextField!
    
    @IBAction func ValidateRecord(_ sender: Any) {
        if isNDEFRecordReady() {
            delegate?.onRecordReady(action: mAction, record: updateNDEFRecordMessage())
            self.dismiss(animated: false, completion: nil)
        } else {
            warningAlert(message: "AAR must not be empty ")
        }
        
    }
    
    @IBAction func CancelRecord(_ sender: Any) {
        delegate?.onRecordReady(action: .cancelled, record: updateNDEFRecordMessage())
         self.dismiss(animated: false, completion: nil)
         
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if mComStSt25sdkNdefAarRecord != nil {
            mAarTextField.text = mComStSt25sdkNdefAarRecord.getAar()
        }
    }
    
    
    private func updateNDEFRecordMessage() -> ComStSt25sdkNdefAarRecord {
        
        mComStSt25sdkNdefAarRecord = ComStSt25sdkNdefAarRecord()
        mComStSt25sdkNdefAarRecord.setAarWith(mAarTextField.text)

        return mComStSt25sdkNdefAarRecord
    }
    
    private func isNDEFRecordReady() -> Bool {
        if (mAarTextField.text != "")  {
            return true
        } else {
            return false
        }
    }

    private func warningAlert(message : String) {
        UIHelper.warningAlert(viewController: self, title : "AAR record" , message: message)
    }

}
