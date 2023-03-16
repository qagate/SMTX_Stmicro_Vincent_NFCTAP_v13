//
//  ST25PasswordViewController.swift
//  ST25NFCApp
//
//  Created by STMicroelectronics on 10/25/19.
//  Copyright © 2019 STMicroelectronics. All rights reserved.
//

import UIKit


protocol ST25PasswordViewDelegate: class {
    func okButtonTapped(pwdValue: Data)
    func cancelButtonTapped()
}

extension ST25PasswordViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
          guard CharacterSet(charactersIn: "0123456789AaBbCcDdEeFf").isSuperset(of: CharacterSet(charactersIn: string)) else {
              return false
          }
        return range.location < 2
    }
}

class ST25PasswordViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
   
    @IBOutlet var Byte0TextField: UITextField!
    @IBOutlet var Byte1TextField: UITextField!
    @IBOutlet var Byte2TextField: UITextField!
    @IBOutlet var Byte3TextField: UITextField!
    
    @IBOutlet weak var byte4TextField: UITextField!
    @IBOutlet weak var byte5TextField: UITextField!
    @IBOutlet weak var byte6TextField: UITextField!
    @IBOutlet weak var byte7TextField: UITextField!
    
    
    @IBOutlet weak var byte8TextField: UITextField!
    @IBOutlet weak var byte9TextField: UITextField!
    @IBOutlet weak var byte10TextField: UITextField!
    @IBOutlet weak var byte11TextField: UITextField!
    
    @IBOutlet weak var byte12TextField: UITextField!
    @IBOutlet weak var byte13TextField: UITextField!
    @IBOutlet weak var byte14TextField: UITextField!
    @IBOutlet weak var byte15TextField: UITextField!
    
    @IBOutlet weak var byte12To15StackView: UIStackView!
    @IBOutlet weak var byte9To11StackView: UIStackView!
    @IBOutlet weak var byte4To8StackView: UIStackView!
    @IBOutlet weak var byte0To3StackView: UIStackView!
    
    
    @IBOutlet var passwordView: UIView!
   
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
  
    @IBAction func onTapCancelButton(_ sender: Any) {
        Byte0TextField.resignFirstResponder()
        delegate?.cancelButtonTapped()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTapOkButton(_ sender: Any) {
        Byte0TextField.resignFirstResponder()
        
        if checkPasswordValidity() == true {
            var pwdString:String!
            if numberOfBytes == 16 {
                pwdString = Byte3TextField.text!+Byte2TextField.text!+Byte1TextField.text!+Byte0TextField.text!
                pwdString = pwdString + byte7TextField.text!+byte6TextField.text!+byte5TextField.text!+byte4TextField.text!
                pwdString = pwdString + byte11TextField.text!+byte10TextField.text!+byte9TextField.text!+byte8TextField.text!
                pwdString = pwdString + byte15TextField.text!+byte14TextField.text!+byte13TextField.text!+byte12TextField.text!

            }
            else if numberOfBytes == 12 {
                pwdString = Byte3TextField.text!+Byte2TextField.text!+Byte1TextField.text!+Byte0TextField.text!
                pwdString = pwdString +  byte7TextField.text!+byte6TextField.text!+byte5TextField.text!+byte4TextField.text!
                pwdString = pwdString + byte11TextField.text!+byte10TextField.text!+byte9TextField.text!+byte8TextField.text!
             }
            else if numberOfBytes == 8 {
                pwdString = Byte3TextField.text!+Byte2TextField.text!+Byte1TextField.text!+Byte0TextField.text!
                pwdString = pwdString +  byte7TextField.text!+byte6TextField.text!+byte5TextField.text!+byte4TextField.text!
            } else {
                pwdString = Byte3TextField.text!+Byte2TextField.text!+Byte1TextField.text!+Byte0TextField.text!
            }
            let pwdData:Data = (ComStSt25sdkHelper.convertHexStringToByteArray(with: pwdString)?.toNSData())!
            
            delegate?.okButtonTapped(pwdValue: pwdData)
            self.dismiss(animated: true, completion: nil)
        }else{
            self.alertWindow(message : "Password NOT Valid")
        }
    }
    
    
    internal var delegate: ST25PasswordViewDelegate?
    internal var titleView:String = ""
    internal var messageView:String  = ""
    internal var numberOfBytes:Int = 4

    
    override func viewDidLoad() {
        super.viewDidLoad()
        Byte0TextField.becomeFirstResponder()
        configureBytesTextFieldUpto4Bytes()
        if numberOfBytes == 16 {
            configureBytesTextFieldFrom4BytesTo7Bytes()
            configureBytesTextFieldFrom8BytesTo11Bytes()
            configureBytesTextFieldFrom12BytesTo15Bytes()
            hideBytesTextFieldFrom16()
 
        }
        else if numberOfBytes == 12 {
            configureBytesTextFieldFrom4BytesTo7Bytes()
            configureBytesTextFieldFrom8BytesTo11Bytes()
            hideBytesTextFieldFrom12()
 
        }
        else if numberOfBytes == 8 {
            configureBytesTextFieldFrom4BytesTo7Bytes()
            hideBytesTextFieldFrom8()
 
        } else {
            // default 4
            numberOfBytes = 4
            // hide the 4 bytes and more
            hideBytesTextFieldFrom4()
        }
        
        titleLabel.text = titleView
        titleLabel.sizeToFit()
        titleLabel.adjustsFontSizeToFitWidth = true
        messageLabel.text = messageView
    }
  

    private func configureBytesTextFieldUpto4Bytes() {
        Byte0TextField.isSecureTextEntry = true
        Byte0TextField.delegate = self
        
        Byte1TextField.delegate = self
        Byte1TextField.isSecureTextEntry = true
        
        Byte2TextField.delegate = self
        Byte2TextField.isSecureTextEntry = true
        
        Byte3TextField.delegate = self
        Byte3TextField.isSecureTextEntry = true
    }
    private func configureBytesTextFieldFrom4BytesTo7Bytes() {
        byte4TextField.isSecureTextEntry = true
        byte4TextField.delegate = self
        
        byte5TextField.delegate = self
        byte5TextField.isSecureTextEntry = true
        
        byte6TextField.delegate = self
        byte6TextField.isSecureTextEntry = true
        
        byte7TextField.delegate = self
        byte7TextField.isSecureTextEntry = true
    }
    
    private func configureBytesTextFieldFrom8BytesTo11Bytes() {
        byte8TextField.isSecureTextEntry = true
        byte8TextField.delegate = self
        
        byte9TextField.delegate = self
        byte9TextField.isSecureTextEntry = true
        
        byte10TextField.delegate = self
        byte10TextField.isSecureTextEntry = true
        
        byte11TextField.delegate = self
        byte11TextField.isSecureTextEntry = true
    }

    private func configureBytesTextFieldFrom12BytesTo15Bytes() {
        byte12TextField.isSecureTextEntry = true
        byte12TextField.delegate = self
        
        byte13TextField.delegate = self
        byte13TextField.isSecureTextEntry = true
        
        byte14TextField.delegate = self
        byte14TextField.isSecureTextEntry = true
        
        byte15TextField.delegate = self
        byte15TextField.isSecureTextEntry = true
    }

    
    private func hideBytesTextFieldFrom4() {
        byte4To8StackView.isHidden = true
        byte9To11StackView.isHidden = true
        byte12To15StackView.isHidden = true
    }

    private func hideBytesTextFieldFrom8() {
        byte4To8StackView.isHidden = false
        byte9To11StackView.isHidden = true
        byte12To15StackView.isHidden = true
    }

    private func hideBytesTextFieldFrom12() {
        byte4To8StackView.isHidden = false
        byte9To11StackView.isHidden = false
        byte12To15StackView.isHidden = true
    }
    
    private func hideBytesTextFieldFrom16() {
        byte4To8StackView.isHidden = false
        byte9To11StackView.isHidden = false
        byte12To15StackView.isHidden = false
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        animateView()
    }
    
    func  setTitle(_ aTitle:String){
        titleView = aTitle
    }
    
    func  setMessage(_ aMessage:String){
       messageView = aMessage
    }

    func  setNumberOfBytes(_ aNumerOfBytes:Int){
        numberOfBytes = aNumerOfBytes
    }
    
    private func setupView() {
        passwordView.layer.cornerRadius = 15
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    private func animateView() {
        passwordView.alpha = 0;
        self.passwordView.frame.origin.y = self.passwordView.frame.origin.y + 100
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.passwordView.alpha = 1.0;
            self.passwordView.frame.origin.y = self.passwordView.frame.origin.y - 100
        })
    }
    
    private func checkPasswordValidity() -> Bool {
        if numberOfBytes == 16 {
            return (check4FirstBytes() && checkBytes4To7() && checkBytes8To11() && checkBytes12To15())
        }
        else if numberOfBytes == 12 {
            return (check4FirstBytes() && checkBytes4To7() && checkBytes8To11())
        }
        else if numberOfBytes == 8 {
            return (check4FirstBytes() && checkBytes4To7())
        } else {
            //  the 4 bytes
            return check4FirstBytes()
        }

    }
    
    private func check4FirstBytes() -> Bool {
        // Check that every field are not empty
        if (Byte0TextField.text!.isEmpty || Byte1TextField.text!.isEmpty || Byte2TextField.text!.isEmpty || Byte3TextField.text!.isEmpty) {
            return false
        }
        
        // Check that every field have good size
        if ((Byte0TextField.text!.count != 2) || (Byte1TextField.text!.count != 2 )  || (Byte2TextField.text!.count != 2) || (Byte3TextField.text!.count != 2)) {
            return false
        }
        
        return true
    }
    private func checkBytes4To7() -> Bool {
        // Check that every field are not empty
        if (byte4TextField.text!.isEmpty || byte5TextField.text!.isEmpty || byte6TextField.text!.isEmpty || byte7TextField.text!.isEmpty) {
            return false
        }
        
        // Check that every field have good size
        if ((byte4TextField.text!.count != 2) || (byte5TextField.text!.count != 2 )  || (byte6TextField.text!.count != 2) || (byte7TextField.text!.count != 2)) {
            return false
        }
        
        return true
    }
    
    private func checkBytes8To11() -> Bool {
        // Check that every field are not empty
        if (byte8TextField.text!.isEmpty || byte9TextField.text!.isEmpty || byte10TextField.text!.isEmpty || byte11TextField.text!.isEmpty) {
            return false
        }
        // Check that every field have good size
        if ((byte8TextField.text!.count != 2) || (byte9TextField.text!.count != 2 )  || (byte10TextField.text!.count != 2) || (byte11TextField.text!.count != 2)) {
            return false
        }

        return true
    }
    
    private func checkBytes12To15() -> Bool {
        // Check that every field are not empty
        if (byte12TextField.text!.isEmpty || byte13TextField.text!.isEmpty || byte14TextField.text!.isEmpty || byte15TextField.text!.isEmpty) {
            return false
        }
        // Check that every field have good size
        if ((byte12TextField.text!.count != 2) || (byte13TextField.text!.count != 2 )  || (byte14TextField.text!.count != 2) || (byte15TextField.text!.count != 2)) {
            return false
        }

        return true
    }
    // Alert Error Windows
    private func alertWindow(message : String){
        let alert = UIAlertController(title: "ST25 Password",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .destructive, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }

}
