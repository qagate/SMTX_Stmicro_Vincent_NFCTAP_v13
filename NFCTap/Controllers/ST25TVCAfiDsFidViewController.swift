//
//  ST25TVCAfiDsFidViewController.swift
//  NFCTap 
//
//  Created by STMicroelectronics on 26/11/2020.
//  Copyright © 2020 STMicroelectronics. All rights reserved.
//

import UIKit
import CoreNFC


class ST25TVCAfiDsFidViewController: ST25UIViewController, UITextViewDelegate {

    internal var miOSReaderSession:iOSReaderSession!
    internal var mTag : ComStSt25sdkNFCTag!
    internal var mType5Tag:STType5Tag! // used for commands type5 directly.

    internal var mST25TVCTag:ST25TVCTag!
    internal var mIsTVC = false

    internal var mAfi : UInt8!
    internal var mDsFid : UInt8!
    internal var mIsAfiLocked = false
    internal var mIsDsFidLocked = false
    internal var mIsWriteLockAfi = false

    internal var mIsAfiLockedSwitch = false
    internal var mIsDsFidLockedSwitch = false
    internal var mIsWriteLockAfiSwitch = false

    internal var mNumberOfAreas: Int8 = 1
    internal var mPwd:Data!
    internal var mAreaReadPwd:Data!
    internal var mAreaWritePwd:Data!


    enum taskToDo {
        case checkStatus
        case checkAfiPrivilege
        case checkDsFidPrivilege
        case updateStatus
        case updateStatusWithPwd
        case updateStatusWithConfPwd
    }
    internal var mTaskToDo:taskToDo!
    
    
    @IBOutlet weak var mAfiHexaTextValue: UITextView!
    @IBOutlet weak var mDsFidHexaTextValue: UITextView!
    
    @IBOutlet weak var mPermanentLockAfiSwitch: UISwitch!
    @IBAction func mPermanentLockAfiSwitchAction(_ sender: UISwitch) {
        if (sender.isOn) {
            confirmationLockDialog(toggle: sender)
        } else {
            mIsAfiLockedSwitch = false

        }
    }
    
    @IBOutlet weak var mWriteLockAfiSwitch: UISwitch!
    @IBAction func mWriteLockAfiSwitchAction(_ sender: UISwitch) {
        if (sender.isOn) {
            mIsWriteLockAfiSwitch = true
        } else {
            mIsWriteLockAfiSwitch = false

        }
    }
    
    @IBOutlet weak var mPermanentLockDsFidSwitch: UISwitch!
    @IBAction func mPermanentLockDsFidSwitchAction(_ sender: UISwitch) {
        if (sender.isOn) {
            confirmationLockDialog(toggle: sender)
        } else {
            mIsDsFidLockedSwitch = false

        }    }
    
    @IBAction func mUpdateTagAction(_ sender: UIButton) {
        getUIValues()
        mTaskToDo = .updateStatus
        self.miOSReaderSession.startTagReaderSession()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Afi and DsFid"

        self.miOSReaderSession = iOSReaderSession(atagReaderSessionViewControllerDelegate: self)

        
        mAfiHexaTextValue.delegate = self
        mDsFidHexaTextValue.delegate = self
        
        mTaskToDo = .checkStatus
        self.miOSReaderSession.startTagReaderSession()

        
    }
    

    // UITextFieldDelegate method
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField == mAfiHexaTextValue || textField == mDsFidHexaTextValue) {
            // Limit number of TextField Entry
            let maxLen:UInt8 = 2 // By default
            
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
            
            // Regx For XXX textField : only accept Hex Values
            let range = NSRange(location: 0, length: string.utf8.count)
            let regex = try! NSRegularExpression(pattern: "[A-Fa-f0-9]")
            return prospectiveText.count <= maxLen && regex.firstMatch(in: string, options: [], range: range) != nil
            
        } else {
            return true
        }
        
    }

    private func warningAlert(message : String) {
        UIHelper.warningAlert(viewController: self, title : "Afi - DsFid features" , message: message)
    }
    
    private func confirmationLockDialog(toggle : UISwitch) {
        if toggle.isOn {
            let confirmationDialog = UIAlertController(title: "Lock is IRREVERSIBLE!", message: "Do you really want to configure lock permanently?", preferredStyle: UIAlertController.Style.alert)
            
            confirmationDialog.addAction(UIAlertAction(title: "Continue lock", style: .default, handler: { (action: UIAlertAction!) in
                toggle.isOn = true
                if toggle == self.mPermanentLockAfiSwitch {
                    self.mIsAfiLockedSwitch = true
                }
                if toggle == self.mPermanentLockDsFidSwitch {
                    self.mIsDsFidLockedSwitch = true
                }
            }))
            
            confirmationDialog.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                //print("Action cancelled: Lock kill password")
                toggle.isOn = false
                if toggle == self.mPermanentLockAfiSwitch {
                    self.mIsAfiLockedSwitch = false
                }
                if toggle == self.mPermanentLockDsFidSwitch {
                    self.mIsDsFidLockedSwitch = false
                }
                
            }))
            present(confirmationDialog, animated: true, completion: nil)
        }
    }
    
    
    private func checkTagStatus() {
        mAfi = UInt8(mType5Tag.getAFI())
        mDsFid = UInt8(mType5Tag.getDSFID())
 
        if mIsTVC {
            mIsWriteLockAfi = mST25TVCTag.isAfiWriteProtected()
            mNumberOfAreas = Int8(mST25TVCTag.getNumberOfAreas())

        }
        
        isAfiLocked(afi: self.mAfi)
        isDsFidLocked(dsafi: self.mDsFid)

        
    }
    
    private func updateStatusOnTag() {
        mType5Tag.writeAFI(withByte: jbyte(mAfi))
        mType5Tag.writeDSFID(withByte: jbyte(mDsFid))
        if mIsAfiLockedSwitch != mIsAfiLocked  && mIsAfiLockedSwitch == true {
            // lock AFI
            mType5Tag.lockAFI()
        }
        if mIsDsFidLockedSwitch != mIsDsFidLocked && mIsDsFidLockedSwitch == true {
            // lock DSFID
            mType5Tag.lockDSFID()

        }
        if mIsTVC {
            if mIsWriteLockAfiSwitch != mIsWriteLockAfi {
                // lock DSFID
                mST25TVCTag.setAfiWriteProtectedWithBoolean(mIsWriteLockAfiSwitch)
                mIsWriteLockAfi = mIsWriteLockAfiSwitch
            }
        }
    }
    
    private func updateStatusOnTagWithPwd() {
        setWritePwdForArea()
        updateStatusOnTag()
    }
    private func updateStatusOnTagWithConfPwd() {
        setConfPwd()
        updateStatusOnTag()
    }
    
    private func getUIValues() {
        mAfi = UInt8(mAfiHexaTextValue.text)
        mDsFid = UInt8(mDsFidHexaTextValue.text)
        mIsAfiLockedSwitch = mPermanentLockAfiSwitch.isOn
        mIsDsFidLockedSwitch = mPermanentLockDsFidSwitch.isOn
        if mIsTVC {
            mIsWriteLockAfiSwitch = mWriteLockAfiSwitch.isOn
        }
    }
    
    private func updateUIStatus() {
        mAfiHexaTextValue.text = ComStSt25sdkHelper.convertByteToHexString(withByte: jbyte(mAfi))
        mDsFidHexaTextValue.text = ComStSt25sdkHelper.convertByteToHexString(withByte: jbyte(mDsFid))
        mPermanentLockAfiSwitch.isOn = mIsAfiLocked
        mPermanentLockDsFidSwitch.isOn = mIsDsFidLocked
        
        mIsAfiLockedSwitch = mIsAfiLocked
        mIsDsFidLockedSwitch = mIsDsFidLocked
        if mIsAfiLocked {
            mAfiHexaTextValue.isUserInteractionEnabled = false
            mPermanentLockAfiSwitch.isEnabled = false
        } else {
            mAfiHexaTextValue.isUserInteractionEnabled = true
            mPermanentLockAfiSwitch.isEnabled = true
        }
        if mIsDsFidLocked {
            mDsFidHexaTextValue.isUserInteractionEnabled = false
            mPermanentLockDsFidSwitch.isEnabled = false
        } else {
            mDsFidHexaTextValue.isUserInteractionEnabled = true
            mPermanentLockDsFidSwitch.isEnabled = true
        }
        
        if !mIsTVC {
            mWriteLockAfiSwitch.visibility = UIView.Visibility.gone
        } else {
            mWriteLockAfiSwitch.isOn = mIsWriteLockAfi
            if mIsWriteLockAfi {
                mWriteLockAfiSwitch.isEnabled = false
            } else {
                mWriteLockAfiSwitch.isEnabled = true
            }
        }
    }
    
    private func isAfiLocked(afi : UInt8) {
        mIsAfiLocked = true
        mType5Tag.writeAFI(withByte: jbyte(afi))
        mIsAfiLocked = false

    }
    private func isDsFidLocked(dsafi : UInt8) {
        mIsDsFidLocked = true
        mType5Tag.writeDSFID(withByte: jbyte(dsafi))
        mIsDsFidLocked = false

        UIHelper.UI { [self] in
            updateUIStatus()
        }
    }
    
    private func presentConfPwdController() {
        let mST25PasswordVC:ST25PasswordViewController = UIStoryboard(name: "ST25Password", bundle: nil).instantiateViewController(withIdentifier: "ST25PasswordID") as! ST25PasswordViewController
        mST25PasswordVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        mST25PasswordVC.setTitle("Enter configuration password")
        mST25PasswordVC.setMessage("(32 bits hexadecimal format)")
        mST25PasswordVC.numberOfBytes = 4
        mST25PasswordVC.delegate = self
        self.present(mST25PasswordVC, animated: false, completion: nil)
    }
    private func setConfPwd() {
        mST25TVCTag.presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25tvcST25TVCTag_ST25TVC_CONFIGURATION_PASSWORD_ID), password: mPwd)
    }
    private func setWritePwdForArea() {
        mST25TVCTag.presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25tvcST25TVCTag_ST25TVC_AREA1_PASSWORD_ID  ), password: mAreaWritePwd)
    }
    private func getCurrentPwdForArea(type : String) {
        let mST25PasswordVC:ST25PasswordViewController = UIStoryboard(name: "ST25Password", bundle: nil).instantiateViewController(withIdentifier: "ST25PasswordID") as! ST25PasswordViewController
        mST25PasswordVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        // MUST be on area 1
        mST25PasswordVC.setTitle("Enter current \(type) area 1 password")
        
        if mTag is ST25TVCTag {
            if  self.mNumberOfAreas == 2 {
                mST25PasswordVC.setMessage("(32 bits hexadecimal format)")
                mST25PasswordVC.numberOfBytes = 4
            } else {
                mST25PasswordVC.setMessage("(64 bits hexadecimal format)")
                mST25PasswordVC.numberOfBytes = 8
            }
        } else {
            UIHelper.UI() {
                self.warningAlert(message: "Tag doesn't support this feature")
            }
            
            return
        }
        
        mST25PasswordVC.delegate = self
        self.present(mST25PasswordVC, animated: false, completion: nil)
    }

}


extension ST25TVCAfiDsFidViewController: ST25PasswordViewDelegate {
    func cancelButtonTapped() {
        print("Password action cancelled !")
    }
    
    func okButtonTapped(pwdValue: Data) {
        if mTaskToDo == .updateStatusWithPwd {
            self.mAreaWritePwd = pwdValue
            self.miOSReaderSession.startTagReaderSession()

        }
        if mTaskToDo == .updateStatusWithConfPwd {
            self.mAreaWritePwd = pwdValue
            self.miOSReaderSession.startTagReaderSession()

        }

    }
    
}

extension ST25TVCAfiDsFidViewController: tagReaderSessionViewControllerDelegate {
    
    func handleTag(st25SDKTag: ComStSt25sdkNFCTag, uid: Data!) throws {
        mTag = st25SDKTag
        mType5Tag = STType5Tag.init(RFReaderInterface: mTag.getReaderInterface() as! iOSRFReaderInterface, uid: (mTag.getUid()?.toNSData())!)
        
        // test if TVC for Protect Write
        if (self.mTag is ST25TVCTag){
            self.mST25TVCTag = self.mTag as? ST25TVCTag
            mIsTVC = true
        }
        if self.isSameTag(uid: uid) {
            switch mTaskToDo {
            case .checkStatus:
                self.checkTagStatus()
            case .checkAfiPrivilege:
                isAfiLocked(afi: self.mAfi)
            case .checkDsFidPrivilege:
                isDsFidLocked(dsafi: self.mDsFid)
            case .updateStatus:
                self.updateStatusOnTag()
            case .updateStatusWithPwd:
                self.updateStatusOnTagWithPwd()
            case .updateStatusWithConfPwd:
                self.updateStatusOnTagWithConfPwd()
            case .none:
                print("Unknown task !")

            }
        } else {
            //print((TabItem.TagInfo.mainVC as! ST25TagInformationViewController).productId?.description)
            //print(uid.toHexString())
            UIHelper.UI() {
                self.warningAlert(message: "Tag has changed, please scan again the Tag ...")
            }
        }
        
    }
    
    
    func handleTagSessionError(didInvalidateWithError error: Error) {
        //print(" ==== entry > handleTagSessionEnd in controller : \(self.mTaskToDo)")
        let errorNFC = error as! NFCReaderError
        //print(" ==== entry > handleTagSessionEnd in controller : \(errorNFC)")
        
        if errorNFC.code ==  NFCReaderError.readerSessionInvalidationErrorSessionTimeout {
            // session Timeout detected
            // restart a session to continu
            //invalidateGridStatus()
        }
        else if errorNFC.code ==  NFCReaderError.readerSessionInvalidationErrorUserCanceled {
        }
        print(error.localizedDescription)
        
 
        }
        
    
    func handleTagST25SdkError(didInvalidateWithError error: NSException) {
//                print("ST25SDK Error description: \(error.description)")
//                print("ST25SDK Error name: \(error.name)")
//                print("ST25SDK Error user info: \(error.userInfo)")
//                print("ST25SDK Error reason: \(error.reason)")
//        let errorST25SDK = error as! ComStSt25sdkSTException
//        UIHelper.UI() {
//          self.warningAlert(message: "Command failed: \(error.description)")
//        }
        
        if error is ComStSt25sdkSTException {
            let errorST25SDK = error as! ComStSt25sdkSTException
            //            print("Error SDK \(errorST25SDK)")
            //            print("Error SDK \(errorST25SDK.getError())")
            //            print("Error SDK \(errorST25SDK.getMessage())")
            if self.mTaskToDo == .updateStatus{
                if (errorST25SDK.getMessage()?.contains(ComStSt25sdkSTException_STExceptionCode.ISO15693_BLOCK_PROTECTED.description()))!
                {
                    UIHelper.UI() {
                        self.mTaskToDo = .updateStatusWithPwd
                        self.getCurrentPwdForArea(type: "write")
                    }
                    
                } else if (errorST25SDK.getMessage()?.contains(ComStSt25sdkSTException_STExceptionCode.PASSWORD_NEEDED.description()))!
                {
                    // Config pwd needed
                    UIHelper.UI() {
                        self.mTaskToDo = .updateStatusWithConfPwd
                        self.presentConfPwdController()
                    }
                    
                }
                else {
                    UIHelper.UI() {
                        self.warningAlert(message: "Command failed: \(error.description)")
                    }
                }
            }
            if self.mTaskToDo == .checkStatus {
                if ((errorST25SDK.getMessage()?.contains(ComStSt25sdkSTException_STExceptionCode.PASSWORD_NEEDED.description()))! ||
                    (errorST25SDK.getMessage()?.contains(ComStSt25sdkSTException_STExceptionCode.ISO15693_BLOCK_IS_LOCKED.description()))!){
                    UIHelper.UI() {
                        self.mTaskToDo = .checkAfiPrivilege
                        self.miOSReaderSession.startTagReaderSession()
                    }
                } else {
                    UIHelper.UI() {
                        self.warningAlert(message: "Command failed: \(error.description)")
                    }
                }
                
            }
            if self.mTaskToDo == .checkAfiPrivilege {
                if ((errorST25SDK.getMessage()?.contains(ComStSt25sdkSTException_STExceptionCode.PASSWORD_NEEDED.description()))! ||
                    (errorST25SDK.getMessage()?.contains(ComStSt25sdkSTException_STExceptionCode.ISO15693_BLOCK_IS_LOCKED.description()))!){
                    UIHelper.UI() {
                        self.mTaskToDo = .checkDsFidPrivilege
                        self.miOSReaderSession.startTagReaderSession()
                    }
                } else {
                    UIHelper.UI() {
                        self.warningAlert(message: "Command failed: \(error.description)")
                    }
                }
                
            }
        } else {
            // NSException
            print(error.reason)
        }

    }
    
}
