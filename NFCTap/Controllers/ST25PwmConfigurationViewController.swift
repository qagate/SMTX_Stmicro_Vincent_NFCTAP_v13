//
//  ST25PwmConfigurationViewController.swift
//  NFCTap 
//
//  Created by STMICROELECTRONICS on 02/06/2020.
//  Copyright © 2020 STMicroelectronics. All rights reserved.
//

import UIKit
import CoreNFC

class ST25PwmConfigurationViewController: ST25UIViewController {

    internal var mTag:ComStSt25sdkNFCTag!
    internal var miOSReaderSession:iOSReaderSession!
    internal var mTaskToDo:taskToDo = .retrieveTagConfiguration
    internal var mST25ConfigurationPwd:Data!
    internal var mST25PwmPwd:Data!
    internal var mST25PwmNewPwd:Data!

    enum taskToDo {
        case retrieveTagConfiguration
        case updateTagConfiguration
        case presentPwmConfigurationPwd
        case updatePwmPwd
        case getPwmPassword
    }
    
    private var mPwm1OutputPower : ComStSt25sdkType5St25dvpwmST25DV02KWRegisterPwmRfConfiguration_OutputDriverTrimming = ComStSt25sdkType5St25dvpwmST25DV02KWRegisterPwmRfConfiguration_OutputDriverTrimming.FULL_POWER
    private var mPwm2OutputPower : ComStSt25sdkType5St25dvpwmST25DV02KWRegisterPwmRfConfiguration_OutputDriverTrimming = ComStSt25sdkType5St25dvpwmST25DV02KWRegisterPwmRfConfiguration_OutputDriverTrimming.FULL_POWER
    private var mDualityMgt : ComStSt25sdkType5St25dvpwmST25DV02KWRegisterPwmRfConfiguration_DualityManagement = ComStSt25sdkType5St25dvpwmST25DV02KWRegisterPwmRfConfiguration_DualityManagement.FULL_DUPLEX
    private var mPwmAccessRights : ComStSt25sdkTagHelper_ReadWriteProtection = .READABLE_AND_WRITABLE
    
    private var mPwm1OutputPowerPickerIndex : Int = 0
    private var mPwm2OutputPowerPickerIndex : Int = 0
    private var mDualityMgtPickerIndex : Int = 0
    private var mPwmAccessRightsPickerIndex : Int = 0

    private var mPwm2Available = false

    enum DRIVER_TRIMMING : Int, CaseIterable {
        case FULL_POWWER = 0
        case ONE_QUARTER_FULL_POWER = 1
        case HALF_FULL_POWER = 2
        case THREE_QUARTER_FULL_POWER = 3
        static var count: Int { return  DRIVER_TRIMMING.THREE_QUARTER_FULL_POWER.hashValue + 1 }
        var description : String {
            switch self {
            case .FULL_POWWER : return "FULL_POWWER"
            case .ONE_QUARTER_FULL_POWER : return"ONE_QUARTER_FULL_POWER"
            case .HALF_FULL_POWER : return "HALF_FULL_POWER"
            case .THREE_QUARTER_FULL_POWER : return "THREE_QUARTER_FULL_POWER"

            }
        }
    }
    
    enum DUALITY_MANAGEMENT : Int, CaseIterable {
        case FULL_DUPLEX = 0
        case PWM_IN_HZ_WHILE_RF_CMD = 1
        case PWM_ONE_QUARTER_FULL_POWER_WHILE_RF_CMD = 2
        case PWM_FREQ_REDUCED = 3
        case PWM_FREQ_REDUCED_AND_ONE_QUARTER_FULL_POWER_WHILE_RF_CMD = 4
        static var count: Int { return  DUALITY_MANAGEMENT.PWM_FREQ_REDUCED_AND_ONE_QUARTER_FULL_POWER_WHILE_RF_CMD.hashValue + 1 }
        var description : String {
            switch self {
            case .FULL_DUPLEX : return "FULL_DUPLEX"
            case .PWM_IN_HZ_WHILE_RF_CMD : return"PWM_IN_HZ_WHILE_RF_CMD"
            case .PWM_ONE_QUARTER_FULL_POWER_WHILE_RF_CMD : return "PWM_ONE_QUARTER_FULL_POWER_WHILE_RF_CMD"
            case .PWM_FREQ_REDUCED : return "PWM_FREQ_REDUCED"
            case .PWM_FREQ_REDUCED_AND_ONE_QUARTER_FULL_POWER_WHILE_RF_CMD : return "PWM_FREQ_REDUCED_AND_ONE_QUARTER_FULL_POWER_WHILE_RF_CMD"

            }
        }
    }

    var pwmProtections : [String] = ["READABLE_AND_WRITABLE","READABLE_AND_WRITE_PROTECTED_BY_PWD","READ_AND_WRITE_PROTECTED_BY_PWD","READABLE_AND_WRITE_IMPOSSIBLE"]

    
    @IBOutlet weak var mPwm1OutputPowerPicker: UIPickerView!
    @IBOutlet weak var mPwm2OutputPowerPicker: UIPickerView!
    
    @IBOutlet weak var mPwmAndRFDualityManagementPicker: UIPickerView!
    
    @IBOutlet weak var mPwmAccessControlPicker: UIPickerView!
    
    @IBAction func updatePwmTagConfigurationButtonAction(_ sender: UIButton) {
        retrieveUIConfiguration()
        mTaskToDo = .presentPwmConfigurationPwd
        presentPwdController()

        //self.miOSReaderSession.startTagReaderSession()
    }
    
    @IBAction func changePwmPwdButtonAction(_ sender: UIButton) {
        mTaskToDo = .getPwmPassword
            getPwmPassword()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "PWM configuration"

        self.miOSReaderSession = iOSReaderSession(atagReaderSessionViewControllerDelegate: self)

        // Do any additional setup after loading the view.
        mPwm1OutputPowerPicker.delegate = self
        mPwm1OutputPowerPicker.dataSource = self

        mPwm2OutputPowerPicker.delegate = self
        mPwm2OutputPowerPicker.dataSource = self

        mPwmAndRFDualityManagementPicker.delegate = self
        mPwmAndRFDualityManagementPicker.dataSource = self
        
        mPwmAccessControlPicker.delegate = self
        mPwmAccessControlPicker.dataSource = self

        mTaskToDo = .retrieveTagConfiguration
        self.miOSReaderSession.startTagReaderSession()
    }
    
    private func retrieveTagConfiguration() {
        self.mPwm1OutputPower = (mTag as! ST25DVPwmTag).getPwmOutputDriverTrimming(with: ComStSt25sdkType5St25dvpwmST25DVPwmTag.PWM1)
        if ((mTag as! ST25DVPwmTag).getNumberOfPwm() == 2) {
            self.mPwm2OutputPower = (mTag as! ST25DVPwmTag).getPwmOutputDriverTrimming(with: ComStSt25sdkType5St25dvpwmST25DVPwmTag.PWM2)
            mPwm2Available = true
        }
        self.mDualityMgt = (mTag as! ST25DVPwmTag).getDualityManagement()
        self.mPwmAccessRights = (mTag as! ST25DVPwmTag).getPwmCtrlAccessRights()
        UIHelper.UI {
            self.updateUIWithTagConfiguration()
        }
    }
    
    private func updateUIWithTagConfiguration () {
        setPwm1OutputPowerPicker(status: self.mPwm1OutputPower)
        setPwm2OutputPowerPicker(status: self.mPwm2OutputPower)
        setPwmDualityMgtPicker(status: self.mDualityMgt)
        setPwmAccessRights(status: self.mPwmAccessRights)
    }
    
    private func setPwm1OutputPowerPicker(status : ComStSt25sdkType5St25dvpwmST25DV02KWRegisterPwmRfConfiguration_OutputDriverTrimming) {
        var statusIndex = 0
        switch status {
        case .FULL_POWER:
            statusIndex = 0
        case .ONE_QUARTER_FULL_POWER:
            statusIndex = 1
        case .HALF_FULL_POWER:
            statusIndex = 2
        case .THREE_QUARTER_FULL_POWER:
            statusIndex = 3

        default:
            print("Undefined status")
        }
        mPwm1OutputPowerPicker.selectRow(statusIndex, inComponent: 0, animated: true)

    }

    private func setPwm2OutputPowerPicker(status : ComStSt25sdkType5St25dvpwmST25DV02KWRegisterPwmRfConfiguration_OutputDriverTrimming) {
        var statusIndex = 0
        switch status {
        case .FULL_POWER:
            statusIndex = 0
        case .ONE_QUARTER_FULL_POWER:
            statusIndex = 1
        case .HALF_FULL_POWER:
            statusIndex = 2
        case .THREE_QUARTER_FULL_POWER:
            statusIndex = 3

        default:
            print("Undefined status")
        }
        mPwm2OutputPowerPicker.selectRow(statusIndex, inComponent: 0, animated: true)
    }
    
    private func getPwmOutputPowerFromIndex(index : Int) -> ComStSt25sdkType5St25dvpwmST25DV02KWRegisterPwmRfConfiguration_OutputDriverTrimming {
        var status : ComStSt25sdkType5St25dvpwmST25DV02KWRegisterPwmRfConfiguration_OutputDriverTrimming = .HALF_FULL_POWER
        switch index {
        case 0:
            status = .FULL_POWER
        case 1:
            status = .ONE_QUARTER_FULL_POWER
        case 2:
            status = .HALF_FULL_POWER
        case 3:
            status = .THREE_QUARTER_FULL_POWER

        default:
            print("Undefined status")
        }
        return status
    }

    private func setPwmDualityMgtPicker(status : ComStSt25sdkType5St25dvpwmST25DV02KWRegisterPwmRfConfiguration_DualityManagement) {
        var statusIndex = 0
        switch status {
        case .FULL_DUPLEX:
            statusIndex = 0
        case .PWM_IN_HZ_WHILE_RF_CMD:
            statusIndex = 1
        case .PWM_ONE_QUARTER_FULL_POWER_WHILE_RF_CMD:
            statusIndex = 2
        case .PWM_FREQ_REDUCED:
            statusIndex = 3
        case .PWM_FREQ_REDUCED_AND_ONE_QUARTER_FULL_POWER_WHILE_RF_CMD:
            statusIndex = 4

        default:
            print("Undefined status")
        }
        mPwmAndRFDualityManagementPicker.selectRow(statusIndex, inComponent: 0, animated: true)
    }

    private func getPwmDualityMgtFromIndex(index : Int) -> ComStSt25sdkType5St25dvpwmST25DV02KWRegisterPwmRfConfiguration_DualityManagement {
        var status : ComStSt25sdkType5St25dvpwmST25DV02KWRegisterPwmRfConfiguration_DualityManagement = .PWM_ONE_QUARTER_FULL_POWER_WHILE_RF_CMD
        switch index {
         case 0:
            status = .FULL_DUPLEX
        case 1:
            status = .PWM_IN_HZ_WHILE_RF_CMD
        case 2:
            status = .PWM_ONE_QUARTER_FULL_POWER_WHILE_RF_CMD
        case 3:
            status = .PWM_FREQ_REDUCED
        case 4:
            status = .PWM_FREQ_REDUCED_AND_ONE_QUARTER_FULL_POWER_WHILE_RF_CMD
        default:
            print("Undefined status")
        }
        return status
    }
    
    private func setPwmAccessRights(status : ComStSt25sdkTagHelper_ReadWriteProtection) {
        var statusIndex = 0
        switch status {
        case .READABLE_AND_WRITABLE:
            statusIndex = 0
        case .READABLE_AND_WRITE_PROTECTED_BY_PWD:
            statusIndex = 1
        case .READ_AND_WRITE_PROTECTED_BY_PWD:
            statusIndex = 2
        case .READ_PROTECTED_BY_PWD_AND_WRITE_IMPOSSIBLE:
            statusIndex = 3

        default:
            print("Undefined status")
        }
        mPwmAccessControlPicker.selectRow(statusIndex, inComponent: 0, animated: true)
    }

    private func getPwmAccessRightsFromIndex(index : Int) -> ComStSt25sdkTagHelper_ReadWriteProtection {
        var status : ComStSt25sdkTagHelper_ReadWriteProtection = .READABLE_AND_WRITABLE
        switch index {
         case 0:
             status  = .READABLE_AND_WRITABLE
         case 1:
             status = .READABLE_AND_WRITE_PROTECTED_BY_PWD
         case 2:
            status  = .READ_AND_WRITE_PROTECTED_BY_PWD
         case 3:
             status = .READ_PROTECTED_BY_PWD_AND_WRITE_IMPOSSIBLE
        default:
            print("Undefined status")
        }
        return status
    }
    
    private func retrieveUIConfiguration() {
        mPwm1OutputPowerPickerIndex = mPwm1OutputPowerPicker.selectedRow(inComponent: 0)
        mPwm2OutputPowerPickerIndex = mPwm2OutputPowerPicker.selectedRow(inComponent: 0)
        mDualityMgtPickerIndex = mPwmAndRFDualityManagementPicker.selectedRow(inComponent: 0)
        mPwmAccessRightsPickerIndex = mPwmAccessControlPicker.selectedRow(inComponent: 0)

        mPwm1OutputPower = getPwmOutputPowerFromIndex(index: mPwm1OutputPowerPickerIndex)
        mPwm2OutputPower = getPwmOutputPowerFromIndex(index: mPwm2OutputPowerPickerIndex)
        mDualityMgt = getPwmDualityMgtFromIndex(index: mDualityMgtPickerIndex)
        mPwmAccessRights = getPwmAccessRightsFromIndex(index: mPwmAccessRightsPickerIndex)
                
    }
    
    private func updateTagConfiguration() {
        (mTag as! ST25DVPwmTag).presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25dvpwmST25DVPwmTag_get_ST25DVPWM_CONFIGURATION_PASSWORD_ID()), password: mST25ConfigurationPwd!)
        
        (mTag as! ST25DVPwmTag).setPwmOutputDriverTrimmingWith(ComStSt25sdkType5St25dvpwmST25DVPwmTag.PWM1, with: mPwm1OutputPower)
        
        if ((mTag as! ST25DVPwmTag).getNumberOfPwm() == 2) {
            (mTag as! ST25DVPwmTag).setPwmOutputDriverTrimmingWith(ComStSt25sdkType5St25dvpwmST25DVPwmTag.PWM2, with: mPwm2OutputPower)
        }
        
        (mTag as! ST25DVPwmTag).setDualityManagementWith(mDualityMgt)
        (mTag as! ST25DVPwmTag).setPwmCtrlAccessRightsWith(mPwmAccessRights)

    }
    private func updatePwmPwd() {
        (mTag as! ST25DVPwmTag).presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25dvpwmST25DVPwmTag_get_ST25DVPWM_PWM_PASSWORD_ID()), password: mST25PwmPwd!)
        (mTag as! ST25DVPwmTag).writePassword(with: ComStSt25sdkType5St25dvpwmST25DVPwmTag_get_ST25DVPWM_PWM_PASSWORD_ID(), with: IOSByteArray.init(nsData: mST25PwmNewPwd))
    }
    
    private func presentPwdController() {
        let mST25PasswordVC:ST25PasswordViewController = UIStoryboard(name: "ST25Password", bundle: nil).instantiateViewController(withIdentifier: "ST25PasswordID") as! ST25PasswordViewController
        mST25PasswordVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        mST25PasswordVC.setTitle("Enter configuration password")

        if mTag is ST25TVTag || mTag is ST25DVPwmTag {
            mST25PasswordVC.setMessage("(32 bits hexadecimal format)")
            mST25PasswordVC.numberOfBytes = 4
        }else{
            mST25PasswordVC.setMessage("(64 bits hexadecimal format)")
            mST25PasswordVC.numberOfBytes = 8
        }
        
        mST25PasswordVC.delegate = self
        self.present(mST25PasswordVC, animated: false, completion: nil)
    }
    
    private func getPwmPwd(nbOfBytes:UInt8, subTitle : String) {
        let mST25PasswordVC:ST25PasswordViewController = UIStoryboard(name: "ST25Password", bundle: nil).instantiateViewController(withIdentifier: "ST25PasswordID") as! ST25PasswordViewController
        mST25PasswordVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        mST25PasswordVC.setTitle(subTitle)

        mST25PasswordVC.numberOfBytes = Int(nbOfBytes)
        if (nbOfBytes == 4){
           mST25PasswordVC.setMessage("(32 bits hexadecimal format)")
        }else{
           mST25PasswordVC.setMessage("(64 bits hexadecimal format)")
        }
        
        mST25PasswordVC.delegate = self
        self.present(mST25PasswordVC, animated: false, completion: nil)
    }
    private func getPwmPassword() {
        getPwmPwd(nbOfBytes: 4, subTitle: "Enter PWM password")
    }
    private func getPwmNewPassword() {
        getPwmPwd(nbOfBytes: 4, subTitle: "Enter PWM new password")
    }

}

extension ST25PwmConfigurationViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    /* Picker Delegate */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == mPwm1OutputPowerPicker || pickerView == mPwm2OutputPowerPicker  {
            return DRIVER_TRIMMING.allCases.count
        }
        if pickerView == mPwmAndRFDualityManagementPicker {
            return DUALITY_MANAGEMENT.allCases.count
        }
        if pickerView == mPwmAccessControlPicker {
            return pwmProtections.count
        }
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == mPwm1OutputPowerPicker || pickerView == mPwm2OutputPowerPicker {
            return DRIVER_TRIMMING.allCases[row].description
            //return DT(rawValue: row)?.description
        }
        if pickerView == mPwmAndRFDualityManagementPicker {
            return DUALITY_MANAGEMENT.allCases[row].description
        }
        if pickerView == mPwmAccessControlPicker {
            return pwmProtections[row]
        }
        return "Not define"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == mPwm1OutputPowerPicker {
            mPwm1OutputPowerPickerIndex = row
        }
        if pickerView == mPwm2OutputPowerPicker {
            mPwm2OutputPowerPickerIndex = row
        }
        if pickerView == mPwmAndRFDualityManagementPicker {
            mDualityMgtPickerIndex = row
        }
        if pickerView == mPwmAccessControlPicker {
            mPwmAccessRightsPickerIndex = row
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "System", size: 12)
            pickerLabel?.textAlignment = .center
            pickerLabel?.sizeToFit()
            pickerLabel?.adjustsFontSizeToFitWidth = true

        }
        if pickerView == mPwm1OutputPowerPicker || pickerView == mPwm2OutputPowerPicker{
            pickerLabel?.text =  DRIVER_TRIMMING.allCases[row].description
        }
        if pickerView == mPwmAndRFDualityManagementPicker {
            pickerLabel?.text =  DUALITY_MANAGEMENT.allCases[row].description
        }
        if pickerView == mPwmAccessControlPicker {
            pickerLabel?.text = pwmProtections[row]
        }
        pickerLabel?.textColor = UIColor.white
        
        return pickerLabel!
    }
    
}



extension ST25PwmConfigurationViewController: tagReaderSessionViewControllerDelegate {
    
    func handleTag(st25SDKTag: ComStSt25sdkNFCTag, uid: Data!) throws {
        self.mTag = st25SDKTag
        if self.isSameTag(uid: uid) {
             if self.mTag is ST25DVPwmTag {
                switch mTaskToDo {

                case .retrieveTagConfiguration:
                    retrieveTagConfiguration()
                case .updateTagConfiguration:
                    updateTagConfiguration()
                case .presentPwmConfigurationPwd:
                    print("presentPwmConfigurationPwd")
                case .updatePwmPwd:
                    updatePwmPwd()
                case .getPwmPassword:
                    print("getPwmPassword")
                }
                
            } else {
                miOSReaderSession.stopTagReaderSession("Tag feature not handled ...")
                return
            }


        } else {
            miOSReaderSession.stopTagReaderSession("Tag has changed, please scan again the Tag ...")
        }
        
    }
    
    func handleTagSessionError(didInvalidateWithError error: Error) {
        let errorNFC = error as! NFCReaderError
        if errorNFC.code ==  NFCReaderError.readerSessionInvalidationErrorSessionTimeout {
        }
        else if errorNFC.code ==  NFCReaderError.readerSessionInvalidationErrorUserCanceled {
        }
         miOSReaderSession.stopTagReaderSession(error.localizedDescription)
        
    }
    
    func handleTagST25SdkError(didInvalidateWithError error: NSException) {
        miOSReaderSession.stopTagReaderSession("Command failed: \(error.description)")
    }
    
}

extension ST25PwmConfigurationViewController: ST25PasswordViewDelegate {
    func okButtonTapped(pwdValue: Data) {
        if self.mTaskToDo == .presentPwmConfigurationPwd {
            //print(pwdValue.toHexString())
            self.mST25ConfigurationPwd = pwdValue
            self.mTaskToDo = .updateTagConfiguration
            self.miOSReaderSession.startTagReaderSession()
        }
        if self.mTaskToDo == .getPwmPassword {
            //print(pwdValue.toHexString())
            self.mST25PwmPwd = pwdValue
            self.mTaskToDo = .updatePwmPwd
            self.getPwmNewPassword()
        }
        if self.mTaskToDo == .updatePwmPwd {
            //print(pwdValue.toHexString())
            self.mST25PwmNewPwd = pwdValue
            self.mTaskToDo = .updatePwmPwd
            self.miOSReaderSession.startTagReaderSession()
        }
    }
    
    func cancelButtonTapped() {
    }
}

