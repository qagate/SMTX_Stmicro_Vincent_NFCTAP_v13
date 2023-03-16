//
//  ST25TVTamperViewController.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 10/29/19.
//  Copyright © 2019 STMicroelectronics. All rights reserved.
//

import UIKit

class ST25TVTamperViewController: ST25UIViewController,tagReaderSessionViewControllerDelegate {
    func handleTagSessionError(didInvalidateWithError error: Error) {
    }
    
    func handleTagST25SdkError(didInvalidateWithError error: NSException) {
        self.warningAlert(message: error.description)
    }
    
    
    internal var mST25TVTag:ST25TVTag!
    internal var miOSReaderSession:iOSReaderSession!
   
    enum taskToDo {
        case initTamper
        case refreshTamper
    }
    

    func handleTag(st25SDKTag: ComStSt25sdkNFCTag, uid: Data!) throws {
        mST25TVTag = st25SDKTag as! ST25TVTag
        refreshST25TVTamper()
    }
    
    @IBOutlet weak var tamperImageView: UIImageView!
    
    @IBAction func handleRefresh(_ sender: Any) {
        miOSReaderSession.startTagReaderSession()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        miOSReaderSession = iOSReaderSession(atagReaderSessionViewControllerDelegate: self)
        miOSReaderSession.startTagReaderSession()
    }
    
    private func refreshST25TVTamper(){
       displayTamperStatus(mST25TVTag.isTamperDetected())
    }
    
    private func displayTamperStatus(_ status:Bool) {
        DispatchQueue.main.sync {
            if (status){
                tamperImageView.image = UIImage(named: "tamper_detect_open.png")
            }else{
                tamperImageView.image = UIImage(named: "tamper_detect_close.png")
            }
        }
        
    }
    
    private func warningAlert(message : String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "ST25TV Tamper", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
