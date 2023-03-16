//
//  ST25PwmControlNormalAndAutoViewController.swift
//  NFCTap 
//
//  Created by STMICROELECTRONICS on 12/06/2020.
//  Copyright © 2020 STMicroelectronics. All rights reserved.
//

import UIKit
import CoreNFC


class ST25PwmControlNormalAndAutoViewController: ST25UIViewController {

    internal var mTag:ComStSt25sdkNFCTag!
    internal var miOSReaderSession:iOSReaderSession!
    internal var mTaskToDo:taskToDo = .retrieveTagConfiguration
    internal var mST25PwmPwd:Data!

    enum taskToDo {
        case retrieveTagConfiguration
        case updateTagConfiguration
        case updatePwm1TagConfiguration
        case updatePwm2TagConfiguration
        case enablePwm1
        case enablePwm2
        case retrieveTagConfigurationWithPwd
        case updateTagConfigurationWithPwd
        case enablePwm1WithPwd
        case enablePwm2WithPwd
        case updatePwm1TagConfigurationWithPwd
        case updatePwm2TagConfigurationWithPwd
        case startLedsAutoMode
        case continueLedsAutoMode
    }
    
    public var mAutoModeEnable : Bool = false

    public var mPwm1Enable : Bool!
    public var mPwm1DutyCycle : Int!
    public var mPwm2Enable : Bool!
    public var mPwm2DutyCycle : Int!

    // PWM2
    private var mPwm2Available = false

    private var mLedsPlayer : LedPlayer!
    
    @IBOutlet weak var mAutoModeSwitch: UISwitch!
    @IBOutlet weak var mPwm1EnableSwitch: UISwitch!
    @IBOutlet weak var mPwm2EnableSwitch: UISwitch!
    @IBOutlet weak var mPwm1DutyCycleSlider: UISlider!
    @IBOutlet weak var mPwm2DutyCycleSlider: UISlider!
    
    @IBAction func mLedAutoModeSwitchAction(_ sender: UISwitch){
        if sender.isOn {
            mLedsPlayer = LedPlayer(controller: self)
            mTaskToDo = .startLedsAutoMode
            self.miOSReaderSession.startTagReaderSession()

        } else {
            if (mLedsPlayer != nil) {
                mLedsPlayer.stop()
            }
        }

    }
    
    @IBAction func mPwm1EnableSwitchAction(_ sender: UISwitch) {
        mPwm1Enable = sender.isOn
        self.mTaskToDo = .enablePwm1
        self.miOSReaderSession.startTagReaderSession()
    }
    
    @IBAction func mPwm2EnableSwitchAction(_ sender: UISwitch) {
        mPwm2Enable = sender.isOn
        self.mTaskToDo = .enablePwm2
        self.miOSReaderSession.startTagReaderSession()
    }
    
    @IBAction func mPwm1DutyCycleSliderAction(_ sender: UISlider) {
        let sliderValue = lroundf(sender.value) //50, 51,
        //print("Slider value : \(sliderValue)")
        mPwm1DutyCycle = sliderValue
        
        mTaskToDo = .updatePwm1TagConfiguration
        self.miOSReaderSession.startTagReaderSession()
    }

    
    @IBAction func mPwm2DutyCycleSliderAction(_ sender: UISlider) {
        let sliderValue = lroundf(sender.value) //50, 51,
        //print("Slider value : \(sliderValue)")
        mPwm2DutyCycle = sliderValue
        
        mTaskToDo = .updatePwm2TagConfiguration
        self.miOSReaderSession.startTagReaderSession()
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "PWM control normal"

        self.miOSReaderSession = iOSReaderSession(atagReaderSessionViewControllerDelegate: self)

        // Default values
        mPwm1DutyCycle = 0
        mPwm1DutyCycleSlider.setValue(0, animated: true)
        mPwm1DutyCycleSlider.isContinuous = false
        mPwm1DutyCycleSlider.minimumValue = Float(0)
        mPwm1DutyCycleSlider.maximumValue = Float(100)

        mPwm2DutyCycle = 0
        mPwm2DutyCycleSlider.setValue(0, animated: true)
        mPwm2DutyCycleSlider.isContinuous = false
        mPwm2DutyCycleSlider.minimumValue = Float(0)
        mPwm2DutyCycleSlider.maximumValue = Float(100)

        // Do any additional setup after loading the view.
        if mAutoModeEnable {
            mLedsPlayer = LedPlayer(controller: self)
            mTaskToDo = .startLedsAutoMode
            self.miOSReaderSession.startTagReaderSession()

        } else {
            // retrieve PWM tag config
            mTaskToDo = .retrieveTagConfiguration
            self.miOSReaderSession.startTagReaderSession()
            
        }
        mAutoModeSwitch.setOn(mAutoModeEnable, animated: true)

    }
    
    
    public func updateUIWithTagControlConfiguration () {
        self.mPwm1EnableSwitch.setOn(self.mPwm1Enable, animated: true)
        self.mPwm2EnableSwitch.setOn(self.mPwm2Enable, animated: true)
        self.mPwm1DutyCycleSlider.setValue(Float(self.mPwm1DutyCycle), animated: true)
        self.mPwm2DutyCycleSlider.setValue(Float(self.mPwm2DutyCycle), animated: true)
    }
    
    private func retrieveTagControlConfiguration() {
        mPwm1DutyCycle = Int((mTag as! ST25DVPwmTag).getPwmDutyCycle(with: ComStSt25sdkType5St25dvpwmST25DVPwmTag.PWM1))
        mPwm1Enable = (mTag as! ST25DVPwmTag).isPwmEnable(with: ComStSt25sdkType5St25dvpwmST25DVPwmTag.PWM1)
        if ((mTag as! ST25DVPwmTag).getNumberOfPwm() == 2) {
            mPwm2DutyCycle = Int((mTag as! ST25DVPwmTag).getPwmDutyCycle(with: ComStSt25sdkType5St25dvpwmST25DVPwmTag.PWM2))
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

    
    public func updateTagConfiguration() {
        updateTagConfiguration(pwm: Int(ComStSt25sdkType5St25dvpwmST25DVPwmTag.PWM1))
        updateTagConfiguration(pwm: Int(ComStSt25sdkType5St25dvpwmST25DVPwmTag.PWM2))

    }
    
    private func updateTagConfiguration(pwm : Int) {
        if pwm == ST25DVPwmTag.PWM1 {
            (mTag as! ST25DVPwmTag).setPwmDutyCycleWith(ComStSt25sdkType5St25dvpwmST25DVPwmTag.PWM1, with: jint(mPwm1DutyCycle))
            enablePwm1()
        }
        if pwm == ST25DVPwmTag.PWM2 {
            if ((mTag as! ST25DVPwmTag).getNumberOfPwm() == 2) {
                (mTag as! ST25DVPwmTag).setPwmDutyCycleWith(ComStSt25sdkType5St25dvpwmST25DVPwmTag.PWM2, with: jint(mPwm2DutyCycle))
                enablePwm2()
            }
        }
    }
    private func updateTagConfigurationWithPwd(pwm : Int) {
        (mTag as! ST25DVPwmTag).presentPassword(passwordNumber: UInt8(ST25DVPwmTag.ST25DVPWM_PWM_PASSWORD_ID), password: mST25PwmPwd!)
        updateTagConfiguration(pwm: pwm)
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
    
    private func setDefaultParamatersValues() {
        self.mAutoModeEnable = false
        self.mAutoModeSwitch.setOn(self.mAutoModeEnable, animated: true)
        self.mPwm1Enable = false
        self.mPwm2Enable = false
        self.mPwm1DutyCycle = 0
        self.mPwm2DutyCycle = 0
        self.updateUIWithTagControlConfiguration()

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
    
    private func startLedsAutoMode() {
        if (mLedsPlayer != nil) {
            mLedsPlayer.start()
        }
    }

    private func continueLedsAutoMode() {
        if (mLedsPlayer != nil) {
            mLedsPlayer.resume()
        }
    }

    private func continueTransferSession() {
        print("continuetransferSession")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0,execute: { () -> Void in
            self.mTaskToDo = .continueLedsAutoMode
            self.miOSReaderSession.startTagReaderSession()
        })
    }
    
    private func warningAlert(message : String) {
        UIHelper.warningAlert(viewController: self, title : "PWM duty cycle control mode" , message: message)
    }
}


extension ST25PwmControlNormalAndAutoViewController: tagReaderSessionViewControllerDelegate {
    
    func handleTag(st25SDKTag: ComStSt25sdkNFCTag, uid: Data!) throws {
        self.mTag = st25SDKTag
        if self.isSameTag(uid: uid) {
            if self.mTag is ST25DVPwmTag {
                switch mTaskToDo {
                case .retrieveTagConfiguration:
                    retrieveTagControlConfiguration()
                case .updateTagConfiguration:
                    updateTagConfiguration()
                case .updatePwm1TagConfiguration:
                    updateTagConfiguration(pwm: Int(ST25DVPwmTag.PWM1))
                case .updatePwm2TagConfiguration:
                    updateTagConfiguration(pwm: Int(ST25DVPwmTag.PWM2))
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
                case .updatePwm1TagConfigurationWithPwd:
                    updateTagConfigurationWithPwd(pwm: Int(ST25DVPwmTag.PWM1))
                case .updatePwm2TagConfigurationWithPwd:
                    updateTagConfigurationWithPwd(pwm: Int(ST25DVPwmTag.PWM2))
                case .startLedsAutoMode:
                    startLedsAutoMode()
                case .continueLedsAutoMode:
                    continueLedsAutoMode()
                    
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
            if (mTaskToDo == .startLedsAutoMode || mTaskToDo == .continueLedsAutoMode) {
                self.miOSReaderSession = iOSReaderSession(atagReaderSessionViewControllerDelegate: self)
                self.continueTransferSession()
            }
            if (mTaskToDo == .retrieveTagConfiguration || mTaskToDo == .retrieveTagConfigurationWithPwd) {
                UIHelper.UI {
                    // defaut init - config not retrieved
                    self.setDefaultParamatersValues()
                    self.updateUIWithTagControlConfiguration()
                    self.warningAlert(message: "Not able to retrieve configuration. Parameters default value set! ")

                }
            }

        }
        else if errorNFC.code ==  NFCReaderError.readerSessionInvalidationErrorUserCanceled {
            if (mTaskToDo == .startLedsAutoMode || mTaskToDo == .continueLedsAutoMode) {
                self.mLedsPlayer.stop()
                UIHelper.UI {
                    self.mAutoModeEnable = false
                    self.mAutoModeSwitch.setOn(self.mAutoModeEnable, animated: true)

                }
            }
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
            if self.mTaskToDo == .updatePwm1TagConfiguration {
                self.mTaskToDo = .updatePwm1TagConfigurationWithPwd
                UIHelper.UI {
                    self.getPwmPassword()
                }
                
            }
            if self.mTaskToDo == .updatePwm2TagConfiguration {
                self.mTaskToDo = .updatePwm2TagConfigurationWithPwd
                UIHelper.UI {
                    self.getPwmPassword()
                }
                
            }

        }
        
    }
    
}


extension ST25PwmControlNormalAndAutoViewController: ST25PasswordViewDelegate {
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


private class LedPlayer {
    
    private var mLedController : ST25PwmControlNormalAndAutoViewController
    
    var mDemoLoop : Bool = true
    var mStepsForLeds : Int = 10
    
    
    private var mDutyCycle : Int = 50
    private var mFrequency : Int = 500

    init(controller: ST25PwmControlNormalAndAutoViewController) {
        mLedController = controller
        initValues()
    }
    
    public func initValues() {
        mDutyCycle = 50
        mStepsForLeds = 10
        mLedController.mPwm1DutyCycle = mDutyCycle
        mLedController.mPwm2DutyCycle = 100 - mDutyCycle
        mLedController.mPwm1Enable = true
        mLedController.mPwm2Enable = true

    }

    public func computeNextValues() {
        if mDutyCycle >= 100  && mStepsForLeds > 0 {
            mStepsForLeds = -10
            mDutyCycle = 100
        }
        if mDutyCycle <= 0  && mStepsForLeds < 0 {
            mStepsForLeds = 10
            mDutyCycle = 0
        }
        mDutyCycle = mDutyCycle + mStepsForLeds
    }
    
    private func setLeds() {
        mLedController.mPwm1DutyCycle = mDutyCycle
        mLedController.mPwm2DutyCycle = 100 - mDutyCycle
        mLedController.updateTagConfiguration()
        UIHelper.UI {
            self.mLedController.updateUIWithTagControlConfiguration()
        }
        computeNextValues()
    }
    
    private func durationStep() {
        // every 1,5 seconds
        usleep(useconds_t(1500*1000))
    }
    
    
    public func stop() {
        //print("stop")
        mDemoLoop = false
        // No more signal
    }
    
    public func start() {
        initValues()
        mDemoLoop = true;
        synchronousCall()
    }
    
    public func resume() {
        mDemoLoop = true;
        synchronousCall()
    }

    public func pause() {
        mDemoLoop = false;
    }
    
    func synchronousCall() {
        //print("Waiting for Led to be executed")
        while(mDemoLoop) {
                synchronousTask()
        }
        
        //print("All tasks were executed")
        //stop()
    }
    
    func synchronousTask() {
        let semaphore = DispatchSemaphore(value: 0)
        //print("Waiting for task \(index) to complete")
        setLeds()
        // dispatch work to a different thread
        DispatchQueue.global(qos: .background).async {
            //print("Starting task \(index)")
            self.durationStep()
            //print("Ending task \(index)")
            semaphore.signal()
        }
        
        semaphore.wait()        // block until the task completes
        //print("Task \(index) is completed")
    }
}

