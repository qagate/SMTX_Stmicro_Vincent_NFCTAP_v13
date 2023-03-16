//
//  ST25TVAreaManagementViewController.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 13/12/2019.
//  Copyright © 2019 STMicroelectronics. All rights reserved.
//

import UIKit
import CoreNFC


class ST25TVAreaManagementViewController: ST25UIViewController {
    internal var mTag:ComStSt25sdkNFCTag!

    internal var miOSReaderSession:iOSReaderSession!
    internal var mST25TagConfigurationPwd:Data!

    enum taskToDo {
        case initAreaMemoryConf
        case getConfigurationPwd
        case updateTagConfiguration
    }
    internal var mTaskToDo:taskToDo = .updateTagConfiguration

    var mArea1Enable:Bool = true
    var mArea2Enable:Bool = false
    var mNumberOfAreas: Int8 = 1
    
    @IBOutlet weak var oneSingleAreaSwitch: UISwitch!
    @IBOutlet weak var twoAreasSwitch: UISwitch!
    @IBOutlet weak var mCurrentMemoryConfLabel: UILabel!
    
    @IBAction func oneSingleAreaSwitchAction(_ sender: Any) {
        if oneSingleAreaSwitch.isOn {
            twoAreasSwitch.setOn(false, animated: true)
            mArea2Enable = false
            mArea1Enable = true
            
        } else {
            mArea1Enable = true
            oneSingleAreaSwitch.setOn(true, animated: true)
        }
    }
    
    @IBAction func twoAreasSwitchAction(_ sender: Any) {
        if twoAreasSwitch.isOn {
            oneSingleAreaSwitch.setOn(false, animated: true)
            mArea1Enable = false
            mArea2Enable = true

        } else {
            mArea2Enable = true
            twoAreasSwitch.setOn(true, animated: true)
        }
    }
    
    @IBAction func updateTag(_ sender: Any) {
        mTaskToDo = .getConfigurationPwd
        presentPwdController()
    }
    
    @IBAction func refreshMemoryConfiguration(_ sender: Any) {
        mTaskToDo = .initAreaMemoryConf
        miOSReaderSession.startTagReaderSession()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Areas management"
        oneSingleAreaSwitch.setOn(true, animated: true)
        mArea1Enable = true
        mArea2Enable = false
        twoAreasSwitch.setOn(false, animated: true)

        self.miOSReaderSession = iOSReaderSession(atagReaderSessionViewControllerDelegate: self)
        
        setMemoryConfigurationNotInitialised()
        
        mTaskToDo = .initAreaMemoryConf
        miOSReaderSession.startTagReaderSession()

    }
    
    private func setSwitchsForTwoAreas() {
        if Thread.isMainThread {
            twoAreasSwitch.setOn(false, animated: true)
            mArea2Enable = false
            mArea1Enable = true
            oneSingleAreaSwitch.setOn(true, animated: true)
            
        } else {
            UIHelper.UI() {
                self.twoAreasSwitch.setOn(false, animated: true)
                self.mArea2Enable = false
                self.mArea1Enable = true
                self.oneSingleAreaSwitch.setOn(true, animated: true)
                
            }
        }
    }
    
    private func setSwitchsForOneArea() {
        if Thread.isMainThread {
            oneSingleAreaSwitch.setOn(false, animated: true)
            mArea1Enable = false
            mArea2Enable = true
            twoAreasSwitch.setOn(true, animated: true)
            
        } else {
            UIHelper.UI() {
                self.oneSingleAreaSwitch.setOn(false, animated: true)
                self.mArea1Enable = false
                self.mArea2Enable = true
                self.twoAreasSwitch.setOn(true, animated: true)
                
            }
        }
    }
    
    
    private func setMemoryConfiguation() {
        if self.mTag is ST25TVTag {
            (self.mTag as! ST25TVTag).presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25tvST25TVTag_ST25TV_CONFIGURATION_PASSWORD_ID), password: mST25TagConfigurationPwd)
            if mArea2Enable {
                (self.mTag as! ST25TVTag).setNumberOfAreasWith(jint(2))
            } else {
                // one area
                (self.mTag as! ST25TVTag).setNumberOfAreasWith(jint(1))
            }
            initPermissionsStatus()
        } else if self.mTag is ST25DVPwmTag {
            (self.mTag as! ST25DVPwmTag).presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25dvpwmST25DVPwmTag.ST25DVPWM_CONFIGURATION_PASSWORD_ID), password: mST25TagConfigurationPwd)
            if mArea2Enable {
                (self.mTag as! ST25DVPwmTag).setNumberOfAreasWith(jint(2))
            } else {
                // one area
                (self.mTag as! ST25DVPwmTag).setNumberOfAreasWith(jint(1))
            }
            initPermissionsStatus()
        } else {
            UIHelper.UI() {
                self.warningAlert(message: "Feature not supported ...")
            }

        }
    }
    
    private func initPermissionsStatus() {
        if self.mTag is ST25TVTag {
            mNumberOfAreas = Int8((self.mTag as! ST25TVTag).getNumberOfAreas())
        } else if self.mTag is ST25DVPwmTag {
            mNumberOfAreas = Int8((self.mTag as! ST25DVPwmTag).getNumberOfAreas())
        } else {
            UIHelper.UI() {
                self.warningAlert(message: "Feature not supported ...")
            }

        }
        if mNumberOfAreas == 2 {
            setSwitchsForTwoAreas()
        } else {
            setSwitchsForOneArea()
        }
        updateCurrentMemoryconfiguration(numberOfAreas: mNumberOfAreas)
    }
    
    private func updateCurrentMemoryconfiguration(numberOfAreas : Int8) {
        if Thread.isMainThread {
            mCurrentMemoryConfLabel.text = String(numberOfAreas) + " Area(s)"
        } else {
            UIHelper.UI() {
                self.mCurrentMemoryConfLabel.text = String(numberOfAreas) + " Area(s)"
            }
        }
    }
    
    private func setMemoryConfigurationNotInitialised() {
        if Thread.isMainThread {
            mCurrentMemoryConfLabel.text = String("X") + " Area(s)"
        } else {
            UIHelper.UI() {
                self.mCurrentMemoryConfLabel.text = String("X") + " Area(s)"
            }
        }
    }
    
    private func presentPwdController() {
        let mST25PasswordVC:ST25PasswordViewController = UIStoryboard(name: "ST25Password", bundle: nil).instantiateViewController(withIdentifier: "ST25PasswordID") as! ST25PasswordViewController
        mST25PasswordVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        mST25PasswordVC.setTitle("Enter configuration password")

        mST25PasswordVC.setMessage("(32 bits hexadecimal format)")
        mST25PasswordVC.numberOfBytes = 4
        
        mST25PasswordVC.delegate = self
        self.present(mST25PasswordVC, animated: false, completion: nil)
    }
    
    private func warningAlert(message : String) {
        UIHelper.warningAlert(viewController: self, title : "Area management" , message: message)
    }
}


extension ST25TVAreaManagementViewController: tagReaderSessionViewControllerDelegate {
    
    func handleTag(st25SDKTag: ComStSt25sdkNFCTag, uid: Data!) throws {
        self.mTag = st25SDKTag
        if self.isSameTag(uid: uid) {
            switch mTaskToDo {
            case .initAreaMemoryConf:
                initPermissionsStatus()
            case .getConfigurationPwd:
                nop()
            case .updateTagConfiguration:
                setMemoryConfiguation()
                
            }
        } else {
            //print((TabItem.TagInfo.mainVC as! ST25TagInformationViewController).productId?.description)
            //print(uid.toHexString())
            UIHelper.UI() {
                self.warningAlert(message: "Tag has changed, please scan again the Tag ...")
            }
        }
        
    }
    
    private func nop() {
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
        UIHelper.UI() {
            self.warningAlert(message: "Command failed: \(error.description)")
        }
        
        if mTaskToDo == .initAreaMemoryConf {
            setMemoryConfigurationNotInitialised()
        }
    }
    

}

extension ST25TVAreaManagementViewController: ST25PasswordViewDelegate {
    func okButtonTapped(pwdValue: Data) {
        if self.mTaskToDo == .getConfigurationPwd {
            //print(pwdValue.toHexString())
            self.mST25TagConfigurationPwd = pwdValue
            self.mTaskToDo = .updateTagConfiguration
            self.miOSReaderSession.startTagReaderSession()
        }
    }
    
    func cancelButtonTapped() {
    }
}
