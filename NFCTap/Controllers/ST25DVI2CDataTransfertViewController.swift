//
//  ST25DVI2CDataTransfertViewController.swift
//  NFCTap
//
//  Created by STMicroelectronics on 9/5/19.
//  Copyright © 2019 STMicroelectronics. All rights reserved.
//

import UIKit
import CoreNFC


class ST25DVI2CDataTransfertViewController: ST25UIViewController {

    // Reference the NFC session
    //private var tagSession: NFCTagReaderSession!
    private var writeBuffer: Bool!

    
    private var buffer:Data!
    
    
    internal var mTag : ComStSt25sdkNFCTag!
    internal var mST25DVConfigurationPwd:Data!

    var mTransferTask : ComStSt25nfcType5St25dvST25DVTransferTask?

    internal var miOSReaderSession:iOSReaderSession!

    enum taskToDo {
        case initMB
        case write
        case read
    }
    internal var mTaskToDo:taskToDo = .initMB

    var mBuffer : Data?

    
    @IBOutlet weak var readBufferTextView: UITextView!
    @IBOutlet weak var readWriteSwitch: UISwitch!
    @IBOutlet weak var bufferTextField: UITextField!
    
    @IBAction func handleReadWriteSwitch(_ sender: Any) {
       bufferTextField.isEnabled = self.readWriteSwitch.isOn
        if (self.readWriteSwitch.isOn){
            bufferTextField.alpha = 1
        }else{
            bufferTextField.alpha = 0.5
        }
       writeBuffer = self.readWriteSwitch.isOn
    }
    
   @IBAction func handleStart(_ sender: Any) {
        var status = true
        var errorMessage:String = ""
        
        self.readBufferTextView.text = ""
        if (self.readWriteSwitch.isOn) {
            if (bufferTextField.text!.isEmpty) {
                errorMessage = "Buffer is empty !!!"
                status = false
            }
            /* Convert ASCII Command into Decimal Value. Use ',' for separator */
            let bufferTextFieldArray : [String] = self.bufferTextField.text!.components(separatedBy: ",")
            let intArray:[UInt8] = bufferTextFieldArray.map{UInt8(Int($0)!)}
            mBuffer = Data(intArray)
            
            mTaskToDo = .write

        } else {
            mTaskToDo = .read
        }
        if ( status == false ) {
            self.alertWindow(aTitle : "ST25DV-I2C" , aMessage: errorMessage)
            return
        }

        miOSReaderSession.startTagReaderSession()
    }
    
    
    private func convertHexToAscii(_ hexString:String) -> String {
        var asciiString:String = ""
        let hexData:Data  = ComStSt25sdkHelper_convertHexStringToByteArrayWithNSString_(hexString).toNSData()
        var final = ""
        if (hexData.count != 0){
            for i in 0...hexData.count-1 {
                 final.append(Character(UnicodeScalar(Int(hexData[i]))!))
            }
        }
        asciiString = final
        return asciiString
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.bufferTextField.isEnabled = self.readWriteSwitch.isOn
        writeBuffer = self.readWriteSwitch.isOn
        self.readBufferTextView.text = ""
        
        
        
//        self.bufferTextField.text = "22aa024af6b1c6012402e00cd4000a021b23011b231b225a03"
//        self.bufferTextField.text = "22aa024af6b1c6012402e00ad40008021b220100515d03"
        
        self.miOSReaderSession = iOSReaderSession(atagReaderSessionViewControllerDelegate: self)
        mTaskToDo = .initMB
        miOSReaderSession.startTagReaderSession()


    }
    
    // Alert Error Windows
    func alertWindow(aTitle : String, aMessage : String){
        // Display content of Record into Alert Controller
        let alert = UIAlertController(title: aTitle,
                                      message: aMessage,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    


        
    // Session
    
    private func startTransfer() {
        if  mTaskToDo == .read {
            
            let mTransferAction = ComStSt25nfcType5St25dvST25DVTransferTask.FAST_RANDOM_TRANSFER_FUNCTION
            if mTag is ST25DVTag {
                mTransferTask = ComStSt25nfcType5St25dvST25DVTransferTask(int: mTransferAction, with: nil, with: mTag as! ST25DVTag)
                //mTransferTask?.setST25DVTagWith(mTag as! ST25DVTag)
            } else if mTag is ST25DVCTag {
                mTransferTask = ComStSt25nfcType5St25dvST25DVTransferTask(int: mTransferAction, with: nil, with: mTag as! ST25DVCTag)
                //mTransferTask?.setST25DVTagWith(mTag as! ST25DVCTag)
            }
            mTransferTask!.setTransferListenerWith(self);
            mTransferTask!.start()
            mTransferTask!.run()

        }
        if mTaskToDo == .write  {
            // Data
            if mBuffer != nil {
                let bufferIOSByteArray = IOSByteArray.init(nsData: NSData(data: mBuffer!) as Data)
                print ("Transfer size : \(String(describing: bufferIOSByteArray?.length()))")
                let mTransferAction = ComStSt25nfcType5St25dvST25DVTransferTask.FAST_BASIC_TRANSFER_FUNCTION
                
                if mTag is ST25DVTag {
                    mTransferTask = ComStSt25nfcType5St25dvST25DVTransferTask(int: mTransferAction, with: bufferIOSByteArray, with: mTag as! ST25DVTag)
                    //mTransferTask?.setST25DVTagWith(mTag as! ST25DVTag)
                } else if mTag is ST25DVCTag {
                    mTransferTask = ComStSt25nfcType5St25dvST25DVTransferTask(int: mTransferAction, with: bufferIOSByteArray, with: mTag as! ST25DVCTag)
                    //mTransferTask?.setST25DVTagWith(mTag as! ST25DVCTag)
                }

                mTransferTask!.setTransferListenerWith(self);
                mTransferTask!.start()
                mTransferTask!.run()
            } else {
                print("buffer is empty")
            }
        }
    }
    

    private func initMB() {
        //print("init MB")
        var isMBEnable = false
        if mTag is ST25DVTag {
            isMBEnable = (mTag as! ST25DVTag).isMailboxEnabled(withBoolean: false)
        } else if mTag is ST25DVCTag {
            isMBEnable = (mTag as! ST25DVCTag).isMailboxEnabled(withBoolean: false)
        }
        if !isMBEnable {
            UIHelper.UI {
                self.warningAlert(message: "MailBox is not enabled - Enable it first")

            }
        }

    }


    
    private func presentPwdController() {
        let mST25PasswordVC:ST25PasswordViewController = UIStoryboard(name: "ST25Password", bundle: nil).instantiateViewController(withIdentifier: "ST25PasswordID") as! ST25PasswordViewController
        mST25PasswordVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        mST25PasswordVC.setTitle("Enter configuration password")
        mST25PasswordVC.setMessage("(64 bits hexadecimal format)")
        mST25PasswordVC.numberOfBytes = 8
        mST25PasswordVC.delegate = self
        self.present(mST25PasswordVC, animated: false, completion: nil)
    }


    
    private func warningAlert(message : String) {
        UIHelper.warningAlert(viewController: self, title : "Data Transfer demo" , message: message)
    }
}


extension ST25DVI2CDataTransfertViewController: ST25PasswordViewDelegate {
    func okButtonTapped(pwdValue: Data) {
        self.mST25DVConfigurationPwd = pwdValue
        self.miOSReaderSession.startTagReaderSession()
    }

    func cancelButtonTapped() {
    }
}

extension ST25DVI2CDataTransfertViewController: tagReaderSessionViewControllerDelegate {

    
    func handleTag(st25SDKTag: ComStSt25sdkNFCTag, uid: Data!) throws {

        mTag = st25SDKTag

        if (!(mTag is ST25DVTag || mTag is ST25DVCTag)){
            UIHelper.UI() {
                self.warningAlert(message: "Tag do not support this feature ...")
            }
            return
        }
        if mTag is ST25DVTag {
            //mTransferTask?.setST25DVTagWith(mTag as! ST25DVTag)
        } else if mTag is ST25DVCTag {
            //mTransferTask?.setST25DVTagWith(mTag as! ST25DVCTag)
        }
        switch mTaskToDo {
        case .initMB:
            initMB()
        case .read:
            startTransfer()
        case .write:
            startTransfer()
        }
    }
    
    func handleTagSessionError(didInvalidateWithError error: Error) {
        //print(" ==== entry > handleTagSessionEnd in controller : \(self.mTaskToDo)")
        let errorNFC = error as! NFCReaderError
        if errorNFC.code ==  NFCReaderError.readerSessionInvalidationErrorSessionTimeout {
            // session Timeout detected
            // restart a session to continu
            mTransferTask?.stop()

         }
        else if errorNFC.code ==  NFCReaderError.readerSessionInvalidationErrorUserCanceled {
            mTransferTask?.stop()

        }
    }
    
    func handleTagST25SdkError(didInvalidateWithError error: NSException) {
        mTransferTask?.stop()

    }
}

extension ST25DVI2CDataTransfertViewController: ComStSt25nfcType5St25dvST25DVTransferTask_OnTransferListener {
    // MARKS
     // ComStSt25pcModelST25DVTransferTask_OnTransferListener
     func transferOnProgress(with progressStatus: jdouble) {
         print("transferOnProgress")
     }
     
     func transferFinished(withBoolean success: jboolean, withLong time: jlong, with buffer: IOSByteArray!) {
        if mTaskToDo == .read {
            DispatchQueue.main.sync {
                //print(self.buffer.toHexString().replacingOccurrences(of: " ", with: ""));
                var bufferData:NSData!
                bufferData = buffer?.toNSData() as NSData?
                
                if buffer != nil {
                    self.readBufferTextView.text =  bufferData.base64EncodedString()
                }
                
            }
        }
        if mTaskToDo == .write {
            print("finished Upload")
        }
        
     }
     
     func getDataToWrite() -> IOSByteArray! {
        return nil

     }
     // End ComStSt25pcModelST25DVTransferTask_OnTransferListener

}

