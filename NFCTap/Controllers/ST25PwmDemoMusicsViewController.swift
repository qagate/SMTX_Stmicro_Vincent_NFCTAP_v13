//
//  ST25PwmDemosMusicsViewController.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 14/05/2020.
//  Copyright © 2020 STMicroelectronics. All rights reserved.
//

import UIKit
import CoreNFC


class ST25PwmDemoMusicsViewController: ST25UIViewController {

    internal var mTag:ComStSt25sdkNFCTag!
    internal var miOSReaderSession:iOSReaderSession!
    enum taskToDo {
        case readPwmSetting
        case enablePwm1
        case startMusic
        case resumeMusic
        case stopMusic
        case pauseMusic
        case muteMusic
    }
    
    internal var mTaskToDo:taskToDo = .startMusic
    
    private var mArrayList:[String]!
    private var mIndexList:Int!

    private let mMusics = Musics()
    private var mMusicsPlayer : MusicPlayer!
    let startButtonLabel = "Start   "
    let resumeButtonLabel = "Resume"


    private var mEnablePwm1 : Bool = false
//    private var mPwm1Frequency : Int!
//    private var mPwm1DutyCycle : Int!
    
    @IBOutlet weak var musicsTypePickerView: UIPickerView!
    
    @IBOutlet weak var mPwm1EnableSwitch: UISwitch!
    @IBAction func enablePwmSwitchAction(_ sender: UISwitch) {
        if mPwm1EnableSwitch.isOn {
            mEnablePwm1 = true
        } else {
            mEnablePwm1 = false

        }
        mTaskToDo = .enablePwm1
        miOSReaderSession.startTagReaderSession()

    }
    
    @IBOutlet weak var mDynamicStartResumeButton: UIButton!
    
    @IBAction func startMusic(_ sender: UIButton) {
        if ( mDynamicStartResumeButton.titleLabel?.text == startButtonLabel) {
            if (self.mMusicsPlayer.setupSources(musicNotes: self.mMusics.mMusicsList[self.mIndexList]! , durationNotes: self.mMusics.mMusicsListTick[self.mIndexList]!)) {
                // start
                mTaskToDo = .startMusic
                miOSReaderSession.startTagReaderSession()
                
            }
            else {
                warningAlert(message: "Invalid music partition")
                
            }
 
        } else {
            // resume
            mTaskToDo = .resumeMusic
            miOSReaderSession.startTagReaderSession()
        }
        
    }
    
    @IBAction func stopMusic(_ sender: UIButton) {
        mDynamicStartResumeButton.titleLabel?.text = startButtonLabel
        mTaskToDo = .stopMusic
        miOSReaderSession.startTagReaderSession()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        musicsTypePickerView.delegate = self
        mIndexList = 0
        // Do any additional setup after loading the view.
        mMusicsPlayer = MusicPlayer(controller: self)
        mEnablePwm1 = false
        mPwm1EnableSwitch.setOn(mEnablePwm1, animated: true)
        self.title = "Pwm music demo"
        self.mDynamicStartResumeButton.setTitle(self.startButtonLabel, for: .normal)
        
        //mDynamicStartResumeButton.titleLabel?.adjustsFontSizeToFitWidth
        
        self.miOSReaderSession = iOSReaderSession(atagReaderSessionViewControllerDelegate: self)
        mTaskToDo = .readPwmSetting
        miOSReaderSession.startTagReaderSession()

    }
    
    private func readPwmSettings(pwmNumber : Int) {
        var enable : Bool;
        var frequency : Int, dutyCycle : Int;
        
        if self.mTag is ST25DVPwmTag {
            if (mTag == nil && ((pwmNumber < 1) || (pwmNumber > (mTag as! ST25DVPwmTag).getNumberOfPwm()))) {
                warningAlert(message: "Invalid Pwm number")
                return
            }
            if (pwmNumber == ComStSt25sdkType5St25dvpwmST25DVPwmTag.PWM1) {
                enable = (mTag as! ST25DVPwmTag).isPwmEnable(with: ComStSt25sdkType5St25dvpwmST25DVPwmTag.PWM1);
                frequency = Int((mTag as! ST25DVPwmTag).getPwmFrequency(with:ComStSt25sdkType5St25dvpwmST25DVPwmTag.PWM1));
                dutyCycle = Int((mTag as! ST25DVPwmTag).getPwmDutyCycle(with: ComStSt25sdkType5St25dvpwmST25DVPwmTag.PWM1));
                UIHelper.UI {
                    self.mPwm1EnableSwitch.setOn(enable, animated: true)
                    if !enable {
                        //self.warningAlert(message: "Pwm1 not enabled!")
                    }
                }

                
            } else if (pwmNumber == ComStSt25sdkType5St25dvpwmST25DVPwmTag.PWM2) {
                enable = (mTag as! ST25DVPwmTag).isPwmEnable(with: ComStSt25sdkType5St25dvpwmST25DVPwmTag.PWM2);
                frequency = Int((mTag as! ST25DVPwmTag).getPwmFrequency(with: ComStSt25sdkType5St25dvpwmST25DVPwmTag.PWM2));
                dutyCycle = Int((mTag as! ST25DVPwmTag).getPwmDutyCycle(with : ComStSt25sdkType5St25dvpwmST25DVPwmTag.PWM2));
                UIHelper.UI {
                    if !enable {
                        self.warningAlert(message: "Pwm2 not enabled!")
                    }
                }
            }
        } else {
            UIHelper.UI {
                self.warningAlert(message: "Invalid Tag")
            }
        }
        
    }
    
    private func enablePwm(pwmNumber : Int, enable : Bool) {
        if self.mTag is ST25DVPwmTag {
            if (pwmNumber == ComStSt25sdkType5St25dvpwmST25DVPwmTag.PWM1) {
                (mTag as! ST25DVPwmTag).enablePwm(with: ComStSt25sdkType5St25dvpwmST25DVPwmTag.PWM1, withBoolean: enable)
                mEnablePwm1 = enable

            } else {
                (mTag as! ST25DVPwmTag).enablePwm(with: ComStSt25sdkType5St25dvpwmST25DVPwmTag.PWM2, withBoolean: enable)
            }

        } else {
            warningAlert(message: "Invalid Tag")
        }
    }
    
    
    public func writePwmConfiguration(freq : Int, dutyCycle : Int, enable : Bool) {
        if self.mTag is ST25DVPwmTag {
            (mTag as! ST25DVPwmTag).setPwmConfigurationWith(ComStSt25sdkType5St25dvpwmST25DVPwmTag.PWM1, with: jint(freq), with: jint(dutyCycle), withBoolean: enable)
        } else {
            warningAlert(message: "Invalid Tag")
        }
    }

    private func startMusic() {
        //print("start the music")
        mMusicsPlayer.start()
    }
    
    private func stopMusic() {
        //print("start the music")
        mMusicsPlayer.stop()
    }
    private func resumeMusic() {
        //print("resume the music")
        mMusicsPlayer.resume()
    }

    private func muteMusic() {
        //print("mute the music")
        mMusicsPlayer.holdNote()
    }
    
    private func pauseMusic() {
        //print("mute the music")
        mMusicsPlayer.pause()
    }
    
    private func warningAlert(message : String) {
        UIHelper.warningAlert(viewController: self, title : "Pwm Musics demo" , message: message)
    }

}




extension ST25PwmDemoMusicsViewController: tagReaderSessionViewControllerDelegate {
    
    func handleTag(st25SDKTag: ComStSt25sdkNFCTag, uid: Data!) throws {
        self.mTag = st25SDKTag
        if self.isSameTag(uid: uid) {
            // needed to have Registers iOSReader Interface aligned with Tag
            if self.mTag is ST25DVPwmTag {
                switch mTaskToDo {
                case .startMusic:
                    startMusic()
                case .stopMusic:
                    stopMusic()
                case .enablePwm1:
                    enablePwm(pwmNumber: Int(ComStSt25sdkType5St25dvpwmST25DVPwmTag.PWM1), enable: mEnablePwm1)
                case .readPwmSetting:
                    readPwmSettings(pwmNumber: Int(ComStSt25sdkType5St25dvpwmST25DVPwmTag.PWM1))
                case .resumeMusic:
                    resumeMusic()
                case .muteMusic:
                    muteMusic()
                case .pauseMusic:
                    pauseMusic()
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
            if self.mTaskToDo == .startMusic || self.mTaskToDo == .resumeMusic {
                UIHelper.UI {
                    self.mDynamicStartResumeButton.setTitle(self.resumeButtonLabel, for: .normal)
                }
                self.mMusicsPlayer.mDemoLoop = false
                //self.mMusicsPlayer.holdNote()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0,execute: { () -> Void in
                    self.mTaskToDo = .pauseMusic
                    self.miOSReaderSession.startTagReaderSession()
                })

            }
        }
        else if errorNFC.code ==  NFCReaderError.readerSessionInvalidationErrorUserCanceled {
            if self.mTaskToDo == .startMusic || self.mTaskToDo == .resumeMusic {
                UIHelper.UI {
                    //self.mDynamicStartResumeButton.titleLabel?.text = self.resumeButtonLabel
                    self.mDynamicStartResumeButton.setTitle(self.resumeButtonLabel, for: .normal)
                }
                self.mMusicsPlayer.mDemoLoop = false
                //self.mMusicsPlayer.holdNote()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0,execute: { () -> Void in
                    self.mTaskToDo = .pauseMusic
                    self.miOSReaderSession.startTagReaderSession()
                })
            }
        }
        miOSReaderSession.stopTagReaderSession(error.localizedDescription)
        
    }
    
    func handleTagST25SdkError(didInvalidateWithError error: NSException) {
        if self.mTaskToDo == .startMusic {
            UIHelper.UI {
                self.mDynamicStartResumeButton.setTitle(self.resumeButtonLabel, for: .normal)
            }
            self.mMusicsPlayer.mDemoLoop = false
            //self.mMusicsPlayer.holdNote()
        }

        miOSReaderSession.stopTagReaderSession("Command failed: \(error.description)")

    }
    
}


extension ST25PwmDemoMusicsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1

    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //print(Musics.MusicListTitle.count)
        return mMusics.mMusicsList.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Musics.MusicListTitle(rawValue: row)?.description
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.mIndexList = row
        UIHelper.UI {
            //self.mDynamicStartResumeButton.titleLabel?.text = self.startButtonLabel
            self.mDynamicStartResumeButton.setTitle(self.startButtonLabel, for: .normal)

        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "System", size: 14)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = Musics.MusicListTitle(rawValue: row)?.description
        pickerLabel?.textColor = UIColor.white

        return pickerLabel!
    }

}

private class MusicPlayer {
    
    private var musicController : ST25PwmDemoMusicsViewController
    
    private var mMusicNotes : [Int]!
    private var mDurationNotes : [Int]!
    var mDemoLoop : Bool = true
    var mStepsForMusic : Int = 0

    private var rightMusicDefined : Bool = false
    
    
    private var mPwm1DutyCycle : Int = 50
    private var mPwm1Enable : Bool = false
    private var mPwm1Frequency : Int = 500

    init(controller: ST25PwmDemoMusicsViewController) {
        musicController = controller
    }
    
    public func setupSources(musicNotes : [Int], durationNotes : [Int]) -> Bool{
        rightMusicDefined = true
        if musicNotes.count != durationNotes.count {
            rightMusicDefined = false
        }
        mMusicNotes = musicNotes;
        mDurationNotes = durationNotes;
        mDemoLoop = true
        mStepsForMusic = 0
        
        mPwm1Enable = false
        mPwm1DutyCycle = 50
        mPwm1Frequency = 500
        return rightMusicDefined
    }
    
    private func setNote(index : Int) {
        var frequency : Int = mMusicNotes[index]
        mPwm1Frequency = frequency
        mPwm1Enable = true
        
        if (frequency == Musics.NOP) {
            musicController.writePwmConfiguration(freq: frequency, dutyCycle: 0, enable: false);
        } else {
            musicController.writePwmConfiguration(freq: frequency, dutyCycle: mPwm1DutyCycle, enable: true);
        }

    }
    private func durationNote(index : Int) {
        usleep(useconds_t(mDurationNotes[mStepsForMusic]*1000))
    }
    
    public func holdNote() {
        musicController.writePwmConfiguration(freq: mPwm1Frequency, dutyCycle: 0, enable: false);
    }
    
    public func stop() {
        print("stop")
        mDemoLoop = false
        mStepsForMusic = 0
        self.musicController.mTaskToDo = .readPwmSetting
        UIHelper.UI {
            self.musicController.mDynamicStartResumeButton.setTitle(self.musicController.startButtonLabel, for: .normal)
        }
        // No more signal
        holdNote()
    }
    
    public func start() {
        mDemoLoop = true;
        mStepsForMusic = 0
        synchronousCall()
    }
    
    public func resume() {
        mDemoLoop = true;
        synchronousCall()
    }

    public func pause() {
        mDemoLoop = false;
        holdNote()
    }
    
    func synchronousCall() {
        //print("Waiting for notes to be executed")
        for i in mStepsForMusic..<mMusicNotes.count {
            if mDemoLoop {
                synchronousTask(index: i)
                mStepsForMusic = i
            } else {
                return
            }
        }
        //print("All tasks were executed")
        stop()
    }
    
    func synchronousTask(index : Int) {
        let semaphore = DispatchSemaphore(value: 0)
        //print("Waiting for task \(index) to complete")
        setNote(index: index)
        // dispatch work to a different thread
        DispatchQueue.global(qos: .background).async {
            //print("Starting task \(index)")
            self.durationNote(index: index)
            //print("Ending task \(index)")
            semaphore.signal()
        }
        
        semaphore.wait()        // block until the task completes
        //print("Task \(index) is completed")
    }
}

private class Musics {
    static let NOP : Int = 489; // In order to generate a pause between notes when needed.
    static let DO4 : Int = 523;
    static let  DOdi4 : Int = 554;
    static let  RE4 : Int = 587;
    static let  REdi4 : Int = 622;
    static let  MI4 : Int = 659;
    static let  FA4 : Int = 698;
    static let  FAdi4 : Int = 740;
    static let  SOL4 : Int = 784;
    static let  SOLdi4 : Int = 831;
    static let  LA4 : Int = 880;
    static let  LAdi4 : Int = 932;
    static let  Sib4 : Int = 932;
    static let  SI4 : Int = 988;
    static let  DO5 : Int = 1047;
    static let  DOdi5 : Int = 1109;
    static let  RE5 : Int = 1175;
    static let  REdi5 : Int = 1245;
    static let  MI5 : Int = 1319;
    static let  FA5 : Int = 1397;
    static let  FAdi5 : Int = 1480;
    static let  SOL5 : Int = 1568;
    static let  SOLdi5 : Int = 1661;
    static let  LA5 : Int = 1760;
    static let  LAdi5 : Int = 1865;
    static let  Sib5 : Int = 1869;
    static let  SI5 : Int = 1976;
    static let  DO6 : Int = 2093;

    static let  Rd : Int = 1600;  // ronde
    static let  B : Int = 800;    // blanche
    static let  N : Int = 400;    // noire
    static let  Cp : Int = 300;   // croche pointée
    static let  C : Int = 200;    // croche
    static let  Dp : Int = 150;   // double croche pointée
    static let  D : Int = 100;    // double croche
    static let  T : Int = 50;     // triple croche
    static let  Q : Int = 25;     // Quad croche
    static let  Bp : Int = 1200;   // blanche pointée
    static let  Np : Int = 600;    // noire pointée
    static let  TC : Int = 133;    // Triple
    static let  TBB : Int = 10;   // pause


    var notesMarseillaise = [DO4, NOP, DO4, NOP, DO4,    FA4, NOP, FA4, SOL4, NOP ,SOL4,   DO5, LA4, FA4, NOP, FA4, LA4, FA4,    RE4, Sib4, SOL4, MI4,   FA4, NOP, FA4, SOL4,    LA4, NOP, LA4, NOP, LA4, Sib4, LA4, NOP,   LA4, SOL4, NOP, SOL4, LA4,    Sib4, NOP, Sib4, NOP, Sib4, DO5, Sib4,    LA4, NOP, DO5, NOP, DO5, NOP,   DO5, LA4, FA4, DO5, LA4, FA4,    DO4, NOP, DO4, NOP, DO4, MI4,    SOL4, Sib4, SOL4, MI4,     SOL4, FA4, REdi4,    RE4, FA4, NOP, FA4, NOP, FA4, MI4, FA4,    SOL4, NOP, SOL4,    SOLdi4, NOP, SOLdi4, NOP, SOLdi4, NOP, SOLdi4, Sib4, DO5,     SOL4, NOP, SOLdi4, SOL4,     FA4, NOP, FA4, NOP, FA4, SOLdi4, SOL4, FA4, NOP,    FA4, MI4, NOP, DO5, NOP,    DO5, DO5, NOP, DO5, LA4, FA4,   SOL4, SOL4, DO5, NOP,    DO5, DO5, NOP, DO5, LA4, FA4,    SOL4, DO4,    FA4, SOL4,    LA4,    Sib4, DO5, RE5,    SOL4, RE5,    DO5, DO5, LA4, Sib4, SOL4,    FA4 ];
    var notesMarseillaiseD = [D, TBB,  Cp,  TBB, D,      N, TBB,   N,   N,   TBB, N,      N,   C,   Cp,  TBB, D,   Cp,  D,      N,    B,   Cp,   D,      B,  N,   Cp,  D,       N,   TBB,  N,  TBB,  N,  Cp,   D,   TBB,   N,   B,  TBB,   Cp,   D,      N,   TBB,  N,   TBB,  N,    Cp,  D,       B,    N,  Cp,  TBB, D,   TBB,    N,  Cp,   D,   N,   Cp,  D,     B,   N,   D,   TBB,  Cp, D,      B,    N,    Cp,   D,       N,    N,   B,        N,   Cp,  TBB,  D,  TBB,  N,  Cp,   D,     B,   N,   N,        Np,      TBB,   C,    TBB,  C,    TBB,   C,     C,    C,        B,   N,    Cp,     D,       Np,  TBB, C,   TBB, C,    C,     C,      C,   TBB,    B,   N,  C,   C,   TBB,     B,   Cp,  TBB, D,   Cp,   D,    Bp,   Cp,   D,    TBB,    B,  Cp,   TBB, D,  Cp,  D,       Bp,  N,      Bp,  N,       Rd,     B,    N,   N,      Bp,   N,      B,   Cp,  D,  Cp,    D,      Rd]

    var notesFrereJacques1 = [FA4, SOL4, LA4, FA4, NOP,    FA4, SOL4, LA4, FA4, NOP,    LA4, LAdi4, DO5,     LA4, LAdi4, DO5, NOP,    DO5, RE5, DO5, LAdi4, LA4, FA4,      DO5, RE5, DO5, LAdi4, LA4, FA4, NOP,      FA4, DO4, FA4, NOP, FA4, DO4, FA4]
    var notesFrereJacques1D = [N,  N,        N,    N,     TBB,      N,     N,       N,     N,    TBB,      N,     N,        B,          N,     N,        B,      TBB,     Cp,    D,     C,       C,        N,      N,        Cp,     D,     C,       C,        N,    N,     TBB,        N,    N,       B,     TBB,   N,      N,      B]

    var notesHappyBirthday = [LA4, NOP, LA4, SI4, LA4, RE5, DOdi5,      LA4, NOP, LA4, SI4, LA4, MI5, RE5,     LA4, NOP, LA4, LA5, FAdi5, RE5, DOdi5, SI4,      SOL5, NOP, SOL5, FAdi5, RE5, MI5, RE5]
    var notesHappyBirthdayD = [Cp, TBB, D,   N,   N,   N,   B,          Cp,  TBB, D,   N,   N,   N,   B,       Cp,  TBB, D,   N,   N,     N,   N,     N,        Cp,   TBB, D,    N,     N,   N,   B  ]


    var notesPacMan = [SI4, SI5, FAdi5, REdi5, SI5, FAdi5, REdi5,    DO5, DO6, SOL5, MI5, DO6, SOL5, MI5,   SI4, SI5, FAdi5, REdi5, SI5, FAdi5, REdi5,    NOP, REdi5, MI5, FA5,  NOP, FA5, FAdi5, SOL5, NOP, SOL5, SOLdi5, LA5, SI5 ]
    var notesPacManD = [C,   C,   C,     C,     D,   Cp,     N,       C,   C,   C,    C,   D,   Cp,   N,     C,   C,   C,     C,     D,   Cp,    N,        TBB, D,     D,   C,    TBB, D,   D,     C,    TBB, D,    D,      C,   N   ]



    var notesLittleFatherChristmas = [DO4,    FA4, NOP, FA4, NOP, FA4, SOL4,    FA4, NOP, FA4, SOL4,    LA4, NOP, LA4, NOP, LA4, Sib4,    LA4, SOL4,    FA4, NOP, FA4, NOP, FA4, NOP, FA4, MI4, RE4,    DO4, NOP, DO4, NOP, DO4,    FA4, NOP, FA4, NOP, FA4, MI4, FA4, SOL4]
    var notesLittleFatherChristmasD = [N, N, TBB, N, TBB, N, N, B, TBB, C, C, N, TBB, N, TBB, N, N, B, N, N, TBB, C, TBB, C, TBB, C, C, C, B, TBB, C, TBB, C, B, TBB, C, TBB, C, C, C, B]

    var notesIndiana = [ MI4, FA4,     SOL4, DO5, DO5, RE4, MI4,         FA4, SOL4, LA4,         SI4, FA5, FA5, LA4, SI4,      DO5, RE5, MI5, MI4, FA4,      SOL4, DO5, DO5, RE5, MI5,       FA5, SOL4, NOP, SOL4,       MI5, RE5, SOL4, MI5, RE5, SOL4,     MI5, RE5, SOL4, MI5, RE5, MI4, FA4,       SOL4, DO5, DO5, RE4, MI4,         FA4, SOL4, LA4,         SI4, FA5, FA5, LA4, SI4,      DO5, RE5, MI5, MI4, FA4,      SOL4, DO5, DO5, RE5, MI5,       FA5, SOL4, NOP, SOL4,       MI5, RE5, SOL4, MI5, RE5, SOL4,     MI5, RE5, SOL4, MI5, RE5, MI4, SOL4,       FA4, RE4, FA4,     MI4, SOL4, MI5, MI5, MI4, SOL4,        FA4, RE4, FA4,     MI4, SOL4, MI5, MI5, RE5, MI5,      FA5, RE5, FA5,        REdi5, RE5, DO5, DO5, NOP, DO5, REdi5   ]
    var notesIndianaD = [ Cp,  D,          C,        C,     B,       Cp,     D,           Bp,     Cp,    D,             C,    C ,     B,      Cp,    D,       N,      N,      N,    Cp,    D,          C,        C,      B,      Cp,   D,           Bp,    Cp,     TBB,   D,             N,     Cp,    D,     N,      Cp,     D,           N,     Cp,    D,      C,      C,          Cp,    D,           C,        C,     B,       Cp,     D,           Bp,     Cp,    D,             C,    C ,     B,      Cp,    D,       N,      N,      N,    Cp,    D,          C,        C,      B,      Cp,   D,           Bp,    Cp,     TBB,   D,             N,     Cp,    D,     N,      Cp,     D,           N,     Cp,    D,      C,      C,      Cp,  D,             Bp,    Cp,   D,         TC,   TC,     TC,    B,       Cp,     D,            Bp,    Cp,    D,        TC,  TC,     TC,    B,      Cp,    D,           Bp,    Cp,    D,        TC,    TC,      TC,     B,        TBB,  Cp,     D ]

    enum MusicListTitle : Int {
        case FrereJacques = 0
        case PacMan = 1
        case Indiana = 2
        case HappyBirthday = 3
        case Marseillaise = 4
        case LittleFatherChristmas = 5
        static var count: Int { return MusicListTitle.LittleFatherChristmas.hashValue + 1 }

        var description: String {
            switch self {
            case .FrereJacques : return "FrereJacques"
            case .PacMan : return "PacMan"
            case .Indiana : return "Indiana"
            case .HappyBirthday : return "HappyBirthday"
            case .Marseillaise : return "Marseillaise"
            case .LittleFatherChristmas : return "LittleFatherChristmas"
            default: return ""
            }
        }
    }

    var mMusicsList : Dictionary<Int, [Int]>
    var mMusicsListTick : Dictionary<Int, [Int]>
    
    public init() {
        mMusicsList = [MusicListTitle.FrereJacques.rawValue : notesFrereJacques1,
                       MusicListTitle.PacMan.rawValue: notesPacMan,
                       MusicListTitle.Indiana.rawValue :  notesIndiana,
                       MusicListTitle.Marseillaise.rawValue : notesMarseillaise,
                       MusicListTitle.HappyBirthday.rawValue : notesHappyBirthday,
                       MusicListTitle.LittleFatherChristmas.rawValue : notesLittleFatherChristmas]
        mMusicsListTick = [MusicListTitle.FrereJacques.rawValue: notesFrereJacques1D,
                           MusicListTitle.PacMan.rawValue: notesPacManD,
            MusicListTitle.Indiana.rawValue: notesIndianaD,
            MusicListTitle.Marseillaise.rawValue: notesMarseillaiseD,
            MusicListTitle.HappyBirthday.rawValue: notesHappyBirthdayD,
            MusicListTitle.LittleFatherChristmas.rawValue: notesLittleFatherChristmasD]
    }
}
