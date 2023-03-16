//
//  ST25TVCLockConfigurationViewController.swift
//  NFCTap 
//
//  Created by STMicroelectronics on 12/11/2020.
//  Copyright © 2020 STMicroelectronics. All rights reserved.
//

import UIKit

class ST25TVCLockConfigurationViewController: ST25UIViewController {
    
    @IBOutlet weak var childLockConfigurationVc: UIView!
    
    @IBAction func handleReadButton(_ sender: Any) {
        self.mTaskToDo = .readLockConf
        miOSReaderSession = iOSReaderSession(atagReaderSessionViewControllerDelegate: self)
        miOSReaderSession.startTagReaderSession()
    }
    
    @IBAction func handleLockButton(_ sender: Any) {
        let alert = UIAlertController(title: "Lock Configuration ", message: "Lock is irreversible. Do you want to continue ? ", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self] action in
            // Get config from UI table view
            mLckarray = lockConfigurationTableVC.getLockConfigUI()
            self.mTaskToDo = .updateLockConf
            presentPwdController()
        }))
       
        alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    // NFC Variables
    internal var miOSReaderSession:iOSReaderSession!
    internal var mPwd:Data!
    internal var mTag:ComStSt25sdkNFCTag!
    internal var mST25TVCTag:ST25TVCTag!
    internal var mUid:Data!

    enum taskToDo {
        case readLockConf
        case updateLockConf
    }
    internal var mTaskToDo:taskToDo = .readLockConf
    
    // Reference to the tableviewController of lock conf
    static let childLockConfigurationSeque = "childLockConfigurationSeque"
    internal var lockConfigurationTableVC:ST25TVCLockConfigurationTableTableViewController!

    // Init a default config lock structure array
    internal var mLckarray:[statusLockConfigStruct]!
        
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.mTaskToDo = .readLockConf
        miOSReaderSession = iOSReaderSession(atagReaderSessionViewControllerDelegate: self)
        miOSReaderSession.startTagReaderSession()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ST25TVCLockConfigurationViewController.childLockConfigurationSeque {
            lockConfigurationTableVC = segue.destination as? ST25TVCLockConfigurationTableTableViewController
            mLckarray = lockConfigurationTableVC.getLockConfigUI()
        }
    }

    private func warningAlert(message : String) {
         DispatchQueue.main.async {
             let alert = UIAlertController(title: "Lock Configuration ", message: message, preferredStyle: .alert)
             alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
             self.present(alert, animated: true, completion: nil)
         }
     }
    
    private func warningAlertLock() {
         DispatchQueue.main.async {
             let alert = UIAlertController(title: "Lock Configuration ", message: "Lock is irreversible. Do you want to continue ? ", preferredStyle: .alert)
             alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                print("Yay! You brought your towel!")
            }))
            
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { action in
               print("Yay! You brought your towel!")
           }))
             self.present(alert, animated: true, completion: nil)
         }
     }
    
    // Password
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
    
    // NFC Access
    private func readConf(){
        mLckarray[lockConfigurationId.lckAfi.rawValue].statusRead = self.mST25TVCTag.isAfiProtectionConfigurationLocked()
        mLckarray[lockConfigurationId.lckPriv.rawValue].statusRead = self.mST25TVCTag.isPrivConfigurationLocked()
        mLckarray[lockConfigurationId.lckAndef.rawValue].statusRead = self.mST25TVCTag.isAndefConfigurationLocked()
        mLckarray[lockConfigurationId.lckTd.rawValue].statusRead = self.mST25TVCTag.isTamperDetectConfigurationLocked()
        mLckarray[lockConfigurationId.lckUtc.rawValue].statusRead = self.mST25TVCTag.isUniqueTapCodeConfigurationLocked()
        mLckarray[lockConfigurationId.LckA2r.rawValue].statusRead = self.mST25TVCTag.isArea2ConfigurationLocked()
        mLckarray[lockConfigurationId.LckA1r.rawValue].statusRead = self.mST25TVCTag.isArea1ConfigurationLocked()
        
        UIHelper.UI { [self] in
            lockConfigurationTableVC.updateUI(lockArray:mLckarray)
        }
    }
    
    // update conf only if status read is Unlocked AND switch is set. If we try to configure a lock already locked, we get an exception.
    private func updateConf(){
        setPwd()
        if (mLckarray[lockConfigurationId.lckAfi.rawValue].statusRead != true && mLckarray[lockConfigurationId.lckAfi.rawValue].statusSwitch == true){
            self.mST25TVCTag.lockAfiSecConfiguration()
        }
        
        if (mLckarray[lockConfigurationId.lckPriv.rawValue].statusRead != true && mLckarray[lockConfigurationId.lckPriv.rawValue].statusSwitch == true){
            self.mST25TVCTag.lockPrivConfiguration()
        }
        
        if (mLckarray[lockConfigurationId.lckAndef.rawValue].statusRead != true && mLckarray[lockConfigurationId.lckAndef.rawValue].statusSwitch == true){
            self.mST25TVCTag.lockAndefConfiguration()
        }
        
        if (mLckarray[lockConfigurationId.lckTd.rawValue].statusRead != true && mLckarray[lockConfigurationId.lckTd.rawValue].statusSwitch == true){
            self.mST25TVCTag.lockTamperDetectConfiguration()
        }
        
        if (mLckarray[lockConfigurationId.lckUtc.rawValue].statusRead != true && mLckarray[lockConfigurationId.lckUtc.rawValue].statusSwitch == true){
            self.mST25TVCTag.lockUniqueTapCodeConfiguration()
        }
        
        if (mLckarray[lockConfigurationId.LckA2r.rawValue].statusRead != true && mLckarray[lockConfigurationId.LckA2r.rawValue].statusSwitch == true){
            self.mST25TVCTag.lockArea2Configuration()
        }
        
        if (mLckarray[lockConfigurationId.LckA1r.rawValue].statusRead != true && mLckarray[lockConfigurationId.LckA1r.rawValue].statusSwitch == true){
            self.mST25TVCTag.lockArea1Configuration()
        }
        
        // Re Read conf to be sure that all is ok
        readConf()
    }
}

extension ST25TVCLockConfigurationViewController: ST25PasswordViewDelegate {
    func okButtonTapped(pwdValue: Data) {
        self.mPwd = pwdValue
        self.miOSReaderSession.startTagReaderSession()
    }

    func cancelButtonTapped() {
    }
}

extension ST25TVCLockConfigurationViewController: tagReaderSessionViewControllerDelegate {
   
    func handleTag(st25SDKTag: ComStSt25sdkNFCTag, uid: Data!) throws {
        self.mTag = st25SDKTag
        if (self.mTag is ST25TVCTag){
            self.mST25TVCTag = self.mTag as? ST25TVCTag
            self.mUid = uid
            if self.isSameTag(uid: uid) {
                switch mTaskToDo {
                case .readLockConf:
                    readConf()
                case .updateLockConf:
                    updateConf()
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
