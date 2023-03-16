//
//  ST25DVPWMConfigurationViewController.swift
//  ST25NFCApp
//
//  Created by STMicroelectronics on 7/24/19.
//  Copyright © 2019 STMicroelectronics. All rights reserved.
//

import UIKit
import CoreNFC



class ST25DVPWMConfigurationViewController: ST25UIViewController,NFCTagReaderSessionDelegate {

    // Reference the NFC session
    private var tagSession: NFCTagReaderSession!
    
    private var mPwm1PeriodLSB:UInt8 = 0xC1
    private var mPwm1PeriodMSB:UInt8 = 0x0D
    private var mPwm1PulseWidthLSB:UInt8 = 0x7F
    private var mPwm1PulseWidthMSB:UInt8 = 0x8D

     private var mAddressPWM:UInt8 = 0xF8
    
    @IBOutlet weak var mPWM2DutyCycleLabel: UILabel!
    @IBOutlet weak var mPWM1DutyCycleLabel: UILabel!
    @IBOutlet weak var mTagInfoTextView: UITextView!
    
    @IBAction func pwm1_0(_ sender: Any) {
        mAddressPWM = 0xF8
        mPWM1DutyCycleLabel.text = "0"
        pwmx_0()
     }
    
    @IBAction func pwm1_25(_ sender: Any) {
        mAddressPWM = 0xF8
        mPWM1DutyCycleLabel.text = "25%"
        pwmx_25()
    }
    
    @IBAction func pwm1_50(_ sender: Any) {
        mAddressPWM = 0xF8
        mPWM1DutyCycleLabel.text = "50%"
        pwmx_50()
    }
    
    @IBAction func pwm1_75(_ sender: Any) {
        mAddressPWM = 0xF8
        mPWM1DutyCycleLabel.text = "75%"
        pwmx_75()
    }
    
    @IBAction func pwm1_100(_ sender: Any) {
        mAddressPWM = 0xF8
        mPWM1DutyCycleLabel.text = "100%"
        pwmx_100()
    }
    
    
    @IBAction func pwm2_0(_ sender: Any) {
        mAddressPWM = 0xF9
        mPWM2DutyCycleLabel.text = "0"
        pwmx_0()
    }
    
    @IBAction func pwm2_25(_ sender: Any) {
        mAddressPWM = 0xF9
        mPWM2DutyCycleLabel.text = "25%"
        pwmx_25()
    }
    
    @IBAction func pwm2_50(_ sender: Any) {
        mAddressPWM = 0xF9
        mPWM2DutyCycleLabel.text = "50%"
        pwmx_50()
    }
    
    @IBAction func pwm2_75(_ sender: Any) {
        mAddressPWM = 0xF9
        mPWM2DutyCycleLabel.text = "75%"
        pwmx_75()
    }
    
    @IBAction func pwm2_100(_ sender: Any) {
        mAddressPWM = 0xF9
        mPWM2DutyCycleLabel.text = "100%"
        pwmx_100()
    }
    
    
    func pwmx_0() {
        mPwm1PeriodLSB = 0x80
        mPwm1PeriodMSB = 0x00
        startSessiont()
       }
       
       func pwmx_25() {
        mPwm1PeriodLSB = 0xA2
        mPwm1PeriodMSB = 0x70
        startSessiont()
       }
       
       func pwmx_50() {
        mPwm1PeriodLSB = 0xC1
        mPwm1PeriodMSB = 0x0D
        startSessiont()
       }
       
       func pwmx_75() {
        mPwm1PeriodLSB = 0xE3
        mPwm1PeriodMSB = 0x7D
        startSessiont()
       }
       
       func pwmx_100() {
        mPwm1PeriodLSB = 0xFF
        mPwm1PeriodMSB = 0x8D
        startSessiont()
       }
       
    
    
    func startSessiont() {
        guard NFCNDEFReaderSession.readingAvailable else {
                let alertController = UIAlertController(
                    title: "Scanning Not Supported",
                    message: "This device doesn't support tag scanning.",
                    preferredStyle: .alert
                )
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            
            tagSession = NFCTagReaderSession(pollingOption: [.iso15693], delegate: self, queue: nil)
       
            tagSession?.alertMessage = "Hold your smartphone near an ST25DV-PWM tag"
            tagSession?.begin()
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        /*
        let miOSReaderInterface = iOSRFReaderInterface()
        let uidString = String("e002390000c1d19b")
        let uidData = uidString.data(using:.utf8)
        let uidIOSByteArray = IOSByteArray.init(nsData: uidData)
        
        let mIso15693Command = ComStSt25sdkCommandIso15693Command(comStSt25sdkRFReaderInterface: miOSReaderInterface, with: uidIOSByteArray)
        let responseTag = mIso15693Command.readSingleBlock(withByte: 0x02)
        
        
        //let mSt25DVPWMTag = ComStSt25sdkType5St25dvpwmST25DVPwmTag(comStSt25sdkRFReaderInterface: miOSReaderInterface, with: uidIOSByteArray)
        
        //let period = mSt25DVPWMTag.computePeriod(with: 1000)
        //print(period)
         */
    }
    

    func tagRemovalDetect(_ tag: NFCTag) {
        self.tagSession?.connect(to: tag) { (error: Error?) in
            if error != nil || !tag.isAvailable {
      
                self.tagSession?.restartPolling()
                return
            }
            DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + .milliseconds(500), execute: {
                self.tagRemovalDetect(tag)
            })
        }
    }
    
    // NFCTagReaderSessionDelegate
    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        // If necessary, you may perform additional operations on session start.
        // At this point RF polling is enabled.
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        // If necessary, you may handle the error. Note session is no longer valid.
        // You must create a new session to restart RF polling.
        //session.restartPolling();
        session.invalidate();
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        if tags.count > 1 {
            tagSession.alertMessage = "More than 1 tags was found. Please present only 1 tag."
            //tagSession.restartPolling()
            self.tagRemovalDetect(tags.first!)
            return
        }
        
        var iso15693Tag: NFCISO15693Tag!
        
        switch tags.first! {
            case let .iso15693(tag):
                iso15693Tag = tag .asNFCISO15693Tag()!
            break
            
       @unknown default:
            session.invalidate(errorMessage: "Tag not valid or not type5")
            //session.restartPolling()
            return
        }
  
        session.connect(to: tags.first!) { (error: Error?) in
             if error != nil {
             session.invalidate(errorMessage: "Connection error. Please try again.")
             return
             }
            self.getSystemInfoType5(session: session, iso15693Tag: iso15693Tag)
            self.setPwmConfig(session: session, iso15693Tag: iso15693Tag)
        }
    }
    
    func setPwmConfig(session: NFCTagReaderSession , iso15693Tag: NFCISO15693Tag){
        
        iso15693Tag.writeSingleBlock(requestFlags: RequestFlag(rawValue: 0x02), blockNumber: self.mAddressPWM, dataBlock: Data(bytes: [self.mPwm1PulseWidthMSB,self.mPwm1PulseWidthLSB,self.mPwm1PeriodMSB,self.mPwm1PeriodLSB])){ (error: Error?) in
              if error != nil {
                  session.invalidate(errorMessage: "PWM1 error . Please try again."+error!.localizedDescription)
                  print(error!.localizedDescription)
                  return
              }
            session.invalidate()
        }
    }
    
    func getSystemInfoType5(session: NFCTagReaderSession , iso15693Tag: NFCISO15693Tag){
        
        iso15693Tag.getSystemInfo(requestFlags: RequestFlag(rawValue: 0x02)) {  (dfsid: Int,afi: Int,blockSize: Int,memorySize: Int,icRef: Int, error: Error?) in
                            if error != nil {
                                session.invalidate(errorMessage: "getSystemInfo error . Please try again."+error!.localizedDescription)
                                print(error!.localizedDescription)
                                return
                            }
            let uidString = iso15693Tag.identifier.toHexString().replacingOccurrences(of: " ", with: "")
            print("==========================================================\n")
            print("Tag Info\n")
            print("==========================================================\n")
            print("IC Identifier = \(uidString)\n")
            print("IC ManufacturerCode = \(iso15693Tag.icManufacturerCode)\n")
            print("==========================================================\n")
            print("Get System Info\n")
            print("==========================================================\n")
            print(String(format: "dfsid %d DFSID\n", dfsid))
            print(String(format: "afi %d AFI\n", afi))
            print(String(format: "blockSize %d blocks Size\n", blockSize))
            print(String(format: "memorySize %d Memory Size\n", memorySize))
            print(String(format: "icRef 0x%X IC Ref\n", icRef))
            
            DispatchQueue.main.sync {
                            // Informs TextView in Main Thread
                            self.mTagInfoTextView.text  = ""
                            self.mTagInfoTextView.text  = self.mTagInfoTextView.text + "IC Identifier = \(uidString)\n"
                            self.mTagInfoTextView.text  = self.mTagInfoTextView.text + "IC ManufacturerCode = \(iso15693Tag.icManufacturerCode)\n"
                            self.mTagInfoTextView.text  = self.mTagInfoTextView.text + String(format: "IC Reference 0x%X\n", icRef)
                            self.mTagInfoTextView.text  = self.mTagInfoTextView.text + String(format: "Block Size %d\n", blockSize)
                            self.mTagInfoTextView.text  = self.mTagInfoTextView.text + String(format: "Memory Size %d blocks\n", memorySize)
                     
            }
                            
        }
    }
}
