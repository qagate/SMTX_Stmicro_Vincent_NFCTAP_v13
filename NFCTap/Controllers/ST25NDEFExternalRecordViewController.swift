//
//  ST25NDEFExternalRecordViewController.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 27/04/2020.
//  Copyright © 2020 STMicroelectronics. All rights reserved.
//

import UIKit

class ST25NDEFExternalRecordViewController: ST25UIViewController {

    var delegate:NdefRecordReady?
    
    // ST25SDK NDEF Records
    var mComStSt25sdkNdefExternalRecord:ComStSt25sdkNdefExternalRecord!
    
    var mAction: actionOnRecordToDo = .add
    
    @IBOutlet weak var domainTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    
    @IBOutlet weak var dataAscii: UITextView!
    @IBOutlet weak var dataHex: UITextView!
    
    @IBAction func ValidateRecord(_ sender: UIButton) {
        // CheckTextFields replace textfield by placeholder values if empty
        checkTextFields()
        delegate?.onRecordReady(action: mAction, record: updateNDEFRecordMessage())
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func CancelRecord(_ sender: UIButton) {
        delegate?.onRecordReady(action: .cancelled, record: updateNDEFRecordMessage())
         self.dismiss(animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        domainTextField.textColor = .white
        typeTextField.textColor   = .white
        dataAscii.textColor   = .white
        dataAscii.textColor   = .white
        
        dataAscii.delegate = self
        dataHex.delegate = self

         // Used to scroll up view. Keyboard is hidden textview
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);

        if mComStSt25sdkNdefExternalRecord != nil {
            domainTextField.text = mComStSt25sdkNdefExternalRecord.getExternalDomain()
            typeTextField.text = mComStSt25sdkNdefExternalRecord.getExternalType()
            dataAscii.text = String(data: mComStSt25sdkNdefExternalRecord.getContent().toNSData(),encoding: .ascii)
            dataHex.text = self.convertAsciiToHex(dataAscii.text)
        }else{
            domainTextField.text = "text"
            typeTextField.text = "plain"
            dataAscii.text = "Hello world"
            dataHex.text = self.convertAsciiToHex(dataAscii.text)
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
    
    private func updateNDEFRecordMessage() -> ComStSt25sdkNdefExternalRecord {
        
        mComStSt25sdkNdefExternalRecord = ComStSt25sdkNdefExternalRecord()
        mComStSt25sdkNdefExternalRecord.setExternalDomainWith(domainTextField.text)
        mComStSt25sdkNdefExternalRecord.setExternalTypeWith(typeTextField.text)
        let dataTextHexa = dataAscii.text?.data(using: String.Encoding.utf8)
        mComStSt25sdkNdefExternalRecord.setContentWith(IOSByteArray(nsData: dataTextHexa))
            
        return mComStSt25sdkNdefExternalRecord
    }

    private func checkTextFields() {
        if (domainTextField.text == "")  {
            domainTextField.text = domainTextField.placeholder
        }
        
        if (typeTextField.text == "")  {
            typeTextField.text = domainTextField.placeholder
        }
    }

}

extension ST25NDEFExternalRecordViewController : UITextViewDelegate {
    
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
