//
//  ST25TVCounterViewController.swift
//  ST25NFCApp
//
//  Created by STMicroelectronics on 10/21/19.
//  Copyright © 2019 STMicroelectronics. All rights reserved.
//

import UIKit

extension ST25TVCounterViewController: ST25PasswordViewDelegate {
    func okButtonTapped(pwdValue: Data) {
        self.mST25TVConfigurationPwd = pwdValue
        self.miOSReaderSession.startTagReaderSession()
    }

    func cancelButtonTapped() {
    }
}
    
class ST25TVCounterViewController: ST25UIViewController {

    internal var mTag:ComStSt25sdkNFCTag!
    internal var mUid:Data!
    
    internal var miOSReaderSession:iOSReaderSession!
    internal var mEnableCounter:Bool = false
    internal var mST25TVConfigurationPwd:Data!
    
    enum taskToDo {
        case initCounter
        case enableCounter
        case readCounter
        case clearCounter
    }
    internal var mTaskToDo:taskToDo = .initCounter
    
    @IBOutlet var counterSwitch: UISwitch!
    @IBOutlet var counterValueTextView: UITextView!
    @IBOutlet var readButton: UIButton!
    
    @IBAction func handleSwitch(_ sender: UISwitch) {
        mTaskToDo = .enableCounter
        mEnableCounter = counterSwitch.isOn
        presentPwdController()
    }
    
    @IBAction func handleRead(_ sender: Any) {
        mTaskToDo = .readCounter
        miOSReaderSession.startTagReaderSession()
    }
    
    @IBAction func handleClear(_ sender: Any) {
        mTaskToDo = .clearCounter
        presentPwdController()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        miOSReaderSession = iOSReaderSession(atagReaderSessionViewControllerDelegate: self)
        mTaskToDo = .initCounter
        presentPwdController()
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

    private func getST25TVCounterInformation() {
        
        self.setPwdST25TVCounter()
        
        if mTag is ST25TVTag {
            var counterValue:UInt8 = 0
            let mST25TVTag = (mTag as! ST25TVTag)
            self.mEnableCounter = mST25TVTag.isCounterEnabled()
            counterValue = mST25TVTag.readCounter()
            DispatchQueue.main.sync {
                self.counterValueTextView.text = String(counterValue)
            }
        }else if mTag is ST25TVCTag {
            var counterValue:String = ""
            let mST25TVTag = (mTag as! ST25TVCTag)
            self.mEnableCounter = true;
            mST25TVTag.enableUniqueTapCode(boolean: true)
            counterValue = mST25TVTag.getUniqueTapCodeString()
            DispatchQueue.main.sync {
                self.counterValueTextView.text = counterValue
            }
        }

        DispatchQueue.main.sync {
            self.counterSwitch.setOn(self.mEnableCounter, animated: true)
            //self.counterValueTextView.text = String(counterValue)
            self.setReadButton(status: self.mEnableCounter)
        }
    }
    
    private func readST25TVCounter() {
        var counterValue:UInt8 = 0
        if mTag is ST25TVTag {
            let mST25TVTag = (mTag as! ST25TVTag)
            counterValue = mST25TVTag.readCounter()
        }
        
        DispatchQueue.main.sync {
            self.counterValueTextView.text = String(counterValue)
        }

    }
    
    private func enableST25TVCounter() {
        self.setPwdST25TVCounter()
        if mTag is ST25TVTag {
            let mST25TVTag = (mTag as! ST25TVTag)
            mST25TVTag.enableCounter(boolean: self.mEnableCounter)
        }
        
        DispatchQueue.main.sync {
            self.setReadButton(status: self.mEnableCounter)
         }
    }
    
    private func resetST25TVCounter() {
        var counterValue:UInt8 = 0
        self.setPwdST25TVCounter()
        if mTag is ST25TVTag {
            let mST25TVTag = (mTag as! ST25TVTag)
            mST25TVTag.resetCounter()
            counterValue = mST25TVTag.readCounter()
        }

        DispatchQueue.main.sync {
            self.mEnableCounter = false
            self.counterSwitch.setOn(self.mEnableCounter, animated: true)
            self.counterValueTextView.text = String(counterValue)
            self.setReadButton(status: self.mEnableCounter)
         }
    }

    private func setPwdST25TVCounter() {
        if mTag is ST25TVTag {
            (mTag as! ST25TVTag).presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25tvST25TVTag_ST25TV_CONFIGURATION_PASSWORD_ID), password: mST25TVConfigurationPwd)
        }else if mTag is ST25TVCTag {
            (mTag as! ST25TVCTag).presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25tvST25TVTag_ST25TV_CONFIGURATION_PASSWORD_ID), password: mST25TVConfigurationPwd)
        }
    }
    
    private func setReadButton(status:Bool){
        self.readButton.isEnabled = status
        if (status){
            self.readButton.alpha = 1
        } else {
            self.readButton.alpha = 0.5
        }
    }
    
    private func warningAlert(message : String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "ST25TV Counter", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension ST25TVCounterViewController: tagReaderSessionViewControllerDelegate {

    //func handleTag(RFReaderInterface: iOSRFReaderInterface, uid: Data!)  {
    func handleTag(st25SDKTag: ComStSt25sdkNFCTag, uid: Data!) throws {
        self.mTag = st25SDKTag
        self.mUid = uid
        if self.isSameTag(uid: uid) {
            switch mTaskToDo {
            case .initCounter:
                getST25TVCounterInformation()
            case .enableCounter:
                enableST25TVCounter()
            case .readCounter:
                readST25TVCounter()
            case .clearCounter:
                resetST25TVCounter()
                 }
        } else {

            UIHelper.UI() {
                self.warningAlert(message: "Tag has changed, please scan again the Tag ...")
            }
        }
        
    }
    
    
    func handleTagSessionError(didInvalidateWithError error: Error) {
    }
    
    func handleTagST25SdkError(didInvalidateWithError error: NSException) {
        self.warningAlert(message: error.description)
    }

}
