//
//  DemoEHViewController.swift
//  NFCTap 
//
//  Created by STMicroelectronics on 7/29/19.
//  Copyright © 2019 STMicroelectronics. All rights reserved.
//

import UIKit
import CoreNFC

class DemoEHViewController: ST25UIViewController,NFCTagReaderSessionDelegate {

    // Reference the NFC session
    private var tagSession: NFCTagReaderSession!
    
    //
    private var startStop: Bool!
    
    @IBAction func start(_ sender: Any) {
       
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
       
       tagSession = NFCTagReaderSession(pollingOption: [.iso14443, .iso15693], delegate: self, queue: nil)
       tagSession?.alertMessage = "Hold your iPhone near an NFC tag to start Energy Harvesting Demo."
       tagSession?.begin()
       startStop = true

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startStop = false
        // Do any additional setup after loading the view.
    }
    
   // MARK: - NFCTagReaderSessionDelegate
    // MARK: - Private helper functions
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
        
        
       var ndefTag: NFCNDEFTag
       switch tags.first! {
        case let .iso15693(tag):
            ndefTag = tag
        @unknown default:
            session.invalidate(errorMessage: "Tag not valid.")
            return
        }
        session.connect(to: tags.first!) { (error: Error?) in
                     if error != nil {
                     session.invalidate(errorMessage: "Connection error. Please try again.")
                     return
                     }
            
            while(self.startStop){
                
                ndefTag.readNDEF() { (message: NFCNDEFMessage?, error: Error?) in
                    if error != nil || message == nil {
                        session.invalidate(errorMessage: "Read error. Please try again.")
                        return
                    }
                    
                }
            }
        }
   }
}
