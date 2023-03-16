//
//  ST25DVAreaPasswordViewController.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 20/03/2020.
//  Copyright © 2020 STMicroelectronics. All rights reserved.
//

import UIKit
import CoreNFC


protocol AreaSecurityPasswordEditionReady
{
    func onSecurityPasswordAreaReady(passwords : [Int])
}

class ST25DVAreaPasswordViewController: ST25UIViewController {
    
    internal var mTag : ComStSt25sdkNFCTag!
    internal var miOSReaderSession:iOSReaderSession!
    internal var mST25TagConfigurationPwd:Data!
    
    enum taskToDo {
        case setPassword
    }
    internal var mTaskToDo:taskToDo = .setPassword
    
    var mNumberOfAreas: Int8!
    var mAreaPasswordProtection = [Int]()
    enum PermissionPassword : String {
        case NOPASSWORD = "(No Password)"
        case PASSWORD1 = "(Password 1)"
        case PASSWORD2 = "(Password 2)"
        case PASSWORD3 = "(Password 3)"
        
        func printPermissionPassword() -> String {
            return self.rawValue
        }
    }

    var delegate:AreaSecurityPasswordEditionReady?
    
    
    var mArea1Enable:Bool = true
    var mArea2Enable:Bool = false
    var mArea3Enable:Bool = false
    var mArea4Enable:Bool = false
    
    @IBOutlet weak var mArea1Switch: UISwitch!
    @IBOutlet weak var mArea2Switch: UISwitch!
    @IBOutlet weak var mArea3Switch: UISwitch!
    @IBOutlet weak var mArea4Switch: UISwitch!
    
    
    @IBOutlet weak var mArea1Label: UILabel!
    @IBOutlet weak var mArea2Label: UILabel!
    @IBOutlet weak var mArea3Label: UILabel!
    @IBOutlet weak var mArea4Label: UILabel!
    
    
    @IBOutlet weak var mNoPasswordFlagSwitch: UISwitch!
    @IBOutlet weak var mPassword1FlagSwitch: UISwitch!
    @IBOutlet weak var mPassword2FlagSwitch: UISwitch!
    @IBOutlet weak var mPassword3FlagSwitch: UISwitch!
    
    var mNoPasswordFlag = false
    var mPassword1Flag = false
    var mPassword2Flag = false
    var mPassword3Flag = false
    

    @IBAction func selectArea1SwitchAction(_ sender: Any) {
        if mArea1Switch.isOn {
            mArea1Enable = true
        } else {
            mArea1Enable = true
            mArea1Switch.setOn(true, animated: true)
        }
        refreshPasswordSwitchs(password: mAreaPasswordProtection[0])
        
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
        refreshPasswordSwitchs(password: mAreaPasswordProtection[1])
        
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
        refreshPasswordSwitchs(password: mAreaPasswordProtection[2])
        
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
        refreshPasswordSwitchs(password: mAreaPasswordProtection[3])
        
        mArea1Switch.setOn(false, animated: true)
        mArea1Enable = false
        mArea2Switch.setOn(false, animated: true)
        mArea2Enable = false
        mArea3Switch.setOn(false, animated: true)
        mArea3Enable = false
        
    }
    

    @IBAction func selectNoPasswordSwitchAction(_ sender: Any) {
        if mNoPasswordFlagSwitch.isOn {
            mNoPasswordFlag = true
        }else {
            mNoPasswordFlag = true
            mNoPasswordFlagSwitch.setOn(true, animated: true)
        }
        mPassword2FlagSwitch.setOn(false, animated: true)
        mPassword1FlagSwitch.setOn(false, animated: true)
        mPassword3FlagSwitch.setOn(false, animated: true)
        mPassword1Flag = false
        mPassword2Flag = false
        mPassword3Flag = false
        
    }
    

    @IBAction func selectPassword1SwitchAction(_ sender: Any) {
        if mPassword1FlagSwitch.isOn {
            mPassword1Flag = true
        }else {
            mPassword1Flag = true
            mPassword2FlagSwitch.setOn(true, animated: true)
        }
        mNoPasswordFlagSwitch.setOn(false, animated: true)
        mPassword2FlagSwitch.setOn(false, animated: true)
        mPassword3FlagSwitch.setOn(false, animated: true)
        mNoPasswordFlag = false
        mPassword2Flag = false
        mPassword3Flag = false
        
    }
  
    @IBAction func selectPassword2SwitchAction(_ sender: Any) {
        if mPassword2FlagSwitch.isOn {
            mPassword2Flag = true
        }else {
            mPassword2Flag = true
            mPassword2FlagSwitch.setOn(true, animated: true)
        }
        mNoPasswordFlagSwitch.setOn(false, animated: true)
        mPassword1FlagSwitch.setOn(false, animated: true)
        mPassword3FlagSwitch.setOn(false, animated: true)
        mNoPasswordFlag = false
        mPassword1Flag = false
        mPassword3Flag = false
        
    }
    
    @IBAction func selectPassword3SwitchAction(_ sender: Any) {
        if mPassword3FlagSwitch.isOn {
            mPassword3Flag = true
        } else {
            mPassword3Flag = true
            mPassword3FlagSwitch.setOn(true, animated: true)
        }
        mNoPasswordFlagSwitch.setOn(false, animated: true)
        mPassword2FlagSwitch.setOn(false, animated: true)
        mPassword1FlagSwitch.setOn(false, animated: true)
        mNoPasswordFlag = false
        mPassword1Flag = false
        mPassword2Flag = false
    }
    

    @IBAction func updateTag(_ sender: Any) {
        mTaskToDo = .setPassword
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
        updatePasswordSwitchs()
        
        disableOOBSwitch()
        updateAreaLabelsSwitch()
        self.miOSReaderSession = iOSReaderSession(atagReaderSessionViewControllerDelegate: self)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.mAreaPasswordProtection != nil {
            delegate?.onSecurityPasswordAreaReady(passwords: self.mAreaPasswordProtection)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    private func disableOOBSwitch() {
        for index in mNumberOfAreas ..< 4 {
            disableSwitch(index: Int(index))
        }
    }
    
    private func updateAreaLabelsSwitch() {
        for index in  0 ..< mNumberOfAreas {
            updateAreaLabelsSwitch(area: Int(index))
        }
    }
    private func updateAreaLabelsSwitch(area : Int) {
        if area == 0 {
            mArea1Label.text = "Area1 " + getPermissionLabelFromState(protection: self.mAreaPasswordProtection[0])
        }
        if area == 1 {
            mArea2Label.text = "Area2 " + getPermissionLabelFromState(protection: self.mAreaPasswordProtection[1])
        }
        if area == 2 {
            mArea3Label.text = "Area3 " + getPermissionLabelFromState(protection: self.mAreaPasswordProtection[2])
        }
        if area == 3 {
            mArea4Label.text = "Area4 " + getPermissionLabelFromState(protection: self.mAreaPasswordProtection[3])
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
        
        if self.mTag is ST25DVTag || self.mTag is ST25DVCTag || self.mTag is ST25TV16KTag || self.mTag is ST25TV64KTag {
            mST25PasswordVC.setMessage("(64 bits hexadecimal format)")
            mST25PasswordVC.setNumberOfBytes(8)
        } else {
            UIHelper.UI() {
                self.warningAlert(message: "Feature not supported ...")
            }
        }
        mST25PasswordVC.delegate = self
        self.present(mST25PasswordVC, animated: false, completion: nil)
    }
    
    
    
    private func setPassword() {
        let area = Int8(getAreaFromSwitchs())
        if self.mTag is ST25DVTag {
            let password = getPermissionFromSwitchs()
            (self.mTag as! ST25DVTag).presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25dvST25DVTag_ST25DV_CONFIGURATION_PASSWORD_ID), password: mST25TagConfigurationPwd)
            (self.mTag as! ST25DVTag).setPasswordNumberWith(jint(area), with: jint(password))
            self.mAreaPasswordProtection.remove(at: Int(area-1))
            self.mAreaPasswordProtection.insert(password, at: Int(area-1))
            UIHelper.UI() {
                self.updateAreaLabelsSwitch(area: Int(area-1))
            }
        } else if self.mTag is ST25DVCTag {
            let password = getPermissionFromSwitchs()
            (self.mTag as! ST25DVCTag).presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25dvST25DVTag_ST25DV_CONFIGURATION_PASSWORD_ID), password: mST25TagConfigurationPwd)
            (self.mTag as! ST25DVCTag).setPasswordNumberWith(jint(area), with: jint(password))
            self.mAreaPasswordProtection.remove(at: Int(area-1))
            self.mAreaPasswordProtection.insert(password, at: Int(area-1))
            UIHelper.UI() {
                self.updateAreaLabelsSwitch(area: Int(area-1))
            }
        } else if self.mTag is ST25TV16KTag {
            let password = getPermissionFromSwitchs()
            (self.mTag as! ST25TV16KTag).presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25dvST25TV16KTag.ST25TVHighDensity_CONFIGURATION_PASSWORD_ID), password: mST25TagConfigurationPwd)
            (self.mTag as! ST25TV16KTag).setPasswordNumberWith(jint(area), with: jint(password))
            self.mAreaPasswordProtection.remove(at: Int(area-1))
            self.mAreaPasswordProtection.insert(password, at: Int(area-1))
            UIHelper.UI() {
                self.updateAreaLabelsSwitch(area: Int(area-1))
            }
        } else if self.mTag is ST25TV64KTag {
            let password = getPermissionFromSwitchs()
            (self.mTag as! ST25TV64KTag).presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25dvST25TV64KTag.ST25TVHighDensity_CONFIGURATION_PASSWORD_ID), password: mST25TagConfigurationPwd)
            (self.mTag as! ST25TV64KTag).setPasswordNumberWith(jint(area), with: jint(password))
            self.mAreaPasswordProtection.remove(at: Int(area-1))
            self.mAreaPasswordProtection.insert(password, at: Int(area-1))
            UIHelper.UI() {
                self.updateAreaLabelsSwitch(area: Int(area-1))
            }
        }else {
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
    
    private func refreshPasswordSwitchs(password: Int)  {
        switch password {
        case 0:
            mNoPasswordFlagSwitch.setOn(true, animated: true)
            mPassword2FlagSwitch.setOn(false, animated: true)
            mPassword1FlagSwitch.setOn(false, animated: true)
            mPassword3FlagSwitch.setOn(false, animated: true)
            
        case Int(ComStSt25sdkType5St25dvST25DVTag_get_ST25DV_PASSWORD_1()):
            mNoPasswordFlagSwitch.setOn(false, animated: true)
            mPassword2FlagSwitch.setOn(false, animated: true)
            mPassword1FlagSwitch.setOn(true, animated: true)
            mPassword3FlagSwitch.setOn(false, animated: true)
            
        case Int(ComStSt25sdkType5St25dvST25DVTag_get_ST25DV_PASSWORD_2()):
            mNoPasswordFlagSwitch.setOn(false, animated: true)
            mPassword2FlagSwitch.setOn(true, animated: true)
            mPassword1FlagSwitch.setOn(false, animated: true)
            mPassword3FlagSwitch.setOn(false, animated: true)
            
        case Int(ComStSt25sdkType5St25dvST25DVTag_get_ST25DV_PASSWORD_3()):
            mNoPasswordFlagSwitch.setOn(false, animated: true)
            mPassword2FlagSwitch.setOn(false, animated: true)
            mPassword1FlagSwitch.setOn(false, animated: true)
            mPassword3FlagSwitch.setOn(true, animated: true)
            
        default:
            print("Permission not handled")
        }
    }
    
    private func updatePasswordSwitchs() {
        if mArea1Switch.isOn {
            refreshPasswordSwitchs(password: mAreaPasswordProtection[0])
        }
        if mArea2Switch.isOn {
            refreshPasswordSwitchs(password: mAreaPasswordProtection[1])
        }
        if mArea3Switch.isOn {
            refreshPasswordSwitchs(password: mAreaPasswordProtection[2])
        }
        if mArea4Switch.isOn {
            refreshPasswordSwitchs(password: mAreaPasswordProtection[3])
        }
    }
    
    private func getPermissionFromSwitchs() -> Int{
        if mNoPasswordFlag {
            return 0
        }
        if mPassword1Flag {
            return Int(ComStSt25sdkType5St25dvST25DVTag_get_ST25DV_PASSWORD_1())
        }
        if mPassword2Flag {
            return Int(ComStSt25sdkType5St25dvST25DVTag_get_ST25DV_PASSWORD_2())
        }
        if mPassword3Flag {
            return Int(ComStSt25sdkType5St25dvST25DVTag_get_ST25DV_PASSWORD_3())
        }
        return 0
    }
    
    private func getPermissionLabelFromState(protection : Int) -> String {
        if protection == 0 {
            return PermissionPassword.NOPASSWORD.printPermissionPassword()
        }
        if protection == Int(ComStSt25sdkType5St25dvST25DVTag_get_ST25DV_PASSWORD_1()) {
            return PermissionPassword.PASSWORD1.printPermissionPassword()
        }
        if protection == Int(ComStSt25sdkType5St25dvST25DVTag_get_ST25DV_PASSWORD_2()) {
            return PermissionPassword.PASSWORD2.printPermissionPassword()
        }
        if protection == Int(ComStSt25sdkType5St25dvST25DVTag_get_ST25DV_PASSWORD_3()) {
            return PermissionPassword.PASSWORD3.printPermissionPassword()
        }
        return PermissionPassword.NOPASSWORD.printPermissionPassword()
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

extension ST25DVAreaPasswordViewController: tagReaderSessionViewControllerDelegate {
    
    func handleTag(st25SDKTag: ComStSt25sdkNFCTag, uid: Data!) throws {
        mTag = st25SDKTag
        if self.isSameTag(uid: uid) {
            switch mTaskToDo {
            case .setPassword:
                setPassword()
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

extension ST25DVAreaPasswordViewController: ST25PasswordViewDelegate {
    func okButtonTapped(pwdValue: Data) {
        //print(pwdValue.toHexString())
        self.mST25TagConfigurationPwd = pwdValue
        self.miOSReaderSession.startTagReaderSession()
    }
    
    func cancelButtonTapped() {
    }
}

