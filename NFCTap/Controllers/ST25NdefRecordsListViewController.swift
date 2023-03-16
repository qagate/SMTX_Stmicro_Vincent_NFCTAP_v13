//
//  ST25NdefRecordsListViewController.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 10/01/2020.
//  Copyright © 2020 STMicroelectronics. All rights reserved.
//

import UIKit
import CoreNFC

enum coreNFCSessionType {
    case tagSession
    case ndefSession
}

enum actionOnArea {
    case modified
    case cancelled
}

protocol AreaEditionReady
{
    func onAreaReady(action: actionOnArea, ndef : ComStSt25sdkNdefNDEFMsg)
}

class ST25NdefRecordsListViewController: ST25UIViewController
{
    var mCoreNFCSessionType:coreNFCSessionType = .ndefSession
    var delegate:AreaEditionReady?

    internal var mST25NdefRecordListManager:ST25NdefRecordsListManager!
    internal var mST25NdefRecordListTagSession:ST25NdefRecordsListTagSession!
    internal var mST25NdefRecordListNdefSession:ST25NdefRecordsListNdefSession!
    
    var mNdefMsg : ComStSt25sdkNdefNDEFMsg!
    var mAera = 1
    var mSize = 0
    var mCCFileLength = 4
    var mNumberOfAreas: Int8 = 1
    var mAreaReadProtected = false
    
    var tagNeedUpdate: Bool = false
    var mCurrentIndexforRecordEdition = 0
    private var mCurrentActionOnRecordToDo :actionOnRecordToDo = .add
    
    var mAreaActionPerformed :actionOnArea = .cancelled
    
    
    enum taskToDo {
        // Task to do for TAG Session
        case getExpectedCCFileLength
        case getAreaMemoryConf
        case updateNdefInArea
        case getAreaMemoryConfWithPwd
        case updateNdefInAreaWithPwd
        
        // Task to do for NDEF Session
        case readNdef
        case writeNdef
    }
    
    internal var mTaskToDo:taskToDo = .getAreaMemoryConf
    
    
    @IBOutlet weak var mRecordsTableView: UITableView!
    @IBOutlet weak var mNdefRecordHeaderLabel: UILabel!
    
    @IBOutlet weak var mWriteToTagButton: UIButton!

    
    @IBAction func refreshNdefContent(_ sender: UIButton) {
        if (mCoreNFCSessionType == .tagSession){
            mTaskToDo = .getAreaMemoryConf
            self.mST25NdefRecordListTagSession.startSession()
        }else{
            mTaskToDo = .readNdef
            self.mST25NdefRecordListNdefSession.startSession()
        }
    }
    
    @IBAction func writeNdefToTag(_ sender: UIButton) {
        
        if (mCoreNFCSessionType == .tagSession){
            mTaskToDo = .updateNdefInArea
            self.mST25NdefRecordListTagSession.startSession()
        }else{
            mTaskToDo = .writeNdef
            if (self.mNdefMsg != nil && self.mNdefMsg.getNbrOfRecords() <= 0){
                self.showAlertWhenWritingEmptyRecord()
            }else{
                self.mST25NdefRecordListNdefSession.startSession()
            }
        }
    }

    func updateWriteToTagButtonMessage(forUpdate : Bool) {
        if forUpdate {
            self.mWriteToTagButton.setTitleColor(.stRedColor(), for: .normal)
        } else {
            self.mWriteToTagButton.setTitleColor(.white, for: .normal)
        }
        if self.mNdefMsg != nil && self.mNdefMsg.getNbrOfRecords() > 0 {
            let ndefSize = Int(self.mNdefMsg.getLength())
            let ccFileSize = self.mCCFileLength
            let tls = 2
            let terminator = 1
            let size = ndefSize + ccFileSize + tls + terminator
            self.mWriteToTagButton.setTitle("Write to Tag (\(size) bytes )", for: .normal)
            enableWriteToTagButton()
        } else {
            if (self.mNdefMsg != nil) {
                self.mWriteToTagButton.setTitle("Write to Tag (Format for NDEF)", for: .normal)
                enableWriteToTagButton()
                
            } else {
                self.mWriteToTagButton.setTitle("Write to Tag (...)", for: .normal)
                disableWriteToTagButton ()
            }
        }
    }

    func updateNdefRecordHeaderLabel(){
        if (mCoreNFCSessionType == .tagSession) {
            if mAreaReadProtected {
                mNdefRecordHeaderLabel.text = "NDEF record(s) for Area\(mAera+1) \nAvailable Size: \(self.mSize) bytes\nRead Protected"
                configureButtonsWhenAreaIsReadOnly(enable: false)
            } else {
                mNdefRecordHeaderLabel.text = "NDEF record(s) for Area\(mAera+1) \nAvailable Size: \(self.mSize) bytes"
                configureButtonsWhenAreaIsReadOnly(enable: true)
            }
        }else{
            mNdefRecordHeaderLabel.text = "NDEF record(s) for Area1 \nAvailable Size: \(self.mSize) bytes"
            configureButtonsWhenAreaIsReadOnly(enable: true)
        }
    }

    private func enableWriteToTagButton () {
        mWriteToTagButton.isEnabled = true
        mWriteToTagButton.backgroundColor = .stDarkBlueColor()
    }
    
    private func disableWriteToTagButton () {
        mWriteToTagButton.isEnabled = false
        mWriteToTagButton.backgroundColor = .stGreyColor()
    }
    
    func configureButtonsWhenAreaIsReadOnly (enable : Bool) {
        mWriteToTagButton.isEnabled = enable
        if enable {
            mWriteToTagButton.backgroundColor = .stDarkBlueColor()
        } else {
            mWriteToTagButton.backgroundColor = .stGreyColor()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Ndef records list"
                
        self.updateWriteToTagButtonMessage(forUpdate: false)
        
        mST25NdefRecordListManager      = ST25NdefRecordsListManager(vc: self)
        if (mCoreNFCSessionType == .tagSession){
            mST25NdefRecordListTagSession   = ST25NdefRecordsListTagSession(vc: self)
        }
        mST25NdefRecordListNdefSession  = ST25NdefRecordsListNdefSession(vc: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.updateNdefRecordHeaderLabel()
        self.mRecordsTableView.reloadData()
        
        if (mCoreNFCSessionType == .ndefSession){
            mTaskToDo = .readNdef
            self.mST25NdefRecordListNdefSession.startSession()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.mNdefMsg != nil {
            delegate?.onAreaReady(action: self.mAreaActionPerformed, ndef: self.mNdefMsg)
        }
        self.dismiss(animated: true, completion: nil)
    }

    private func warningAlert(message : String) {
        UIHelper.warningAlert(viewController: self, title : "NDEF record management" , message: message)
    }
    
    private func showAlertWhenWritingEmptyRecord() {
        
        // Create a standard UIAlertController
         let alertController = UIAlertController(title: "NDEF Write", message: "There is no records to write. It will write an Empty record. Are you ok ? ", preferredStyle: .alert)

         // A cancel action
         let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
         }

         // This action handles your confirmation action
         let confirmAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.mST25NdefRecordListNdefSession.startSession()
         }

         // Add the actions, the order here does not matter
         alertController.addAction(cancelAction)
         alertController.addAction(confirmAction)
         
         //
         self.present(alertController, animated: true, completion:nil)
     }
    
}



extension ST25NdefRecordsListViewController: NdefRecordReady {
    // Call back from records Controller to know edition result
    func onRecordReady(action: actionOnRecordToDo, record: ComStSt25sdkNdefNDEFRecord) {
        if action != .cancelled {
            rebuildNdefMessage(action: action, record: record)
            tagNeedUpdate = true
            DispatchQueue.main.async {
                self.mRecordsTableView.reloadData()
                self.updateWriteToTagButtonMessage(forUpdate: true)
            }
        }

    }
    
    private func rebuildNdefMessage(action: actionOnRecordToDo, record: ComStSt25sdkNdefNDEFRecord) {
        if action == .cancelled {
            // do nothing
        }
        
        if action == .add || action == .insert{
            print("Index to add in NDEF : \(mCurrentIndexforRecordEdition)")
            if self.mNdefMsg == nil {
                self.mNdefMsg = ComStSt25sdkNdefNDEFMsg(comStSt25sdkNdefNDEFRecord: record)
            } else {
                let nbRecords = self.mNdefMsg.getNbrOfRecords()
                //print("Add/Insert nb rcd init: \(nbRecords)")
                var tmpRecords = [ComStSt25sdkNdefNDEFRecord]()
                if nbRecords > 0 {
                    for it in 0 ..< nbRecords{
                        let currentNdefRecord = self.mNdefMsg.getNDEFRecord(with: it)
                        if self.mCurrentIndexforRecordEdition == it {
                            if action == .add {
                                //print("Adding : \(it)")
                                tmpRecords.append(currentNdefRecord!)
                                tmpRecords.append(record)
                            } else { // insert
                                //print("Inserting: \(it)")
                                tmpRecords.append(record)
                                tmpRecords.append(currentNdefRecord!)
                            }
                        } else {
                            tmpRecords.append(currentNdefRecord!)
                        }
                    }
                } else {
                    // NDEF Empty with no record
                    tmpRecords.append(record)
                }
                //print (tmpRecords)
                if nbRecords > 0 {
                    // delete NDEF records
                    for itDeletion in 1...nbRecords {
                        self.mNdefMsg.deleteRecord(with: itDeletion)
                    }
                }
                self.mNdefMsg = ComStSt25sdkNdefNDEFMsg()

                // rebuild NDEF with Records
                for itRebuild in 0 ..< tmpRecords.count {
                    self.mNdefMsg.addRecord(with: tmpRecords[itRebuild])
                }
                tmpRecords.removeAll()
            }
            UIHelper.UI() {
                self.mRecordsTableView.reloadData()
            }
        }
        
        if action == .edit {
            let index = self.mCurrentIndexforRecordEdition
            if index >= 0 &&  index < self.mNdefMsg.getNbrOfRecords() {
                //print(record.getPayload()?.toNSData()?.toHexString())
                self.mNdefMsg.updateRecord(with: record, with: jint(index))
            }
            UIHelper.UI() {
                self.mRecordsTableView.reloadData()
            }
        }
    }
}


