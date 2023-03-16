//
//  ST25TVPasswordViewController.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 09/12/2019.
//  Copyright © 2019 STMicroelectronics. All rights reserved.
//

import UIKit
import CoreNFC


class ST25TVPasswordViewController: ST25UIViewController {
    internal var mTag : ComStSt25sdkNFCTag!

    internal var miOSReaderSession:iOSReaderSession!
    internal var mST25TagAreaPwd:Data!
    internal var mST25TagAreaPwdNew:Data!

    enum taskToDo {
        case getAreaPassword
        case modifPasswordForArea
    }
    internal var mTaskToDo:taskToDo = .getAreaPassword
    
    var mNumberOfAreas: Int8!
    var mSelectedArea = ComStSt25sdkMultiAreaInterface_AREA1
    
    var mAreaAffectedPasswordNumber: Int!
    var mPasswordNumbersOfBytes: Int!

    
    @IBOutlet weak var mArea1Switch: UISwitch!
    @IBOutlet weak var mArea2Switch: UISwitch!
    @IBOutlet weak var mArea3Switch: UISwitch!
    @IBOutlet weak var mArea4Switch: UISwitch!
    
    var mArea1Enable:Bool = true
    var mArea2Enable:Bool = false
    var mArea3Enable:Bool = false
    var mArea4Enable:Bool = false
    
    @IBOutlet weak var mArea1Label: UILabel!
    @IBOutlet weak var mArea2Label: UILabel!
    @IBOutlet weak var mArea3Label: UILabel!
    @IBOutlet weak var mArea4Label: UILabel!
    
    
    @IBAction func selectArea1SwitchAction(_ sender: Any) {
        if mArea1Switch.isOn {
            mSelectedArea =  ComStSt25sdkMultiAreaInterface_AREA1

        } else {
            mArea1Switch.setOn(true, animated: true)
        }
        mArea1Enable = true
        mArea2Switch.setOn(false, animated: true)
        mArea3Switch.setOn(false, animated: true)
        mArea4Switch.setOn(false, animated: true)
        mArea2Enable = false
        mArea3Enable = false
        mArea4Enable = false

    }
    
    @IBAction func selectArea2SwitchAction(_ sender: Any) {
        if mArea2Switch.isOn {
            mSelectedArea = ComStSt25sdkMultiAreaInterface_AREA2
        } else {
            mArea2Switch.setOn(true, animated: true)

        }
        mArea1Switch.setOn(false, animated: true)
        mArea3Switch.setOn(false, animated: true)
        mArea4Switch.setOn(false, animated: true)
        mArea2Enable = true
        mArea1Enable = false
        mArea3Enable = false
        mArea4Enable = false
    }
    
    @IBAction func selectArea3SwitchAction(_ sender: Any) {
        if mArea3Switch.isOn {
            mSelectedArea = ComStSt25sdkMultiAreaInterface_AREA3
        } else {
            mArea3Switch.setOn(true, animated: true)
            
        }
        mArea1Switch.setOn(false, animated: true)
        mArea2Switch.setOn(false, animated: true)
        mArea4Switch.setOn(false, animated: true)
        mArea3Enable = true
        mArea1Enable = false
        mArea2Enable = false
        mArea4Enable = false
        
    }
    
    @IBAction func selectArea4SwitchAction(_ sender: Any) {
        if mArea4Switch.isOn {
            mSelectedArea = ComStSt25sdkMultiAreaInterface_AREA4
        } else {
            mArea4Switch.setOn(true, animated: true)

        }
        mArea1Switch.setOn(false, animated: true)
        mArea2Switch.setOn(false, animated: true)
        mArea3Switch.setOn(false, animated: true)
        mArea4Enable = true
        mArea1Enable = false
        mArea2Enable = false
        mArea3Enable = false
    }
    
    @IBAction func changePassword(_ sender: Any) {
        mTaskToDo = .getAreaPassword
        retrievePasswordFromAreaIfNeeded()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mArea1Switch.setOn(true, animated: true)
        mSelectedArea = ComStSt25sdkMultiAreaInterface_AREA1
        mArea2Switch.setOn(false, animated: true)
        mArea3Switch.setOn(false, animated: true)
        mArea4Switch.setOn(false, animated: true)
        disableOOBSwitch()
        mTaskToDo = .getAreaPassword
        // Do any additional setup after loading the view.
        self.miOSReaderSession = iOSReaderSession(atagReaderSessionViewControllerDelegate: self)
    }
    

    
    private func disableOOBSwitch() {
        if mTag is ST25TVTag || self.mTag is ST25DVPwmTag || self.mTag is ST25TVCTag {
            for index in mNumberOfAreas ..< 4 {
                disableSwitch(index: Int(index))
            }
        } else if mTag is ST25DVTag || self.mTag is ST25DVCTag || self.mTag is ST25TV16KTag || self.mTag is ST25TV64KTag {
            configureForST25DVPassword()
        } else {
            warningAlert(message: "Feature not supported")
            return
        }

    }
    
    private func configureForST25DVPassword() {
        mArea1Label.text = "Password 1"
        mArea2Label.text = "Password 2"
        mArea3Label.text = "Password 3"
        disableFourthAreaConfiguration()
    }
    
    private func disableSwitch(index: Int) {
        if index == 1 {
            disableSecondAreaConfiguration()
        }
        if index == 2 {
            disableThirdAreaConfiguration()
        }
        if index == 3 {
            disableFourthAreaConfiguration()
        }
    }
    
    
    private func disableSecondAreaConfiguration() {
        mArea1Switch.isUserInteractionEnabled = false
        mArea2Switch.isUserInteractionEnabled = false
        mArea2Label.alpha = 0.66
        
        mArea2Switch.isHidden = true
        mArea2Label.isHidden = true
    }
    private func disableThirdAreaConfiguration() {
        mArea3Switch.isHidden = true
        mArea3Label.isHidden = true
    }
    private func disableFourthAreaConfiguration() {
        mArea4Switch.isHidden = true
        mArea4Label.isHidden = true
    }
    
    private func getNewAreaPwd() {
        let mST25PasswordVC:ST25PasswordViewController = UIStoryboard(name: "ST25Password", bundle: nil).instantiateViewController(withIdentifier: "ST25PasswordID") as! ST25PasswordViewController
        mST25PasswordVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext

        if mTag is ST25TVTag || self.mTag is ST25DVPwmTag || self.mTag is ST25TVCTag {
            mST25PasswordVC.setTitle("Enter new area \(mSelectedArea) password")
            if  mNumberOfAreas == 2 {
                mST25PasswordVC.setMessage("(32 bits hexadecimal format)")
                mST25PasswordVC.setNumberOfBytes(4)
            } else {
                mST25PasswordVC.setMessage("(64 bits hexadecimal format)")
                mST25PasswordVC.setNumberOfBytes(8)
            }
        } else if mTag is ST25DVTag || self.mTag is ST25DVCTag || self.mTag is ST25TV16KTag || self.mTag is ST25TV64KTag {
            mST25PasswordVC.setTitle("Enter new password \(getST25DVPasswordFromSwitchs()) ")
            // DV Area pwd on 64 bits
            mST25PasswordVC.setMessage("64 bits hexadecimal format")
            mST25PasswordVC.setNumberOfBytes(8)
            
        } else {
            warningAlert(message: "Feature not supported")
            return
        }

        mST25PasswordVC.delegate = self
        self.present(mST25PasswordVC, animated: false, completion: nil)
    }
    

    private func getCurrentPwdForArea() {
        let mST25PasswordVC:ST25PasswordViewController = UIStoryboard(name: "ST25Password", bundle: nil).instantiateViewController(withIdentifier: "ST25PasswordID") as! ST25PasswordViewController
        mST25PasswordVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        if mTag is ST25TVTag || self.mTag is ST25DVPwmTag || self.mTag is ST25TVCTag {
            mST25PasswordVC.setTitle("Enter current area \(mSelectedArea) password")
            if  mNumberOfAreas == 2 {
                mST25PasswordVC.setMessage("(32 bits hexadecimal format)")
                mST25PasswordVC.setNumberOfBytes(4)
            } else {
                mST25PasswordVC.setMessage("(64 bits hexadecimal format)")
                mST25PasswordVC.setNumberOfBytes(8)
            }

        } else if mTag is ST25DVTag || self.mTag is ST25DVCTag || self.mTag is ST25TV16KTag || self.mTag is ST25TV64KTag {
            mAreaAffectedPasswordNumber = getST25DVPasswordFromSwitchs()
            mST25PasswordVC.setTitle("Enter current password \(String(describing: mAreaAffectedPasswordNumber)) ")
                // DV Area pwd on 64 bits
            mST25PasswordVC.setMessage("64 bits hexadecimal format")
            mST25PasswordVC.setNumberOfBytes(8)
            
        } else {
            warningAlert(message: "Feature not supported")
            return
        }
        
        mST25PasswordVC.delegate = self
        self.present(mST25PasswordVC, animated: false, completion: nil)
    }

    private func warningAlert(message : String) {
        UIHelper.warningAlert(viewController: self, title : "Password update" , message: message)
    }
    
    private func modifyPassword() {
        let pwdIOSByteArray = IOSByteArray.init(nsData: mST25TagAreaPwdNew)

        if mTag is ST25TVTag {
            if mSelectedArea == ComStSt25sdkType5St25tvST25TVTag_ST25TV_AREA1_PASSWORD_ID {
                (mTag as! ST25TVTag).presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25tvST25TVTag_ST25TV_AREA1_PASSWORD_ID), password: self.mST25TagAreaPwd)
                (mTag as! ST25TVTag).writePassword(with: jint(ComStSt25sdkType5St25tvST25TVTag_ST25TV_AREA1_PASSWORD_ID), with: pwdIOSByteArray!)
            } else {
                (mTag as! ST25TVTag).presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25tvST25TVTag_ST25TV_AREA2_PASSWORD_ID), password: mST25TagAreaPwd)
                (mTag as! ST25TVTag).writePassword(with: jint(ComStSt25sdkType5St25tvST25TVTag_ST25TV_AREA2_PASSWORD_ID), with: pwdIOSByteArray!)
            }
        } else if mTag is ST25TVCTag {
            if mSelectedArea == ComStSt25sdkType5St25tvcST25TVCTag_ST25TVC_AREA1_PASSWORD_ID {
                (mTag as! ST25TVCTag).presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25tvcST25TVCTag_ST25TVC_AREA1_PASSWORD_ID), password: self.mST25TagAreaPwd)
                (mTag as! ST25TVCTag).writePassword(with: jint(ComStSt25sdkType5St25tvcST25TVCTag_ST25TVC_AREA1_PASSWORD_ID), with: pwdIOSByteArray!)
            } else {
                (mTag as! ST25TVCTag).presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25tvcST25TVCTag_ST25TVC_AREA2_PASSWORD_ID), password: mST25TagAreaPwd)
                (mTag as! ST25TVCTag).writePassword(with: jint(ComStSt25sdkType5St25tvcST25TVCTag_ST25TVC_AREA2_PASSWORD_ID), with: pwdIOSByteArray!)
            }
        } else if mTag is ST25DVTag {
            (mTag as! ST25DVTag).presentPassword(passwordNumber: UInt8(self.mAreaAffectedPasswordNumber), password: self.mST25TagAreaPwd)
            (mTag as! ST25DVTag).writePassword(with: jint(mAreaAffectedPasswordNumber), with: pwdIOSByteArray!)
        } else if mTag is ST25DVCTag {
            (mTag as! ST25DVCTag).presentPassword(passwordNumber: UInt8(self.mAreaAffectedPasswordNumber), password: self.mST25TagAreaPwd)
            (mTag as! ST25DVCTag).writePassword(with: jint(mAreaAffectedPasswordNumber), with: pwdIOSByteArray!)
        } else if self.mTag is ST25DVPwmTag {
            if mSelectedArea == ComStSt25sdkType5St25dvpwmST25DVPwmTag_ST25DVPWM_AREA1_PASSWORD_ID {
                (mTag as! ST25DVPwmTag).presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25dvpwmST25DVPwmTag_ST25DVPWM_AREA1_PASSWORD_ID), password: self.mST25TagAreaPwd)
                (mTag as! ST25DVPwmTag).writePassword(with: jint(ComStSt25sdkType5St25dvpwmST25DVPwmTag_ST25DVPWM_AREA1_PASSWORD_ID), with: pwdIOSByteArray!)
            } else {
                (mTag as! ST25DVPwmTag).presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25dvpwmST25DVPwmTag_ST25DVPWM_AREA2_PASSWORD_ID), password: mST25TagAreaPwd)
                (mTag as! ST25DVPwmTag).writePassword(with: jint(ComStSt25sdkType5St25dvpwmST25DVPwmTag_ST25DVPWM_AREA2_PASSWORD_ID), with: pwdIOSByteArray!)
            }

        } else if mTag is ST25TV16KTag {
            (mTag as! ST25TV16KTag).presentPassword(passwordNumber: UInt8(self.mAreaAffectedPasswordNumber), password: self.mST25TagAreaPwd)
            (mTag as! ST25TV16KTag).writePassword(with: jint(mAreaAffectedPasswordNumber), with: pwdIOSByteArray!)
        }  else if mTag is ST25TV64KTag {
            (mTag as! ST25TV64KTag).presentPassword(passwordNumber: UInt8(self.mAreaAffectedPasswordNumber), password: self.mST25TagAreaPwd)
            (mTag as! ST25TV64KTag).writePassword(with: jint(mAreaAffectedPasswordNumber), with: pwdIOSByteArray!)
        } else {
            UIHelper.UI() {
                self.warningAlert(message: "Feature not supported ...")
            }
        }
        
    }
    
    private func retrievePasswordFromAreaIfNeeded() {
        if mTag is ST25TVTag || self.mTag is ST25DVPwmTag || self.mTag is ST25TVCTag{
            // no need to retrieve Tag information
            mSelectedArea = Int32(getAreaFromSwitchs())
            mAreaAffectedPasswordNumber = Int(mSelectedArea)

            if  mNumberOfAreas == 2 {
                mPasswordNumbersOfBytes = 4
            } else {
                mPasswordNumbersOfBytes = 8
            }
            getCurrentPwdForArea()
        } else if mTag is ST25DVTag || self.mTag is ST25DVCTag || self.mTag is ST25TV16KTag || self.mTag is ST25TV64KTag {
            // need to retrieve affected password
            // Start Reader session
            //mSelectedArea = Int32(getAreaFromSwitchs())
            //self.miOSReaderSession.startTagReaderSession()
            getCurrentPwdForArea()

        } else {
            UIHelper.UI() {
                self.warningAlert(message: "Feature not supported")
            }

        }
    }
    
    private func getAreaFromSwitchs() -> Int{
        if mArea1Enable {
            return Int(ComStSt25sdkMultiAreaInterface_AREA1)
        }
        if mArea2Enable {
            return Int(ComStSt25sdkMultiAreaInterface_AREA2)
        }
        if mArea3Enable {
            return Int(ComStSt25sdkMultiAreaInterface_AREA3)
        }
        if mArea4Enable {
            return Int(ComStSt25sdkMultiAreaInterface_AREA4)
        }
        return Int(ComStSt25sdkMultiAreaInterface_AREA1)
    }

    private func getST25DVPasswordFromSwitchs() -> Int{
        if mArea1Enable {
            return Int(ComStSt25sdkType5St25dvST25DVTag_get_ST25DV_PASSWORD_1())
        }
        if mArea2Enable {
            return Int(ComStSt25sdkType5St25dvST25DVTag_get_ST25DV_PASSWORD_2())
        }
        if mArea3Enable {
            return Int(ComStSt25sdkType5St25dvST25DVTag_get_ST25DV_PASSWORD_3())
        }
        return Int(ComStSt25sdkType5St25dvST25DVTag_get_ST25DV_PASSWORD_1())
    }

    private func getTagAffectedAreaPassword() {
        if mTag is ST25DVTag {
            // Get the password number in case of protected area
            mAreaAffectedPasswordNumber = (Int)((mTag as! ST25DVTag).getPasswordNumber(with: jint(mSelectedArea)))
            mPasswordNumbersOfBytes = (Int)((mTag as! ST25DVTag).getAreaPasswordLength(with: jint(mSelectedArea)))/8
            UIHelper.UI() {
                self.getCurrentPwdForArea()
            }

        }
        if mTag is ST25DVCTag {
            // Get the password number in case of protected area
            mAreaAffectedPasswordNumber = (Int)((mTag as! ST25DVCTag).getPasswordNumber(with: jint(mSelectedArea)))
            mPasswordNumbersOfBytes = (Int)((mTag as! ST25DVCTag).getAreaPasswordLength(with: jint(mSelectedArea)))/8
            UIHelper.UI() {
                self.getCurrentPwdForArea()
            }

        }
        if mTag is ST25TV16KTag {
            // Get the password number in case of protected area
            mAreaAffectedPasswordNumber = (Int)((mTag as! ST25TV16KTag).getPasswordNumber(with: jint(mSelectedArea)))
            mPasswordNumbersOfBytes = (Int)((mTag as! ST25TV16KTag).getAreaPasswordLength(with: jint(mSelectedArea)))/8
            UIHelper.UI() {
                self.getCurrentPwdForArea()
            }

        }
        if mTag is ST25TV64KTag {
            // Get the password number in case of protected area
            mAreaAffectedPasswordNumber = (Int)((mTag as! ST25TV64KTag).getPasswordNumber(with: jint(mSelectedArea)))
            mPasswordNumbersOfBytes = (Int)((mTag as! ST25TV64KTag).getAreaPasswordLength(with: jint(mSelectedArea)))/8
            UIHelper.UI() {
                self.getCurrentPwdForArea()
            }

        }
    }

}


extension ST25TVPasswordViewController: tagReaderSessionViewControllerDelegate {
    
    func handleTag(st25SDKTag: ComStSt25sdkNFCTag, uid: Data!) throws {
        mTag = st25SDKTag
        if self.isSameTag(uid: uid) {
            switch mTaskToDo {
            case .modifPasswordForArea:
                modifyPassword()
            case .getAreaPassword:
                getTagAffectedAreaPassword()
            }
        }else {
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
        if errorNFC.code ==  NFCReaderError.readerSessionInvalidationErrorSessionTimeout {
            // session Timeout detected
            // restart a session to continu
            //invalidateGridStatus()
        }
        else if errorNFC.code ==  NFCReaderError.readerSessionInvalidationErrorUserCanceled {
        }
    }
    
    func handleTagST25SdkError(didInvalidateWithError error: NSException) {
        //print(error.description)
        DispatchQueue.main.async {
            self.warningAlert(message: "Command failed: \(error.description)")
        }
    }
    

}

extension ST25TVPasswordViewController: ST25PasswordViewDelegate {
    func okButtonTapped(pwdValue: Data) {
        if self.mTaskToDo == .getAreaPassword {
            //print(pwdValue.toHexString())
            self.mST25TagAreaPwd = pwdValue
            DispatchQueue.main.async {
                self.mTaskToDo = .modifPasswordForArea
                self.getNewAreaPwd()
            }

        }
        if self.mTaskToDo == .modifPasswordForArea {
            //print(pwdValue.toHexString())
            self.mST25TagAreaPwdNew = pwdValue
            self.mTaskToDo = .modifPasswordForArea
            self.miOSReaderSession.startTagReaderSession()
        }

    }

    func cancelButtonTapped() {
        if mTaskToDo == .modifPasswordForArea {
            mTaskToDo = .getAreaPassword
        }
    }
}
