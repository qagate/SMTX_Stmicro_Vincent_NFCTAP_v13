//
//  ST25PwmDemoStepMotorViewController.swift
//  NFCTap 
//
//  Created by STMICROELECTRONICS on 28/05/2020.
//  Copyright © 2020 STMicroelectronics. All rights reserved.
//

import UIKit
import CoreNFC

class ST25PwmDemoStepMotorViewController: ST25UIViewController {

    internal var mTag:ComStSt25sdkNFCTag!
    internal var miOSReaderSession:iOSReaderSession!
    
    enum taskToDo {
        case switchOnOffMotor
        case speedUpdate
        case directionUpdate
    }
    
    private var mCurrentFrequencyPwm1 = Int(ST25DVPwmTag.ST25DVPWM_PWM_MIN_FREQ)
    private var mCurrentDutyCyclePwm1 = 0
    private var mCurrentFrequencyPwm2 = Int(ST25DVPwmTag.ST25DVPWM_PWM_MIN_FREQ)
    private var mCurrentDutyCyclePwm2 = 16000 // DEFAULT Value

    
    internal var mTaskToDo:taskToDo = .switchOnOffMotor
    
    private var mMotorForwardDirection = true;
    private var mFrequencyMaxValue : Int = Int(ST25DVPwmTag.ST25DVPWM_PWM_MAX_FREQ)
    private var mFrequencyMinValue : Int = Int(ST25DVPwmTag.ST25DVPWM_PWM_MIN_FREQ)
    
    private var mFirstInit : Bool = true

    var maxTextFieldLen:Int = 5

    
    @IBOutlet weak var mMotorEngineSwitch: UISwitch!
    @IBAction func mMotorEngineSwitchAction(_ sender: UISwitch) {
        // PWM1 Frequency
        mCurrentFrequencyPwm1 = mFrequencyMinValue + 10 * (mFrequencyMaxValue - mFrequencyMinValue) / 100
        // set the spiner for the speed
        mMotorSpeedSlider.setValue(10, animated: true)
        // Direction Forward
        mCurrentDutyCyclePwm2 = 100
        self.mMotorForwardDirection = true
        self.mMotorDirectionImageView.image = UIImage(named:"ic_step_motor_dir1")!
        
        if sender.isOn {
            // start Motor
            // output
            mCurrentDutyCyclePwm1 = 50
            
        } else {
            // Stop Motor
            // no output
            mCurrentDutyCyclePwm1 = 0

        }
        mTaskToDo = .switchOnOffMotor
        self.miOSReaderSession.startTagReaderSession()
        
    }
    
    @IBOutlet weak var mMotorDirectionImageView: UIImageView!
    
    @IBOutlet weak var mFreqMinLabelForSlider: UILabel!
    @IBOutlet weak var mFreqMaxLabelForSlider: UILabel!
    @IBOutlet weak var mMotorSpeedSlider: UISlider!
    
    
    @IBAction func mMotorSpeedSliderAction(_ sender: UISlider) {
        let sliderValue = lroundf(sender.value) //50, 51,
        print("Slider value : \(sliderValue)")
        mCurrentFrequencyPwm1 = sliderValue

        mTaskToDo = .speedUpdate
        self.miOSReaderSession.startTagReaderSession()

    }
    
    
    @IBOutlet weak var mFreqMaxEditText: UITextField!
    @IBOutlet weak var mFreqMinEditText: UITextField!
    
    @IBAction func mFreqMaxEditTextChanged(_ sender: UITextField) {
        let myText = sender.text
        let freq = Int(myText!)
        if isPwmFrequencyMaxCorrect(freq : freq!) {
            setMaxFreqReference(val: freq!)
            UserDefaults.standard.set("\(mFrequencyMaxValue)", forKey: "StepMotorFrequencyMaxValue")
        } else {
            warningAlert(message: "Wrong value: Please check value according to available range")
            sender.text = String(mFrequencyMaxValue)
        }
    }
    
    @IBAction func mFreqMinEditTextChanged(_ sender: UITextField) {
        let myText = sender.text
        let freq = Int(myText!)
        if isPwmFrequencyMinCorrect(freq : freq!) {
            setMinFreqReference(val: freq!)
            UserDefaults.standard.set("\(mFrequencyMinValue)", forKey: "StepMotorFrequencyMinValue")
        } else {
            warningAlert(message: "Wrong value: Please check value according to available range")
            sender.text = String(mFrequencyMinValue)

        }
   }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.miOSReaderSession = iOSReaderSession(atagReaderSessionViewControllerDelegate: self)

        readFrequencyPreferedValues()
        
        mFreqMaxEditText.delegate = self
        mFreqMaxEditText.returnKeyType = UIReturnKeyType.done
        mFreqMinEditText.delegate = self
        mFreqMinEditText.returnKeyType = UIReturnKeyType.done
        self.addDoneButtonOnKeyboard()

        mMotorSpeedSlider.setValue(0, animated: true)
        mMotorSpeedSlider.isContinuous = false
        mMotorEngineSwitch.isOn = false
        // Used to scroll up view. Keyboard is hidden textview
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        mMotorDirectionImageView.isUserInteractionEnabled = true
        mMotorDirectionImageView.addGestureRecognizer(tapGestureRecognizer)
        mMotorForwardDirection = true
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -200 // Move view 150 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        if tappedImage == self.mMotorDirectionImageView {
            updateMotorDirectionImage(forward: mMotorForwardDirection)
        }
        // Your action
    }
    
    private func addDoneButtonOnKeyboard() {
            let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
            doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(ST25PwmDemoStepMotorViewController.doneButtonAction))

            var items = [UIBarButtonItem]()
            items.append(flexSpace)
            items.append(done)

            doneToolbar.items = items
            doneToolbar.sizeToFit()

            self.mFreqMaxEditText.inputAccessoryView = doneToolbar
            self.mFreqMinEditText.inputAccessoryView = doneToolbar
        }

    @objc func doneButtonAction() {
            self.view.endEditing(true);
        }
    
    private func readFrequencyPreferedValues() {
        let minValue = UserDefaults.standard.string(forKey: "StepMotorFrequencyMinValue")
        let maxValue = UserDefaults.standard.string(forKey: "StepMotorFrequencyMaxValue")
        // Update Label and slider limits

        if minValue != nil {
            let val = Int(minValue!)
            if val != nil {
                setMinFreqReference(val: val!)
                mFreqMinEditText.text = minValue
            }
        }
        if maxValue != nil {
            let val = Int(maxValue!)
            if val != nil {
                setMaxFreqReference(val: val!)
                mFreqMaxEditText.text = maxValue

            }
        }
        
    }
    
    private func setMinFreqReference(val : Int) {
        mFrequencyMinValue = val
        self.mFreqMinLabelForSlider.text = "\(mFrequencyMinValue)Hz[0]"
        mMotorSpeedSlider.minimumValue = Float(mFrequencyMinValue)
    }
    private func setMaxFreqReference(val : Int) {
        mFrequencyMaxValue = val
        self.mFreqMaxLabelForSlider.text = "\(mFrequencyMaxValue)Hz[100]"
        mMotorSpeedSlider.maximumValue = Float(mFrequencyMaxValue)
    }
    
    private func updateMotorDirectionImage(forward : Bool) {
        if forward {
            // change image to backward
            self.mMotorForwardDirection = false
            self.mMotorDirectionImageView.image = UIImage(named:"ic_step_motor_dir2")!
            mCurrentDutyCyclePwm2 = 0
        } else {
            // change image to forward
            self.mMotorForwardDirection = true
            self.mMotorDirectionImageView.image = UIImage(named:"ic_step_motor_dir1")!
            mCurrentDutyCyclePwm2 = 100
        }
        mTaskToDo = .directionUpdate
        self.miOSReaderSession.startTagReaderSession()

    }
    
    private func isPwmFrequencyMaxCorrect(freq : Int) -> Bool{
        return freq <= ST25DVPwmTag.ST25DVPWM_PWM_MAX_FREQ && freq > mFrequencyMinValue
    }
    private func isPwmFrequencyMinCorrect(freq : Int) -> Bool{
        return freq >= ST25DVPwmTag.ST25DVPWM_PWM_MIN_FREQ && freq < mFrequencyMaxValue
    }
    
    private func warningAlert(message : String) {
        UIHelper.warningAlert(viewController: self, title : "Step motor" , message: message)
    }
    
    private func startStopMotor() {
        if self.mTag is ST25DVPwmTag {
            writePwmConfiguration(pwmID: Int(ComStSt25sdkType5St25dvpwmST25DVPwmTag.PWM1), freq: mCurrentFrequencyPwm1, dutyCycle: mCurrentDutyCyclePwm1, enable: true)
            if  (mTag as! ST25DVPwmTag).getNumberOfPwm() == 2 {
                if mFirstInit {
                    writePwmConfiguration(pwmID: Int(ComStSt25sdkType5St25dvpwmST25DVPwmTag.PWM2), freq: mCurrentFrequencyPwm2, dutyCycle: mCurrentDutyCyclePwm2, enable: true)
                    mFirstInit = false
                }
            }
            
        }
    }
    
    private func updateSpeed() {
             writePwmConfiguration(pwmID: Int(ComStSt25sdkType5St25dvpwmST25DVPwmTag.PWM1), freq: mCurrentFrequencyPwm1, dutyCycle: mCurrentDutyCyclePwm1, enable: true)
    }
    
    private func changeDirection() {
        if  (mTag as! ST25DVPwmTag).getNumberOfPwm() == 2 {
            writePwmConfiguration(pwmID: Int(ComStSt25sdkType5St25dvpwmST25DVPwmTag.PWM2), freq: mCurrentFrequencyPwm2, dutyCycle: mCurrentDutyCyclePwm2, enable: true)
        }
    }

    public func writePwmConfiguration(pwmID : Int, freq : Int, dutyCycle : Int, enable : Bool) {
        if self.mTag is ST25DVPwmTag {
            if pwmID == ComStSt25sdkType5St25dvpwmST25DVPwmTag.PWM1 {
                (mTag as! ST25DVPwmTag).setPwmConfigurationWith(ComStSt25sdkType5St25dvpwmST25DVPwmTag.PWM1, with: jint(freq), with: jint(dutyCycle), withBoolean: enable)
            } else if pwmID == ComStSt25sdkType5St25dvpwmST25DVPwmTag.PWM2 {
                (mTag as! ST25DVPwmTag).setPwmConfigurationWith(ComStSt25sdkType5St25dvpwmST25DVPwmTag.PWM2, with: jint(freq), with: jint(dutyCycle), withBoolean: enable)
            }
            
        } else {
            warningAlert(message: "Invalid Tag")
        }
    }
    
     func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

            let currentText = textField.text! + string
            return currentText.count <= maxTextFieldLen
       }
    
}


extension ST25PwmDemoStepMotorViewController: tagReaderSessionViewControllerDelegate {
    
    func handleTag(st25SDKTag: ComStSt25sdkNFCTag, uid: Data!) throws {
        self.mTag = st25SDKTag
        if self.isSameTag(uid: uid) {
             if self.mTag is ST25DVPwmTag {
            } else {
                miOSReaderSession.stopTagReaderSession("Tag feature not handled ...")
                return
            }

            switch mTaskToDo {
            case .switchOnOffMotor:
                startStopMotor()
            case .speedUpdate:
                updateSpeed()
            case .directionUpdate:
                changeDirection()
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
