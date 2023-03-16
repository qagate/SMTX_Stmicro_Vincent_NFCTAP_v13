//
//  ST25PwmControlExpertViewController.swift
//  NFCTap 
//
//  Created by STMICROELECTRONICS on 11/06/2020.
//  Copyright © 2020 STMicroelectronics. All rights reserved.
//

import UIKit
import CoreNFC


class ST25PwmControlExpertViewController: ST25UIViewController {

    internal var mTag:ComStSt25sdkNFCTag!
    internal var miOSReaderSession:iOSReaderSession!
    internal var mTaskToDo:taskToDo = .retrieveTagConfiguration
    internal var mST25PwmPwd:Data!
    
    enum taskToDo {
        case retrieveTagConfiguration
        case updateTagConfiguration
        case enablePwm1
        case enablePwm2
        case retrieveTagConfigurationWithPwd
        case updateTagConfigurationWithPwd
        case enablePwm1WithPwd
        case enablePwm2WithPwd

    }

    var maxTextFieldLen:Int = 5

    // PWM1
    var mPwm1DutyCycle : Int!
    var mPwm1Frequency : Int!
    var mPwm1Enable : Bool!

    var mPwm1Period : Int!
    var mPwm1PulseWidth : Int!

    // PWM2
    private var mPwm2Available = false

    var mPwm2DutyCycle : Int!
    var mPwm2Frequency : Int!
    var mPwm2Enable : Bool!

    var mPwm2Period : Int!
    var mPwm2PulseWidth : Int!
    
    @IBOutlet weak var mPwm1ResolutionLabel: UILabel!
    @IBOutlet weak var mPwm1EnableSwitch: UISwitch!
    @IBOutlet weak var mPwm1FrequencyEditText: UITextField!
    @IBOutlet weak var mPwm1DutyCycleEditText: UITextField!
    @IBOutlet weak var mPwm1PulseWidthLabel: UILabel!
    @IBOutlet weak var mPwm1PeriodLabel: UILabel!
    
    @IBOutlet weak var mPwm2ResolutionLabel: UILabel!
    @IBOutlet weak var mPwm2EnableSwitch: UISwitch!
    @IBOutlet weak var mPwm2FrequencyEditText: UITextField!
    @IBOutlet weak var mPwm2DutyCycleEditText: UITextField!
    @IBOutlet weak var mPwm2PulseWidthLabel: UILabel!
    @IBOutlet weak var mPwm2PeriodLabel: UILabel!
    
    @IBOutlet weak var mUpdateButton: UIButton!
    @IBAction func mUpdateButtonAction(_ sender: UIButton) {
        self.mTaskToDo = .updateTagConfiguration
        self.miOSReaderSession.startTagReaderSession()
    }
    
    @IBAction func mPwm1SwitchAction(_ sender: UISwitch) {

        mPwm1Enable = mPwm1EnableSwitch.isOn
        self.mTaskToDo = .enablePwm1
        self.miOSReaderSession.startTagReaderSession()
    }
    
    @IBAction func mPwm2SwitchAction(_ sender: UISwitch) {
        mPwm2Enable = mPwm2EnableSwitch.isOn
        self.mTaskToDo = .enablePwm2
        self.miOSReaderSession.startTagReaderSession()
    }
    
    @IBAction func mPwm1FreqEditTextChanged(_ sender: UITextField) {
        let myText = sender.text
        let freq = Int(myText!)
        if isPwmFrequencyCorrect(freq : freq!) {
            mPwm1Frequency = freq
            updatePwm1ComputedValuesAccordingly(freq: freq!)
            //UserDefaults.standard.set("\(mFrequencyMinValue)", forKey: "StepMotorFrequencyMinValue")
            notifyControlValuesHasChanged(changed: true)
        } else {
            warningAlert(message: "Wrong value: Please check value according to available range")
            sender.text = String(mPwm1Frequency)
        }
    }
    
    @IBAction func mPwm1DutyEditTextChanged(_ sender: UITextField) {
        let myText = sender.text
        let duty = Int(myText!)
        if isPwmDutyCycleCorrect(dutyCycle: duty!) {
            mPwm1DutyCycle = duty
            updatePwm1ComputedValuesAccordingly(duty: duty!)
            //UserDefaults.standard.set("\(mFrequencyMinValue)", forKey: "StepMotorFrequencyMinValue")
            notifyControlValuesHasChanged(changed: true)
        } else {
            warningAlert(message: "Wrong value: Please check value according to available range")
            sender.text = String(mPwm1DutyCycle)
        }
    }

    @IBAction func mPwm2FreqEditTextChanged(_ sender: UITextField) {
        let myText = sender.text
        let freq = Int(myText!)
        if isPwmFrequencyCorrect(freq : freq!) {
            mPwm2Frequency = freq
            updatePwm2ComputedValuesAccordingly(freq: freq!)
            //UserDefaults.standard.set("\(mFrequencyMinValue)", forKey: "StepMotorFrequencyMinValue")
            notifyControlValuesHasChanged(changed: true)
        } else {
            warningAlert(message: "Wrong value: Please check value according to available range")
            sender.text = String(mPwm2Frequency)
        }
    }
    

    @IBAction func mPwm2DutyEditTextChanged(_ sender: UITextField) {
        let myText = sender.text
        let duty = Int(myText!)
        if isPwmDutyCycleCorrect(dutyCycle: duty!) {
            mPwm2DutyCycle = duty
            updatePwm2ComputedValuesAccordingly(duty: duty!)
            //UserDefaults.standard.set("\(mFrequencyMinValue)", forKey: "StepMotorFrequencyMinValue")
            notifyControlValuesHasChanged(changed: true)
        } else {
            warningAlert(message: "Wrong value: Please check value according to available range")
            sender.text = String(mPwm2DutyCycle)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "PWM control expert"

        self.miOSReaderSession = iOSReaderSession(atagReaderSessionViewControllerDelegate: self)

        // Do any additional setup after loading the view.
        mPwm1FrequencyEditText.delegate = self
        mPwm1FrequencyEditText.returnKeyType = UIReturnKeyType.done
        mPwm1DutyCycleEditText.delegate = self
        mPwm1DutyCycleEditText.returnKeyType = UIReturnKeyType.done
        mPwm2FrequencyEditText.delegate = self
        mPwm2FrequencyEditText.returnKeyType = UIReturnKeyType.done
        mPwm2DutyCycleEditText.delegate = self
        mPwm2DutyCycleEditText.returnKeyType = UIReturnKeyType.done

        self.addDoneButtonOnKeyboard()

        // Used to scroll up view. Keyboard is hidden textview
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);

        
        mTaskToDo = .retrieveTagConfiguration
        self.miOSReaderSession.startTagReaderSession()
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -200 // Move view 150 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }

    private func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.mPwm1FrequencyEditText.inputAccessoryView = doneToolbar
        self.mPwm1DutyCycleEditText.inputAccessoryView = doneToolbar
        self.mPwm2FrequencyEditText.inputAccessoryView = doneToolbar
        self.mPwm2DutyCycleEditText.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction() {
            self.view.endEditing(true);
        }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

           let currentText = textField.text! + string
           return currentText.count <= maxTextFieldLen
      }
    
    private func updatePwm1ComputedValuesAccordingly(freq: Int) {
        // Frequency is changed
        // Update period and pulse W
        let period : Int = (Int(1000000000 / (Double(freq) * ST25DVPwmTag.ST25DVPWM_PWM_RESOLUTION_NS)))
        let pulse : Int = period * mPwm1DutyCycle / 100
        mPwm1PulseWidthLabel.text = String(format: "0x%X",pulse)
        mPwm1PeriodLabel.text = String(format: "0x%X",period)
        mPwm1FrequencyEditText.textColor = .red
    }
    private func updatePwm1ComputedValuesAccordingly(duty: Int) {
        // Duty is changed
        // Update period and pulse W
        let period : Int = (Int(1000000000 / (Double(mPwm1Frequency) * ST25DVPwmTag.ST25DVPWM_PWM_RESOLUTION_NS)))
        let pulse : Int = period * mPwm1DutyCycle / 100
        mPwm1PulseWidthLabel.text = String(format: "0x%X",pulse)
        mPwm1PeriodLabel.text = String(format: "0x%X",period)
        mPwm1DutyCycleEditText.textColor = .red
    }
    private func updatePwm2ComputedValuesAccordingly(freq: Int) {
        // Frequency is changed
        // Update period and pulse W
        let period : Int = (Int(1000000000 / (Double(mPwm2Frequency) * ST25DVPwmTag.ST25DVPWM_PWM_RESOLUTION_NS)))
        let pulse : Int = period * mPwm2DutyCycle / 100
        mPwm2PulseWidthLabel.text = String(format: "0x%X",pulse)
        mPwm2PeriodLabel.text = String(format: "0x%X",period)
        mPwm2FrequencyEditText.textColor = .red
    }
    private func updatePwm2ComputedValuesAccordingly(duty: Int) {
        // Duty is changed
        // Update period and pulse W
        let period : Int = (Int(1000000000 / (Double(mPwm2Frequency) * ST25DVPwmTag.ST25DVPWM_PWM_RESOLUTION_NS)))
        let pulse : Int = period * mPwm2DutyCycle / 100
        mPwm2PulseWidthLabel.text = String(format: "0x%X",pulse)
        mPwm2PeriodLabel.text = String(format: "0x%X",period)
        mPwm2DutyCycleEditText.textColor = .red
    }
    
    private func notifyControlValuesHasChanged(changed : Bool) {
        if changed {
            self.mUpdateButton.setTitleColor(.stRedColor(), for: .normal)

        } else {
            self.mUpdateButton.setTitleColor(.white, for: .normal)
            mPwm1FrequencyEditText.textColor = .white
            mPwm1DutyCycleEditText.textColor = .white
            mPwm2FrequencyEditText.textColor = .white
            mPwm2DutyCycleEditText.textColor = .white

        }
    }
    
    private func updateUIWithTagControlConfiguration () {
        mPwm1ResolutionLabel.text = String(format: "%.1f", ST25DVPwmTag.ST25DVPWM_PWM_RESOLUTION_NS)
        mPwm1EnableSwitch.setOn(mPwm1Enable, animated: true)
        mPwm1FrequencyEditText.text = String(mPwm1Frequency)
        mPwm1DutyCycleEditText.text = String(mPwm1DutyCycle)
        mPwm1PulseWidthLabel.text = String(format: "0x%X",mPwm1PulseWidth)
        mPwm1PeriodLabel.text = String(format: "0x%X",mPwm1Period)

        mPwm2ResolutionLabel.text = String(format: "%.1f", ST25DVPwmTag.ST25DVPWM_PWM_RESOLUTION_NS)
        mPwm2EnableSwitch.setOn(mPwm2Enable, animated: true)
        mPwm2FrequencyEditText.text = String(mPwm2Frequency)
        mPwm2DutyCycleEditText.text = String(mPwm2DutyCycle)
        mPwm2PulseWidthLabel.text = String(format: "0x%X",mPwm2PulseWidth)
        mPwm2PeriodLabel.text = String(format: "0x%X",mPwm2Period)
    }
    
    private func retrieveTagControlConfiguration() {
        mPwm1Period = Int((mTag as! ST25DVPwmTag).getPwmPeriod(with: ComStSt25sdkType5St25dvpwmST25DVPwmTag.PWM1))
        mPwm1DutyCycle = Int((mTag as! ST25DVPwmTag).getPwmDutyCycle(with: ComStSt25sdkType5St25dvpwmST25DVPwmTag.PWM1))
        mPwm1Frequency = Int((mTag as! ST25DVPwmTag).getPwmFrequency(with: ComStSt25sdkType5St25dvpwmST25DVPwmTag.PWM1))
        mPwm1PulseWidth = Int((mTag as! ST25DVPwmTag).getPwmPulseWidth(with: ComStSt25sdkType5St25dvpwmST25DVPwmTag.PWM1))
        mPwm1Enable = (mTag as! ST25DVPwmTag).isPwmEnable(with: ComStSt25sdkType5St25dvpwmST25DVPwmTag.PWM1)
        if ((mTag as! ST25DVPwmTag).getNumberOfPwm() == 2) {
            mPwm2Period = Int((mTag as! ST25DVPwmTag).getPwmPeriod(with: ComStSt25sdkType5St25dvpwmST25DVPwmTag.PWM2))
            mPwm2DutyCycle = Int((mTag as! ST25DVPwmTag).getPwmDutyCycle(with: ComStSt25sdkType5St25dvpwmST25DVPwmTag.PWM2))
            mPwm2Frequency = Int((mTag as! ST25DVPwmTag).getPwmFrequency(with: ComStSt25sdkType5St25dvpwmST25DVPwmTag.PWM2))
            mPwm2PulseWidth = Int((mTag as! ST25DVPwmTag).getPwmPulseWidth(with: ComStSt25sdkType5St25dvpwmST25DVPwmTag.PWM2))
            mPwm2Enable = (mTag as! ST25DVPwmTag).isPwmEnable(with: ComStSt25sdkType5St25dvpwmST25DVPwmTag.PWM2)
            mPwm2Available = true

        }
        
        UIHelper.UI {
            self.updateUIWithTagControlConfiguration()
        }
    }
    private func retrieveTagControlConfigurationWithPwd() {
        (mTag as! ST25DVPwmTag).presentPassword(passwordNumber: UInt8(ST25DVPwmTag.ST25DVPWM_PWM_PASSWORD_ID), password: mST25PwmPwd!)
        retrieveTagControlConfiguration()
    }

    
    private func updateTagConfiguration() {
        (mTag as! ST25DVPwmTag).setPwmDutyCycleWith(ComStSt25sdkType5St25dvpwmST25DVPwmTag.PWM1, with: jint(mPwm1DutyCycle))
        (mTag as! ST25DVPwmTag).setPwmFrequencyWith(ComStSt25sdkType5St25dvpwmST25DVPwmTag.PWM1, with: jint(mPwm1Frequency))
        if ((mTag as! ST25DVPwmTag).getNumberOfPwm() == 2) {
            (mTag as! ST25DVPwmTag).setPwmDutyCycleWith(ComStSt25sdkType5St25dvpwmST25DVPwmTag.PWM2, with: jint(mPwm2DutyCycle))
            (mTag as! ST25DVPwmTag).setPwmFrequencyWith(ComStSt25sdkType5St25dvpwmST25DVPwmTag.PWM2, with: jint(mPwm2Frequency))
            
        }
        UIHelper.UI {
            self.notifyControlValuesHasChanged(changed: false)
        }
        
    }
    private func updateTagConfigurationWithPwd() {
        (mTag as! ST25DVPwmTag).presentPassword(passwordNumber: UInt8(ST25DVPwmTag.ST25DVPWM_PWM_PASSWORD_ID), password: mST25PwmPwd!)
        updateTagConfiguration()
    }
    
    
    private func enablePwm1() {
        (mTag as! ST25DVPwmTag).enablePwm(with: ComStSt25sdkType5St25dvpwmST25DVPwmTag.PWM1, withBoolean: self.mPwm1Enable)

    }
    private func enablePwm1WithPwd() {
        (mTag as! ST25DVPwmTag).presentPassword(passwordNumber: UInt8(ST25DVPwmTag.ST25DVPWM_PWM_PASSWORD_ID), password: mST25PwmPwd!)
        enablePwm1()
        
    }
    
    private func enablePwm2() {
        if ((mTag as! ST25DVPwmTag).getNumberOfPwm() == 2) {
            (mTag as! ST25DVPwmTag).enablePwm(with: ComStSt25sdkType5St25dvpwmST25DVPwmTag.PWM2, withBoolean: self.mPwm2Enable)
        }
    }
    private func enablePwm2WithPwd() {
        if ((mTag as! ST25DVPwmTag).getNumberOfPwm() == 2) {
            (mTag as! ST25DVPwmTag).presentPassword(passwordNumber: UInt8(ST25DVPwmTag.ST25DVPWM_PWM_PASSWORD_ID), password: mST25PwmPwd!)
            enablePwm2()
        }
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


    
    
    private func isPwmFrequencyCorrect(freq : Int) -> Bool{
        return freq <= ST25DVPwmTag.ST25DVPWM_PWM_MAX_FREQ && freq >= ST25DVPwmTag.ST25DVPWM_PWM_MIN_FREQ
    }
    private func isPwmDutyCycleCorrect(dutyCycle : Int) -> Bool{
        return dutyCycle >= 0 && dutyCycle <= 100
    }
    
    private func warningAlert(message : String) {
        UIHelper.warningAlert(viewController: self, title : "PWM control expert mode" , message: message)
    }

}


extension ST25PwmControlExpertViewController: tagReaderSessionViewControllerDelegate {
    
    func handleTag(st25SDKTag: ComStSt25sdkNFCTag, uid: Data!) throws {
        self.mTag = st25SDKTag
        if self.isSameTag(uid: uid) {
            if self.mTag is ST25DVPwmTag {
                switch mTaskToDo {
                case .retrieveTagConfiguration:
                    retrieveTagControlConfiguration()
                case .updateTagConfiguration:
                    updateTagConfiguration()
                case .enablePwm1:
                    enablePwm1()
                case .enablePwm2:
                    enablePwm2()
                case .retrieveTagConfigurationWithPwd:
                    retrieveTagControlConfigurationWithPwd()
                case .updateTagConfigurationWithPwd:
                    updateTagConfigurationWithPwd()
                case .enablePwm1WithPwd:
                    enablePwm1WithPwd()
                case .enablePwm2WithPwd:
                    enablePwm2WithPwd()
                    
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
        //        print("ST25SDK Error description: \(error.description)")
        //        print("ST25SDK Error name: \(error.name)")
        //        print("ST25SDK Error user info: \(error.userInfo)")
        //        print("ST25SDK Error reason: \(error.reason)")
        let errorST25SDK = error as! ComStSt25sdkSTException
        
        //        print("Error SDK \(errorST25SDK)")
        //        print("Error SDK \(errorST25SDK.getError())")
        //        print("Error SDK \(errorST25SDK.getMessage())")
        
        
        if ((errorST25SDK.getMessage()?.contains(ComStSt25sdkSTException_STExceptionCode.PASSWORD_NEEDED.description()))! ||
            (errorST25SDK.getMessage()?.contains(ComStSt25sdkSTException_STExceptionCode.ISO15693_BLOCK_PROTECTED.description()))! ||
            (errorST25SDK.getMessage()?.contains(ComStSt25sdkSTException_STExceptionCode.ISO15693_BLOCK_IS_LOCKED.description()))!
            ){
            if self.mTaskToDo == .retrieveTagConfiguration {
                self.mTaskToDo = .retrieveTagConfigurationWithPwd
                UIHelper.UI {
                    self.getPwmPassword()
                }            }
            if self.mTaskToDo == .updateTagConfiguration {
                self.mTaskToDo = .updateTagConfigurationWithPwd
                UIHelper.UI {
                    self.getPwmPassword()
                }
                
            }
            if self.mTaskToDo == .enablePwm1 {
                self.mTaskToDo = .enablePwm1WithPwd
                UIHelper.UI {
                    self.getPwmPassword()
                }
                
            }
            if self.mTaskToDo == .enablePwm2 {
                self.mTaskToDo = .enablePwm2WithPwd
                UIHelper.UI {
                    self.getPwmPassword()
                }
                
            }
        }
        
    }
    
}

extension ST25PwmControlExpertViewController: ST25PasswordViewDelegate {
    func okButtonTapped(pwdValue: Data) {
        if self.mTaskToDo == .updateTagConfigurationWithPwd {
            //print(pwdValue.toHexString())
            self.mST25PwmPwd = pwdValue
            self.mTaskToDo = .updateTagConfigurationWithPwd
            self.miOSReaderSession.startTagReaderSession()
        }
        if self.mTaskToDo == .retrieveTagConfigurationWithPwd {
            //print(pwdValue.toHexString())
            self.mST25PwmPwd = pwdValue
            self.mTaskToDo = .retrieveTagConfigurationWithPwd
            self.miOSReaderSession.startTagReaderSession()
        }
        if self.mTaskToDo == .enablePwm1WithPwd {
            //print(pwdValue.toHexString())
            self.mST25PwmPwd = pwdValue
            self.mTaskToDo = .enablePwm1WithPwd
            self.miOSReaderSession.startTagReaderSession()
        }
        if self.mTaskToDo == .enablePwm2WithPwd {
            //print(pwdValue.toHexString())
            self.mST25PwmPwd = pwdValue
            self.mTaskToDo = .enablePwm2WithPwd
            self.miOSReaderSession.startTagReaderSession()
        }
    }
    
    func cancelButtonTapped() {
    }
}
