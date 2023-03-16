//
//  ST25DVPictureTransferViewController.swift
//  NFCTap
//
//  Created by STMICROELECTRONICS on 06/11/2019.
//  Copyright © 2019 STMicroelectronics. All rights reserved.
//

import UIKit
import CoreNFC

class ST25DVPictureTransferViewController: ST25UIViewController   {

    internal var mTag:ComStSt25sdkNFCTag!
    //internal var mST25DVCTag:ST25DVCTag!
    internal var miOSReaderSession:iOSReaderSession!
    internal var mST25DVConfigurationPwd:Data!

    var mEnableMB: Bool?
    var mBuffer : Data?
    var mTransferTask : ComStSt25sdkFtmprotocolFtmCommands!
    private let DEFAULT_FTM_TIMEOUT_IN_MS = 10000
    private let DEFAULT_FTM_TIMEOUT_BETWEEN_CMD_IN_MS = 0
    private let DEFAULT_FTM_TIMEOUT_AFTER_CMD_SENT_IN_MS = 1
    
    
    var mUploadEnable = false
    var mDownloadEnable = false
    
    
    enum taskToDo {
        case initMB
        case enableMB
        case disableMB
        case resume
        case startTransfer
        case stopTransfer
    }
    internal var mTaskToDo:taskToDo = .initMB
    
    let mQueueForTasksTansfer = DispatchQueue(label: "Image transfer")
    var mOperationQueue = OperationQueue()


    @IBOutlet weak var mMailBoxEnableSwitch: UISwitch!
    
    @IBOutlet weak var mUploadEnableSwitch: UISwitch!
    @IBOutlet weak var mDownloadEnableSwitch: UISwitch!

    @IBOutlet weak var mUploadImageView: UIImageView!
    @IBOutlet weak var mDownloadImageView: UIImageView!
    
    
    @IBAction func mDownloadSwitchAction(_ sender: Any) {
        if mDownloadEnableSwitch.isOn {
            mUploadEnableSwitch.setOn(false, animated: true)
            mUploadEnable = false
            mDownloadEnable = true
            
        } else {
            mDownloadEnable = false
        }
    }
    
    
    @IBAction func mUploadSwitchAction(_ sender: Any) {
        if mUploadEnableSwitch.isOn {
            mDownloadEnableSwitch.setOn(false, animated: true)
            mDownloadEnable = false
            mUploadEnable = true
            //mBuffer = mUploadImageView.image?.pngData()
            mBuffer = mUploadImageView.image?.jpegData(compressionQuality: 0.5)
            //print("Image size : \(mBuffer?.count)")
        } else {
            mUploadEnable = false

        }

    }
    @IBAction func startTransfer(_ sender: Any) {
        self.mTaskToDo = .startTransfer
        self.miOSReaderSession.startTagReaderSession()

    }
        
    
    @IBAction func enableMailBox(_ sender: Any) {
        if (self.mMailBoxEnableSwitch.isOn){
            mTaskToDo = .enableMB
        }else{
            mTaskToDo = .disableMB
        }
        presentPwdController()
        //miOSReaderSession.startTagReaderSession()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Picture transfer"

        self.miOSReaderSession = iOSReaderSession(atagReaderSessionViewControllerDelegate: self)
        mTaskToDo = .initMB
        mEnableMB = false;
        miOSReaderSession.startTagReaderSession()

        mDownloadEnableSwitch.setOn(false, animated: true)
        mUploadEnableSwitch.setOn(false, animated: true)
        mDownloadEnable = false
        mUploadEnable = false
        // Do any additional setup after loading the view.
        self.mTransferTask = ComStSt25sdkFtmprotocolFtmCommands(comStSt25sdkType5St25dvST25DVTag: mTag as? ComStSt25sdkType5St25dvST25DVTag)
        self.mTransferTask.setMinTimeInMsWhenWaitingAckWithLong(5)
         // customization of packets segments to avoid retransmitting too much packets when segment issue on session timeout
        self.mTransferTask.setSegmentLengthWith(20)
        // default value ajusted according to previous Timeout
        self.mTransferTask.setNbrOfRetriesInCaseOfErrorWith(50)


        mOperationQueue.isSuspended = false

    }
    

    private func initMB() {
        //print("init MB")
        
        if mTag is ST25DVTag {
            mEnableMB = (mTag as! ST25DVTag).isMailboxEnabled(withBoolean: false)
        } else if mTag is ST25DVCTag {
            mEnableMB = (mTag as! ST25DVCTag).isMailboxEnabled(withBoolean: false)
        }
        DispatchQueue.main.sync {
            mMailBoxEnableSwitch.setOn(mEnableMB!, animated: true)
        }
    }
    
    private func enableMB() {
        if mTag is ST25DVTag {
            enableMB(tag: mTag as! ST25DVTag)
        } else if mTag is ST25DVCTag {
            enableMB(tag: mTag as! ST25DVCTag)
        }
    }
    
    private func enableMB(tag : ST25DVTag) {
        //print("enableMB MB")
        //let pwd:Data = Data([0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00])
        //print("PWD = " + self.mST25DVConfigurationPwd.toHexString())
        tag.presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25dvST25DVTag_ST25DV_CONFIGURATION_PASSWORD_ID), password: self.mST25DVConfigurationPwd)
        tag.enableMailbox()
        mEnableMB = true
    }
    private func enableMB(tag : ST25DVCTag) {
        //print("enableMB MB")
        //let pwd:Data = Data([0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00])
        //print("PWD = " + self.mST25DVConfigurationPwd.toHexString())
        tag.presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25dvST25DVTag_ST25DV_CONFIGURATION_PASSWORD_ID), password: self.mST25DVConfigurationPwd)
        tag.enableMailbox()
        mEnableMB = true
    }
    
    private func disableMB() {
        if mTag is ST25DVTag {
            disableMB(tag: mTag as! ST25DVTag)
        } else if mTag is ST25DVCTag {
            disableMB(tag: mTag as! ST25DVCTag)
        }
    }
    private func disableMB(tag : ST25DVTag) {
        //print("disable MB")
        //print("PWD = " + self.mST25DVConfigurationPwd.toHexString())
        //let pwd:Data = Data([0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00])
        tag.presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25dvST25DVTag_ST25DV_CONFIGURATION_PASSWORD_ID), password: self.mST25DVConfigurationPwd)
        tag.disableMailbox()
        mEnableMB = false
    }

    private func disableMB(tag : ST25DVCTag) {
        //print("disable MB")
        //print("PWD = " + self.mST25DVConfigurationPwd.toHexString())
        //let pwd:Data = Data([0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00])
        tag.presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25dvST25DVTag_ST25DV_CONFIGURATION_PASSWORD_ID), password: self.mST25DVConfigurationPwd)
        tag.disableMailbox()
        mEnableMB = false
    }

    
    private func startTransfer() {
        if  mDownloadEnable {
            
            let operation0 = BlockOperation(block: { [self] in
                //self.mTransferTask = ComStSt25sdkFtmprotocolFtmCommands(comStSt25sdkType5St25dvST25DVTag: mTag as? ComStSt25sdkType5St25dvST25DVTag)
                let mTransferAction = ComStSt25sdkFtmprotocolFtmCommands_FTM_CMD_READ_PICTURE
     
                self.mTransferTask.setMinTimeInMsBetweenReceiveCmdsWithLong(80)

                self.mTransferTask!.sendCmd(withByte: jbyte(mTransferAction), with: nil, withBoolean: true, withBoolean: true, with: self, with: self, with: jint(DEFAULT_FTM_TIMEOUT_IN_MS), withByte: jbyte(ComStSt25sdkCommandIso15693Protocol_HIGH_DATA_RATE_MODE | ComStSt25sdkCommandIso15693Protocol_ADDRESSED_MODE))

            })
            mOperationQueue.maxConcurrentOperationCount = 1
            mOperationQueue.addOperation(operation0)

        }
        if mUploadEnable  {
            // Data
            if mBuffer != nil {
                
                let operation0 = BlockOperation(block: { [self] in
                    let bufferIOSByteArray = IOSByteArray.init(nsData: NSData(data: mBuffer!) as Data)
                    print ("Transfer size : \(String(describing: bufferIOSByteArray?.length()))")
                    let mTransferAction = ComStSt25sdkFtmprotocolFtmCommands_FTM_CMD_SEND_PICTURE
                    self.mTransferTask.setMinTimeInMsBetweenSendCmdsWithLong(80)

                    self.mTransferTask!.sendCmd(withByte: jbyte(mTransferAction), with: bufferIOSByteArray, withBoolean: true, withBoolean: true, with: self, with: self, with: 20000, withByte: jbyte(ComStSt25sdkCommandIso15693Protocol_HIGH_DATA_RATE_MODE | ComStSt25sdkCommandIso15693Protocol_ADDRESSED_MODE))
     

                })
                mOperationQueue.maxConcurrentOperationCount = 1
                mOperationQueue.addOperation(operation0)

                
                
            } else {
                print("buffer is empty")
            }
        }
    }
    

    
    private func stopTransfer() {
        print("stopTransfer MB")
        self.mOperationQueue.cancelAllOperations()

        if mTransferTask != nil {
            mTransferTask?.cancelCurrentTransfer()
        }
    }

    private func continuTaskTransfer() {
        print("continuTransfer MB")
        if mTransferTask != nil {
            mTransferTask?.resumeCurrentTransfer()

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

    private func continutransferSession() {
        print("continutransferSession")
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0,execute: { () -> Void in
            self.mTaskToDo = .resume
            self.miOSReaderSession.startTagReaderSession()
        })
    }
    
    private func warningAlert(message : String) {
        UIHelper.warningAlert(viewController: self, title : "Picture update" , message: message)
    }
    
    private func transfertOnGoingAlert() {
        let alert = UIAlertController(title: "Picture update", message: "Please Wait...Transfer still on going..", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5){
            alert.dismiss(animated: false, completion: nil)
        }
    }
    

    
    private func resizeImageWithAspect(image: UIImage,ratio :CGFloat)->UIImage? {
        let oldWidth = image.size.width;
        let oldHeight = image.size.height;

        let newHeight = (( oldHeight - 10) * ratio / 100 + 10 )
        let newWidth = (( oldWidth - 10) * ratio / 100 + 10 )
        
        print(newHeight)
        print(newWidth)
        
        let newSize = CGSize(width: newWidth, height: newHeight)

        UIGraphicsBeginImageContextWithOptions(newSize,false,UIScreen.main.scale);

        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height));
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage
    }
    
}


extension ST25DVPictureTransferViewController: ST25PasswordViewDelegate {
    func okButtonTapped(pwdValue: Data) {
        self.mST25DVConfigurationPwd = pwdValue
        self.miOSReaderSession.startTagReaderSession()
    }

    func cancelButtonTapped() {
    }
}

extension ST25DVPictureTransferViewController: tagReaderSessionViewControllerDelegateWithFinallyBlock {
    func handleFinallyBlock() {
        if (mTaskToDo == .startTransfer || mTaskToDo == .resume) {
            // Nothing to do, others cases, stop the session
        } else {
            self.miOSReaderSession.stopTagReaderSession()
        }

    }
    

    func handleTagSessionError(didInvalidateWithError error: Error) {
        //print(" ==== entry > handleTagSessionEnd in controller : \(self.mTaskToDo)")
        let errorNFC = error as! NFCReaderError
        if errorNFC.code ==  NFCReaderError.readerSessionInvalidationErrorSessionTimeout {
            // session Timeout detected
            // restart a session to continu
            mTransferTask?.pauseCurrentTransfer()
            mOperationQueue.isSuspended = true

            DispatchQueue.main.sync {
                transfertOnGoingAlert()
            }
            self.miOSReaderSession = iOSReaderSession(atagReaderSessionViewControllerDelegate: self)
            continutransferSession()
        } else if errorNFC.code ==  NFCReaderError.readerSessionInvalidationErrorUserCanceled {
            if (mTaskToDo == .startTransfer || mTaskToDo == .resume ) {
                mTransferTask?.cancelCurrentTransfer()
            }
        }
    }

    func handleTagST25SdkError(didInvalidateWithError error: NSException) {
        
        if mTaskToDo == taskToDo.enableMB || mTaskToDo == taskToDo.disableMB {
            print(error.description)
            DispatchQueue.main.async {
                self.mMailBoxEnableSwitch.setOn(self.mEnableMB!, animated: true)
                self.warningAlert(message: "Command failed: \(error.description)")
            }

        }
        
    }

    
    // Delegates iOSReaderSession
    func handleTag(st25SDKTag: ComStSt25sdkNFCTag, uid: Data!) throws {
        mTag = st25SDKTag

        if (!(mTag is ST25DVTag || mTag is ST25DVCTag)){
            UIHelper.UI() {
                self.warningAlert(message: "Tag do not support this feature ...")
            }
            return
        }
        self.mTransferTask?.setTagWith(self.mTag as? ComStSt25sdkType5St25dvST25DVTag)

        switch mTaskToDo {
        case .initMB:
            initMB()
        case .enableMB:
            enableMB()
        case .disableMB:
            disableMB()
        case .startTransfer:
            startTransfer()
        case .stopTransfer:
            stopTransfer()
        case .resume:
            continuTaskTransfer()
        }
    }

}


extension ST25DVPictureTransferViewController: ComStSt25sdkFtmprotocolFtmProtocol_TransferCompletionListener {
    func transferDone(with transferStatus: ComStSt25sdkFtmprotocolFtmProtocol_TransferStatus!, with response: IOSByteArray!) {

        if  mDownloadEnable {
            if (transferStatus == .TRANSFER_OK) {
                self.miOSReaderSession.stopTagReaderSession()
                //print(self.buffer.toHexString().replacingOccurrences(of: " ", with: ""));
                if response != nil {

                    //print("\(response.toNSData().toHexString())")
                    
                    let dataToNSData = response.toNSData()!
                    let data  = dataToNSData[2...dataToNSData.count-1]

                    UIHelper.UI {
                        let picture = UIImage(data: data)
                        if picture != nil {
                            self.mDownloadImageView.image =  self.resizeImageWithAspect(image: picture!, ratio: 100)
                        } else {
                            self.warningAlert(message: "Download completed, image data issue .....")
                        }
                        
                    }
                }
                
            } else {
                
                UIHelper.UI() {
                    self.warningAlert(message: "Download failed .....")
                }
            }
            
        }
        if mUploadEnable  {
            if (transferStatus == .TRANSFER_OK) {
                UIHelper.UI() {
                    self.miOSReaderSession.stopTagReaderSession()

                    self.warningAlert(message: "Upload completed .....")
                }            }else {
                    UIHelper.UI() {
                        self.warningAlert(message: "Upload failed .....")
                    }
                }
        }
    }
}


extension ST25DVPictureTransferViewController: ComStSt25sdkFtmprotocolFtmProtocol_TransferProgressionListener {
    func transmissionProgress(with transmittedBytes: jint, with acknowledgedBytes: jint, with totalSize: jint) {
        //print("Transfer in progress")
        //print(progressStatus)
        if (mTaskToDo == .startTransfer || mTaskToDo == .resume) {
            //print("....................... \(transmittedBytes)")
            //print("....................... \(acknowledgedBytes)")
            //print("....................... \(totalSize)")

            DispatchQueue.main.sync {
                 self.miOSReaderSession.updateTagReaderSessionMessage(message: "Transmitted bytes: \(transmittedBytes), Ackknowledged bytes: \(acknowledgedBytes), Total bytes: \(totalSize)")
             }
         }

    }
    
    func receptionProgress(with receivedBytes: jint, with acknowledgedBytes: jint, with totalSize: jint) {
        //print("Transfer in progress")
        //print(progressStatus)
        if (mTaskToDo == .startTransfer || mTaskToDo == .resume) {
            //print("....................... \(transmittedBytes)")
            //print("....................... \(acknowledgedBytes)")
            //print("....................... \(totalSize)")

            DispatchQueue.main.sync {
                 self.miOSReaderSession.updateTagReaderSessionMessage(message: "Transmitted bytes: \(receivedBytes), Ackknowledged bytes: \(acknowledgedBytes), Total bytes: \(totalSize)")
             }
         }
    }
    
}
