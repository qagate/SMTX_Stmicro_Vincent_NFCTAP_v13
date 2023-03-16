//
//  ST25NDEFUrlRecordViewController.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 14/01/2020.
//  Copyright © 2020 STMicroelectronics. All rights reserved.
//

import UIKit

protocol NdefRecordReady
{
    func onRecordReady(action: actionOnRecordToDo, record : ComStSt25sdkNdefNDEFRecord)
}

class ST25NDEFUrlRecordViewController: ST25UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{

    var delegate:NdefRecordReady?
    
    // ST25SDK NDEF Records
    var mComStSt25sdkNdefUriRecord:ComStSt25sdkNdefUriRecord!
    var mAction: actionOnRecordToDo = .add
    
    //
    public var mListScheme = [
    " ",
    "http://www.",
    "https://www.",
    "http://",
    "https://",
    "tel:",
    "mailto:",
    "ftp://anonymous:anonymous@",
    "ftp://ftp.",
    "ftps://",
    "sftp://",
    "smb://",
    "nfs://",
    "ftp://",
    "dav://",
    "news:",
    "telnet://",
    "imap:",
    "rtsp://",
    "urn:",
    "pop:",
    "sip:",
    "sips:",
    "tftp:",
    "btspp://",
    "btl2cap://",
    "btgoep://",
    "tcpobex://",
    "irdaobex://",
    "file://",
    "urn:epc:id:",
    "urn:epc:tag:",
    "urn:epc:pat:",
    "urn:epc:raw:",
    "urn:epc:",
    "urn:nfc:"
    ]
    public var mIndexListScheme:Int!
    
    @IBOutlet weak var schemeButton: UIButton!
    //@IBOutlet weak var mDropDown: UIPickerView!
    @IBOutlet weak var mUrlTextField: UITextField!
    @IBOutlet weak var mDropDown: UIPickerView!
    
    @IBAction func openPickerView(_ sender: Any) {
        mDropDown.isHidden = !mDropDown.isHidden
    }

    
    @IBAction func ValidateRecord(_ sender: Any) {
        delegate?.onRecordReady(action: mAction, record: updateNDEFRecordMessage())
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func CancelRecord(_ sender: Any) {
        delegate?.onRecordReady(action: .cancelled, record: updateNDEFRecordMessage())
        self.dismiss(animated: false, completion: nil)

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mIndexListScheme = 1
        mDropDown.delegate = self
        mDropDown.isHidden = true
        
        updateNDEFRecordUI()
        
    }
    
    public func updateNDEFRecordUI() {
        if mComStSt25sdkNdefUriRecord != nil {
            let ndefCode = mComStSt25sdkNdefUriRecord.getUriID()
            mIndexListScheme = Int(ComStSt25sdkNdefUriRecord.getUriCodePositionInList(with: ndefCode!))
            //mDropDown.selectedRow(inComponent: Int(ComStSt25sdkNdefUriRecord.getUriCodePositionInList(with: ndefCode!)))
            
            schemeButton.setTitle(mListScheme[mIndexListScheme], for: .normal)
            
            mUrlTextField.text = mComStSt25sdkNdefUriRecord.getContent()

        }
        mDropDown.selectRow(mIndexListScheme, inComponent:0, animated:true)
        schemeButton.setTitle(mListScheme[mIndexListScheme], for: .normal)
    }
    
    public func updateNDEFRecordMessage() -> ComStSt25sdkNdefUriRecord {
        
        // Create ST25SDK NDEF URI
        mComStSt25sdkNdefUriRecord = ComStSt25sdkNdefUriRecord()
        let uriIdCode = ComStSt25sdkNdefUriRecord_NdefUriIdCode_fromOrdinal(UInt(mIndexListScheme)) as ComStSt25sdkNdefUriRecord_NdefUriIdCode
        mComStSt25sdkNdefUriRecord.setUriIDWith(uriIdCode)
        
        mComStSt25sdkNdefUriRecord.setContentWith(mUrlTextField.text)
        return mComStSt25sdkNdefUriRecord
    }
    

    
    /* Picker Delegate */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return mListScheme.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.mListScheme[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //self.mUrlTextField.text = self.list[row]
        //self.mDropDown.isHidden = true
        schemeButton.setTitle(self.mListScheme[row], for: .normal)
        self.mIndexListScheme = row
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "System", size: 17)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = mListScheme[row]
        pickerLabel?.textColor = UIColor.white

        return pickerLabel!
    }

}
