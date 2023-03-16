//
//  ST25DVFirmwareUpdateViewController.swift
//  NFCTap 
//
//  Created by STMICROELECTRONICS on 28/10/2019.
//  Copyright © 2019 STMicroelectronics. All rights reserved.
//

import UIKit
import MobileCoreServices
import CoreNFC


class ST25DVFirmwareUpdateViewController: ST25UIViewController , UIDocumentPickerDelegate {


    internal var mTag : ComStSt25sdkNFCTag!

    internal var miOSReaderSession:iOSReaderSession!
    internal var mST25DVConfigurationPwd:Data!
    
    internal var RESTART_SESSION_SCHEDULE_INTERVAL = 3.0
    
    
    var mEnableMB: Bool?
    var mBuffer : Data?
    //var mTransferTask : ComStSt25nfcType5St25dvST25DVTransferTask?
    var mTransferTask : ComStSt25sdkFtmprotocolFtmCommands!

    var mTimer: Timer!
    var mEntryStrPassword: String!
    
    var mCount = 0
    var mTimerChrono = Timer()

    enum taskToDo {
        case initMB
        case enableMB
        case disableMB
        case presentPassword
        case startTransfer
        case resume
        case stopTransfer
    }
    internal var mTaskToDo:taskToDo = .initMB
    
    var mOperationQueue = OperationQueue()

    private var mBoardName: UInt8 = 0
    private var mVersionMajor: UInt8 = 0
    private var mVersionMinor: UInt8 = 0
    private var mVersionPatch: UInt8 = 0
    private var mBoardInformationCollected : Bool = false
    
    private let BOARD_MB_1283 : UInt8 = 0
    private let BOARD_MB_1396 : UInt8 = 1

    
    private let MINIMUN_VERSION_MAJOR_NUMBER  : UInt8 = 2
    private let MINIMUN_VERSION_MINOR_NUMBER  : UInt8 = 1
    private let MINIMUN_VERSION_PATCH_NUMBER  : UInt8 = 0
    
    private let DEFAULT_FTM_TIMEOUT_IN_MS = 10000
    private let DEFAULT_FTM_TIMEOUT_BETWEEN_CMD_IN_MS = 0
    private let DEFAULT_FTM_TIMEOUT_AFTER_CMD_SENT_IN_MS = 1

    private let FILE_INFORMATION = "Please select a file first !"
    /// Creating UIDocumentInteractionController instance.
    let documentInteractionController = UIDocumentInteractionController()

    @IBOutlet weak var mSelectFileButton: UIButton!
    @IBOutlet weak var mStartbutton: UIButton!
    @IBOutlet weak var mStopButton: UIButton!
    
    
    @IBOutlet weak var mFileInformationLabel: UILabel!
    @IBOutlet weak var mMailBoxEnableSwitch: UISwitch!
    @IBOutlet weak var fwProgressBar: UIProgressView!
    

    @IBAction func enableMailBox(_ sender: Any) {
        if (self.mMailBoxEnableSwitch.isOn){
            mTaskToDo = .enableMB
        }else{
            mTaskToDo = .disableMB
        }
        //miOSReaderSession.startTagReaderSession()
        presentPwdController()
    }
    
    
    @IBAction func startFwTransfer(_ sender: Any) {
        if (self.mMailBoxEnableSwitch.isOn){
            startFWPresentPwdtransferSession()
        }else{
            print("TODO - Check files et MB enable")
        }
    }
    
    @IBAction func stopFwTransfer(_ sender: Any) {
        stopTaskTransfer()
        resetChrono()
        if mTimer != nil {
            mTimer.invalidate()
        }
    }
    
    @IBAction func selectFirmware(_ sender: Any) {

        let otherAlert = UIAlertController(title: "Firmware selection", message: "Which firmware do you want to use?", preferredStyle: UIAlertController.Style.actionSheet)
        let embeddedFW = UIAlertAction(title: "Embedded FW-MB1283", style: UIAlertAction.Style.default, handler: self.embeddedFWHandler)
        let embeddedFW2 = UIAlertAction(title: "Embedded FW-MB1396", style: UIAlertAction.Style.default, handler: self.embeddedFWHandler1396)
        let storageFW = UIAlertAction(title: "Storage FW", style: UIAlertAction.Style.default, handler: self.storageFWHandler)

        let dismiss = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)

        // relate actions to controllers
        otherAlert.addAction(embeddedFW)
        otherAlert.addAction(embeddedFW2)
        otherAlert.addAction(storageFW)
        otherAlert.addAction(dismiss)

        present(otherAlert, animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Firmware update"
        
        mFileInformationLabel.text = FILE_INFORMATION
        miOSReaderSession = iOSReaderSession(atagReaderSessionViewControllerDelegate: self)
        

        mTaskToDo = .initMB
        mEnableMB = false;
        miOSReaderSession.startTagReaderSession()
        
        fwProgressBar.transform = CGAffineTransform(scaleX: 1, y: 4)
        fwProgressBar.progress = 0
        fwProgressBar.layer.cornerRadius = 10
        fwProgressBar.clipsToBounds = true
        fwProgressBar.layer.sublayers![1].cornerRadius = 10
        fwProgressBar.subviews[1].clipsToBounds = true
        fwProgressBar.layer.borderColor = UIColor.lightGray.cgColor
        
        mFileInformationLabel.adjustsFontSizeToFitWidth = true
        
        enableButtonsForSelectFile()
        
        mOperationQueue.isSuspended = false
        
        self.mTransferTask = ComStSt25sdkFtmprotocolFtmCommands(comStSt25sdkType5St25dvST25DVTag: mTag as? ComStSt25sdkType5St25dvST25DVTag)
        self.mTransferTask.setMinTimeInMsWhenWaitingAckWithLong(5)
        self.mTransferTask.setMinTimeInMsBetweenSendCmdsWithLong(80)
         // customization of packets segments to avoid retransmitting too much packets when segment issue on session timeout
        self.mTransferTask.setSegmentLengthWith(20)
        // default value ajusted according to previous Timeout
        self.mTransferTask.setNbrOfRetriesInCaseOfErrorWith(50)

    }
    
    // MARKS Documents selection and Document Picker delegates functions
    //
    func embeddedFWHandler(alert: UIAlertAction){
        //print("You tapped: \(alert.title)")
        readEmbeddedFWFile(fw: 1)
    }
    
    func embeddedFWHandler1396(alert: UIAlertAction){
        //print("You tapped: \(alert.title)")
        readEmbeddedFWFile(fw: 2)
    }
    
    func storageFWHandler(alert: UIAlertAction){
        //print("You tapped: \(alert.title)")
        //warningAlert(message: "Not yet implemented !")
        
        //let types = [String(kUTTypePNG), String(kUTTypeJPEG), String(kUTTypePlainText)]
        //let types = [String("com.st.st25nfc.fw"), String("public.item")]
        let types = ["public.item", "public.folder", "public.directory"]

        let documentPickerViewController =
        UIDocumentPickerViewController(documentTypes: types,
                                       in: .import)

        documentPickerViewController.delegate = self
        documentPickerViewController.shouldShowFileExtensions = true
        documentPickerViewController.allowsMultipleSelection   = false
        documentPickerViewController.overrideUserInterfaceStyle = .dark

        // Set the initial directory.
        //self.navigationController?.pushViewController(documentPickerViewController, animated: true)
        self.present(documentPickerViewController, animated: true, completion: nil)
    }
    

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("Cancelled")
        controller.dismiss(animated: true, completion: nil)

    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        //print("didPickDocuments at \(urls)")
        if controller.documentPickerMode == UIDocumentPickerMode.import {
            do {
                mBuffer = try NSData(contentsOf: urls[0] as URL) as Data
                let byteArray = [UInt8](mBuffer!)
                let mBufferSize = byteArray.count
                let theFileName = (urls[0].absoluteString as NSString).lastPathComponent.description
                let fileSelected = "File selected :" + theFileName
                let informationMessage: String = fileSelected + "\n" + "File size : " + mBufferSize.description
                print (informationMessage)
                mFileInformationLabel.text = getBoardInfo() + "  " + informationMessage
                UIHelper.UI {
                    self.enableButtonsForStart()
                }
            }
            catch {
                print("Error...")
            }
        }

    }

    // MARKS UI Button Enable/disable

    private func enableButtonsForSelectFile() {
        mSelectFileButton.isEnabled = true
        mSelectFileButton.alpha = 1.0
        
        mStartbutton.isEnabled = false
        mStartbutton.alpha = 0.66
        
        mStopButton.isEnabled = false
        mStopButton.alpha = 0.66
    }
    
    private func enableButtonsForStart() {
        mSelectFileButton.isEnabled = true
        mSelectFileButton.alpha = 1.0
        
        mStartbutton.isEnabled = true
        mStartbutton.alpha = 1.0
        
        mStopButton.isEnabled = false
        mStopButton.alpha = 0.66
    }
    private func enableButtonsForStop() {
        mSelectFileButton.isEnabled = false
        mSelectFileButton.alpha = 0.66
        
        mStartbutton.isEnabled = false
        mStartbutton.alpha = 0.66
        
        mStopButton.isEnabled = true
        mStopButton.alpha = 1.0
    }
    
    // MARKS Functions related to TaskToDo
    private func initMB() {
        //print("init MB")
        
        if mTag is ST25DVTag {
            mEnableMB = (mTag as! ST25DVTag).isMailboxEnabled(withBoolean: false)
        } else if mTag is ST25DVCTag {
            mEnableMB = (mTag as! ST25DVCTag).isMailboxEnabled(withBoolean: false)
        }
        let mTransferAction = ComStSt25sdkFtmprotocolFtmCommands_FTM_CMD_GET_BOARD_INFO
        let response = self.mTransferTask?.sendCmdAndWaitForCompletion(withByte: jbyte(mTransferAction), with: nil, withBoolean: true, withBoolean: true, with: self, with: 1000, withByte: jbyte(ComStSt25sdkCommandIso15693Protocol_HIGH_DATA_RATE_MODE | ComStSt25sdkCommandIso15693Protocol_ADDRESSED_MODE))

        //print("\(response!.toNSData().toHexString())")
        parseBoardInfo(with: response)
        
        DispatchQueue.main.sync {
            mMailBoxEnableSwitch.setOn(mEnableMB!, animated: true)
            mFileInformationLabel.text = getBoardInfo() + "  " + FILE_INFORMATION

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


    
    private func startFWPresentPwdtransferSession() {
        print("startFWPresentPwdtransferSession")
        if mBuffer != nil {
            presentPasswordForFWTransferDemo()
        } else {
            print("Buffer is empty, no file selected")
            warningAlert(message: "Buffer is empty, no file selected !")
        }
        

    }
    
    private func startFWtransferSession() {
        print("startFWtransferSession")
        if mBuffer != nil {

            DispatchQueue.main.asyncAfter(deadline: .now() + RESTART_SESSION_SCHEDULE_INTERVAL,execute: { () -> Void in
                self.mTaskToDo = .startTransfer
                self.miOSReaderSession.startTagReaderSession()
            })
        } else {
            print("Buffer is empty, no file selected")
            warningAlert(message: "Buffer is empty, no file selected !")
        }
        
        
    }
    
    private func continutransferSession() {
        print("continutransferSession")
            DispatchQueue.main.asyncAfter(deadline: .now() + RESTART_SESSION_SCHEDULE_INTERVAL,execute: { () -> Void in
            self.mTaskToDo = .resume
            self.miOSReaderSession.startTagReaderSession()
        })
    }
    

    
    private func startTaskPresentPassword() {
        print("startTaskPresentPassword")
        
        if mBuffer != nil {
            DispatchQueue.main.sync {
                fwProgressBar.progress = 0
            }
            // PWD
            if mEntryStrPassword != nil {
                
                let operation0 = BlockOperation(block: { [self] in
                    let strPwd = mEntryStrPassword
                    let bufferIOSByteArray = ComStSt25sdkHelper.convertHexStringToByteArray(with:strPwd)
                    var mTransferAction = ComStSt25sdkFtmprotocolFtmCommands_FTM_CMD_SEND_PASSWORD
                    //let response = self.mTransferTask.sendCmdAndWaitForCompletion(withByte: jbyte(mTransferAction), with: bufferIOSByteArray, withBoolean: true, withBoolean: true, with: self, with: 2000, withByte: jbyte(ComStSt25sdkCommandIso15693Protocol_HIGH_DATA_RATE_MODE | ComStSt25sdkCommandIso15693Protocol_ADDRESSED_MODE))
                    //self.mTransferTask.setST25DVTagWith(self.mTag as? ComStSt25sdkType5St25dvST25DVTag)
                    self.mTransferTask.sendCmd(withByte: jbyte(mTransferAction), with: bufferIOSByteArray, withBoolean: true, withBoolean: true, with: self, with: self, with: 2000, withByte: jbyte(ComStSt25sdkCommandIso15693Protocol_HIGH_DATA_RATE_MODE | ComStSt25sdkCommandIso15693Protocol_ADDRESSED_MODE))


                })
                mOperationQueue.maxConcurrentOperationCount = 1
                mOperationQueue.addOperation(operation0)


            } else {
                DispatchQueue.main.sync {
                    self.warningAlert(message: "Empty password !")
                }
            }
        } else {
            print("Buffer is empty, no file selected")
            DispatchQueue.main.sync {
                self.warningAlert(message: "Buffer is empty, no file selected !")
            }
        }
    }

    // must be internal or public.
    @objc func update() {
        stopTaskTransfer()
    }

    private func startTaskTransfer() {
        print("startTaskTransfer MB")
        // Data
        if mBuffer != nil {
            if mTimer != nil {
                mTimer.invalidate()
            }
            mOperationQueue.cancelAllOperations()
            let operation0 = BlockOperation(block: { [self] in
                self.mTaskToDo = .startTransfer
                let bufferIOSByteArray = IOSByteArray.init(nsData: NSData(data: self.mBuffer!) as Data)
                
                let mTransferAction = ComStSt25sdkFtmprotocolFtmCommands_FTM_CMD_FW_UPGRADE
                //let response = self.mTransferTask?.sendCmdAndWaitForCompletion(withByte: jbyte(mTransferAction), with: bufferIOSByteArray, withBoolean: true, withBoolean: true, with: self, with: 40000, withByte: jbyte(ComStSt25sdkCommandIso15693Protocol_HIGH_DATA_RATE_MODE | ComStSt25sdkCommandIso15693Protocol_ADDRESSED_MODE))
                self.mTransferTask?.sendCmd(withByte: jbyte(mTransferAction), with: bufferIOSByteArray, withBoolean: true, withBoolean: true, with: self, with: self, with: jint(DEFAULT_FTM_TIMEOUT_IN_MS), withByte: jbyte(ComStSt25sdkCommandIso15693Protocol_HIGH_DATA_RATE_MODE | ComStSt25sdkCommandIso15693Protocol_ADDRESSED_MODE))

            })
            mOperationQueue.maxConcurrentOperationCount = 1
            mOperationQueue.addOperation(operation0)


        } else {
            print("Buffer is empty, no file selected !")
            DispatchQueue.main.sync {
                self.warningAlert(message: "Buffer is empty, no file selected !")
            }
        }
    }
    
    private func stopTaskTransfer() {
        print("stopTransfer MB")
        self.mTaskToDo = .stopTransfer
        if self.mTransferTask != nil {
            self.mTransferTask?.cancelCurrentTransfer()
        }
        if self.mTimer != nil {
            self.mTimer.invalidate()
        }
        enableButtonsForStart()
    }
    
    private func continuTaskTransfer() {
        print("continuTransfer MB")
        if self.mTransferTask != nil {
            self.mTransferTask.setTagWith(mTag as! ComStSt25sdkType5St25dvST25DVTag)
            self.mOperationQueue.isSuspended = false
            self.mTransferTask.resumeCurrentTransfer()

        }
    }
    

    
    private func continuTransferSession() {
        print("continutransferSession")
            DispatchQueue.main.asyncAfter(deadline: .now() + RESTART_SESSION_SCHEDULE_INTERVAL,execute: { () -> Void in
            self.mTaskToDo = .resume
            self.miOSReaderSession.startTagReaderSession()
        })
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
    
    private func presentPasswordForFWTransferDemo() {
        var inputTextField: UITextField?;

        let passwordPrompt = UIAlertController(title: "Enter Password", message: "Please enter firmware update password", preferredStyle: UIAlertController.Style.alert);

        passwordPrompt.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) -> Void in
            // Now do whatever you want with inputTextField (remember to unwrap the optional)

            self.mEntryStrPassword = (inputTextField?.text)!
            
            self.initChrono()

            DispatchQueue.main.async {
                self.mTaskToDo = .presentPassword
                self.miOSReaderSession.startTagReaderSession()
            }

        }));


        passwordPrompt.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { (action) -> Void in
            print("done");
        }));

        passwordPrompt.addTextField(configurationHandler: {(textField:  UITextField!) in
            //textField.placeholder = "12345678"
            textField.text = "12345678"
            inputTextField = textField
        });
        self.present(passwordPrompt, animated: true, completion: nil);
        return;
    }
    
    
    @objc func counter() {
        mCount += 1
    }

    private func initChrono() {
        resetChrono()
        self.mTimerChrono = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.counter), userInfo: nil, repeats: true)
    }
    
    private func resetChrono() {
        if mTimerChrono != nil {
            mTimerChrono.invalidate()
        }
        mCount = 0
        //counterLabel.text = "00"
    }
    
    private func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = time - Double(minutes) * 60
        let secondsFraction = seconds - Double(Int(seconds))
        return String(format:"%02i:%02i.%01i",minutes,Int(seconds),Int(secondsFraction * 10.0))
    }
    
    
    private func readEmbeddedFWFile (fw: Int) {
        var firmwareFiles = [String]()
        let fm = FileManager.default
        let path = Bundle.main.resourcePath
        let items = try! fm.contentsOfDirectory(atPath: path!)
        firmwareFiles = items.filter{$0.hasSuffix("bin")}
        //print(firmwareFiles)
        
        // ST25DVDemo_FwUpgrd.bin
        //let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] _MB1396
        
        // Default - The last uptodate
        var fileName = "ST25DVDemo_FwUpgrd_MB1396.bin"
        // selection according to Board
        if fw == 1 {
            // Original one for board MB1283
            fileName = "ST25DVDemo_FwUpgrd_MB1283.bin"

        }
        if fw == 2 {
            fileName = "ST25DVDemo_FwUpgrd_MB1396.bin"

        }
                
        //fm.contents(atPath: path! + "ST25DVDemo_FwUpgrd.bin")
        // Following checks will be used later on
//        if fm.fileExists(atPath: fwFilepath) {
//            print("ST25DVDemo_FwUpgrd.bin : File exists")
//        } else {
//            print("File not found")
//        }
//
//        if fm.isReadableFile(atPath: fwFilepath) {
//            print("File is readable")
//        } else {
//            print("File is not readable")
//        }
        
        mBuffer = fm.contents(atPath: path! + "/" + fileName)
        if mBuffer == nil {
            UIHelper.UI { [self] in
                warningAlert(message: "File not found ..")
            }
            return
        }
        let byteArray = [UInt8](mBuffer!)
        let mBufferSize = byteArray.count
        
        let informationMessage: String = "File selected :" + fileName + "\n" +
            "File size : " + mBufferSize.description
        //print (informationMessage)
        mFileInformationLabel.text = getBoardInfo() + "  " + informationMessage
        enableButtonsForStart()
    }
    
    private func warningAlert(message : String) {
        UIHelper.warningAlert(viewController: self, title : "Firmware update" , message: message)
    }
    
    private func transfertOnGoingAlert() {
        let alert = UIAlertController(title: "Firmware update", message: "Please Wait...Transfer still on going..", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5){
            alert.dismiss(animated: false, completion: nil)
        }
    }
    
    
    private func checkAndExecuteNextToPresentPassword(transferStatus: ComStSt25sdkFtmprotocolFtmProtocol_TransferStatus) {
        if transferStatus ==  ComStSt25sdkFtmprotocolFtmProtocol_TransferStatus.TRANSFER_OK {
            //print("password ok")
            //self.mTransferTask.cancelCurrentTransfer()
            DispatchQueue.main.async {
                self.enableButtonsForStop()
            }
            startTaskTransfer()
        } else {
            //print("wrong password")
            DispatchQueue.main.sync {
                warningAlert(message: "Wrong password : \(mEntryStrPassword)")
            }
            self.miOSReaderSession.stopTagReaderSession()
            self.mOperationQueue.cancelAllOperations()
            self.mTransferTask.cancelCurrentTransfer()

        }

    }
    private func checkAndExecuteNextToFwTransfers(transferStatus: ComStSt25sdkFtmprotocolFtmProtocol_TransferStatus) {
        if transferStatus ==  ComStSt25sdkFtmprotocolFtmProtocol_TransferStatus.TRANSFER_OK {
            //print("Transfer ok")
            self.mTaskToDo = .stopTransfer
            self.miOSReaderSession.stopTagReaderSession()
            self.mTransferTask.cancelCurrentTransfer()
            self.mOperationQueue.cancelAllOperations()
            DispatchQueue.main.sync {
                warningAlert(message: "Transfer successful : \(timeString(time: TimeInterval(mCount)))")
            }

        } else {
            self.mTaskToDo = .stopTransfer
            self.miOSReaderSession.stopTagReaderSession()
            self.mTransferTask.cancelCurrentTransfer()
            self.mOperationQueue.cancelAllOperations()

            //print("Transfer failed")
            DispatchQueue.main.sync {
                warningAlert(message: "Transfer failed or cancelled : \(timeString(time: TimeInterval(mCount)))")
            }
        }
        DispatchQueue.main.async {
            self.enableButtonsForStart()
        }
        resetChrono()

    }
    
    
    private func parseBoardInfo(with data: IOSByteArray!) {
        let dataToNSData = data.toNSData()!

        if dataToNSData.count <= 2 {
            // board info not transmitted
            mBoardInformationCollected = false
            return
        }
        if dataToNSData.count == 4 {
            // board info transmitted
            mBoardInformationCollected = true
            mBoardName = dataToNSData[0]
            mVersionMajor = dataToNSData[1]
            mVersionMinor = dataToNSData[2]
            mVersionPatch = dataToNSData[3]
            return
        }
        
    }
    private func getBoardInfo() -> String {
        if mBoardInformationCollected == true {
            var boardName = "MB_xxxx"
            if (mBoardName == BOARD_MB_1283) {
                boardName = "MB_1283"
            }
            if (mBoardName == BOARD_MB_1396) {
                boardName = "MB_1396"
            }
           return ("Identified Board : \(boardName) FW ver. \(mVersionMajor).\(mVersionMinor).\(mVersionPatch).")
        } else {
            return ("Mother Board not detected.")
        }
    }
 
}


extension ST25DVFirmwareUpdateViewController: ST25PasswordViewDelegate {
    func okButtonTapped(pwdValue: Data) {
        self.mST25DVConfigurationPwd = pwdValue
        self.miOSReaderSession.startTagReaderSession()
    }

    func cancelButtonTapped() {
    }
}

extension ST25DVFirmwareUpdateViewController: ComStSt25sdkFtmprotocolFtmProtocol_TransferProgressionListener {
    func transmissionProgress(with transmittedBytes: jint, with acknowledgedBytes: jint, with totalSize: jint) {
        if (mTaskToDo == .startTransfer || mTaskToDo == .resume) {
            //print("....................... \(transmittedBytes)")
            //print("....................... \(acknowledgedBytes)")
            //print("....................... \(totalSize)")

            DispatchQueue.main.sync {
                let progress = Float(Float(transmittedBytes)/Float(totalSize))
                 self.fwProgressBar.setProgress(progress,animated:false)
                self.miOSReaderSession.updateTagReaderSessionMessage(message: "Transmitted bytes: \(transmittedBytes), Ackknowledged bytes: \(acknowledgedBytes), Total bytes: \(totalSize)")
             }
         }
    }
    
    func receptionProgress(with receivedBytes: jint, with acknowledgedBytes: jint, with totalSize: jint) {
        // NA
    }
    
}

extension ST25DVFirmwareUpdateViewController: ComStSt25sdkFtmprotocolFtmProtocol_TransferCompletionListener {
    func transferDone(with transferStatus: ComStSt25sdkFtmprotocolFtmProtocol_TransferStatus!, with response: IOSByteArray!) {

                if mTaskToDo == .presentPassword {
                    checkAndExecuteNextToPresentPassword(transferStatus: transferStatus)
                } else if (mTaskToDo == .startTransfer || mTaskToDo == .resume ) {
        
                    checkAndExecuteNextToFwTransfers(transferStatus: transferStatus)
                    
                }
    }
   

}

extension ST25DVFirmwareUpdateViewController: tagReaderSessionViewControllerDelegateWithFinallyBlock {
    func handleFinallyBlock() {
        //print("==> handleFinallyBlock to be implemented")
        //self.miOSReaderSession.stopTagReaderSession()
        if (mTaskToDo == .startTransfer || mTaskToDo == .resume || mTaskToDo == .presentPassword) {
            // Nothing to do, others cases, stop the session
        } else {
            self.miOSReaderSession.stopTagReaderSession()
            if (mTaskToDo == .initMB) {
                UIHelper.UI { [self] in
                    mFileInformationLabel.text = getBoardInfo() + "  " + FILE_INFORMATION
                }
            }
        }
    }
    

    func handleTagSessionError(didInvalidateWithError error: Error) {
        //print(error.localizedDescription)
        //print(" ==== handleTagSessionError > : \(error.self.localizedDescription)")
        //print(" ==== entry > handleTagSessionEnd in controller : \(self.mTaskToDo)")
        let errorNFC = error as! NFCReaderError
        if errorNFC.code ==  NFCReaderError.readerTransceiveErrorTagConnectionLost {
            print("........ Connection lost .......")
            print(error.localizedDescription)

        }

        if errorNFC.code ==  NFCReaderError.readerSessionInvalidationErrorSessionTimeout {
            // session Timeout detected
            // restart a session to continu
            if (mTaskToDo == .startTransfer || mTaskToDo == .resume ) {
                self.mTransferTask?.pauseCurrentTransfer()
                self.mOperationQueue.isSuspended = true

                self.miOSReaderSession = iOSReaderSession(atagReaderSessionViewControllerDelegate: self)
                self.continuTransferSession()
            }
            
            DispatchQueue.main.sync {
                self.transfertOnGoingAlert()
            }
            
        } else if errorNFC.code ==  NFCReaderError.readerSessionInvalidationErrorUserCanceled {
            if (self.mTaskToDo == .startTransfer || self.mTaskToDo == .resume ) {
                self.mTransferTask?.cancelCurrentTransfer()
                DispatchQueue.main.sync {
                    self.enableButtonsForStart()
                }
            }
        }
    }
    
    func handleTagST25SdkError(didInvalidateWithError error: NSException) {
        if self.mTaskToDo == taskToDo.enableMB || self.mTaskToDo == taskToDo.disableMB {
            print(error.description)
            DispatchQueue.main.async {
                self.mMailBoxEnableSwitch.setOn(self.mEnableMB!, animated: true)
                self.warningAlert(message: "Command failed: \(error.description)")
            }

        }
        //print(error.description)

        
    }
 
    func handleTag(st25SDKTag: ComStSt25sdkNFCTag, uid: Data!) throws {

        self.mTag = st25SDKTag

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
        case .presentPassword:
            startTaskPresentPassword()
        case .startTransfer:
            startTaskTransfer()
        case .resume:
            continuTaskTransfer()
        case .stopTransfer:
            stopTaskTransfer()
        }
        
    }
}
