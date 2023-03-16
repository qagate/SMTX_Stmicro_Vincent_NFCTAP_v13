//
//  ST25Type4AccessRightsViewController.swift
//  NFCTap 
//
//  Created by STMICROELECTRONICS on 03/11/2021.
//  Copyright © 2021 STMicroelectronics. All rights reserved.
//

import UIKit

class ST25Type4AccessRightsViewController: ST25UIViewController {

    @IBOutlet weak var ndefFileNumberPickerView: UIPickerView!
    public var mNdefFileNumberPickerView = ["1","2","3","4","5","6","7","8"]
    public var mNdefFileNumberIndex:Int!
    public var mNdefFileWritable:Bool =  false
    public var mCurrentNdefFileNumber:Int = 0

    
    @IBOutlet weak var  accessRightSwitch: UISwitch!
    internal var        accessRightBoolean:Bool!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBAction func checkStatus(_ sender: Any) {
        mTaskToDo = .checkStatus
        startNFCSession()
    }
    
    @IBAction func lockPwd(_ sender: Any) {
        mTaskToDo = .lockPwd
        startNFCSession()
    }
    
    @IBAction func unlockPwd(_ sender: Any) {
        mTaskToDo = .unlockPwd
        startNFCSession()
    }
    
    @IBAction func lockNDEF(_ sender: Any) {
        warningAlertLock()
    }
    
    @IBAction func accessRight(_ sender: Any) {
        accessRightBoolean = accessRightSwitch.isOn
    }
    
    // Reference the NFC session
    // NFC & Tags infos
    internal var miOSReaderSession:iOSReaderSession!
    internal var mTag:ComStSt25sdkNFCTag!
    internal var mST25Type4ATag:ComStSt25sdkType4aSTType4Tag!
    internal var mUid:Data!
    
    internal var mPwd:Data!


    enum taskToDo {
        case initController
        case checkStatus
        case lockPwd
        case unlockPwd
        case lockNdef
        case presentPwdForLock
        case presentPwdForUnLock
        case presentPwdForLockNdef
    }
    internal var mTaskToDo:taskToDo = .initController

    override func viewDidLoad() {
        super.viewDidLoad()

        mNdefFileNumberIndex = 0
        ndefFileNumberPickerView.delegate = self
        ndefFileNumberPickerView.dataSource = self
        ndefFileNumberPickerView.selectRow(0, inComponent: 0, animated: true)

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        accessRightBoolean = accessRightSwitch.isOn
        mTaskToDo = .initController
        startNFCSession()
    }

    private func startNFCSession(){
        miOSReaderSession = iOSReaderSession(atagReaderSessionViewControllerDelegate: self)
        miOSReaderSession.startTagReaderSession()
    }


    private func warningAlert(message : String) {
         DispatchQueue.main.async {
             let alert = UIAlertController(title: "ST Type4 Access Rights", message: message, preferredStyle: .alert)
             alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
             self.present(alert, animated: true, completion: nil)
         }
     }
    
    private func warningAlertLock() {
         DispatchQueue.main.async {
             let alert = UIAlertController(title: "ST Type4 Access Rights", message: "you re going to definitely lock the selected NDEF file. This is irreversible. Do you want to continue ? ", preferredStyle: .alert)
             alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self] action in
                 mTaskToDo = .lockNdef
                 startNFCSession()
            }))
            
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { action in
               
           }))
             self.present(alert, animated: true, completion: nil)
         }
     }

    
    //PWD
    // Password
    private func presentPwdController() {
        let mST25PasswordVC:ST25PasswordViewController = UIStoryboard(name: "ST25Password", bundle: nil).instantiateViewController(withIdentifier: "ST25PasswordID") as! ST25PasswordViewController
        mST25PasswordVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        mST25PasswordVC.setTitle("Present Write password")
        mST25PasswordVC.setMessage("(16 Bytes hexadecimal format)")
        mST25PasswordVC.numberOfBytes = 16
        mST25PasswordVC.delegate = self
        self.present(mST25PasswordVC, animated: false, completion: nil)
    }
    
    private func presentPwdForLock(){
        if (accessRightBoolean == true) {
            mST25Type4ATag.lockRead(with: Int32(mNdefFileNumberIndex+1), with: IOSByteArray.init(nsData: mPwd))
        }else{
            mST25Type4ATag.lockWrite(with: Int32(mNdefFileNumberIndex+1), with: IOSByteArray.init(nsData: mPwd))
        }
    }
    
    private func presentPwdForUnLock(){
        if (accessRightBoolean == true) {
            mST25Type4ATag.unlockRead(with: Int32(mNdefFileNumberIndex+1), with: IOSByteArray.init(nsData: mPwd))
        }else{
            mST25Type4ATag.unlockWrite(with: Int32(mNdefFileNumberIndex+1), with: IOSByteArray.init(nsData: mPwd))
        }
    }

    private func presentPwdForLockNdef(){
        if (accessRightBoolean == true) {
            mST25Type4ATag.lockReadPermanently(with: Int32(mNdefFileNumberIndex+1), with: IOSByteArray.init(nsData: mPwd))
        }else{
            mST25Type4ATag.lockWritePermanently(with: Int32(mNdefFileNumberIndex+1), with: IOSByteArray.init(nsData: mPwd))
        }
    }

    
    func initController(){
        let nbrOfFiles = mST25Type4ATag.getNbrOfFiles()
        UIHelper.UI { [self] in
            mNdefFileNumberPickerView.removeAll()
            mNdefFileNumberPickerView.append("1")
            for i in 2..<nbrOfFiles+1 {
                mNdefFileNumberPickerView.append(String(format: "%d", i))
            }
            ndefFileNumberPickerView.reloadAllComponents()
        }

        
        mST25Type4ATag.selectFile(with: Int32(mNdefFileNumberIndex+1))
        if (accessRightBoolean == true) {
            mST25Type4ATag.verifyReadPassword(with: nil)
        }else{
            mST25Type4ATag.verifyWritePassword(with: nil)
        }
        
        UIHelper.UI { [self] in
            statusLabel.text = "Access Granted"
        }

        
    }

    func checkStatus(){
        mST25Type4ATag.selectFile(with: Int32(mNdefFileNumberIndex+1))

        if (accessRightBoolean == true) {
            mST25Type4ATag.verifyReadPassword(with: nil)
        }else{
            mST25Type4ATag.verifyWritePassword(with: nil)
        }
        UIHelper.UI { [self] in
            statusLabel.text = "Access Granted"
        }
    }
    
    func lockPwd(){
        mST25Type4ATag.selectFile(with: Int32(mNdefFileNumberIndex+1))

        if (accessRightBoolean == true) {
            mST25Type4ATag.lockRead()
        }else{
            mST25Type4ATag.lockWrite()
        }
    }
    
    func unlockPwd(){
        mST25Type4ATag.selectFile(with: Int32(mNdefFileNumberIndex+1))

        if (accessRightBoolean == true) {
            mST25Type4ATag.unlockRead()
        }else{
            mST25Type4ATag.unlockWrite()
        }
    }
    
    func lockNdef(){
        mST25Type4ATag.selectFile(with: Int32(mNdefFileNumberIndex+1))

        if (accessRightBoolean == true) {
            mST25Type4ATag.lockReadPermanently()
        }else{
            mST25Type4ATag.lockWritePermanently()
        }
    }

}

extension ST25Type4AccessRightsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    /* Picker Delegate */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return mNdefFileNumberPickerView.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.mNdefFileNumberPickerView[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.mNdefFileNumberIndex = row
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "System", size: 17)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = mNdefFileNumberPickerView[row]
        pickerLabel?.textColor = UIColor.stDarkBlueColor()

        return pickerLabel!
    }
}

extension ST25Type4AccessRightsViewController: ST25PasswordViewDelegate {
    func okButtonTapped(pwdValue: Data) {
        self.mPwd = pwdValue
        if (self.mTaskToDo == .lockPwd){
            self.mTaskToDo = .presentPwdForLock
        }else if (self.mTaskToDo == .unlockPwd){
            self.mTaskToDo = .presentPwdForUnLock
        }else if (self.mTaskToDo == .lockNdef ){
            self.mTaskToDo = .presentPwdForLockNdef
        }
        self.miOSReaderSession.startTagReaderSession()
    }

    func cancelButtonTapped() {
    }
}

extension ST25Type4AccessRightsViewController: tagReaderSessionViewControllerDelegate{
    
    func handleTag(st25SDKTag: ComStSt25sdkNFCTag, uid: Data!) throws {
        self.mTag = st25SDKTag
        if (self.mTag is ComStSt25sdkType4aType4Tag   ) {
            self.mST25Type4ATag = self.mTag as? ComStSt25sdkType4aSTType4Tag
            self.mUid = uid
            if self.isSameTag(uid: uid) {
                switch mTaskToDo {
                    case .checkStatus:
                        self.checkStatus()
                    case .lockPwd:
                        self.lockPwd()
                    case .unlockPwd:
                        self.unlockPwd()
                    case .lockNdef:
                        self.lockNdef()
                    case .initController:
                        self.initController()
                    case .presentPwdForLock:
                        self.presentPwdForLock()
                    case .presentPwdForUnLock:
                        self.presentPwdForUnLock()
                    case .presentPwdForLockNdef:
                        self.presentPwdForLockNdef()
                }
            } else {

                UIHelper.UI() {
                    self.warningAlert(message: "Tag has changed, please scan again the Tag ...")
                }
            }
        }else{
            UIHelper.UI() {
                self.warningAlert(message: "This is not a Type4A Tag")
            }
        }
        
    }
    
    func handleTagSessionError(didInvalidateWithError error: Error) {
    }
    
    func handleTagST25SdkError(didInvalidateWithError error: NSException) {
        let stException:ComStSt25sdkSTException = error as! ComStSt25sdkSTException
        if (mTaskToDo == .initController || mTaskToDo == .checkStatus) {
            var errorMsg:String = ""
            switch stException.getError() {
            case ComStSt25sdkSTException_STExceptionCode_get_PASSWORD_NEEDED():
                errorMsg = "Password Needed"
                UIHelper.UI { [self] in
                    statusLabel.text = errorMsg
                }
            case ComStSt25sdkSTException_STExceptionCode_get_PERMANENTLY_LOCKED(),
                 ComStSt25sdkSTException_STExceptionCode_get_INVALID_DATA_PARAM():
                errorMsg = "Permanently locked"
                UIHelper.UI { [self] in
                    statusLabel.text = errorMsg
                }
            default:
                errorMsg = "Unknown Error Code"
                UIHelper.UI { [self] in
                    statusLabel.text = errorMsg
                }
                warningAlert(message: stException.description())
            }
        }
        
        if (mTaskToDo == .lockPwd || mTaskToDo == .unlockPwd || mTaskToDo == .lockNdef) {
            switch stException.getError() {
            case ComStSt25sdkSTException_STExceptionCode_get_WRONG_SECURITY_STATUS():
                UIHelper.UI { [self] in
                    presentPwdController()
                }
            default:
                warningAlert(message: "Lock/Unlock Command Failed . Unknown reason")
            }
        }
        
        if (mTaskToDo == .presentPwdForLock ){
            warningAlert(message: "Lock Access Right : error during presentation ")
        }
            
        if (mTaskToDo == .presentPwdForUnLock ){
            warningAlert(message: "Unlock Access Right : error during presentation ")
        }
        
        if (mTaskToDo == .presentPwdForLockNdef){
            warningAlert(message: "Lock Permanently Access Right : error during presentation ")
        }


    }

}
