//
//  ST25NdefRecordsListTagSession.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 07/04/2020.
//  Copyright © 2020 STMicroelectronics. All rights reserved.
//

import UIKit
import CoreNFC


class ST25NdefRecordsListTagSession: NSObject {
    var mParentVC:ST25NdefRecordsListViewController!
   
    internal var mTag : ComStSt25sdkNFCTag!
    internal var miOSReaderSession:iOSReaderSession!
    
    internal var mAreaReadPwd:Data!
    internal var mAreaWritePwd:Data!
    internal var mAreaAffectedPasswordNumber: Int!
    internal var mPasswordNumbersOfBits: Int!


    init(vc:ST25UIViewController) {
        super.init()
        self.mParentVC = (vc as! ST25NdefRecordsListViewController)
        self.miOSReaderSession = iOSReaderSession(atagReaderSessionViewControllerDelegate: self)
    }

    func startSession(){
        miOSReaderSession.startTagReaderSession()
    }
    
    // READ WRITE method to TAG
    private func readCCFileLength() {
        if mTag is ST25TVTag {
            self.mParentVC.mCCFileLength = Int((mTag as! ST25TVTag).getExpectedCCFileLength())
        }else if mTag is ST25TVCTag {
            self.mParentVC.mCCFileLength = Int((mTag as! ST25TVCTag).getExpectedCCFileLength())
        }else if mTag is ST25DVTag {
            self.mParentVC.mCCFileLength = Int((mTag as! ST25DVTag).getExpectedCCFileLength())
        } else if mTag is ST25DVCTag {
            self.mParentVC.mCCFileLength = Int((mTag as! ST25DVCTag).getExpectedCCFileLength())
        } else if mTag is ST25TV16KTag {
            self.mParentVC.mCCFileLength = Int((mTag as! ST25TV16KTag).getExpectedCCFileLength())
        } else if mTag is ST25TV64KTag {
            self.mParentVC.mCCFileLength = Int((mTag as! ST25TV64KTag).getExpectedCCFileLength())
        } else if self.mTag is ST25DVPwmTag {
            self.mParentVC.mCCFileLength = Int((mTag as! ST25DVPwmTag).getExpectedCCFileLength())

        } else {
            UIHelper.UI() {
                self.warningAlert(message: "Tag doesn't support this feature")
            }
            
        }
    }
    
    private func readAreaNdefMessage(area: Int) {
        if mTag is ST25TVTag {
            self.mParentVC.mNdefMsg = (mTag as! ST25TVTag).readNdefMessage(with: jint(area))
        } else if mTag is ST25TVCTag {
            self.mParentVC.mNdefMsg = (mTag as! ST25TVCTag).readNdefMessage(with: jint(area))
        } else if mTag is ST25DVTag {
            readAreaNdefMessage(area: area, tag: mTag as! ST25DVTag)
        } else if mTag is ST25DVCTag {
            readAreaNdefMessage(area: area, tag: mTag as! ST25DVCTag)
        } else if mTag is ST25TV16KTag {
            readAreaNdefMessage(area: area, tag: mTag as! ST25TV16KTag)
        } else if mTag is ST25TV64KTag {
            readAreaNdefMessage(area: area, tag: mTag as! ST25TV64KTag)
        } else if self.mTag is ST25DVPwmTag {
            self.mParentVC.mNdefMsg = (mTag as! ST25DVPwmTag).readNdefMessage(with: jint(area))
        } else {
            UIHelper.UI() {
                self.warningAlert(message: "Tag doesn't support this feature")
            }        }
        
        UIHelper.UI() {
            self.mParentVC.mRecordsTableView.reloadData()
        }
    }
    
    private func readAreaNdefMessage(area: Int, tag: ST25DVTag) {
        // Get the password number in case of protected area
        mAreaAffectedPasswordNumber = (Int)(tag.getPasswordNumber(with: jint(area)))
        if (mAreaAffectedPasswordNumber != 0){
            mPasswordNumbersOfBits = (Int)(tag.getAreaPasswordLength(with: jint(area)))
        }
        tag.invalidateCache()
        self.mParentVC.mNdefMsg = tag.readNdefMessage(with: jint(area))
    }
    
    private func readAreaNdefMessage(area: Int, tag: ST25DVCTag) {
        // Get the password number in case of protected area
        mAreaAffectedPasswordNumber = (Int)(tag.getPasswordNumber(with: jint(area)))
        if (mAreaAffectedPasswordNumber != 0){
            mPasswordNumbersOfBits = (Int)(tag.getAreaPasswordLength(with: jint(area)))
        }
        tag.invalidateCache()
        self.mParentVC.mNdefMsg = tag.readNdefMessage(with: jint(area))
    }
    
    private func readAreaNdefMessage(area: Int, tag: ST25TV16KTag) {
        // Get the password number in case of protected area
        mAreaAffectedPasswordNumber = (Int)(tag.getPasswordNumber(with: jint(area)))
        if (mAreaAffectedPasswordNumber != 0){
            mPasswordNumbersOfBits = (Int)(tag.getAreaPasswordLength(with: jint(area)))
        }
        tag.invalidateCache()
        self.mParentVC.mNdefMsg = tag.readNdefMessage(with: jint(area))
    }
    private func readAreaNdefMessage(area: Int, tag: ST25TV64KTag) {
        // Get the password number in case of protected area
        mAreaAffectedPasswordNumber = (Int)(tag.getPasswordNumber(with: jint(area)))
        if (mAreaAffectedPasswordNumber != 0){
            mPasswordNumbersOfBits = (Int)(tag.getAreaPasswordLength(with: jint(area)))
        }
        tag.invalidateCache()
        self.mParentVC.mNdefMsg = tag.readNdefMessage(with: jint(area))
    }
    
    
    private func writeAreaNdefMessage(area: Int) {
        if self.mParentVC.mNdefMsg != nil {
            if mTag is ST25TVTag {
                (mTag as! ST25TVTag).writeNdefMessage(with: jint(area), with: self.mParentVC.mNdefMsg)
            } else if mTag is ST25TVCTag {
                (mTag as! ST25TVCTag).writeNdefMessage(with: jint(area), with: self.mParentVC.mNdefMsg)
            } else if mTag is ST25DVTag {
                writeAreaNdefMessage(area: area, tag: mTag as! ST25DVTag)
            } else if mTag is ST25DVCTag {
                writeAreaNdefMessage(area: area, tag: mTag as! ST25DVCTag)
            } else if mTag is ST25TV16KTag {
                writeAreaNdefMessage(area: area, tag: mTag as! ST25TV16KTag)
            } else if mTag is ST25TV64KTag {
                writeAreaNdefMessage(area: area, tag: mTag as! ST25TV64KTag)
            } else if self.mTag is ST25DVPwmTag {
                (mTag as! ST25DVPwmTag).writeNdefMessage(with: jint(area), with: self.mParentVC.mNdefMsg)
            } else {
                UIHelper.UI() {
                    self.warningAlert(message: "Tag doesn't support this feature")
                }
            }
            self.mParentVC.delegate?.onAreaReady(action: self.mParentVC.mAreaActionPerformed, ndef: self.mParentVC.mNdefMsg)
            
        }  else {
            UIHelper.UI() {
                self.warningAlert(message: "No Ndef message defined ...")
            }
        }
        
    }
    
    private func writeAreaNdefMessage(area: Int, tag: ST25DVTag) {
        // Get the password number in case of protected area
        mAreaAffectedPasswordNumber = (Int)(tag.getPasswordNumber(with: jint(area)))
        if (mAreaAffectedPasswordNumber != 0){
            mPasswordNumbersOfBits = (Int)(tag.getAreaPasswordLength(with: jint(area)))
        }
        tag.writeNdefMessage(with: jint(area), with: self.mParentVC.mNdefMsg)
   }
    
    private func writeAreaNdefMessage(area: Int, tag: ST25DVCTag) {
        // Get the password number in case of protected area
        mAreaAffectedPasswordNumber = (Int)(tag.getPasswordNumber(with: jint(area)))
        if (mAreaAffectedPasswordNumber != 0){
            mPasswordNumbersOfBits = (Int)(tag.getAreaPasswordLength(with: jint(area)))
        }
        tag.writeNdefMessage(with: jint(area), with: self.mParentVC.mNdefMsg)
   }
    
    private func writeAreaNdefMessage(area: Int, tag: ST25TV16KTag) {
        // Get the password number in case of protected area
        mAreaAffectedPasswordNumber = (Int)(tag.getPasswordNumber(with: jint(area)))
        if (mAreaAffectedPasswordNumber != 0){
            mPasswordNumbersOfBits = (Int)(tag.getAreaPasswordLength(with: jint(area)))
        }
        tag.writeNdefMessage(with: jint(area), with: self.mParentVC.mNdefMsg)
   }
    private func writeAreaNdefMessage(area: Int, tag: ST25TV64KTag) {
        // Get the password number in case of protected area
        mAreaAffectedPasswordNumber = (Int)(tag.getPasswordNumber(with: jint(area)))
        if (mAreaAffectedPasswordNumber != 0){
            mPasswordNumbersOfBits = (Int)(tag.getAreaPasswordLength(with: jint(area)))
        }
        tag.writeNdefMessage(with: jint(area), with: self.mParentVC.mNdefMsg)
   }
    private func readAreaNdefMessageWithPwd(area: Int) {
        if mTag is ST25TVTag {
            if area == ComStSt25sdkType5St25tvST25TVTag_ST25TV_AREA1_PASSWORD_ID {
                (mTag as! ST25TVTag).presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25tvST25TVTag_ST25TV_AREA1_PASSWORD_ID), password: mAreaReadPwd)
            } else {
                (mTag as! ST25TVTag).presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25tvST25TVTag_ST25TV_AREA2_PASSWORD_ID), password: mAreaReadPwd)
            }
        } else if mTag is ST25TVCTag {
            if area == ComStSt25sdkType5St25tvST25TVTag_ST25TV_AREA1_PASSWORD_ID {
                (mTag as! ST25TVCTag).presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25tvST25TVTag_ST25TV_AREA1_PASSWORD_ID), password: mAreaReadPwd)
            } else {
                (mTag as! ST25TVCTag).presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25tvST25TVTag_ST25TV_AREA2_PASSWORD_ID), password: mAreaReadPwd)
            }
        } else if mTag is ST25DVTag {
            (mTag as! ST25DVTag).presentPassword(passwordNumber: UInt8(mAreaAffectedPasswordNumber), password: mAreaReadPwd)
        } else if mTag is ST25DVCTag {
            (mTag as! ST25DVCTag).presentPassword(passwordNumber: UInt8(mAreaAffectedPasswordNumber), password: mAreaReadPwd)
        } else if mTag is ST25TV16KTag {
            (mTag as! ST25TV16KTag).presentPassword(passwordNumber: UInt8(mAreaAffectedPasswordNumber), password: mAreaReadPwd)
        } else if mTag is ST25TV64KTag {
            (mTag as! ST25TV64KTag).presentPassword(passwordNumber: UInt8(mAreaAffectedPasswordNumber), password: mAreaReadPwd)
        } else if self.mTag is ST25DVPwmTag {
            if area == ComStSt25sdkType5St25dvpwmST25DVPwmTag_ST25DVPWM_AREA1_PASSWORD_ID {
                (mTag as! ST25DVPwmTag).presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25dvpwmST25DVPwmTag_ST25DVPWM_AREA1_PASSWORD_ID), password: mAreaReadPwd)
            } else {
                (mTag as! ST25DVPwmTag).presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25dvpwmST25DVPwmTag_ST25DVPWM_AREA2_PASSWORD_ID), password: mAreaReadPwd)
            }
        } else {
            UIHelper.UI() {
                self.warningAlert(message: "Tag doesn't support this feature")
            }
            return
        }
        
        self.readAreaNdefMessage(area: area)
        UIHelper.UI() {
            self.mParentVC.configureButtonsWhenAreaIsReadOnly(enable: true)
        }
        
    }
    
    private func writeAreaNdefMessageWithPwd(area: Int) {
        if mTag is ST25TVTag {
            if area == ComStSt25sdkType5St25tvST25TVTag_ST25TV_AREA1_PASSWORD_ID {
                (mTag as! ST25TVTag).presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25tvST25TVTag_ST25TV_AREA1_PASSWORD_ID), password: mAreaWritePwd)
            } else {
                (mTag as! ST25TVTag).presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25tvST25TVTag_ST25TV_AREA2_PASSWORD_ID), password: mAreaWritePwd)
            }
        } else if mTag is ST25TVCTag {
            if area == ComStSt25sdkType5St25tvST25TVTag_ST25TV_AREA1_PASSWORD_ID {
                (mTag as! ST25TVCTag).presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25tvST25TVTag_ST25TV_AREA1_PASSWORD_ID), password: mAreaWritePwd)
            } else {
                (mTag as! ST25TVCTag).presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25tvST25TVTag_ST25TV_AREA2_PASSWORD_ID), password: mAreaWritePwd)
            }
        } else if mTag is ST25DVTag {
            (mTag as! ST25DVTag).presentPassword(passwordNumber: UInt8(mAreaAffectedPasswordNumber), password: mAreaWritePwd)
        } else if mTag is ST25DVCTag {
            (mTag as! ST25DVCTag).presentPassword(passwordNumber: UInt8(mAreaAffectedPasswordNumber), password: mAreaWritePwd)
        } else if mTag is ST25TV16KTag {
            (mTag as! ST25TV16KTag).presentPassword(passwordNumber: UInt8(mAreaAffectedPasswordNumber), password: mAreaWritePwd)
        } else if mTag is ST25TV64KTag {
            (mTag as! ST25TV64KTag).presentPassword(passwordNumber: UInt8(mAreaAffectedPasswordNumber), password: mAreaWritePwd)
        } else if self.mTag is ST25DVPwmTag {
            if area == ComStSt25sdkType5St25dvpwmST25DVPwmTag_ST25DVPWM_AREA1_PASSWORD_ID {
                (mTag as! ST25DVPwmTag).presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25dvpwmST25DVPwmTag_ST25DVPWM_AREA1_PASSWORD_ID), password: mAreaWritePwd)
            } else {
                (mTag as! ST25DVPwmTag).presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25dvpwmST25DVPwmTag_ST25DVPWM_AREA2_PASSWORD_ID), password: mAreaWritePwd)
            }
        } else {
            UIHelper.UI() {
                self.warningAlert(message: "Tag doesn't support this feature")
            }
            return
        }
        self.writeAreaNdefMessage(area: area)
    }
    
    private func getCurrentPwdForArea(type : String) {
        let mST25PasswordVC:ST25PasswordViewController = UIStoryboard(name: "ST25Password", bundle: nil).instantiateViewController(withIdentifier: "ST25PasswordID") as! ST25PasswordViewController
        mST25PasswordVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        mST25PasswordVC.setTitle("Enter current \(type) area \(self.mParentVC.mAera+1) password")
        
        if mTag is ST25TVTag || self.mTag is ST25DVPwmTag || mTag is ST25TVCTag {
            if  self.mParentVC.mNumberOfAreas == 2 {
                mST25PasswordVC.setMessage("(32 bits hexadecimal format)")
                mST25PasswordVC.numberOfBytes = 4
            } else {
                mST25PasswordVC.setMessage("(64 bits hexadecimal format)")
                mST25PasswordVC.numberOfBytes = 8
            }
        }else if mTag is ST25DVTag || mTag is ST25DVCTag || mTag is ST25TV16KTag || mTag is ST25TV64KTag {
            if mPasswordNumbersOfBits/8 == 8 {
                // DV Area pwd on 64 bits
                mST25PasswordVC.setMessage("64 bits hexadecimal format for pwd :\(String(mAreaAffectedPasswordNumber))")
                mST25PasswordVC.numberOfBytes = 8
            } else {
                UIHelper.UI() {
                    self.warningAlert(message: "Wrong area or password length")
                }
                
                return
            }
        } else {
            UIHelper.UI() {
                self.warningAlert(message: "Tag doesn't support this feature")
            }
            
            return
        }
        
        mST25PasswordVC.delegate = self
        self.mParentVC.present(mST25PasswordVC, animated: false, completion: nil)
    }
        
    private func warningAlert(message : String) {
        UIHelper.warningAlert(viewController: self.mParentVC, title : "NDEF record management" , message: message)
    }

}

extension ST25NdefRecordsListTagSession: ST25PasswordViewDelegate {
    func okButtonTapped(pwdValue: Data) {
        if self.mParentVC.mTaskToDo == .getAreaMemoryConfWithPwd {
            //print(pwdValue.toHexString())
            DispatchQueue.main.async {
                self.mAreaReadPwd = pwdValue
                self.mParentVC.mTaskToDo = .getAreaMemoryConfWithPwd
                self.miOSReaderSession.startTagReaderSession()
            }
        }
        if self.mParentVC.mTaskToDo == .updateNdefInAreaWithPwd {
            //print(pwdValue.toHexString())
            DispatchQueue.main.async {
                self.mAreaWritePwd = pwdValue
                self.mParentVC.mTaskToDo = .updateNdefInAreaWithPwd
                self.miOSReaderSession.startTagReaderSession()
            }
        }
    }
    
    func cancelButtonTapped() {
        if self.mParentVC.mTaskToDo == .getAreaMemoryConfWithPwd {
            self.mParentVC.mTaskToDo = .getAreaMemoryConf
        }
        if self.mParentVC.mTaskToDo == .updateNdefInAreaWithPwd {
            self.mParentVC.mTaskToDo = .updateNdefInArea
        }
    }
    
}

extension ST25NdefRecordsListTagSession: tagReaderSessionViewControllerDelegate {

    func handleTag(st25SDKTag: ComStSt25sdkNFCTag, uid: Data!) throws{
        mTag = st25SDKTag
        if self.mParentVC.isSameTag(uid: uid)  {
            switch self.mParentVC.mTaskToDo {
            case .getExpectedCCFileLength:
                readCCFileLength()
                
            case .getAreaMemoryConf:
                self.readAreaNdefMessage(area: self.mParentVC.mAera+1)
                UIHelper.UI() {
                    self.mParentVC.updateWriteToTagButtonMessage(forUpdate: false)
                }
            case .updateNdefInArea:
                self.writeAreaNdefMessage(area: self.mParentVC.mAera+1)
                self.mParentVC.mAreaActionPerformed = .modified
                UIHelper.UI() {
                    self.mParentVC.updateWriteToTagButtonMessage(forUpdate: false)
                }
                
            case .getAreaMemoryConfWithPwd:
                self.readAreaNdefMessageWithPwd(area: self.mParentVC.mAera+1)
                UIHelper.UI() {
                    self.mParentVC.updateWriteToTagButtonMessage(forUpdate: false)
                }
                
            case .updateNdefInAreaWithPwd:
                self.writeAreaNdefMessageWithPwd(area: self.mParentVC.mAera+1)
                self.mParentVC.mAreaActionPerformed = .modified
                UIHelper.UI() {
                    self.mParentVC.updateWriteToTagButtonMessage(forUpdate: false)
                }
                
            default:
                self.miOSReaderSession.stopTagReaderSession("Tag operation not handled !!!")
                break
            }
        } else {
            UIHelper.UI() {
                self.warningAlert(message: "Tag has changed, please scan again the Tag ...")
            }
        }
        
    }
    
    func handleTagSessionError(didInvalidateWithError error: Error) {
        let errorNFC = error as! NFCReaderError
        
        if errorNFC.code ==  NFCReaderError.readerSessionInvalidationErrorSessionTimeout {
        }
        else if errorNFC.code ==  NFCReaderError.readerSessionInvalidationErrorUserCanceled {
        }
        print(error.localizedDescription)
        
    }
    
    func handleTagST25SdkError(didInvalidateWithError error: NSException) {
        //        print("ST25SDK Error description: \(error.description)")
        //        print("ST25SDK Error name: \(error.name)")
        //        print("ST25SDK Error user info: \(error.userInfo)")
        //        print("ST25SDK Error reason: \(error.reason)")
        if error is ComStSt25sdkSTException {
            let errorST25SDK = error as! ComStSt25sdkSTException
            
            if self.mParentVC.mTaskToDo == .getAreaMemoryConf {
                if (errorST25SDK.getMessage()?.contains(ComStSt25sdkSTException_STExceptionCode.PASSWORD_NEEDED.description()))! ||
                    (errorST25SDK.getMessage()?.contains(ComStSt25sdkSTException_STExceptionCode.ISO15693_BLOCK_PROTECTED.description()))!
                    {
                    DispatchQueue.main.async {
                        self.mParentVC.mTaskToDo = .getAreaMemoryConfWithPwd
                        self.getCurrentPwdForArea(type: "read")
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        self.warningAlert(message: "Command failed: \(error.description)")
                    }
                }
            }
            if self.mParentVC.mTaskToDo == .updateNdefInArea {
                //            print("Error SDK \(errorST25SDK)")
                //            print("Error SDK \(errorST25SDK.getError())")
                //            print("Error SDK \(errorST25SDK.getMessage())")
                if ((errorST25SDK.getMessage()?.contains(ComStSt25sdkSTException_STExceptionCode.PASSWORD_NEEDED.description()))! ||
                    (errorST25SDK.getMessage()?.contains(ComStSt25sdkSTException_STExceptionCode.ISO15693_BLOCK_IS_LOCKED.description()))!){
                    DispatchQueue.main.async {
                        self.mParentVC.mTaskToDo = .updateNdefInAreaWithPwd
                        self.getCurrentPwdForArea(type: "write")
                    }
                } else {
                    DispatchQueue.main.async {
                        self.warningAlert(message: "Command failed: \(error.description)")
                    }
                }
                
            }

        } else {
            // NSException
            print(error.reason)
        }
    }
}







