//
//  ST25TVSignatureViewController.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 11/4/19.
//  Copyright © 2019 STMicroelectronics. All rights reserved.
//

import UIKit
import CoreNFC

class ST25TVSignatureViewController: ST25UIViewController {

    internal var mTag:ComStSt25sdkNFCTag!
    internal var mUid:Data!
    internal var miOSReaderSession:iOSReaderSession!
    
    enum taskToDo {
         case checkSignature
     }
    internal var mTaskToDo:taskToDo = .checkSignature

    @IBAction func handleCheckSignature(_ sender: Any) {
        mTaskToDo = .checkSignature
        miOSReaderSession.startTagReaderSession()
    }
    
    @IBOutlet weak var statusSignatureTextField: UITextField!
    @IBOutlet weak var signatureTextView: UITextView!
    @IBOutlet weak var keyIDTextField: UITextField!
    @IBOutlet weak var tagUidTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        mTaskToDo = .checkSignature
        miOSReaderSession = iOSReaderSession(atagReaderSessionViewControllerDelegate: self)
        miOSReaderSession.startTagReaderSession()
    }
    
    private func updateDisplay(uidString:String, keyIdString:String, signatureString:String, result:Bool) {
        DispatchQueue.main.sync {
            tagUidTextField.text = uidString
            keyIDTextField.text = "0x"+keyIdString
            signatureTextView.text = signatureString
            if (result){
                statusSignatureTextField.text = "Signature OK"
                statusSignatureTextField.backgroundColor = UIColor.stLightGreenColor()
            }else{
                statusSignatureTextField.text = "Error while checking signature !"
                statusSignatureTextField.backgroundColor = UIColor.stLightRedColor()
            }
        }
    }
    
    private func checkSignature() throws {
        let KeyId:jbyte!
        let SignatureIOSByteArray:IOSByteArray!
        let signatureCheck:Bool!
        
        if mTag is ST25TVTag {
             KeyId =  (mTag as! ST25TVTag).getKeyIdNDA()
             SignatureIOSByteArray =  (mTag as! ST25TVTag).readSignatureNDA()
             signatureCheck = try  (mTag as! ST25TVTag).isSignatureOk()
        } else if mTag is ST25TVCTag {
            KeyId =  (mTag as! ST25TVCTag).getKeyIdNDA()
            SignatureIOSByteArray =  (mTag as! ST25TVCTag).readSignatureNDA()
            signatureCheck = try  (mTag as! ST25TVCTag).isSignatureOk()
        } else if mTag is ST25DVPwmTag {
             KeyId =  (mTag as! ST25DVPwmTag).getKeyIdNDA()
             SignatureIOSByteArray =  (mTag as! ST25DVPwmTag).readSignatureNDA()
             signatureCheck = try  (mTag as! ST25DVPwmTag).isSignatureOk()
        }else if mTag is ST25TNTag{
             KeyId =  (mTag as! ST25TNTag).getKeyIdNDA()
             SignatureIOSByteArray =  (mTag as! ST25TNTag).readSignatureNDA()
            signatureCheck = try  (mTag as! ST25TNTag).isSignatureOk()
        }else if mTag is ComStSt25sdkType4aType4aTag {
            let type4Tag:ST25TA02KBTag = ST25TA02KBTag.init(comStSt25sdkRFReaderInterface: miOSReaderSession.mComStSt25sdkRFReaderInterface, with: IOSByteArray.init(nsData: mUid))
             KeyId =  type4Tag.getKeyIdNDA()
             SignatureIOSByteArray =  type4Tag.readSignatureNDA()
             signatureCheck = try  type4Tag.isSignatureOk()
        }else{
            warningAlert(message: "Tag not supported")
            return
        }
            updateDisplay(uidString: self.mUid.toHexString(),
                          keyIdString: ComStSt25sdkHelper_convertByteToHexStringWithByte_(KeyId),
                          signatureString: ComStSt25sdkHelper_convertByteArrayToHexStringWithByteArray_(SignatureIOSByteArray),
                          result: signatureCheck)
   }
    
    private func warningAlert(message : String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "ST25 Signature", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

}

extension ST25TVSignatureViewController: tagReaderSessionViewControllerDelegate {
    
    func handleTag(st25SDKTag: ComStSt25sdkNFCTag, uid: Data!) throws {
        self.mTag = st25SDKTag
        self.mUid = uid
        if self.isSameTag(uid: uid) {
            switch mTaskToDo {
            case .checkSignature:
                try checkSignature()
            }
        } else {

            UIHelper.UI() {
                self.warningAlert(message: "Tag has changed, please scan again the Tag ...")
            }
        }
        
    }
    
    func handleTagSessionError(didInvalidateWithError error: Error) {
        let errorNFC = error as! NFCReaderError
        if errorNFC.code ==  NFCReaderError.readerSessionInvalidationErrorSessionTimeout {
        }
        else if errorNFC.code ==  NFCReaderError.readerSessionInvalidationErrorUserCanceled {
        }
    }
    
    func handleTagST25SdkError(didInvalidateWithError error: NSException) {
        UIHelper.UI() {
            self.warningAlert(message: "Command failed: \(error.description)")
        }
    }
    

}
