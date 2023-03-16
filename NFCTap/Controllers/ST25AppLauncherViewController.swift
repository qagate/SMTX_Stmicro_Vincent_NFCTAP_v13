//
//  ST25AppLauncherViewController.swift
//  NFCTap 
//
//  Created by STMicroelectronics on 02/08/2021.
//  Copyright © 2021 STMicroelectronics. All rights reserved.
//

import UIKit
import CoreNFC

class ST25AppLauncherViewController: ST25UIViewController {
    
    // NFC & Tags infos
    internal var miOSReaderSession:iOSReaderSession!
    internal var miOSNdef:iOSNdef!


    @IBAction func handleWriteTag(_ sender: Any) {
        miOSReaderSession = iOSReaderSession(andefReaderSessionViewControllerDelegate: self)
        miOSReaderSession.startNdefReaderSession()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    private func warningAlert(message : String) {
         DispatchQueue.main.async {
             let alert = UIAlertController(title: "ST25 App Launcher", message: message, preferredStyle: .alert)
             alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
             self.present(alert, animated: true, completion: nil)
         }
     }
    
    private func writeNDEFs(){
        
        let ndefMsg:ComStSt25sdkNdefNDEFMsg = ComStSt25sdkNdefNDEFMsg()
        
        // Create ST25SDK NDEF URI Universal Link
        let comStSt25sdkNdefUriRecord:ComStSt25sdkNdefUriRecord = new_ComStSt25sdkNdefUriRecord_initWithComStSt25sdkNdefUriRecord_NdefUriIdCode_withNSString_(.NDEF_RTD_URI_ID_HTTPS_WWW, "myst25.com")
            
        // Create ST25SDK NDEF AAR
        let comStSt25sdkNdefAar:ComStSt25sdkNdefAarRecord = new_ComStSt25sdkNdefAarRecord_initWithNSString_("com.st.st25nfc")
        
        // Create ST25SDK NDEF Exernal
        let externalString = "Example of record containing application data"
        let externalData = externalString.data(using: .utf8)
        
        let comStSt25sdkNdefExternal:ComStSt25sdkNdefExternalRecord = new_ComStSt25sdkNdefExternalRecord_init()
        comStSt25sdkNdefExternal.setExternalDomainWith("my_organization")
        comStSt25sdkNdefExternal.setExternalDomainWith("my_type_name")
        comStSt25sdkNdefExternal.setContentWith(IOSByteArray.init(nsData: externalData))
        
        ndefMsg.addRecord(with: comStSt25sdkNdefUriRecord)
        ndefMsg.addRecord(with: comStSt25sdkNdefAar)
        ndefMsg.addRecord(with: comStSt25sdkNdefExternal)
        
        let ndefManager:NDEFManager = NDEFManager.init()
        let coreNfcNdefMsg:NFCNDEFMessage = ndefManager.convertSt25NdefToiOSNdef(message: ndefMsg)
        self.miOSNdef.writeNdef(coreNfcNdefMsg)
        
    }

}

extension ST25AppLauncherViewController: ndefReaderSessionViewControllerDelegate {
    func handleNdef(tag: iOSNdef, status: NFCNDEFStatus, capacity: Int) throws {
        self.miOSNdef = tag
        writeNDEFs()
    }
    
    func handleNdefSessionError(didInvalidateWithError error: Error) {
    }
    
    func handleNdefST25SdkError(didInvalidateWithError error: NSException) {
        self.warningAlert(message: error.description)
    }
    
   

}
