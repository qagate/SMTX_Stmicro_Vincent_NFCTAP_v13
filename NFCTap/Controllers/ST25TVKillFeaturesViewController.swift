//
//  ST25TVKillFeaturesViewController.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 24/02/2020.
//  Copyright © 2020 STMicroelectronics. All rights reserved.
//

import UIKit
import CoreNFC


class ST25TVKillFeaturesViewController: ST25UIViewController {
    //internal var mTag:ST25TVTag!
    internal var mTag:ComStSt25sdkNFCTag!

    internal var miOSReaderSession:iOSReaderSession!
    internal var mKillPassword:Data!

    enum taskToDo {
        case killTag
        case changeKillPassword
        case lockKillPassword
    }
    
    internal var mTaskToDo:taskToDo!
    
    @IBAction func killTagAction(_ sender: Any) {
        mTaskToDo = .killTag
        presentKillPwdController(title: "Enter kill password. WARNING!the kill action is IRREVERSIBLE!")
    }
    
    @IBAction func lockKillPasswordAction(_ sender: Any) {
        confirmationLockKillPasswordDialog()
    }
    
    @IBAction func changeKillPasswordAction(_ sender: Any) {
        mTaskToDo = .changeKillPassword
        presentKillPwdController(title: "Enter new kill password")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Kill features"

        // Do any additional setup after loading the view.
        self.miOSReaderSession = iOSReaderSession(atagReaderSessionViewControllerDelegate: self)

    }
    
    
    private func killTag () {
        if mTag is ST25TVTag {
            (mTag as! ST25TVTag).kill(with: IOSByteArray.init(nsData: mKillPassword))
        } else if mTag is ST25TVCTag {
            (mTag as! ST25TVCTag).kill(with: IOSByteArray.init(nsData: mKillPassword))
        } else {
        }
    }
    
    private func lockKillPassword () {
        if mTag is ST25TVTag {
            (mTag as! ST25TVTag).lockKill()
        } else if mTag is ST25TVCTag {
            (mTag as! ST25TVCTag).lockKill()
        } else {
        }
    }
    
    
    private func changeKillPassword () {
        if mTag is ST25TVTag {
            (mTag as! ST25TVTag).writeKill(with: IOSByteArray.init(nsData: mKillPassword))
        } else if mTag is ST25TVCTag {
            (mTag as! ST25TVCTag).writeKill(with: IOSByteArray.init(nsData: mKillPassword))
        } else {
        }
    }
    
    
    private func confirmationLockKillPasswordDialog() {
        let confirmationDialog = UIAlertController(title: "Confirmation needed", message: "Do you want to lock the kill password?", preferredStyle: UIAlertController.Style.alert)

        confirmationDialog.addAction(UIAlertAction(title: "Lock password", style: .default, handler: { (action: UIAlertAction!) in
            self.mTaskToDo = .lockKillPassword
            self.miOSReaderSession.startTagReaderSession()
        }))

        confirmationDialog.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
              //print("Action cancelled: Lock kill password")
        }))
        present(confirmationDialog, animated: true, completion: nil)
    }
    
    private func warningAlert(message : String) {
        UIHelper.warningAlert(viewController: self, title : "Kill features" , message: message)
    }

    private func presentKillPwdController(title : String) {
        let mST25PasswordVC:ST25PasswordViewController = UIStoryboard(name: "ST25Password", bundle: nil).instantiateViewController(withIdentifier: "ST25PasswordID") as! ST25PasswordViewController
        mST25PasswordVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        mST25PasswordVC.setTitle(title)

        mST25PasswordVC.setMessage("(32 bits hexadecimal format)")
        mST25PasswordVC.numberOfBytes = 4
        
        mST25PasswordVC.delegate = self
        self.present(mST25PasswordVC, animated: false, completion: nil)
    }
    
}

extension ST25TVKillFeaturesViewController: tagReaderSessionViewControllerDelegate {

    func handleTag(st25SDKTag: ComStSt25sdkNFCTag, uid: Data!) throws {
        self.mTag = st25SDKTag
        if self.isSameTag(uid: uid) {
            switch mTaskToDo {
            case .killTag:
                //print("kill tag")
                self.killTag()
            case .changeKillPassword:
                //print ("Change kill password")
                self.changeKillPassword()
            case .lockKillPassword:
                //print ("lock kill password")
                self.lockKillPassword()
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
        UIHelper.UI() {
            self.warningAlert(message: "Command failed: \(error.description)")
        }
    }
    
}


extension ST25TVKillFeaturesViewController: ST25PasswordViewDelegate {
    func okButtonTapped(pwdValue: Data) {
        if self.mTaskToDo == .killTag {
            //print(pwdValue.toHexString())
            self.mKillPassword = pwdValue
            self.miOSReaderSession.startTagReaderSession()
        }
        if self.mTaskToDo == .changeKillPassword {
            //print(pwdValue.toHexString())
            self.mKillPassword = pwdValue
            self.miOSReaderSession.startTagReaderSession()
        }
    }
    
    func cancelButtonTapped() {
    }
}
