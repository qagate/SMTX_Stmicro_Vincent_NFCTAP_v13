//
//  ST25EnergyHarverstingViewController.swift
//  NFCTap 
//
//  Created by STMICROELECTRONICS on 07/04/2021.
//  Copyright © 2021 STMicroelectronics. All rights reserved.
//

import UIKit
import CoreNFC
      
class ST25EnergyHarverstingViewController: ST25UIViewController {
    
    //CoreNFC
    internal var miOSReaderSession:iOSReaderSession!
    
    //Timer management : 60s Max due to coreNFC
    var mTimer: Timer!
    @objc func stopTimer() {
        if self.mTimer != nil {
            self.mTimer.invalidate()
        }
        
        if self.miOSReaderSession != nil {
            self.miOSReaderSession.stopTagReaderSession()
        }
    }

 
    @IBOutlet weak var timeoutTextField: UITextField!
    
    @IBAction func startEnergyHarvesting(_ sender: Any) {
        
        // start a timer to stop EH after Timeouit value entered by user
        if let valStr = timeoutTextField.text,
            let valInt = Int(valStr){
            
            if valInt > 60 {
                warningAlert(message: "Max Timeout Value is 60s")
            }else{
                mTimer = Timer.scheduledTimer(timeInterval: TimeInterval(valInt), target: self, selector: #selector(self.stopTimer), userInfo: nil, repeats: false)
                // run NFC
                self.miOSReaderSession = iOSReaderSession(atagReaderSessionViewControllerDelegate: self)
                self.miOSReaderSession.startTagReaderSession()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func warningAlert(message : String) {
        UIHelper.warningAlert(viewController: self, title : "Energy Harvesting" , message: message)
    }

}

extension ST25EnergyHarverstingViewController: tagReaderSessionViewControllerDelegateWithFinallyBlock {
    
    func handleFinallyBlock() {
        //Does nothing
    }

    func handleTag(st25SDKTag: ComStSt25sdkNFCTag, uid: Data!) throws {
        // Does nothing
    }

    func handleTagSessionError(didInvalidateWithError error: Error) {
        let errorNFC = error as! NFCReaderError
        if errorNFC.code ==  NFCReaderError.readerSessionInvalidationErrorSessionTimeout {
        }
        else if errorNFC.code ==  NFCReaderError.readerSessionInvalidationErrorUserCanceled {
        }
        stopTimer()
    }

    func handleTagST25SdkError(didInvalidateWithError error: NSException) {
        miOSReaderSession.stopTagReaderSession("Command failed: \(error.description)")
    }
}
