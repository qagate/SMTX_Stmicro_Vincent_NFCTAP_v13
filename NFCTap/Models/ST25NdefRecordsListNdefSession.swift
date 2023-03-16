//
//  ST25NdefRecordsListNdefSession.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 07/04/2020.
//  Copyright © 2020 STMicroelectronics. All rights reserved.
//

import UIKit
import CoreNFC


class ST25NdefRecordsListNdefSession: NSObject {
    var mParentVC:ST25NdefRecordsListViewController!
   
    internal var mNdefTag:iOSNdef!
    internal var miOSReaderSession:iOSReaderSession!
    internal var mCapacity:Int!
    internal let mNdefManager:NDEFManager = NDEFManager()
    
    
    init(vc:ST25UIViewController) {
        super.init()
        self.mParentVC = (vc as! ST25NdefRecordsListViewController)
        self.miOSReaderSession = iOSReaderSession(andefReaderSessionViewControllerDelegate: self)
    }

    func startSession(){
        miOSReaderSession.startNdefReaderSession()
    }

    // READ WRITE method to TAG
    private func readTagLength() {
        self.mParentVC.mSize = mCapacity
    }
    
    private func readNdefMessage() {
        let readNdef = mNdefTag.readNdef()
        
        if readNdef.message != nil {
           // Convert read NDEF iOS Message into NDEF ST25SDK
            self.mParentVC.mNdefMsg = self.mNdefManager.convertiOSNdefToSt25Ndef(message: readNdef.message!)
            
            UIHelper.UI() {
                self.mParentVC.mRecordsTableView.reloadData()
            }
        }else{
            mNdefTag.sessionInvalidate(error: "No NDEF Message found")
        }
     }
    
    private func writeNdefMessage() {
        
        if self.mParentVC.mNdefMsg != nil {
            // Convert NDEF ST25SDK into NDEF iOS , then write it using coreNFC
            let aNFCNDEFMessage:NFCNDEFMessage = self.mNdefManager.convertSt25NdefToiOSNdef(message: self.mParentVC.mNdefMsg)
            
            let status:String? = mNdefTag.writeNdef(aNFCNDEFMessage)
            
            if (status == nil){
                // Inform that NDEF list was modified.
                self.mParentVC.delegate?.onAreaReady(action: .modified, ndef: self.mParentVC.mNdefMsg)
            }else{
                mNdefTag.sessionInvalidate(error: "Error writing NDEF : \n"+status!+"\nPlease check NDEF size and Tag permissions")
            }
            
        } else {
            UIHelper.UI() {
                self.warningAlert(message: "No Ndef message defined ...")
            }
        }
    }
    
    private func warningAlert(message : String) {
        UIHelper.warningAlert(viewController: self.mParentVC, title : "NDEF record management" , message: message)
    }

}

extension ST25NdefRecordsListNdefSession: ndefReaderSessionViewControllerDelegate {
    func handleNdef(tag:iOSNdef, status: NFCNDEFStatus, capacity: Int) throws {
        self.mNdefTag = tag
        self.mCapacity = capacity
        
        if status == .notSupported {
           self.miOSReaderSession.stopNdefReaderSession("Tag not supported.")
        }
        
        switch self.mParentVC.mTaskToDo {
            case .readNdef:
                readTagLength()
                readNdefMessage()
                UIHelper.UI() {
                    self.mParentVC.updateNdefRecordHeaderLabel()
                    self.mParentVC.updateWriteToTagButtonMessage(forUpdate: false)
                }
            
            case .writeNdef:
                if status == .readOnly {
                    self.miOSReaderSession.stopNdefReaderSession("Tag is not writable.")
                }
                writeNdefMessage()
                self.mParentVC.mAreaActionPerformed = .modified
                UIHelper.UI() {
                    self.mParentVC.updateNdefRecordHeaderLabel()
                    self.mParentVC.updateWriteToTagButtonMessage(forUpdate: false)
                }
            
            default:
                mNdefTag.sessionInvalidate(error: "Tag operation not handled !!!")
        }
    }
    
    func handleNdefSessionError(didInvalidateWithError error: Error) {
        let errorNFC = error as! NFCReaderError
        
        if errorNFC.code ==  NFCReaderError.readerSessionInvalidationErrorSessionTimeout {
        }
        else if errorNFC.code ==  NFCReaderError.readerSessionInvalidationErrorUserCanceled {
        }
        print(error.localizedDescription)
        mNdefTag.sessionInvalidate(error: "Command failed: \(error.localizedDescription)")
    }
    
    func handleNdefST25SdkError(didInvalidateWithError error: NSException) {
        let errorST25SDK = error as! ComStSt25sdkSTException
        mNdefTag.sessionInvalidate(error: "Command failed: \(errorST25SDK.getMessage())")
    }
    
}
    






