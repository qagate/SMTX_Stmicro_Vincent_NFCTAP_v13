//
//  ST25TVCUniqueTapCodeViewController.swift
//  NFCTap 
//
//  Created by STMicroelectronics on 26/10/2020.
//  Copyright © 2020 STMicroelectronics. All rights reserved.
//

import Foundation
import UIKit


class ST25TVCUniqueTapCodeViewController: ST25UIViewController {

    internal var mTag:ComStSt25sdkNFCTag!
    internal var mST25TVCTag:ST25TVCTag!
    internal var mUid:Data!
    
    internal var miOSReaderSession:iOSReaderSession!
    internal var mEnableCounter:Bool = false
    internal var mPwd:Data!
    
    enum taskToDo {
        case initUniqueTapCode
        case enableUniqueTapCode
        case readUniqueTapCode
    }
    
    internal var mTaskToDo:taskToDo = .initUniqueTapCode
    
    @IBOutlet var counterSwitch: UISwitch!
    @IBOutlet var counterValueTextView: UITextView!
    @IBOutlet var readButton: UIButton!
    
    @IBAction func handleSwitch(_ sender: UISwitch) {
        mTaskToDo = .enableUniqueTapCode
        mEnableCounter = counterSwitch.isOn
        presentPwdController()
    }
    
    @IBAction func handleRead(_ sender: Any) {
        mTaskToDo = .readUniqueTapCode
        miOSReaderSession.startTagReaderSession()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        miOSReaderSession = iOSReaderSession(atagReaderSessionViewControllerDelegate: self)
        mTaskToDo = .initUniqueTapCode
        miOSReaderSession.startTagReaderSession()
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

    private func getInformation() {
        var counterValue:String = ""
        self.mEnableCounter = mST25TVCTag.isUniqueTapCodeEnabled()
        counterValue = mST25TVCTag.getUniqueTapCodeString()
        DispatchQueue.main.sync {
            self.counterValueTextView.text = counterValue
            self.counterSwitch.setOn(self.mEnableCounter, animated: true)
        }
    }
    
    private func readUniqueTapCode() {
        var counterValue:String = ""
        counterValue = mST25TVCTag.getUniqueTapCodeString()
        DispatchQueue.main.sync {
            self.counterValueTextView.text = counterValue
        }

    }
    
    private func enableUniqueTapCode() {
        self.setPwd()
        mST25TVCTag.enableUniqueTapCode(boolean: self.mEnableCounter)
    }
    

    private func setPwd() {
        mST25TVCTag.presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25tvcST25TVCTag_ST25TVC_CONFIGURATION_PASSWORD_ID), password: mPwd)
    }
    
   private func warningAlert(message : String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Unique Tap Code", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension ST25TVCUniqueTapCodeViewController: tagReaderSessionViewControllerDelegate {

    func handleTag(st25SDKTag: ComStSt25sdkNFCTag, uid: Data!) throws {
        self.mTag = st25SDKTag
        if (self.mTag is ST25TVCTag){
            self.mST25TVCTag = self.mTag as? ST25TVCTag
            self.mUid = uid
            if self.isSameTag(uid: uid) {
                switch mTaskToDo {
                case .initUniqueTapCode:
                    getInformation()
                case .enableUniqueTapCode:
                    enableUniqueTapCode()
                case .readUniqueTapCode:
                    readUniqueTapCode()
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

extension ST25TVCUniqueTapCodeViewController: ST25PasswordViewDelegate {
    func okButtonTapped(pwdValue: Data) {
        self.mPwd = pwdValue
        self.miOSReaderSession.startTagReaderSession()
    }

    func cancelButtonTapped() {
    }
}
