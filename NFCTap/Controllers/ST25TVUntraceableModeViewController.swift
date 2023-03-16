//
//  ST25TVUntraceableModeViewController.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 2/25/20.
//  Copyright © 2020 STMicroelectronics. All rights reserved.
//

import UIKit


class ST25TVUntraceableModeViewController: ST25UIViewController {

    internal var mTag:ComStSt25sdkNFCTag!
    internal var mST25TVTag:ST25TVTag!
    internal var mST25TVCTag:ST25TVCTag!
    
    internal var miOSReaderSession:iOSReaderSession!
    internal var mST25TVConfigurationPwd:Data!
    
    enum taskToDo {
        case enableUntraceableMode  // Not used for the meantime as Addressed mode not supported in iOS14
        case getOutUntraceableMode
        case changePassword         // Not used for the meantime as Addressed mode not supported in iOS14

    }
    internal var mTaskToDo:taskToDo = .enableUntraceableMode
    
    @IBAction func enableUntraceableMode(_ sender: Any) {
        self.mTaskToDo = .enableUntraceableMode
        UIHelper.warningAlert(viewController: self, title: "WARNING! After enabling Untraceable mode, the tag won't be usable anymore on iPhone.", message: "")
        self.presentPwdController("Please enter Untraceable Mode Password")
    }
    
    @IBAction func getOutUntraceableMode(_ sender: Any) {
        self.mTaskToDo = .getOutUntraceableMode
        self.presentPwdController("Please enter Untraceable Mode Password")
    }
    
    
    @IBAction func changePwd(_ sender: Any) {
        self.mTaskToDo = .changePassword
        self.presentPwdController("Enter New Untraceable Mode Password")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Untraceable mode"
        miOSReaderSession = iOSReaderSession(atagReaderSessionViewControllerDelegate: self)
    }

    // Not used for the meantime as Addressed mode not supported in iOS14
    private func enableUntraceableMode() {
        if mTag is ST25TVTag {
            (mTag as! ST25TVTag).enableUntraceableMode(with: IOSByteArray.init(nsData: mST25TVConfigurationPwd))
        }else  if mTag is ST25TVCTag {
            (mTag as! ST25TVCTag).toggleUntraceableMode(with: IOSByteArray.init(nsData: mST25TVConfigurationPwd), withByte: jbyte(ComStSt25sdkCommandIso15693Protocol_HIGH_DATA_RATE_MODE | ComStSt25sdkCommandIso15693Protocol_ADDRESSED_MODE & ~ComStSt25sdkCommandIso15693Protocol_SELECTED_MODE))
        }
    }

    // The only one used as Non addressed mode is supported (In Public version ONLY)
    func getOutUntracebleMode(){
        (mTag as! ST25TVCTag).toggleUntraceableMode(with: IOSByteArray.init(nsData: mST25TVConfigurationPwd), withByte: jbyte(ComStSt25sdkCommandIso15693Protocol_HIGH_DATA_RATE_MODE & ~ComStSt25sdkCommandIso15693Protocol_ADDRESSED_MODE & ~ComStSt25sdkCommandIso15693Protocol_SELECTED_MODE))
    }

    // Not used for the meantime as Addressed mode not supported in iOS14
    private func changePwd() {
        if mTag is ST25TVTag {
            (mTag as! ST25TVTag).writeKill(with: IOSByteArray.init(nsData: mST25TVConfigurationPwd))
        }else  if mTag is ST25TVCTag {
            (mTag as! ST25TVCTag).writeKill(with: IOSByteArray.init(nsData: mST25TVConfigurationPwd))
        }
    }
    
    private func presentPwdController(_ title:String) {
        let mST25PasswordVC:ST25PasswordViewController = UIStoryboard(name: "ST25Password", bundle: nil).instantiateViewController(withIdentifier: "ST25PasswordID") as! ST25PasswordViewController
        mST25PasswordVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        mST25PasswordVC.setTitle(title)
        mST25PasswordVC.setMessage("(32 bits hexadecimal format)")
        mST25PasswordVC.numberOfBytes = 4
        mST25PasswordVC.delegate = self
        self.present(mST25PasswordVC, animated: false, completion: nil)
    }
}

extension ST25TVUntraceableModeViewController:tagReaderSessionViewControllerDelegate {
    func handleTag(st25SDKTag: ComStSt25sdkNFCTag, uid: Data!) throws {
        mTag = st25SDKTag
        // Only TV and TVANEF are handled
        if (mTag is ST25TVTag || mTag is ST25TVCTag || uid == mUIDUnTraceable){
           if self.isSameTag(uid: uid) {
                switch self.mTaskToDo {
                case .enableUntraceableMode:
                    self.enableUntraceableMode()
                case .getOutUntraceableMode:
                    self.getOutUntracebleMode()
                case .changePassword:
                    self.changePwd()
                default:
                    UIHelper.warningAlert(viewController: self, title: "ST25TVUntraceableMode", message: "Undefined Action")
                }
            }else{
                UIHelper.UI() {
                    UIHelper.warningAlert(viewController: self, title: "Bad Uid", message: "Tag has changed, please scan again the Tag ...")
                }
            }
        }else{
            UIHelper.UI() {
                UIHelper.warningAlert(viewController: self, title: "Tag not supported", message: "Feature not handled by Tag")
            }
        }
    }
    
      
    func handleTagSessionError(didInvalidateWithError error: Error) {
        miOSReaderSession.stopTagReaderSession("Command failed: \(error)")
    }
    
    func handleTagST25SdkError(didInvalidateWithError error: NSException) {
        // In case of NDA Version, an exception is raised when instanciating Tag.
        // call static function to getOutU+ntraceable Mode
        if (self.mTaskToDo == .getOutUntraceableMode){
            ST25TVCTag.getOutUntracebleModeType5Cmd(aiOSReaderSession: self.miOSReaderSession, aPwd: self.mST25TVConfigurationPwd)
        }else{
            miOSReaderSession.stopTagReaderSession("Command failed: \(error.description)")
        }
    }
    
    
}

extension ST25TVUntraceableModeViewController: ST25PasswordViewDelegate {
    func okButtonTapped(pwdValue: Data) {
        self.mST25TVConfigurationPwd = pwdValue
        self.miOSReaderSession.startTagReaderSession()
    }

    func cancelButtonTapped() {
    }
}
