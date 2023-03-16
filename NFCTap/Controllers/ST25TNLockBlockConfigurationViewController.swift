//
//  ST25TNLockBlockConfigurationViewController.swift
//  NFCTap 
//
//  Created by STMicroelectronics on 12/11/2020.
//  Copyright © 2020 STMicroelectronics. All rights reserved.
//

import UIKit

class ST25TNLockBlockConfigurationViewController: ST25UIViewController {
    
    @IBOutlet weak var childLockConfigurationVc: UIView!
    
    private var mLockBlockArray:[statusLockBlockConfigStruct]!
    
    // NFC & Tags infos
    internal var miOSReaderSession:iOSReaderSession!
    internal var mTag:ComStSt25sdkNFCTag!
    internal var mST25TNTag:ST25TNTag!
    internal var mUid:Data!
    internal var mPwd:Data!

    @IBAction func writeConfig(_ sender: Any) {
        let alert = UIAlertController(title: "Lock Blocks ", message: "You are about to lock some blocks. Lock is irreversible as lock bits are OTP bits. Do you want to continue ? ", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self] action in
            // Get config from UI table view
            mLockBlockArray = lockConfigurationTableVC.getLockConfigUI()
            self.mTaskToDo = .updateLockConf
            miOSReaderSession = iOSReaderSession(atagReaderSessionViewControllerDelegate: self)
            miOSReaderSession.startTagReaderSession()
        }))
       
        alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func readConfig(_ sender: Any) {
        self.mTaskToDo = .readLockConf
        miOSReaderSession = iOSReaderSession(atagReaderSessionViewControllerDelegate: self)
        miOSReaderSession.startTagReaderSession()
    }
    
    enum taskToDo {
        case readLockConf
        case updateLockConf
    }
    internal var mTaskToDo:taskToDo = .readLockConf
    
    // Reference to the tableviewController of lock conf
    static let childLockConfigurationSeque = "childLockConfigurationSeque"
    internal var lockConfigurationTableVC:ST25TNLockBlockConfigurationTableTableViewController!

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
        if segue.identifier == ST25TNLockBlockConfigurationViewController.childLockConfigurationSeque {
            lockConfigurationTableVC = segue.destination as? ST25TNLockBlockConfigurationTableTableViewController
            mLockBlockArray = lockConfigurationTableVC.getLockConfigUI()
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
    
    // Read Lock Registers
    private func readTagLockRegisters() {
        var mLockRegisterArray = lockConfigurationTableVC.getLockRegister()
        
        let statLock0:Int16 = Int16(self.mST25TNTag.getStatLock0()) & 0xFF
        let statLock1:Int16 = Int16(self.mST25TNTag.getStatLock1()) & 0xFF
        let dynLock0:Int16  = Int16(self.mST25TNTag.getDynLock0()) & 0xFF
        let dynLock1:Int16  = Int16(self.mST25TNTag.getDynLock1()) & 0xFF
        let dynLock2:Int16  = Int16(self.mST25TNTag.getDynLock2()) & 0xFF
        let sysLock:Int16   = Int16(self.mST25TNTag.getSysLock())  & 0xFF
                
        for var lockRegisterId in mLockRegisterArray {
            switch lockRegisterId.name {
                
                case "STATLOCK_0":
                    lockRegisterId.val = statLock0
                break;
                
                case "STATLOCK_1":
                    lockRegisterId.val = statLock1
                break;
                
                case "DYNLOCK_0":
                    lockRegisterId.val = dynLock0
                break;

                case "DYNLOCK_1":
                    lockRegisterId.val = dynLock1
                break;
                
                case "DYNLOCK_2":
                    lockRegisterId.val = dynLock2
                break;

               case "SYSLOCK":
                    lockRegisterId.val = sysLock
                break;

                default:
                    break;
            }
            lockConfigurationTableVC.setLockRegisterStruct(lockRegister: lockRegisterId)
        }
    }
        
    // Read Tag Lock Block Config
    private func readTagLockBlockConfig() {
       mLockBlockArray = lockConfigurationTableVC.getLockConfigUI()
        for var lockConfig in mLockBlockArray {
            lockConfig.statusTag = self.isBlockLocked(lockBlockConfig: lockConfig)
            lockConfig.statusUI = lockConfig.statusTag
            UIHelper.UI { [self] in
                lockConfigurationTableVC.updateLockBlockUI(lockBlockConfig: lockConfig)
                // Update extended blocks
                lockConfigurationTableVC.updateExtendedBlocks(lockBlockConfig: lockConfig)

            }
       }
    }
    
    // Write Tag Lock Block Config
    private func writeTagLockBlockConfig() {
        mLockBlockArray = lockConfigurationTableVC.getLockConfigUI()
        for var lockConfig in mLockBlockArray {
            if ( (lockConfig.statusTag == false) && (lockConfig.statusUI == true)){
                mST25TNTag.lock(with: lockConfig.id)
                lockConfig.statusTag = true
                lockConfigurationTableVC.setLockBlockConfigStruct(lockBlockConfig: lockConfig)
            }
       }
    }

    //
    private func isBlockLocked(lockBlockConfig:statusLockBlockConfigStruct) -> Bool {
        return self.mST25TNTag.isLocked(with: lockBlockConfig.id)
    }
}

extension ST25TNLockBlockConfigurationViewController: ST25PasswordViewDelegate {
    func okButtonTapped(pwdValue: Data) {
        self.mPwd = pwdValue
        self.miOSReaderSession.startTagReaderSession()
    }

    func cancelButtonTapped() {
    }
}

extension ST25TNLockBlockConfigurationViewController: tagReaderSessionViewControllerDelegate {
   
    func handleTag(st25SDKTag: ComStSt25sdkNFCTag, uid: Data!) throws {
        self.mTag = st25SDKTag
        if (self.mTag is ST25TNTag){
            self.mST25TNTag = self.mTag as? ST25TNTag
            self.mUid = uid
            if self.isSameTag(uid: uid) {
                switch mTaskToDo {
                case .readLockConf:
                    readTagLockRegisters()
                    readTagLockBlockConfig()
                case .updateLockConf:
                    writeTagLockBlockConfig()
                 }
            } else {

                UIHelper.UI() {
                    self.warningAlert(message: "Tag has changed, please scan again the Tag ...")
                }
            }
        }else{
            UIHelper.UI() {
                self.warningAlert(message: "This is not a ST25TN Tag")
            }
        }
        
    }
    
    func handleTagSessionError(didInvalidateWithError error: Error) {
    }
    
    func handleTagST25SdkError(didInvalidateWithError error: NSException) {
        self.warningAlert(message: error.description)
    }

}
