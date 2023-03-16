//
//  ST25PermissionsViewController.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 09/12/2019.
//  Copyright © 2019 STMicroelectronics. All rights reserved.
//

import UIKit
import CoreNFC

protocol AreaSecurityPermissionEditionReady
{
    func onSecurityPermissionAreaReady(permissions : [ComStSt25sdkTagHelper_ReadWriteProtection])
}

class ST25PermissionsViewController: ST25UIViewController {

    internal var mTag : ComStSt25sdkNFCTag!
    internal var miOSReaderSession:iOSReaderSession!
    internal var mST25TagConfigurationPwd:Data!

    enum taskToDo {
        case setPermissionStatus
    }
    internal var mTaskToDo:taskToDo = .setPermissionStatus
    
    var mNumberOfAreas: Int8!
    
    var mAreaRWProtection = [ComStSt25sdkTagHelper_ReadWriteProtection]()

    var delegate:AreaSecurityPermissionEditionReady?

    
    var mArea1Enable:Bool = true
    var mArea2Enable:Bool = false
    var mArea3Enable:Bool = false
    var mArea4Enable:Bool = false
    
    @IBOutlet weak var mArea1Switch: UISwitch!
    @IBOutlet weak var mArea2Switch: UISwitch!
    @IBOutlet weak var mArea3Switch: UISwitch!
    @IBOutlet weak var mArea4Switch: UISwitch!
    
    
    @IBOutlet weak var mArea2Label: UILabel!
    @IBOutlet weak var mArea3Label: UILabel!
    @IBOutlet weak var mArea4Label: UILabel!
    

    @IBOutlet weak var mRProtectedWImpossibleSwitch: UISwitch!
    @IBOutlet weak var mRandWProtectedSwitch: UISwitch!
    @IBOutlet weak var mRWProtectedSwitch: UISwitch!
    @IBOutlet weak var mRWEnableSwitch: UISwitch!
    
    
    var mRWEnableFlag = false
    var mRandWProtectedFlag = false
    var mRWProtectedFlag = false
    var mRProtectedWImpossibleFlag = false

    @IBAction func selectArea1SwitchAction(_ sender: Any) {
        if mArea1Switch.isOn {
            mArea1Enable = true
        } else {
            mArea1Enable = true
            mArea1Switch.setOn(true, animated: true)
        }
        refreshPermissionSwitchs(permission: mAreaRWProtection[0])

        mArea2Switch.setOn(false, animated: true)
        mArea2Enable = false
        mArea3Switch.setOn(false, animated: true)
        mArea3Enable = false
        mArea4Switch.setOn(false, animated: true)
        mArea4Enable = false

    }
    
    @IBAction func selectArea2SwitchAction(_ sender: Any) {
        if mArea2Switch.isOn {
            mArea2Enable = true
        } else {
            mArea2Enable = true
            mArea2Switch.setOn(true, animated: true)
        }
        refreshPermissionSwitchs(permission: mAreaRWProtection[1])

        mArea1Switch.setOn(false, animated: true)
        mArea1Enable = false
        mArea3Switch.setOn(false, animated: true)
        mArea3Enable = false
        mArea4Switch.setOn(false, animated: true)
        mArea4Enable = false
    }
    
    @IBAction func selectArea3SwitchAction(_ sender: UISwitch) {
        if mArea3Switch.isOn {
              mArea3Enable = true
          } else {
              mArea3Enable = true
              mArea3Switch.setOn(true, animated: true)
           }
         refreshPermissionSwitchs(permission: mAreaRWProtection[2])

         mArea1Switch.setOn(false, animated: true)
         mArea1Enable = false
         mArea2Switch.setOn(false, animated: true)
         mArea2Enable = false
         mArea4Switch.setOn(false, animated: true)
         mArea4Enable = false
    }
    
    @IBAction func selectArea4SwitchAction(_ sender: UISwitch) {
        if mArea4Switch.isOn {
            mArea4Enable = true
        } else {
            mArea4Enable = true
            mArea4Switch.setOn(true, animated: true)
        }
        refreshPermissionSwitchs(permission: mAreaRWProtection[3])
        
        mArea1Switch.setOn(false, animated: true)
        mArea1Enable = false
        mArea2Switch.setOn(false, animated: true)
        mArea2Enable = false
        mArea3Switch.setOn(false, animated: true)
        mArea3Enable = false
        
    }
    
    @IBAction func selectRWEnableSwitchAction(_ sender: Any) {
        if mRWEnableSwitch.isOn {
            //mRWEnableSwitch.setOn(false, animated: true)
            mRWProtectedSwitch.setOn(false, animated: true)
            mRandWProtectedSwitch.setOn(false, animated: true)
            mRProtectedWImpossibleSwitch.setOn(false, animated: true)
        }else {
            mRWEnableSwitch.setOn(true, animated: true)
        }
        mRWEnableFlag = true
        mRWProtectedFlag = false
        mRandWProtectedFlag = false
        mRProtectedWImpossibleFlag = false

    }
    
    @IBAction func selectRWProtectedSwitchAction(_ sender: Any) {
        if mRWProtectedSwitch.isOn {
            mRWEnableSwitch.setOn(false, animated: true)
            //mRWProtectedSwitch.setOn(false, animated: true)
            mRandWProtectedSwitch.setOn(false, animated: true)
            mRProtectedWImpossibleSwitch.setOn(false, animated: true)
        }else {
            mRWProtectedSwitch.setOn(true, animated: true)
        }
        mRWEnableFlag = false
        mRWProtectedFlag = true
        mRandWProtectedFlag = false
        mRProtectedWImpossibleFlag = false

    }
    @IBAction func selectRandWProtectedSwitchAction(_ sender: Any) {
        if mRandWProtectedSwitch.isOn {
            mRWEnableSwitch.setOn(false, animated: true)
            mRWProtectedSwitch.setOn(false, animated: true)
            //mRandWProtectedSwitch.setOn(false, animated: true)
            mRProtectedWImpossibleSwitch.setOn(false, animated: true)
        }else {
            mRandWProtectedSwitch.setOn(true, animated: true)
        }
        mRWEnableFlag = false
        mRWProtectedFlag = false
        mRandWProtectedFlag = true
        mRProtectedWImpossibleFlag = false

    }
    
    @IBAction func selectRProtectedWImpossibleSwitchAction(_ sender: Any) {
        if mRProtectedWImpossibleSwitch.isOn {
            mRWEnableSwitch.setOn(false, animated: true)
            mRWProtectedSwitch.setOn(false, animated: true)
            mRandWProtectedSwitch.setOn(false, animated: true)
            //mRProtectedWImpossibleSwitch.setOn(false, animated: true)
        } else {
            mRProtectedWImpossibleSwitch.setOn(true, animated: true)
        }
        mRWEnableFlag = false
        mRWProtectedFlag = false
        mRandWProtectedFlag = false
        mRProtectedWImpossibleFlag = true
    }
    
    @IBAction func updateTag(_ sender: Any) {
        mTaskToDo = .setPermissionStatus
        presentPwdController()

    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        mArea1Switch.setOn(true, animated: true)
        mArea1Enable = true
        mArea2Switch.setOn(false, animated: true)
        mArea3Switch.setOn(false, animated: true)
        mArea4Switch.setOn(false, animated: true)
        mArea2Enable = false
        mArea3Enable = false
        mArea4Enable = false
        updatePermissionSwitchs()
        
        disableOOBSwitch()

        self.miOSReaderSession = iOSReaderSession(atagReaderSessionViewControllerDelegate: self)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.mAreaRWProtection != nil {
            delegate?.onSecurityPermissionAreaReady(permissions: self.mAreaRWProtection)
        }
        self.dismiss(animated: true, completion: nil)
    }

    
    private func disableOOBSwitch() {
        for index in mNumberOfAreas ..< 4 {
            disableSwitch(index: Int(index))
        }
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
    
    private func presentPwdController() {
        let mST25PasswordVC:ST25PasswordViewController = UIStoryboard(name: "ST25Password", bundle: nil).instantiateViewController(withIdentifier: "ST25PasswordID") as! ST25PasswordViewController
        mST25PasswordVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        mST25PasswordVC.setTitle("Enter configuration password")

        if self.mTag is ST25TVTag || self.mTag is ST25DVPwmTag || self.mTag is ST25TVCTag {
            mST25PasswordVC.setMessage("(32 bits hexadecimal format)")
            mST25PasswordVC.setNumberOfBytes(4)
        } else if self.mTag is ST25DVTag || self.mTag is ST25TV16KTag || self.mTag is ST25TV64KTag {
            mST25PasswordVC.setMessage("(64 bits hexadecimal format)")
            mST25PasswordVC.setNumberOfBytes(8)
        }
        
        mST25PasswordVC.delegate = self
        self.present(mST25PasswordVC, animated: false, completion: nil)
    }
    

    
    private func setPermissions() {
        var area: Int8 = 1
        area = Int8(getAreaFromSwitchs())
        if self.mTag is ST25TVTag {
            let permission = getPermissionFromSwitchs()
            (self.mTag as! ST25TVTag).presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25tvST25TVTag_ST25TV_CONFIGURATION_PASSWORD_ID), password: mST25TagConfigurationPwd)
            (self.mTag as! ST25TVTag).setReadWriteProtectionWith(jint(area), with: permission)
            self.mAreaRWProtection.remove(at: Int(area-1))
            self.mAreaRWProtection.insert(permission, at: Int(area-1))
        } else if self.mTag is ST25TVCTag {
            let permission = getPermissionFromSwitchs()
            (self.mTag as! ST25TVCTag).presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25tvcST25TVCTag_ST25TVC_CONFIGURATION_PASSWORD_ID), password: mST25TagConfigurationPwd)
            (self.mTag as! ST25TVCTag).setReadWriteProtectionWith(jint(area), with: permission)
            self.mAreaRWProtection.remove(at: Int(area-1))
            self.mAreaRWProtection.insert(permission, at: Int(area-1))
        } else if self.mTag is ST25DVTag {
            let permission = getPermissionFromSwitchs()
            (self.mTag as! ST25DVTag).presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25dvST25DVTag_ST25DV_CONFIGURATION_PASSWORD_ID), password: mST25TagConfigurationPwd)
            (self.mTag as! ST25DVTag).setReadWriteProtectionWith(jint(area), with: permission)
            self.mAreaRWProtection.remove(at: Int(area-1))
            self.mAreaRWProtection.insert(permission, at: Int(area-1))
        } else if self.mTag is ST25DVCTag {
            let permission = getPermissionFromSwitchs()
            (self.mTag as! ST25DVCTag).presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25dvST25DVTag_ST25DV_CONFIGURATION_PASSWORD_ID), password: mST25TagConfigurationPwd)
            (self.mTag as! ST25DVCTag).setReadWriteProtectionWith(jint(area), with: permission)
            self.mAreaRWProtection.remove(at: Int(area-1))
            self.mAreaRWProtection.insert(permission, at: Int(area-1))
        } else if self.mTag is ST25DVPwmTag {
            let permission = getPermissionFromSwitchs()
            (self.mTag as! ST25DVPwmTag).presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25dvpwmST25DVPwmTag_ST25DVPWM_CONFIGURATION_PASSWORD_ID), password: mST25TagConfigurationPwd)
            (self.mTag as! ST25DVPwmTag).setReadWriteProtectionWith(jint(area), with: permission)
            self.mAreaRWProtection.remove(at: Int(area-1))
            self.mAreaRWProtection.insert(permission, at: Int(area-1))

        } else if self.mTag is ST25TV16KTag {
            let permission = getPermissionFromSwitchs()
            (self.mTag as! ST25TV16KTag).presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25dvST25TV16KTag.ST25TVHighDensity_CONFIGURATION_PASSWORD_ID), password: mST25TagConfigurationPwd)
            (self.mTag as! ST25TV16KTag).setReadWriteProtectionWith(jint(area), with: permission)
            self.mAreaRWProtection.remove(at: Int(area-1))
            self.mAreaRWProtection.insert(permission, at: Int(area-1))
        }  else if self.mTag is ST25TV64KTag {
            let permission = getPermissionFromSwitchs()
            (self.mTag as! ST25TV64KTag).presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25dvST25TV64KTag.ST25TVHighDensity_CONFIGURATION_PASSWORD_ID), password: mST25TagConfigurationPwd)
            (self.mTag as! ST25TV64KTag).setReadWriteProtectionWith(jint(area), with: permission)
            self.mAreaRWProtection.remove(at: Int(area-1))
            self.mAreaRWProtection.insert(permission, at: Int(area-1))
        } else {
            UIHelper.UI() {
                self.warningAlert(message: "Feature not supported ...")
            }

        }

    }
    
    private func disableSecondAreaConfiguration() {
        mArea1Switch.isUserInteractionEnabled = false
        mArea2Switch.isUserInteractionEnabled = false
        mArea2Label.alpha = 0.66
        
        mArea2Label.isHidden = true
        mArea2Switch.isHidden = true
    }
    private func disableThirdAreaConfiguration() {
        mArea3Switch.isUserInteractionEnabled = false
        mArea3Label.alpha = 0.66
        mArea3Label.isHidden = true
        mArea3Switch.isHidden = true

    }
    private func disableFourthAreaConfiguration() {
        mArea4Switch.isUserInteractionEnabled = false
        mArea4Label.alpha = 0.66
        mArea4Label.isHidden = true
        mArea4Switch.isHidden = true
    }
    
    private func refreshPermissionSwitchs(permission: ComStSt25sdkTagHelper_ReadWriteProtection)  {
        if permission != nil {
            switch permission {
            case .READABLE_AND_WRITABLE:
                mRWEnableSwitch.setOn(true, animated: true)
                mRWProtectedSwitch.setOn(false, animated: true)
                mRandWProtectedSwitch.setOn(false, animated: true)
                mRProtectedWImpossibleSwitch.setOn(false, animated: true)
                
            case .READABLE_AND_WRITE_PROTECTED_BY_PWD:
                mRWEnableSwitch.setOn(false, animated: true)
                mRWProtectedSwitch.setOn(true, animated: true)
                mRandWProtectedSwitch.setOn(false, animated: true)
                mRProtectedWImpossibleSwitch.setOn(false, animated: true)

            case .READ_AND_WRITE_PROTECTED_BY_PWD:
                mRWEnableSwitch.setOn(false, animated: true)
                mRWProtectedSwitch.setOn(false, animated: true)
                mRandWProtectedSwitch.setOn(true, animated: true)
                mRProtectedWImpossibleSwitch.setOn(false, animated: true)

            case .READ_PROTECTED_BY_PWD_AND_WRITE_IMPOSSIBLE:
                mRWEnableSwitch.setOn(false, animated: true)
                mRWProtectedSwitch.setOn(false, animated: true)
                mRandWProtectedSwitch.setOn(false, animated: true)
                mRProtectedWImpossibleSwitch.setOn(true, animated: true)

            default:
                print("Permission not handled")
            }
        }
    }
    
    private func updatePermissionSwitchs() {
        if mArea1Switch.isOn {
            refreshPermissionSwitchs(permission: mAreaRWProtection[0])
        }
        if mArea2Switch.isOn {
            refreshPermissionSwitchs(permission: mAreaRWProtection[1])
        }
        if mArea3Switch.isOn {
            refreshPermissionSwitchs(permission: mAreaRWProtection[2])
        }
        if mArea4Switch.isOn {
            refreshPermissionSwitchs(permission: mAreaRWProtection[3])
        }
    }

    private func getPermissionFromSwitchs() -> ComStSt25sdkTagHelper_ReadWriteProtection{
        if mRWEnableFlag {
            return ComStSt25sdkTagHelper_ReadWriteProtection.READABLE_AND_WRITABLE
        }
        if mRWProtectedFlag {
            return ComStSt25sdkTagHelper_ReadWriteProtection.READABLE_AND_WRITE_PROTECTED_BY_PWD
        }
        if mRandWProtectedFlag {
            return ComStSt25sdkTagHelper_ReadWriteProtection.READ_AND_WRITE_PROTECTED_BY_PWD
        }
        if mRProtectedWImpossibleFlag {
            return ComStSt25sdkTagHelper_ReadWriteProtection.READABLE_AND_WRITE_IMPOSSIBLE
        }
        return ComStSt25sdkTagHelper_ReadWriteProtection.READABLE_AND_WRITABLE
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
    
    private func warningAlert(message : String) {
        UIHelper.warningAlert(viewController: self, title : "Permissions update" , message: message)
    }

}

extension ST25PermissionsViewController: tagReaderSessionViewControllerDelegate {
    
    func handleTag(st25SDKTag: ComStSt25sdkNFCTag, uid: Data!) throws {
        mTag = st25SDKTag
        if self.isSameTag(uid: uid) {
            switch mTaskToDo {
            case .setPermissionStatus:
                setPermissions()
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

extension ST25PermissionsViewController: ST25PasswordViewDelegate {
    func okButtonTapped(pwdValue: Data) {
        //print(pwdValue.toHexString())
        self.mST25TagConfigurationPwd = pwdValue
        self.miOSReaderSession.startTagReaderSession()
    }

    func cancelButtonTapped() {
    }
}
