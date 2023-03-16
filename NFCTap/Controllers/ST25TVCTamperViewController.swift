//
//  ST25TVCTamperViewController.swift
//  NFCTap 
//
//  Created by STMicroelectronics on 02/11/2020.
//  Copyright © 2020 STMicroelectronics. All rights reserved.
//

import UIKit


protocol ST25TVCTamperViewControllerDelegate: class {
    func okButtonTapped(tamperStatus:String, tamperHistory:String)
    func cancelButtonTapped()
}

class ST25TVCTamperViewController: ST25UIViewController {
    
    @IBOutlet weak var tamperStatusTextView: UITextView!
    @IBOutlet weak var tamperImageView: UIImageView!
    
    @IBOutlet weak var tdIsOpenedTextField: UITextField!
    @IBOutlet weak var tdIsClosedTextField: UITextField!
    @IBOutlet weak var tdHistorySealed: UITextField!
    @IBOutlet weak var tdHistoryResealed: UITextField!
    @IBOutlet weak var tdHistoryOpened: UITextField!
    
    @IBOutlet weak var historyEnabledSwitch: UISwitch!
 
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    internal var miOSReaderSession:iOSReaderSession!
    internal var mPwd:Data!
    
    internal var delegate: ST25TVCTamperViewControllerDelegate?

    
    internal var mTag:ComStSt25sdkNFCTag!
    internal var mST25TVCTag:ST25TVCTag!
    internal var mUid:Data!

    // Tamper Messages status
    internal var mTdIsOpenMsg:String!
    internal var mTdIsClosedMsg:String!
    
    // Tamper Messages event
    internal var mTdHistoryOpenMsg:String!
    internal var mTdHistoryReasealMsg:String!
    internal var mTdHistorySealMsg:String!
    
    // history mode
    internal var mTdHistoryUpdateEnabled:Bool = true

    // Variables used for UI update
    internal var imageTamper:UIImage = UIImage(named: "tamper_detect_andef_open.png")!
    internal var statusMsg:String = "Status: "
    internal var tamperStatus:String = ""
    internal var tamperEvent:String = ""
 

    
    enum taskToDo {
        case initTamper
        case readTamper
        case updateTamper
    }
    internal var mTaskToDo:taskToDo = .initTamper

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.tdIsOpenedTextField.delegate = self
        self.tdIsClosedTextField.delegate = self
        self.tdHistorySealed.delegate = self
        self.tdHistoryOpened.delegate = self
        self.tdHistoryResealed.delegate = self
        
        // Hide Cancel button if delegate ST25TVCTamperViewControllerDelegate is not required
        if delegate == nil {
            self.cancelButton.isHidden = true
        }
        
        self.mTaskToDo = .initTamper
        miOSReaderSession = iOSReaderSession(atagReaderSessionViewControllerDelegate: self)
        presentPwdController()

    }
    
    @IBAction func handleRead(_ sender: Any) {
        self.mTaskToDo = .readTamper
        self.miOSReaderSession.startTagReaderSession()
    }
    
   @IBAction func handleUpdate(_ sender: Any) {
        self.mTaskToDo = .updateTamper
        presentPwdController()
    }
    
    @IBAction func handleCancel(_ sender: Any) {
        if delegate != nil {
            delegate?.cancelButtonTapped()
        }
        self.dismiss(animated: true, completion: nil)
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
    
    private func warningAlert(message : String) {
         DispatchQueue.main.async {
             let alert = UIAlertController(title: "Tamper ", message: message, preferredStyle: .alert)
             alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
             self.present(alert, animated: true, completion: nil)
         }
     }
    
    private func initTamper(){
        setPwd()
        readConf()
        readStatus()
        writeUI()
    }
    
    private func readTamper(){
        readStatus()
        writeUI()
    }
    
    private func updateTamper(){
        readUI()
        setPwd()
        writeConf()
        // needed for call back update
        readStatus()
        UIHelper.UI { [self] in
            if delegate != nil {
                delegate?.okButtonTapped(tamperStatus: tamperStatus, tamperHistory: tamperEvent)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    private func readStatus(){
        self.tamperStatus = mST25TVCTag.getTamperDetectLoopStatusString()
        self.tamperEvent  = mST25TVCTag.getTamperDetectEventStatusString()
    }
    
    private func readConf(){
        self.mTdHistoryOpenMsg = mST25TVCTag.getTamperDetectOpenMsg()
        self.mTdHistoryReasealMsg = mST25TVCTag.getTamperDetectResealMsg()
        self.mTdHistorySealMsg = mST25TVCTag.getTamperDetectSealMsg()
        
        self.mTdIsOpenMsg = mST25TVCTag.getTamperDetectOpenMsg()
        self.mTdIsClosedMsg = mST25TVCTag.getTamperDetectShortMsg()

        self.mTdHistoryUpdateEnabled = mST25TVCTag.isTamperDetectEventUpdateEnabled()
    }
    
    private func writeConf(){
        mST25TVCTag.setTamperDetectOpenMsgWith(self.mTdHistoryOpenMsg)
        mST25TVCTag.setTamperDetectResealMsgWith(self.mTdHistoryReasealMsg)
        mST25TVCTag.setTamperDetectSealMsgWith(self.mTdHistorySealMsg)
        
        mST25TVCTag.setTamperDetectOpenMsgWith(self.mTdIsOpenMsg)
        mST25TVCTag.setTamperDetectSealMsgWith(self.mTdIsClosedMsg)
         
        mST25TVCTag.setTamperDetectEventUpdateEnableWithBoolean(self.mTdHistoryUpdateEnabled)
    }
        
    private func writeUI(){
        // Handle Status
        statusMsg = "Status: "
        if (tamperStatus == self.mTdIsOpenMsg){
            statusMsg += "IS OPENED ("+self.mTdIsOpenMsg+")"
            imageTamper = UIImage(named: "tamper_detect_andef_open.png")!
        }else if (tamperStatus == self.mTdIsClosedMsg){
            statusMsg += "IS CLOSED ("+self.mTdIsClosedMsg+")"
            imageTamper = UIImage(named: "tamper_detect_andef_close.png")!
        }else{
            statusMsg += "NO INFO"
        }
        
        // Handle Event
        statusMsg += ",Event: "
        if (tamperEvent == self.mTdHistoryOpenMsg){
            statusMsg += "OPENED ("+self.mTdHistoryOpenMsg+")"
        }else if (tamperEvent == self.mTdHistoryReasealMsg){
            statusMsg += "RESEALED ("+self.mTdHistoryReasealMsg+")"
        }else if (tamperEvent == self.mTdHistorySealMsg){
            statusMsg += "SEALED ("+self.mTdHistorySealMsg+")"
        }else{
            statusMsg += "NO INFO"
        }
        
        UIHelper.UI {
            self.tamperStatusTextView.text = self.statusMsg
            self.tamperImageView.image = self.imageTamper
            
            self.tdIsOpenedTextField.text = self.mTdIsOpenMsg
            self.tdIsClosedTextField.text = self.mTdIsClosedMsg
            self.tdHistoryResealed.text   = self.mTdHistoryReasealMsg
            self.tdHistorySealed.text     = self.mTdHistorySealMsg
            self.tdHistoryOpened.text     = self.mTdHistoryOpenMsg
            
            self.historyEnabledSwitch.setOn(self.mTdHistoryUpdateEnabled, animated: true)
        }
    }
    
    private func readUI(){
        UIHelper.UI {
            self.mTdIsOpenMsg   = self.tdIsOpenedTextField.text
            self.mTdIsClosedMsg = self.tdIsClosedTextField.text
            
            self.mTdHistoryReasealMsg   = self.tdHistoryResealed.text
            self.mTdHistorySealMsg      = self.tdHistorySealed.text
            self.mTdHistoryOpenMsg      = self.tdHistoryOpened.text
            
            self.mTdHistoryUpdateEnabled = self.historyEnabledSwitch.isOn
        }
    }
    
    // UITextFieldDelegate method
    override func textFieldDidEndEditing(_ textField: UITextField) {
        
        //check that textField are valid. Disable "update" button otherwise
        var textFieldLength:UInt8 = 2
        if (textField == tdIsOpenedTextField || textField == tdIsClosedTextField){
            textFieldLength = 1
        }
        
        if (textField.text!.count < textFieldLength) {
            updateButton.alpha = 0.5
            updateButton.isUserInteractionEnabled = false
        }else{
            updateButton.alpha = 1
            updateButton.isUserInteractionEnabled = true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Limit number of TextField Entry
        var maxLen:UInt8 = 2 // By default

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
        

        if (textField == tdIsOpenedTextField || textField == tdIsClosedTextField){
            maxLen = 1
        }
       
        return currentText.count < maxLen
    }
}

extension ST25TVCTamperViewController: ST25PasswordViewDelegate {
    func okButtonTapped(pwdValue: Data) {
        self.mPwd = pwdValue
        self.miOSReaderSession.startTagReaderSession()
    }

    func cancelButtonTapped() {
        if (delegate != nil){
            self.delegate?.cancelButtonTapped()
        }
    }
}

extension ST25TVCTamperViewController: tagReaderSessionViewControllerDelegate {
   
    func handleTag(st25SDKTag: ComStSt25sdkNFCTag, uid: Data!) throws {
        self.mTag = st25SDKTag
        if (self.mTag is ST25TVCTag){
            self.mST25TVCTag = self.mTag as? ST25TVCTag
            self.mUid = uid
            if self.isSameTag(uid: uid) {
                switch mTaskToDo {
                case .initTamper:
                    initTamper()
                case .readTamper:
                    readTamper()
                case .updateTamper:
                    updateTamper()
                 }
            } else {

                UIHelper.UI() {
                    self.warningAlert(message: "Tag has changed, please scan again the Tag ...")
                }
            }
        }else{
            UIHelper.UI() {
                self.warningAlert(message: "This is not a ST25TVC Tag")
            }
        }
        
    }
    
    func handleTagSessionError(didInvalidateWithError error: Error) {
    }
    
    func handleTagST25SdkError(didInvalidateWithError error: NSException) {
        self.warningAlert(message: error.description)
    }

}
