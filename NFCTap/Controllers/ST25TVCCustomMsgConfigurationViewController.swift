//
//  ST25TVCCustomMsgConfigurationViewController.swift
//  NFCTap 
//
//  Created by STMicroelectronics on 03/11/2020.
//  Copyright © 2020 STMicroelectronics. All rights reserved.
//

import UIKit

protocol ST25TVCCustomMsgConfigurationDelegate: class {
    func okButtonTapped(customMessage:String)
    func cancelButtonTapped()
}

class ST25TVCCustomMsgConfigurationViewController: ST25UIViewController {

    @IBOutlet weak var CustomMsgView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var asciiCustomMessage: UITextField!
    @IBOutlet weak var hexadecimalMessageLabel: UILabel!

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
  
    @IBAction func onTapCancelButton(_ sender: Any) {
        delegate?.cancelButtonTapped()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTapOkButton(_ sender: Any) {
        if (!asciiCustomMessage.text!.isEmpty && asciiCustomMessage.text?.count == self.MAX_MESSAGE_LENGTH) {
            self.mTaskToDo = .updateCustomMessage
            if (self.mTag is ST25TVCTag){
                presentPwdController()
            }else{
                self.miOSReaderSession.startTagReaderSession()
            }
        } else {
            // Message must be MAX_MESSAGE_LENGTH characters
            warningAlert(message: "Custom message must be \(MAX_MESSAGE_LENGTH) characters")
        }

    }
    
    internal var  MAX_MESSAGE_LENGTH:Int = 8 //By default.
    internal var mCustomMessage:String!

    internal var delegate: ST25TVCCustomMsgConfigurationDelegate?
    internal var titleView:String = ""
    internal var messageView:String = ""
    
    internal var miOSReaderSession:iOSReaderSession!
    internal var mPwd:Data!
    internal var mUid:Data!

    internal var mTag:ComStSt25sdkNFCTag!
    internal var mST25TVCTag:ST25TVCTag!
    internal var mST25TNTag:ST25TNTag!
 
    enum taskToDo {
        case initCustomMessage
        case updateCustomMessage
    }
    internal var mTaskToDo:taskToDo = .initCustomMessage

    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = titleView
        titleLabel.sizeToFit()
        titleLabel.adjustsFontSizeToFitWidth = true
        messageLabel.text = messageView

        // Do any additional setup after loading the view.
        asciiCustomMessage.delegate = self
        
        if !mCustomMessage.isEmpty {
            asciiCustomMessage.text = mCustomMessage
            // update hexadecimal message field
            hexadecimalMessageLabel.text = asciiCustomMessage.text!.toHexEncodedString()
        }
        
        miOSReaderSession = iOSReaderSession(atagReaderSessionViewControllerDelegate: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if mCustomMessage != "" {
            // already provided by caller
            
        } else {
            //
            self.mTaskToDo = .initCustomMessage
            self.miOSReaderSession.startTagReaderSession()
        }


    }
    
    func  setCustomMessageLength(length:Int){
        // By default, it is 8 ascii
        MAX_MESSAGE_LENGTH = length
    }
    
    func  setTitle(_ aTitle:String){
        titleView = aTitle
    }
    
    func  setMessage(_ aMessage:String){
       messageView = aMessage
    }

    
    private func setupView() {
        CustomMsgView.layer.cornerRadius = 15
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }

    // Alert Error Windows
    private func warningAlert(message : String) {
         DispatchQueue.main.async {
             let alert = UIAlertController(title: "Custom Message Configuration ", message: message, preferredStyle: .alert)
             alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
             self.present(alert, animated: true, completion: nil)
         }
     }

    // Use this if you have a UITextField
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == asciiCustomMessage {
            
            // get the current text, or use an empty string if that failed
            let currentText = textField.text ?? ""

            // attempt to read the range they are trying to change, or exit if we can't
            guard let stringRange = Range(range, in: currentText) else { return false }

            // add their new text to the existing text
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

            // update hexadecimal message field
            hexadecimalMessageLabel.text = updatedText.toHexEncodedString()
            // make sure the result is under MAX_MESSAGE_LENGTH characters
            return updatedText.count <= MAX_MESSAGE_LENGTH
        } else {
            return true
        }
        
    }

    private func presentPwdController() {
        let mST25PasswordVC:ST25PasswordViewController = UIStoryboard(name: "ST25Password", bundle: nil).instantiateViewController(withIdentifier: "ST25PasswordID") as! ST25PasswordViewController
        mST25PasswordVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        mST25PasswordVC.setTitle("Enter configuration password")
        mST25PasswordVC.setMessage("(32 bits hexadecimal format)")
        mST25PasswordVC.numberOfBytes = 4
        mST25PasswordVC.delegate = self
        self.present(mST25PasswordVC, animated: false, completion: nil)
    }
    
    private func setPwd() {
        mST25TVCTag.presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25tvcST25TVCTag_ST25TVC_CONFIGURATION_PASSWORD_ID), password: mPwd)
    }
    
    private func initCustomMessage(){
        readConf()
        writeUI()
    }
    private func readConf(){
        if (self.mTag is ST25TVCTag){
            self.mCustomMessage = mST25TVCTag.getAndefCustomMsg()
        }else if (self.mTag is ST25TNTag){
            self.mCustomMessage = mST25TNTag.getAndefCustomMsg()
        }
    }
    private func writeUI(){
        UIHelper.UI { [self] in
            asciiCustomMessage.text = mCustomMessage
            // update hexadecimal message field
            if !asciiCustomMessage.text!.isEmpty {
                hexadecimalMessageLabel.text = asciiCustomMessage.text!.toHexEncodedString()
            }
            
        }
    }
    
    private func updateCustomMessage(){
        readUI()
        if (self.mTag is ST25TVCTag){
            setPwd()
        }
        writeConf()
        // finalyse UI
        UIHelper.UI { [self] in
            delegate?.okButtonTapped(customMessage: asciiCustomMessage.text!)
            self.dismiss(animated: true, completion: nil)
        }

    }
    private func readUI(){
         UIHelper.UI {
            self.mCustomMessage   = self.asciiCustomMessage.text!
         }
     }
    private func writeConf(){
        if (self.mTag is ST25TVCTag){
            mST25TVCTag.setAndefCustomMsgWith(self.mCustomMessage)
        }else if (self.mTag is ST25TNTag){
            mST25TNTag.setAndefCustomMsgWith(self.mCustomMessage)
        }
    }
}

extension ST25TVCCustomMsgConfigurationViewController: ST25PasswordViewDelegate {
    func okButtonTapped(pwdValue: Data) {
        
        self.mPwd = pwdValue
        self.miOSReaderSession.startTagReaderSession()
    }

    func cancelButtonTapped() {
    }
}

extension ST25TVCCustomMsgConfigurationViewController: tagReaderSessionViewControllerDelegate {
   
    func handleTag(st25SDKTag: ComStSt25sdkNFCTag, uid: Data!) throws {
        var tagHandled = true;
        self.mTag = st25SDKTag
        if (self.mTag is ST25TVCTag){
            self.mST25TVCTag = self.mTag as? ST25TVCTag
        }else if (self.mTag is ST25TNTag){
            self.mST25TNTag = self.mTag as? ST25TNTag
        }else{
            tagHandled = false
            UIHelper.UI() {
                self.warningAlert(message: "This is not a valid ST25 Tag")
            }
        }
        
        if (tagHandled){
            self.mUid = uid
            if self.isSameTag(uid: uid) {
                switch mTaskToDo {
                case .initCustomMessage:
                    initCustomMessage()
                case .updateCustomMessage:
                    updateCustomMessage()
                 }
            } else {

                UIHelper.UI() {
                    self.warningAlert(message: "Tag has changed, please scan again the Tag ...")
                }
            }
        }
    }
    
    func handleTagSessionError(didInvalidateWithError error: Error) {
    }
    
    func handleTagST25SdkError(didInvalidateWithError error: NSException) {
        self.warningAlert(message: error.description)
    }

}


extension String {
    func toHexEncodedString(uppercase: Bool = true, prefix: String = "", separator: String = "") -> String {
        return unicodeScalars.map { prefix + .init($0.value, radix: 16, uppercase: uppercase) } .joined(separator: separator)
    }
}
