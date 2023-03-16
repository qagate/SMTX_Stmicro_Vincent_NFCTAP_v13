//
//  ST25LockBlockViewController.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 03/03/2020.
//  Copyright © 2020 STMicroelectronics. All rights reserved.
//

import UIKit
import CoreNFC


class ST25LockBlockViewController: ST25UIViewController  {
    
    internal var miOSReaderSession:iOSReaderSession!
    internal var mTag : ComStSt25sdkNFCTag!
    internal var mType5Tag:Type5Tag! // used for commands type5 directly.
    
    enum BlockStatus : String {
        case UNKNOWN = "UNKNOWN"
        case LOCKED = "LOCKED"
        case UNLOCKED = "UNLOCKED"
    }
    private let LOCK_FLAG = 0x01 // as defined in ISO15693-3
    
    enum taskToDo {
        case checkBlockStatus
        case lockBlock
    }
    
    internal var mTaskToDo:taskToDo!
    
    private var mCurrentBlockNumber : Int!
    
    private var mToolBarAccessoryView : UIToolbar?
    
    @IBOutlet weak var mBlockNumberField: UITextField!
    @IBOutlet weak var mBlockStatusTextField: UILabel!
    
    @IBAction func userTappedBackground(_ sender: Any) {
        mBlockNumberField.endEditing(true)
    }
    
    @IBAction func checkBlockStatusButtonAction(_ sender: UIButton) {
        self.mCurrentBlockNumber = Int(mBlockNumberField.text!)
        if self.mCurrentBlockNumber != nil {
            mTaskToDo = .checkBlockStatus
            self.miOSReaderSession.startTagReaderSession()
        } else {
            warningAlert(message: "Wrong block number")
        }
    }
    
    @IBAction func lockBlockButtonAction(_ sender: UIButton) {
        self.mCurrentBlockNumber = Int(mBlockNumberField.text!)
        if self.mCurrentBlockNumber != nil {
            mTaskToDo = .lockBlock
            confirmationLockDialog()
        } else {
            warningAlert(message: "Wrong block number")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Lock block features"
        mBlockNumberField.delegate = self
        mBlockNumberField.text = "0"
        self.miOSReaderSession = iOSReaderSession(atagReaderSessionViewControllerDelegate: self)

    }
    
    private func checkTagBlockStatus() {
        var answer : IOSByteArray!
        let flag : jbyte = ComStSt25sdkCommandIso15693Command.OPTION_FLAG |
        ComStSt25sdkCommandIso15693Command.HIGH_DATA_RATE_MODE |
        ComStSt25sdkCommandIso15693Command.ADDRESSED_MODE
        
        if self.mCurrentBlockNumber < 256 {
            answer = mType5Tag.readSingleBlock(with: jint(self.mCurrentBlockNumber), withByte: flag)
        } else {
            answer = mType5Tag.extendedReadSingleBlock(with: jint(self.mCurrentBlockNumber), withByte: flag)
        }

        if answer != nil && answer.length() == 6 && answer.byte(at: 0) == 0 {
            updateUIBlockStatus(lockByteValue: Int(answer.byte(at: 1)))
        } else {
            // update status with UNKNOWN
            updateUIBlockStatus(lockByteValue: -1)
        }
    }

    private func updateUIBlockStatus (lockByteValue : Int) {
        if lockByteValue < 0 {
            // UNKNOWN
            UIHelper.UI() {
                self.mBlockStatusTextField.text = BlockStatus.UNKNOWN.rawValue
            }
            return
        }
        if lockByteValue == LOCK_FLAG {
            // LOCKED
            UIHelper.UI() {
                self.mBlockStatusTextField.text = BlockStatus.LOCKED.rawValue
            }
            
        } else {
            // UNKLOCKED
            UIHelper.UI() {
                self.mBlockStatusTextField.text = BlockStatus.UNLOCKED.rawValue
            }
        }
    }

    private func lockBlockOnTag() {
        if self.mCurrentBlockNumber < 256 {
            mType5Tag.lockSingleBlock(with: jint(self.mCurrentBlockNumber))
        } else {
            mType5Tag.extendedLockSingleBlock(with: jint(self.mCurrentBlockNumber))
        }

        updateUIBlockStatus(lockByteValue: LOCK_FLAG)
    }
    
    private func warningAlert(message : String) {
        UIHelper.warningAlert(viewController: self, title : "Lock block features" , message: message)
    }
    
    
    private func confirmationLockDialog() {
        let confirmationDialog = UIAlertController(title: "Lock block is IRREVERSIBLE!", message: "Do you really want to lock the block?", preferredStyle: UIAlertController.Style.alert)

        confirmationDialog.addAction(UIAlertAction(title: "Lock block", style: .default, handler: { (action: UIAlertAction!) in
            self.mTaskToDo = .lockBlock
            self.miOSReaderSession.startTagReaderSession()
        }))

        confirmationDialog.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
              //print("Action cancelled: Lock kill password")
        }))
        present(confirmationDialog, animated: true, completion: nil)
    }


    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if mToolBarAccessoryView == nil {
            mToolBarAccessoryView = UIToolbar.init(frame:
                CGRect.init(x: 0, y: 0,
                width: self.view.frame.size.width, height: 44))
            let done = UIBarButtonItem.init(title: "Done",
                        style: .plain, target: self, action: #selector(doBtnDone))
            mToolBarAccessoryView?.items = [done]
        }
        // set the tool bar as this text field's input accessory view
        textField.inputAccessoryView = mToolBarAccessoryView
        return true
    }
    @objc
    func doBtnDone() {
        mBlockNumberField.resignFirstResponder()
        self.view.endEditing(true)
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.mCurrentBlockNumber = Int(mBlockNumberField.text!)

    }


}

extension ST25LockBlockViewController: tagReaderSessionViewControllerDelegate {
    
    func handleTag(st25SDKTag: ComStSt25sdkNFCTag, uid: Data!) throws {
        mTag = st25SDKTag
        mType5Tag = Type5Tag.init(RFReaderInterface: mTag.getReaderInterface() as! iOSRFReaderInterface, uid: (mTag.getUid()?.toNSData())!)
        if self.isSameTag(uid: uid) {
            switch mTaskToDo {
            case .checkBlockStatus:
                //print("kill tag")
                self.checkTagBlockStatus()
            case .lockBlock:
                //print ("Change kill password")
                self.lockBlockOnTag()
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
        updateUIBlockStatus(lockByteValue: -1)
    }
    
}
