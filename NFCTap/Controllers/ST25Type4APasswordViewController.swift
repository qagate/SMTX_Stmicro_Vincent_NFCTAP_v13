//
//  ST25Type4APasswordViewController.swift
//  NFCTap 
//
//  Created by STMICROELECTRONICS on 03/11/2021.
//  Copyright © 2021 STMicroelectronics. All rights reserved.
//

import UIKit

class ST25Type4APasswordViewController: ST25UIViewController {

    @IBOutlet weak var ndefFileNumberPickerView: UIPickerView!
    public var mNdefFileNumberPickerView = ["1","2","3","4","5","6","7","8"]
    public var mNdefFileNumber:Int!
    public var mNdefFileWritable:Bool =  false

    @IBAction func handlePresentPwd(_ sender: Any) {
        self.mTaskToDo = .presentPwd
        self.presentPwdController(title: "Present Write Password")
    }
    
    @IBAction func handleChangePwd(_ sender: Any) {
        self.warningChangePwd()
    }
    
    @IBOutlet weak var  accessRightSwitch: UISwitch!
    internal var        accessRightBoolean:Bool!
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
    internal var mPresentPwd:Data!


    enum taskToDo {
        case initController
        case presentPwd
        case changePwdStep1
        case changePwdStep2
    }
    internal var mTaskToDo:taskToDo = .initController

    
    internal var mST25PasswordVC:ST25PasswordViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mNdefFileNumber = 1
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
             let alert = UIAlertController(title: "ST Type4 Passwords", message: message, preferredStyle: .alert)
             alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
             self.present(alert, animated: true, completion: nil)
         }
     }
    
    private func warningChangePwd() {
        DispatchQueue.main.async { [self] in
             var readWriteString:String = "READ"
             if (accessRightBoolean == false) {
                 readWriteString = "WRITE"
             }
             let alert = UIAlertController(title: "ST Type4 Passwords", message: "you re going to change the \(readWriteString) password. Do you want to continue ? ", preferredStyle: .alert)
             alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self] action in
                 mTaskToDo = .changePwdStep1
                 self.presentPwdController(title: "Present Write Password")
            }))
            
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { action in
               
           }))
             self.present(alert, animated: true, completion: nil)
         }
     }

    
    //PWD
    // Password
    private func presentPwdController(title:String) {
        mST25PasswordVC = UIStoryboard(name: "ST25Password", bundle: nil).instantiateViewController(withIdentifier: "ST25PasswordID") as! ST25PasswordViewController
        mST25PasswordVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        mST25PasswordVC.setTitle(title)
        mST25PasswordVC.setMessage("(16 Bytes hexadecimal format)")
        mST25PasswordVC.numberOfBytes = 16
        mST25PasswordVC.delegate = self
        self.present(mST25PasswordVC, animated: false, completion: nil)
    }
    
    private func initController(){
        let nbrOfFiles = mST25Type4ATag.getNbrOfFiles()
        UIHelper.UI { [self] in
            mNdefFileNumberPickerView.removeAll()
            mNdefFileNumberPickerView.append("1")
            for i in 2..<nbrOfFiles+1 {
                mNdefFileNumberPickerView.append(String(format: "%d", i))
            }
            ndefFileNumberPickerView.reloadAllComponents()
        }
    }
    
    private func presentPWD(){
        // Read Pwd
        if (self.accessRightBoolean == true){
            let type4Tag:ComStSt25sdkType4aSTType4Tag = ComStSt25sdkType4aSTType4Tag.init(comStSt25sdkRFReaderInterface: miOSReaderSession.mComStSt25sdkRFReaderInterface, with: IOSByteArray.init(nsData: mUid))
            type4Tag.verifyReadPassword(with: jint(mNdefFileNumber), with: IOSByteArray.init(nsData: self.mPwd))
        }else{
            let type4Tag:ComStSt25sdkType4aSTType4Tag = ComStSt25sdkType4aSTType4Tag.init(comStSt25sdkRFReaderInterface: miOSReaderSession.mComStSt25sdkRFReaderInterface, with: IOSByteArray.init(nsData: mUid))
            type4Tag.verifyWritePassword(with: jint(mNdefFileNumber), with: IOSByteArray.init(nsData: self.mPwd))
        }
        
    }
    
    private func changePWD(){
        // Read Pwd
        if (self.accessRightBoolean == true){
            let type4Tag:ComStSt25sdkType4aSTType4Tag = ComStSt25sdkType4aSTType4Tag.init(comStSt25sdkRFReaderInterface: miOSReaderSession.mComStSt25sdkRFReaderInterface, with: IOSByteArray.init(nsData: mUid))
            type4Tag.changeReadPassword(with: jint(mNdefFileNumber), with: IOSByteArray.init(nsData: self.mPwd), with: IOSByteArray.init(nsData: self.mPresentPwd))
        }else{
            let type4Tag:ComStSt25sdkType4aSTType4Tag = ComStSt25sdkType4aSTType4Tag.init(comStSt25sdkRFReaderInterface: miOSReaderSession.mComStSt25sdkRFReaderInterface, with: IOSByteArray.init(nsData: mUid))
            type4Tag.changeWritePassword(with: jint(mNdefFileNumber), with: IOSByteArray.init(nsData: self.mPwd), with: IOSByteArray.init(nsData: self.mPresentPwd))
        }
    }
}

extension ST25Type4APasswordViewController: UIPickerViewDataSource, UIPickerViewDelegate {
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
        self.mNdefFileNumber = Int(ComStSt25sdkHelper.convertStringToInt(with: mNdefFileNumberPickerView[row]))
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

extension ST25Type4APasswordViewController: ST25PasswordViewDelegate {
    func okButtonTapped(pwdValue: Data) {
        self.mPwd = pwdValue
        if (self.mTaskToDo == .presentPwd){
            self.startNFCSession()
        }else if (self.mTaskToDo == .changePwdStep1){
            mST25PasswordVC.dismiss(animated: true, completion: nil)
            self.mPresentPwd = pwdValue
            mTaskToDo = .changePwdStep2
            if (self.mTaskToDo == .changePwdStep2){
                var readWriteString:String = "READ"
                if (accessRightBoolean == false) {
                    readWriteString = "WRITE"
                }
                self.presentPwdController(title: "Enter new \(readWriteString) password")
            }
        }else if (self.mTaskToDo == .changePwdStep2){
            self.startNFCSession()
        }
    }

    func cancelButtonTapped() {
    }
}

extension ST25Type4APasswordViewController: tagReaderSessionViewControllerDelegate{
    
    func handleTag(st25SDKTag: ComStSt25sdkNFCTag, uid: Data!) throws {
        self.mTag = st25SDKTag
        if (self.mTag is ComStSt25sdkType4aType4Tag   ) {
            self.mST25Type4ATag = self.mTag as? ComStSt25sdkType4aSTType4Tag
            self.mUid = uid
            if self.isSameTag(uid: uid) {
                switch mTaskToDo {
                    case .initController:
                        self.initController()
                    case .presentPwd:
                        self.presentPWD()
                    case .changePwdStep2:
                        self.changePWD()
                    default:
                        return
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
        var errorMsg:String = ""
        switch stException.getError() {
        case ComStSt25sdkSTException_STExceptionCode_get_PASSWORD_NEEDED():
            errorMsg = "Password Needed"
        default:
            errorMsg = "Unknown Error Code"
            warningAlert(message: stException.description())
        }
    }

}
