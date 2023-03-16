//
//  ST25ConfigurationPasswordViewController.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 12/12/2019.
//  Copyright © 2019 STMicroelectronics. All rights reserved.
//

import UIKit
import CoreNFC


class ST25ConfigurationPasswordViewController: ST25UIViewController {

    internal var mTag : ComStSt25sdkNFCTag!
    internal var miOSReaderSession:iOSReaderSession!
    internal var mST25ConfigurationPwd:Data!
    internal var mST25ConfigurationPwdNew:Data!

    enum taskToDo {
        case getConfigurationPassword
        case changeConfigurationPassword
        case getlockConfiguration
        case lockConfiguration
    }
    internal var mTaskToDo:taskToDo = .changeConfigurationPassword

    @IBAction func changePassword(_ sender: Any) {
        mTaskToDo = .getConfigurationPassword
        getCurrentConfigurationPwd()
    }
    
    @IBAction func lockConfiguration(_ sender: Any) {
        if self.mTag is ST25TVCTag {
            // handled directly by button - start lock configuration controller
            changeLockConfigurationRegister(tag: mTag as! ST25TVCTag)
            return
        }
        mTaskToDo = .getlockConfiguration
        getCurrentConfigurationPwd()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mTaskToDo = .changeConfigurationPassword
        mTag = (TabItem.TagInfo.mainVC as! ST25TagInformationViewController).mTagSystemInfo?.mCurrentST25SdkTagInstance
        self.miOSReaderSession = iOSReaderSession(atagReaderSessionViewControllerDelegate: self)
      }

    private func modifyPassword(){
        if mTag is ST25TVTag {
            modifyPassword(tag: mTag as! ST25TVTag)
        }else if mTag is ST25DVTag {
            modifyPassword(tag: mTag as! ST25DVTag)
        } else if mTag is ST25DVCTag {
            modifyPassword(tag: mTag as! ST25DVCTag)
        } else if self.mTag is ST25DVPwmTag {
            modifyPassword(tag: mTag as! ST25DVPwmTag)
        } else if self.mTag is ST25TV64KTag {
            modifyPassword(tag: mTag as! ST25TV64KTag)
        } else if self.mTag is ST25TV16KTag {
            modifyPassword(tag: mTag as! ST25TV16KTag)
        } else if self.mTag is ST25TVCTag {
            modifyPassword(tag: mTag as! ST25TVCTag)
        } else{
            UIHelper.UI() {
                self.warningAlert( message: "Tag does not support this feature")
            }
        }
    }
    
    private func modifyPassword(tag:ST25TVTag) {
        let pwdIOSByteArray = IOSByteArray.init(nsData: mST25ConfigurationPwdNew)
        tag.presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25tvST25TVTag_ST25TV_CONFIGURATION_PASSWORD_ID), password: mST25ConfigurationPwd)
        tag.writePassword(with: jint(ComStSt25sdkType5St25tvST25TVTag_ST25TV_CONFIGURATION_PASSWORD_ID), with: pwdIOSByteArray!)
    }
    
    private func modifyPassword(tag:ST25DVTag) {
        let pwdIOSByteArray = IOSByteArray.init(nsData: mST25ConfigurationPwdNew)
        tag.presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25dvST25DVTag_ST25DV_CONFIGURATION_PASSWORD_ID), password: mST25ConfigurationPwd)
        tag.writePassword(with: jint(ComStSt25sdkType5St25dvST25DVTag_ST25DV_CONFIGURATION_PASSWORD_ID), with: pwdIOSByteArray!)
    }
    
    private func modifyPassword(tag:ST25DVCTag) {
        let pwdIOSByteArray = IOSByteArray.init(nsData: mST25ConfigurationPwdNew)
        tag.presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25dvST25DVTag_ST25DV_CONFIGURATION_PASSWORD_ID), password: mST25ConfigurationPwd)
        tag.writePassword(with: jint(ComStSt25sdkType5St25dvST25DVTag_ST25DV_CONFIGURATION_PASSWORD_ID), with: pwdIOSByteArray!)
    }
    
    private func modifyPassword(tag:ST25TV16KTag) {
        let pwdIOSByteArray = IOSByteArray.init(nsData: mST25ConfigurationPwdNew)
        tag.presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25dvST25TV16KTag.ST25TVHighDensity_CONFIGURATION_PASSWORD_ID), password: mST25ConfigurationPwd)
        tag.writePassword(with: jint(ComStSt25sdkType5St25dvST25TV16KTag.ST25TVHighDensity_CONFIGURATION_PASSWORD_ID), with: pwdIOSByteArray!)
    }
    private func modifyPassword(tag:ST25TV64KTag) {
        let pwdIOSByteArray = IOSByteArray.init(nsData: mST25ConfigurationPwdNew)
        tag.presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25dvST25TV64KTag.ST25TVHighDensity_CONFIGURATION_PASSWORD_ID), password: mST25ConfigurationPwd)
        tag.writePassword(with: jint(ComStSt25sdkType5St25dvST25TV64KTag.ST25TVHighDensity_CONFIGURATION_PASSWORD_ID), with: pwdIOSByteArray!)
    }
    
    private func modifyPassword(tag:ST25DVPwmTag) {
        let pwdIOSByteArray = IOSByteArray.init(nsData: mST25ConfigurationPwdNew)
        tag.presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25dvpwmST25DVPwmTag_ST25DVPWM_CONFIGURATION_PASSWORD_ID), password: mST25ConfigurationPwd)
        tag.writePassword(with: jint(ComStSt25sdkType5St25dvpwmST25DVPwmTag_ST25DVPWM_CONFIGURATION_PASSWORD_ID), with: pwdIOSByteArray!)
    }
    
    private func modifyPassword(tag:ST25TVCTag) {
        let pwdIOSByteArray = IOSByteArray.init(nsData: mST25ConfigurationPwdNew)
        tag.presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25tvcST25TVCTag_ST25TVC_CONFIGURATION_PASSWORD_ID), password: mST25ConfigurationPwd)
        tag.writePassword(with: jint(ComStSt25sdkType5St25tvcST25TVCTag_ST25TVC_CONFIGURATION_PASSWORD_ID), with: pwdIOSByteArray!)
    }
    
    private func changeLockConfigurationRegister() {
        if mTag is ST25TVTag {
           changeLockConfigurationRegister(tag: mTag as! ST25TVTag)
        } else if mTag is ST25DVTag {
           changeLockConfigurationRegister(tag: mTag as! ST25DVTag)
        } else  if mTag is ST25DVCTag {
            changeLockConfigurationRegister(tag: mTag as! ST25DVCTag)
         } else if self.mTag is ST25DVPwmTag {
            changeLockConfigurationRegister(tag: mTag as! ST25DVPwmTag)
        } else if self.mTag is ST25TV64KTag {
            changeLockConfigurationRegister(tag: mTag as! ST25TV64KTag)
        } else if self.mTag is ST25TV16KTag {
            changeLockConfigurationRegister(tag: mTag as! ST25TV16KTag)
        } else if self.mTag is ST25TVCTag {
            // handled directly by button
            UIHelper.UI() {
                self.warningAlert( message: "Lock features managed in an other way")
            }        } else{
            UIHelper.UI() {
                self.warningAlert( message: "Tag does not support this feature")
            }
        }
    }
    
    private func changeLockConfigurationRegister(tag:ST25TVTag) {
        tag.presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25tvST25TVTag_ST25TV_CONFIGURATION_PASSWORD_ID), password: mST25ConfigurationPwd)
        tag.lockConfiguration()
    }
 
    private func changeLockConfigurationRegister(tag:ST25TVCTag) {
        TabItem.ST25TVCLockConfiguration.withNC = false

        let vc = TabItem.ST25TVCLockConfiguration.toViewController()
        if let navigator = navigationController {
            navigator.pushViewController(vc, animated: false)
        }
    }
    
    private func changeLockConfigurationRegister(tag:ST25DVTag) {
        tag.presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25dvST25DVTag_ST25DV_CONFIGURATION_PASSWORD_ID), password: mST25ConfigurationPwd)
        tag.lockConfiguration()
    }

    private func changeLockConfigurationRegister(tag:ST25DVCTag) {
        tag.presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25dvST25DVTag_ST25DV_CONFIGURATION_PASSWORD_ID), password: mST25ConfigurationPwd)
        tag.lockConfiguration()
    }
    
    private func changeLockConfigurationRegister(tag:ST25TV16KTag) {
        tag.presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25dvST25TV16KTag.ST25TVHighDensity_CONFIGURATION_PASSWORD_ID), password: mST25ConfigurationPwd)
        tag.lockConfiguration()
    }
    private func changeLockConfigurationRegister(tag:ST25TV64KTag) {
        tag.presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25dvST25TV64KTag.ST25TVHighDensity_CONFIGURATION_PASSWORD_ID), password: mST25ConfigurationPwd)
        tag.lockConfiguration()
    }
    private func changeLockConfigurationRegister(tag:ST25DVPwmTag) {
        tag.presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25dvpwmST25DVPwmTag_ST25DVPWM_CONFIGURATION_PASSWORD_ID), password: mST25ConfigurationPwd)
        tag.lockConfiguration()
    }
    
    private func getNewConfigurationPwd(){
        if self.mTag is ST25TVTag || self.mTag is ST25DVPwmTag || self.mTag is ST25TVCTag {
            getNewConfigurationPwd(nbOfBytes: 4)
        }else if self.mTag is ST25DVTag || self.mTag is ST25DVCTag || self.mTag is ST25TV16KTag || self.mTag is ST25TV64KTag {
            getNewConfigurationPwd(nbOfBytes: 8)
        }else{
            UIHelper.UI() {
                self.warningAlert( message: "Tag does not support this feature")
            }
        }
    }
    private func getNewConfigurationPwd(nbOfBytes:UInt8) {
        let mST25PasswordVC:ST25PasswordViewController = UIStoryboard(name: "ST25Password", bundle: nil).instantiateViewController(withIdentifier: "ST25PasswordID") as! ST25PasswordViewController
        mST25PasswordVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        mST25PasswordVC.setTitle("Enter new configuration password")

        mST25PasswordVC.numberOfBytes = Int(nbOfBytes)
        if (nbOfBytes == 4){
           mST25PasswordVC.setMessage("(32 bits hexadecimal format)")
        }else{
           mST25PasswordVC.setMessage("(64 bits hexadecimal format)")
        }
        
        mST25PasswordVC.delegate = self
        self.present(mST25PasswordVC, animated: false, completion: nil)
    }
    
    private func getCurrentConfigurationPwd(){
        if self.mTag is ST25TVTag || self.mTag is ST25DVPwmTag || self.mTag is ST25TVCTag{
            getCurrentConfigurationPwd(nbOfBytes: 4)
        }else if self.mTag is ST25DVTag || self.mTag is ST25DVCTag || self.mTag is ST25TV16KTag || self.mTag is ST25TV64KTag {
            getCurrentConfigurationPwd(nbOfBytes: 8)
        }else{
            UIHelper.UI() {
                self.warningAlert( message: "Tag does not support this feature")
            }
        }
    }

    private func getCurrentConfigurationPwd(nbOfBytes:UInt8) {
        let mST25PasswordVC:ST25PasswordViewController = UIStoryboard(name: "ST25Password", bundle: nil).instantiateViewController(withIdentifier: "ST25PasswordID") as! ST25PasswordViewController
        mST25PasswordVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        mST25PasswordVC.setTitle("Enter current configuration password")

        mST25PasswordVC.numberOfBytes = Int(nbOfBytes)
        if (nbOfBytes == 4){
            mST25PasswordVC.setMessage("(32 bits hexadecimal format)")
        }else{
            mST25PasswordVC.setMessage("(64 bits hexadecimal format)")
        }
            
        mST25PasswordVC.delegate = self
        self.present(mST25PasswordVC, animated: false, completion: nil)
    }

    
    private func warningAlert(message : String) {
        UIHelper.warningAlert(viewController: self, title : "Password update" , message: message)
    }

}

extension ST25ConfigurationPasswordViewController: ST25PasswordViewDelegate {
    func okButtonTapped(pwdValue: Data) {
        if self.mTaskToDo == .getConfigurationPassword {
             self.mST25ConfigurationPwd = pwdValue
             DispatchQueue.main.async {
                 self.mTaskToDo = .changeConfigurationPassword
                 self.getNewConfigurationPwd()
             }

         }
         if self.mTaskToDo == .changeConfigurationPassword {
             self.mST25ConfigurationPwdNew = pwdValue
             self.mTaskToDo = .changeConfigurationPassword
             self.miOSReaderSession.startTagReaderSession()
         }

        if self.mTaskToDo == .getlockConfiguration {
            self.mST25ConfigurationPwd = pwdValue
            self.mTaskToDo = .lockConfiguration
            self.miOSReaderSession.startTagReaderSession()
            
        }
    }
    

    func cancelButtonTapped() {
        if mTaskToDo == .changeConfigurationPassword {
            mTaskToDo = .getConfigurationPassword
        }
        if mTaskToDo == .lockConfiguration {
            mTaskToDo = .getlockConfiguration
        }
    }
}

extension ST25ConfigurationPasswordViewController: tagReaderSessionViewControllerDelegate {
    
    func handleTag(st25SDKTag: ComStSt25sdkNFCTag, uid: Data!) throws {
        
        // Check if tag has changed
        if (!isSameTag(uid: uid)) {
            miOSReaderSession.stopTagReaderSession("Tag has changed, please scan again the Tag ...")
            return
        }
        mTag = st25SDKTag
        switch mTaskToDo {
        case .changeConfigurationPassword:
            modifyPassword()
        case .getConfigurationPassword:
            nop()
        case .getlockConfiguration:
            nop()
        case .lockConfiguration:
            changeLockConfigurationRegister()
        }
    }
    
    private func nop() {
    }

    func handleTagSessionError(didInvalidateWithError error: Error) {
        //print(" ==== entry > handleTagSessionEnd in controller : \(self.mTaskToDo)")
        let errorNFC = error as! NFCReaderError
        if errorNFC.code ==  NFCReaderError.readerSessionInvalidationErrorSessionTimeout {
            // session Timeout detected
            // restart a session to continu
            //invalidateGridStatus()
        }
        else if errorNFC.code ==  NFCReaderError.readerSessionInvalidationErrorUserCanceled {
        }
    }
    
    func handleTagST25SdkError(didInvalidateWithError error: NSException) {
        miOSReaderSession.stopTagReaderSession("Command failed: \(error.description)")
    }
    
}
