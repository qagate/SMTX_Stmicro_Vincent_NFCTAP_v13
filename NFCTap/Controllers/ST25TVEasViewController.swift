//
//  ST25TVEasViewController.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 3/5/20.
//  Copyright © 2020 STMicroelectronics. All rights reserved.
//

import UIKit
import CoreNFC

class ST25TVEasViewController: ST25UIViewController {
    
    // Variable used to move frame when displaying Keybaord
    internal var mFrameOriginY:CGFloat?
    
    // Variables used to store UI infos
    internal var mEasId:String!
    internal var mEasTelegram:String!
    
    // For NFC & Tags
    internal var mST25TVTag:ST25TVTag!
    internal var miOSReaderSession:iOSReaderSession!
    
    // NFC tasks
    enum taskToDo {
        case readEasConf
        case writeEasConf
    }
    
    internal var mTaskToDo:taskToDo = .readEasConf

    // Present PWD info
    internal var mPresentPwd:Bool!
    internal var mPassword:Data!
    
    // EAS Switch mirror : use internal var to mirror enableEasSwitch.
    internal var mIsEasEnabled:Bool = false {
        didSet{
            UIHelper.UI {
                // Disable/Enable UI objects according to mIsEasEnabled state
                self.enableEasSwitch.setOn(self.mIsEasEnabled, animated: true)
                self.EasIdTextField.isEnabled = self.mIsEasEnabled
                self.EasTelegramTextField.isEnabled = self.mIsEasEnabled
                self.easProtectionPickerVieww.isUserInteractionEnabled = self.mIsEasEnabled
                
                var alphaValue:CGFloat = 1
                if (self.mIsEasEnabled == false){
                    alphaValue = 0.5
                }
                self.EasIdTextField.alpha = alphaValue
                self.EasTelegramTextField.alpha = alphaValue
                self.easProtectionPickerVieww.alpha = alphaValue
            }
        }
    }
    
    // Picker UI infos
    private var mList = [
    "EAS not protected",
    "EAS Protected by pwd",
    "EAS permanently locked"
    ]
    private var mIndexList:Int!

    // UI objects and actions
    @IBOutlet weak var easScrollView: UIScrollView!
    @IBOutlet weak var enableEasSwitch: UISwitch!
    @IBOutlet weak var easProtectionPickerVieww: UIPickerView!
    @IBOutlet weak var updateTagButton: UIButton!
  
    @IBOutlet weak var EasIdTextField: UITextField!
    @IBOutlet weak var EasTelegramTextField: UITextField!

    @IBAction func enableEasAction(_ sender: Any) {
        mIsEasEnabled = enableEasSwitch.isOn
    }
    
    @IBAction func updateTagAction(_ sender: Any) {
        if(self.EasIdTextField.text?.count != 4){
            UIHelper.warningAlert(viewController: self, title: "ST25TV EAS", message: "bad EAS ID value. EAS ID must be 2 bytes size")
            return
        }
        
        mEasId = self.EasIdTextField.text
        mEasTelegram = self.EasTelegramTextField.text
        
        // Check if lock required
        if (mIndexList == 2){
            let confirmationDialog = UIAlertController(title: "Lock EAS is IRREVERSIBLE!", message: "Do you really want to lock the block?", preferredStyle: UIAlertController.Style.alert)

            confirmationDialog.addAction(UIAlertAction(title: "Lock EAS", style: .default, handler: { (action: UIAlertAction!) in
                self.mTaskToDo = .writeEasConf
                self.miOSReaderSession.startTagReaderSession()

           }))

            confirmationDialog.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                  //print("Action cancelled: Lock kill password")
            }))
            present(confirmationDialog, animated: true, completion: nil)
        }else{
            mTaskToDo = .writeEasConf
            self.presentPwdController(title: "ST25TV EAS Password")
        }
    }
    
    //
    override func viewDidLoad() {
        super.viewDidLoad()

        // Init Frame origin Y
        mFrameOriginY = self.easScrollView.frame.origin.y
        
        // Init picker view
        mIndexList = 0
        easProtectionPickerVieww.delegate = self
        easProtectionPickerVieww.selectRow(mIndexList, inComponent:0, animated:true)
        
        // Init delegate textFields
        EasIdTextField.delegate = self
        EasTelegramTextField.delegate = self
        
        // Init Keyboard observers to control scroll view when keyboard is shown or dismissed
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Start NFC session to read conf in first
        mTaskToDo = .readEasConf
        miOSReaderSession = iOSReaderSession(atagReaderSessionViewControllerDelegate: self)
        miOSReaderSession.startTagReaderSession()
        
        // Value by default
        mPresentPwd = false
        mIsEasEnabled = enableEasSwitch.isOn
    }
    
    // Move scrollview with keyboard
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
            self.easScrollView.contentInset = contentInsets
            self.easScrollView.scrollIndicatorInsets = contentInsets
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        self.easScrollView.contentInset = contentInsets
        self.easScrollView.scrollIndicatorInsets = contentInsets
    }

    
    

    private func presentPwdController(title : String) {
       let mST25PasswordVC:ST25PasswordViewController = UIStoryboard(name: "ST25Password", bundle: nil).instantiateViewController(withIdentifier: "ST25PasswordID") as! ST25PasswordViewController
       mST25PasswordVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
       mST25PasswordVC.setTitle(title)

       mST25PasswordVC.setMessage("(32 bits hexadecimal format)")
       mST25PasswordVC.numberOfBytes = 4
       
       mST25PasswordVC.delegate = self
       self.present(mST25PasswordVC, animated: false, completion: nil)
   }
    
    private func readEasConfiguration(){
        var easTelegram:String?
        var easId:String?
        var easConfig:Data?

        if (mPresentPwd == true){
            mST25TVTag.presentPassword(passwordNumber:UInt8( ComStSt25sdkType5St25tvST25TVTag_ST25TV_CONFIGURATION_PASSWORD_ID), password: mPassword)
        }
        // If we arrive at this step, this means that pwd is correct(No try/catch execption rised)
        mPresentPwd = false
        mIsEasEnabled = mST25TVTag.isEasEnabled()
        if (mIsEasEnabled){
            easTelegram = mST25TVTag.readEasTelegram()
            easId = ComStSt25sdkHelper.convertIntToHexFormatString(with: mST25TVTag.readEasId())
            
            // Check Protection
            easConfig = mST25TVTag.readConfig(with: ComStSt25sdkType5St25tvST25TVTag_ST25TV_REGISTER_EAS_SECURITY_ACTIVATION)?.toNSData()
            // by default no protection
            self.mIndexList = 0
            if (easConfig != nil){
                let easRegisterValue:UInt8 = (easConfig?[1])!
                if ((easRegisterValue & 0x01) == 0x01){
                    self.mIndexList = 1
                }else{
                    self.mIndexList = 0
                }
            }
        }
        
        // Update UI
        UIHelper.UI {
            if (self.mIsEasEnabled){
                self.EasIdTextField.text = easId
                self.EasTelegramTextField.text = easTelegram
                self.easProtectionPickerVieww.selectRow(self.mIndexList, inComponent:0, animated:true)
            }
        }
    }
    
    private func writeEasConfiguration(){
        mST25TVTag.presentPassword(passwordNumber:UInt8( ComStSt25sdkType5St25tvST25TVTag_ST25TV_CONFIGURATION_PASSWORD_ID), password: mPassword)
        mST25TVTag.writeEasId(with: ComStSt25sdkHelper.convertHexStringToInt(with: self.mEasId))
        mST25TVTag.writeEasTelegram(with: self.mEasTelegram)
        
        // check if pwd protected
        if (mIndexList == 1){
            mST25TVTag.writeEasSecurityConfiguration(withBoolean: true)
        }else{
            mST25TVTag.writeEasSecurityConfiguration(withBoolean: false)
        }
      
        // check if locked
        if (mIndexList == 2){
           mST25TVTag.lockEas()
        }
        
        if (mIsEasEnabled){
            mST25TVTag.setEas()
        }else{
            mST25TVTag.resetEas()
        }
    }
}

extension ST25TVEasViewController: tagReaderSessionViewControllerDelegate {
    func handleTag(st25SDKTag: ComStSt25sdkNFCTag, uid: Data!) throws {
        mST25TVTag = st25SDKTag as? ST25TVTag
        if self.isSameTag(uid: uid) {
            switch mTaskToDo {
            case .readEasConf:
                readEasConfiguration()
            case .writeEasConf:
                writeEasConfiguration()
            }
        } else {
            UIHelper.UI() {
                UIHelper.warningAlert(viewController: self, title: "EAS", message: "Tag has changed, please scan again the Tag ...")
            }
        }
    }
    
    
    func handleTagSessionError(didInvalidateWithError error: Error) {
        let errorNFC = error as! NFCReaderError
        miOSReaderSession.stopTagReaderSession(errorNFC.localizedDescription)
    }
    
    func handleTagST25SdkError(didInvalidateWithError error: NSException) {
        let errorST25SDK = error as! ComStSt25sdkSTException
        if (
            (errorST25SDK.getMessage()?.contains(ComStSt25sdkSTException_STExceptionCode.ISO15693_BLOCK_IS_LOCKED.description()))! || (errorST25SDK.getMessage()?.contains(ComStSt25sdkSTException_STExceptionCode.CONFIG_PASSWORD_NEEDED.description()))!
            )
            {
            miOSReaderSession.stopTagReaderSession("ST25TV Configuration Password recquired")
            mPresentPwd = true
             UIHelper.UI() {
                self.presentPwdController(title: "ST25TV EAS Password")
            }
        }
        else{
            mPresentPwd = false
            miOSReaderSession.stopTagReaderSession("Command failed: \(error.description)")
        }
    }
    
    // UITextFieldDelegate method
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Limit number of TextField Entry
        var maxLen:UInt8 = 32 // By default

        // We ignore any change that doesn't add characters to the text field.
        // These changes are things like character deletions and cuts, as well
        // as moving the insertion point.
        //
        // We still return true to allow the change to take place.
        if string.count == 0 {
            return true
        }

        // Check to see if the text field's contents still fit the constraints
        // with the new content added to it.
        // If the contents still fit the constraints, allow the change
        // by returning true; otherwise disallow the change by returning false.
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        // Regx For EASID textField : only accept Hex Values
        if (textField == EasIdTextField){
            maxLen = 4
            let range = NSRange(location: 0, length: string.utf8.count)
            let regex = try! NSRegularExpression(pattern: "[A-Fa-f0-9]")
            return prospectiveText.count <= maxLen && regex.firstMatch(in: string, options: [], range: range) != nil
        }
       
        return currentText.count < maxLen
    }
}


extension ST25TVEasViewController:UIPickerViewDataSource, UIPickerViewDelegate {
        
    /* Picker Delegate */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return mList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.mList[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //schemeButton.setTitle(self.mListScheme[row], for: .normal)
        self.mIndexList = row
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "System", size: 17)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = mList[row]
        pickerLabel?.textColor = UIColor.white

        return pickerLabel!
    }
}

extension ST25TVEasViewController: ST25PasswordViewDelegate {
    func okButtonTapped(pwdValue: Data) {
        self.mPassword = pwdValue
        self.miOSReaderSession.startTagReaderSession()
    }
    
    func cancelButtonTapped() {
    }
}
