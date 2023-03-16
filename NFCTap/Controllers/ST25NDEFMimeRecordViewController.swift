//
//  ST25NDEFMimeRecordViewController.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 27/04/2020.
//  Copyright © 2020 STMicroelectronics. All rights reserved.
//

import UIKit

class ST25NDEFMimeRecordViewController: ST25UIViewController {

    var delegate:NdefRecordReady?
    
    // ST25SDK NDEF Records
    var mComStSt25sdkNdefMimeRecord:ComStSt25sdkNdefMimeRecord!
    
    var mAction: actionOnRecordToDo = .add
    

    private var mArrayList:[String]!
    private var mIndexList:Int!
    
    
    @IBOutlet weak var dataTypePickerView: UIPickerView!
    
    @IBOutlet weak var dataAscii: UITextView!
    @IBOutlet weak var dataHex: UITextView!
    
    @IBAction func ValidateRecord(_ sender: UIButton) {
        if isNDEFRecordReady() {
            delegate?.onRecordReady(action: mAction, record: updateNDEFRecordMessage())
            self.dismiss(animated: false, completion: nil)
        } else {
            UIHelper.warningAlert(viewController: self, title : "Mime record" , message: "Data Field must not be empty ")
        }
    }
    
    @IBAction func CancelRecord(_ sender: UIButton) {
        delegate?.onRecordReady(action: .cancelled, record: updateNDEFRecordMessage())
         self.dismiss(animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Used to scroll up view. Keyboard is hidden textview
       NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
        
        mArrayList = NDEFUriRecords().getRecordsListCode(listCode: ComStSt25sdkNdefMimeRecord.getMimeCodesList())
        dataTypePickerView.delegate = self
        dataAscii.delegate = self
        dataHex.delegate = self
        dataAscii.textColor = .white
        
        if mComStSt25sdkNdefMimeRecord != nil {
            let mimeId = mComStSt25sdkNdefMimeRecord.getMimeID()
            mIndexList = Int(ComStSt25sdkNdefMimeRecord.getMimeCodePositionInList(with: mimeId!))
            dataAscii.text = String(data: mComStSt25sdkNdefMimeRecord.getContent().toNSData(),encoding: .ascii)
            dataHex.text = self.convertAsciiToHex(dataAscii.text)
        }else{
            // Set example as default
            let mimeId = ComStSt25sdkNdefMimeRecord.getMimeCodeFromStr(with: "video/mpeg")
            mIndexList = Int(ComStSt25sdkNdefMimeRecord.getMimeCodePositionInList(with: mimeId!))
            dataAscii.text = "video.mov"
            dataHex.text = self.convertAsciiToHex(dataAscii.text)
        }
        dataTypePickerView.selectRow(mIndexList, inComponent:0, animated:true)
        
    }
  
    private func updateNDEFRecordMessage() -> ComStSt25sdkNdefMimeRecord {
        
        mComStSt25sdkNdefMimeRecord = ComStSt25sdkNdefMimeRecord()
        let mimeIdCode = ComStSt25sdkNdefMimeRecord_NdefMimeIdCode_fromOrdinal(UInt(mIndexList)) as ComStSt25sdkNdefMimeRecord_NdefMimeIdCode
        mComStSt25sdkNdefMimeRecord.setMimeIDWith(mimeIdCode)
        
        let dataAsciiTmp = dataAscii.text?.data(using: String.Encoding.utf8)
        mComStSt25sdkNdefMimeRecord.setContentWith(IOSByteArray(nsData: dataAsciiTmp))
            
        return mComStSt25sdkNdefMimeRecord
    }

    private func isNDEFRecordReady() -> Bool {
        if (dataAscii.text != "")  {
            return true
        } else {
            return false
        }
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -150 // Move view 150 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }
    
    private func convertAsciiToHex(_ asciiString:String) -> String {
        var hexString:String = ""
        hexString = asciiString.data(using: String.Encoding.utf8)!.toHexString()
        hexString = hexString.replacingOccurrences(of: " ", with: "")
        return hexString
    }
    
    private func convertHexToAscii(_ hexString:String) -> String {
        var asciiString:String = ""
        let hexData:Data  = ComStSt25sdkHelper_convertHexStringToByteArrayWithNSString_(hexString).toNSData()
        var final = ""
        if (hexData.count != 0){
            for i in 0...hexData.count-1 {
                 final.append(Character(UnicodeScalar(Int(hexData[i]))!))
            }
        }
        asciiString = final
        return asciiString
    }

}

extension ST25NDEFMimeRecordViewController : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView){
        if (textView == dataAscii){
            dataHex.text = self.convertAsciiToHex(textView.text)
        }
        
        if (textView == dataHex){
            if (textView.text.count % 2 == 0){
                dataAscii.text = self.convertHexToAscii(textView.text)
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        if (textView == self.dataHex){
            
            // We ignore any change that doesn't add characters to the text field.
            // These changes are things like character deletions and cuts, as well
            // as moving the insertion point.
            //
            // We still return true to allow the change to take place.
            if text.count == 0 {
                return true
            }

            // Check to see if the text field's contents still fit the constraints
            // with the new content added to it.
            // If the contents still fit the constraints, allow the change
            // by returning true; otherwise disallow the change by returning false.
            let currentText = textView.text ?? ""
            let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: text)

            // Regx For EASID textField : only accept Hex Values
            let range = NSRange(location: 0, length: text.utf8.count)
            let regex = try! NSRegularExpression(pattern: "[A-Fa-f0-9]")
            if (regex.firstMatch(in: text, options: [], range: range) != nil){
                return true
            }else{
                return false
            }
       }else{
            return true
        }
    }
    
}

extension ST25NDEFMimeRecordViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1

    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return mArrayList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.mArrayList[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.mIndexList = row
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "System", size: 14)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = mArrayList[row]
        pickerLabel?.textColor = UIColor.white

        return pickerLabel!
    }

}
