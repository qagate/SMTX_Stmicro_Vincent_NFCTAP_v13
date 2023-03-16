//
//  ST25DVMailboxManagementViewController.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 31/10/2019.
//  Copyright © 2019 STMicroelectronics. All rights reserved.
//

import UIKit




class ST25DVMailboxManagementViewController: ST25UIViewController, tagReaderSessionViewControllerDelegate {
    
    
    internal var mTag : ComStSt25sdkNFCTag!

    internal var miOSReaderSession:iOSReaderSession!
    internal var mST25DVConfigurationPwd:Data!
    
    var mEnableMB : Bool?
    private  var  mHostPutMsg: Bool?
    private  var  mRfPutMsg: Bool?
    private  var  mHostMissMsg: Bool?
    private  var  mRfMissMsg: Bool?
    
    private var imageChecked = UIImage(named: "checked")
    private var imageUnchecked = UIImage(named: "unchecked")

    enum taskToDo {
        case initMB
        case enableMB
        case disableMB
        case refreshStatus
        case resetMailbox
    }
    internal var mTaskToDo:taskToDo = .initMB
    
    
    @IBOutlet weak var mMailBoxEnableSwitch: UISwitch!
    
    @IBOutlet weak var mailboxEnabledImage: UIImageView!
    @IBOutlet weak var msgPutViaSerialImage: UIImageView!
    @IBOutlet weak var msgMissedBySerialImage: UIImageView!
    @IBOutlet weak var msgPutViaRFImage: UIImageView!
    @IBOutlet weak var msgMissedByRFImage: UIImageView!
    
    

    
    @IBAction func enableMailBox(_ sender: Any) {
        if (self.mMailBoxEnableSwitch.isOn){
            //enableMB()
            mTaskToDo = .enableMB
        }else{
            //disableMB()
            mTaskToDo = .disableMB
        }
        presentPwdController()
        //miOSReaderSession.startTagReaderSession()
    }
    
    @IBAction func refreshStatusAction(_ sender: Any) {
        mTaskToDo = .refreshStatus
        miOSReaderSession.startTagReaderSession()
        
    }
    @IBAction func resetMailBoxAction(_ sender: Any) {
        mTaskToDo = .resetMailbox
        miOSReaderSession.startTagReaderSession()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Mailbox management"

        self.miOSReaderSession = iOSReaderSession(atagReaderSessionViewControllerDelegate: self)
        mTaskToDo = .initMB
        mEnableMB = false;
        miOSReaderSession.startTagReaderSession()
        
        // Do any additional setup after loading the view.
    }
    
    
    func handleTagSessionError(didInvalidateWithError error: Error) {
        
    }

    func handleTagST25SdkError(didInvalidateWithError error: NSException) {
        
        if mTaskToDo == taskToDo.enableMB || mTaskToDo == taskToDo.disableMB {
            print(error.description)
            DispatchQueue.main.async {
                self.mMailBoxEnableSwitch.setOn(self.mEnableMB!, animated: true)
                self.warningAlert(message: "Command failed: \(error.description)")
            }
        }
    }

    func handleTag(st25SDKTag: ComStSt25sdkNFCTag, uid: Data!) throws {

        if (!(st25SDKTag is ST25DVTag || st25SDKTag is ST25DVCTag)){
            UIHelper.UI() {
                self.warningAlert(message: "Tag do not support this feature ...")
            }
            return
        }
        if self.isSameTag(uid: uid) {
            mTag = st25SDKTag
            switch mTaskToDo {
            case .initMB:
                initMB()
            case .enableMB:
                enableMB()
            case .disableMB:
                disableMB()
            case .refreshStatus:
                refreshStatus()
            case .resetMailbox:
                resetMailbox()
            }
            
        } else {
            //print((TabItem.TagInfo.mainVC as! ST25TagInformationViewController).productId?.description)
            //print(uid.toHexString())
            UIHelper.UI() {
                self.warningAlert(message: "Tag has changed, please scan again the Tag ...")
            }
        }

        
    }
    
    
    private func initMB() {
        //print("init MB")
        if mTag is ST25DVTag {
            updateMailboxStatus(myTag: mTag as! ST25DVTag)
        } else if mTag is ST25DVCTag {
            updateMailboxStatus(myTag: mTag as! ST25DVCTag)
        }
    }
    
    private func putStatusImage(view : UIImageView, checked : Bool) {
        if checked {
            view.image = imageChecked
        } else {
            view.image = imageUnchecked
        }
    }
    
    private func updateMailboxStatus(myTag : ST25DVTag) {
        mEnableMB = myTag.isMailboxEnabled(withBoolean: false)
        mHostPutMsg = myTag.hasHostPutMsg(refresh: false)
        mRfPutMsg = myTag.hasRFPutMsg(refresh: false)
        mHostMissMsg = myTag.hasHostMissMsg(refresh: false)
        mRfMissMsg = myTag.hasRFMissMsg(refresh: false)
        updateUIStatus()

    }
    private func updateMailboxStatus(myTag : ST25DVCTag) {
        mEnableMB = myTag.isMailboxEnabled(withBoolean: false)
        mHostPutMsg = myTag.hasHostPutMsg(refresh: false)
        mRfPutMsg = myTag.hasRFPutMsg(refresh: false)
        mHostMissMsg = myTag.hasHostMissMsg(refresh: false)
        mRfMissMsg = myTag.hasRFMissMsg(refresh: false)
        updateUIStatus()

    }
    private func updateUIStatus() {
        DispatchQueue.main.sync {
            mMailBoxEnableSwitch.setOn(mEnableMB!, animated: true)

            putStatusImage(view: mailboxEnabledImage, checked: mEnableMB!)
            putStatusImage(view: msgPutViaSerialImage, checked: mHostPutMsg!)
            putStatusImage(view: msgMissedBySerialImage, checked: mHostMissMsg!)
            putStatusImage(view: msgPutViaRFImage, checked: mRfPutMsg!)
            putStatusImage(view: msgMissedByRFImage, checked: mRfMissMsg!)
        }
    }
    
    private func enableMB() {
        //print("enableMB MB")
        //let pwd:Data = Data([0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00])
        if mTag is ST25DVTag {
            (mTag as! ST25DVTag).presentPassword(passwordNumber: 0x00, password: self.mST25DVConfigurationPwd)
            (mTag as! ST25DVTag).enableMailbox()
            updateMailboxStatus(myTag: (mTag as! ST25DVTag))

        } else if mTag is ST25DVCTag {
            (mTag as! ST25DVCTag).presentPassword(passwordNumber: 0x00, password: self.mST25DVConfigurationPwd)
            (mTag as! ST25DVCTag).enableMailbox()
            updateMailboxStatus(myTag: (mTag as! ST25DVCTag))
            
        }
    }
    
    private func disableMB() {
        //print("disable MB")
        //let pwd:Data = Data([0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00])
       if mTag is ST25DVTag {
            (mTag as! ST25DVTag).presentPassword(passwordNumber: 0x00, password: self.mST25DVConfigurationPwd)
            (mTag as! ST25DVTag).disableMailbox()
            updateMailboxStatus(myTag: (mTag as! ST25DVTag))

        } else if mTag is ST25DVCTag {
            (mTag as! ST25DVCTag).presentPassword(passwordNumber: 0x00, password: self.mST25DVConfigurationPwd)
            (mTag as! ST25DVCTag).disableMailbox()
            updateMailboxStatus(myTag: (mTag as! ST25DVCTag))
            
        }
     }
    
    private func refreshStatus() {
        //print("refreshStatus MB")
        if mTag is ST25DVTag {
              updateMailboxStatus(myTag: (mTag as! ST25DVTag))
         } else if mTag is ST25DVCTag {
             updateMailboxStatus(myTag: (mTag as! ST25DVCTag))
         }
    }
    
    private func resetMailbox() {
        //print("stopTransfer MB")
        if mTag is ST25DVTag {
             (mTag as! ST25DVTag).presentPassword(passwordNumber: 0x00, password: self.mST25DVConfigurationPwd)
             (mTag as! ST25DVTag).resetMailbox()
             updateMailboxStatus(myTag: (mTag as! ST25DVTag))

         } else if mTag is ST25DVCTag {
             (mTag as! ST25DVCTag).presentPassword(passwordNumber: 0x00, password: self.mST25DVConfigurationPwd)
             (mTag as! ST25DVCTag).resetMailbox()
             updateMailboxStatus(myTag: (mTag as! ST25DVCTag))
             
         }
    }
    

    
    private func warningAlert(message : String) {
        UIHelper.warningAlert(viewController: self, title : "Mailbox management" , message: message)
    }
    
    private func presentPwdController() {
        let mST25PasswordVC:ST25PasswordViewController = UIStoryboard(name: "ST25Password", bundle: nil).instantiateViewController(withIdentifier: "ST25PasswordID") as! ST25PasswordViewController
        mST25PasswordVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        mST25PasswordVC.setTitle("Enter configuration password")
        mST25PasswordVC.setMessage("(64 bits hexadecimal format)")
        mST25PasswordVC.numberOfBytes = 8
        mST25PasswordVC.delegate = self
        self.present(mST25PasswordVC, animated: false, completion: nil)
    }

}


extension ST25DVMailboxManagementViewController: ST25PasswordViewDelegate {
    func okButtonTapped(pwdValue: Data) {
        self.mST25DVConfigurationPwd = pwdValue
        self.miOSReaderSession.startTagReaderSession()
    }

    func cancelButtonTapped() {
    }
}


