//
//  testCoreNfcViewController.swift
//  ST25NFCApp
//
//  Created by STMicroelectronics on 9/17/19.
//  Copyright © 2019 STMicroelectronics. All rights reserved.
//

import UIKit
import CoreNFC

class testCoreNfcViewController: ST25UIViewController,NFCTagReaderSessionDelegate,UIPickerViewDataSource, UIPickerViewDelegate  {
    
    @IBOutlet weak var blockNumberLabel: UILabel!
    @IBOutlet weak var blockNumberStackView: UIStackView!
    @IBOutlet weak var blockNumberTextField: UITextField!
    @IBOutlet weak var dataStackView: UIStackView!
    @IBOutlet weak var dataTextField: UITextField!
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var textView: UITextView!
    
    internal var isCustomCommand:Bool = false;
    internal var mBlockNumberOrAddress:UInt!
    
    internal var mBufferToWrite:UInt!
    internal var mBufferToWriteData:NSData!
    
    @IBAction func handleStart(_ sender: Any) {
        if (!dataStackView.isHidden){
            if (dataTextField.text!.isEmpty){
                self.warningAlert(message: "Please , enter correct value in Data !!!")
                return
            }else{
                if (isCustomCommand && (dataTextField.text!.count % 2) != 0) {
                    self.warningAlert(message: "Number of Data to write must be a multiple of byte")
                    return
                }
                
                if (isCustomCommand){
                    mBufferToWriteData = ComStSt25sdkHelper.convertHexStringToByteArray(with: dataTextField.text).toNSData() as NSData?
                }else{
                    mBufferToWrite = UInt((ComStSt25sdkHelper.convertHexStringToInt(with: dataTextField.text)))
                }
            }
        }
 
        if (!blockNumberStackView.isHidden){
            if (blockNumberTextField.text!.isEmpty){
                self.warningAlert(message: "Please , enter correct value in BlockNumber or Custom Command !!!")
                return
            }else{
                mBlockNumberOrAddress = UInt((ComStSt25sdkHelper.convertHexStringToInt(with: blockNumberTextField.text)))
            }
        }
      startSession()
    }
    
    // List of Methods
    private var pickerList = [
        "resetToReady",
        "select",
        "stayQuiet",
        "getSystemInfo",
        "lockBlock",
        "getMultipleBlockSecurityStatus",
        "writeAFI",
        "lockAFI",
        "writeDSFID",
        "lockDFSID",
        "extendedLockBlock",
        "readConfiguration",
        "readDynConfiguration",
        "writeConfiguration",
        "writeDynConfiguration",
        "manageGPO",
        "Custom",
        "getExtendedSystemInfo",
    ]
    
    private var pickerListIndex:Int!
    
    // Reference the NFC session
    private var tagSession: NFCTagReaderSession!
    
    func startSession() {
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
        
        tagSession?.alertMessage = "Hold your smartphone near an NFC Type5 tag"
        tagSession?.begin()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataStackView.isHidden = true;
        blockNumberStackView.isHidden = true;
        
        pickerView.delegate = self
        pickerListIndex = 0
        
        blockNumberTextField.delegate = self;
        dataTextField.delegate = self;
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        dataStackView.isHidden = true;
        blockNumberStackView.isHidden = true;
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
          guard CharacterSet(charactersIn: "0123456789AaBbCcDdEeFf").isSuperset(of: CharacterSet(charactersIn: string)) else {
              return false
          }
        if (isCustomCommand == true && textField == dataTextField){
            return true
        }else{
            return range.location < 2
        }
    }
    
    private func warningAlert(message : String) {
         DispatchQueue.main.async {
             let alert = UIAlertController(title: "CoreNFC", message: message, preferredStyle: .alert)
             alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
             self.present(alert, animated: true, completion: nil)
         }
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
            return
        }
        
        session.connect(to: tags.first!) { (error: Error?) in
            if error != nil {
                session.invalidate(errorMessage: "Connection error. Please try again.")
                return
            }
            self.startTest(session: session, iso15693Tag: iso15693Tag)
        }
    }
    
    func startTest(session: NFCTagReaderSession , iso15693Tag: NFCISO15693Tag){
        
        switch self.pickerListIndex {
        case 0:
            self.resetToReady(session: session, iso15693Tag: iso15693Tag)
            break
        case 1:
            self.select(session: session, iso15693Tag: iso15693Tag)
            break
        case 2:
            self.stayQuiet(session: session, iso15693Tag: iso15693Tag)
            break
        case 3:
            self.getSystemInfo(session: session, iso15693Tag: iso15693Tag)
            break
        case 4:
            self.lockBlock(session: session, iso15693Tag: iso15693Tag)
            break
        case 5:
            self.getMultipleBlockSecurityStatus(session: session, iso15693Tag: iso15693Tag)
            break
        case 6:
            self.writeAFI(session: session, iso15693Tag: iso15693Tag)
            break
        case 7:
            self.lockAFI(session: session, iso15693Tag: iso15693Tag)
            break
        case 8:
            self.writeDSFID(session: session, iso15693Tag: iso15693Tag)
            break
        case 9:
            self.lockDFSID(session: session, iso15693Tag: iso15693Tag)
            break
        case 10:
            self.extendedLockBlock(session: session, iso15693Tag: iso15693Tag)
            break
        case 11:
            self.readConfiguration(session: session, iso15693Tag: iso15693Tag)
            break
        case 12:
            self.readDynConfiguration(session: session, iso15693Tag: iso15693Tag)
            break
        case 13:
            self.writeConfiguration(session: session, iso15693Tag: iso15693Tag)
            break
        case 14:
            self.writeDynConfiguration(session: session, iso15693Tag: iso15693Tag)
            break
        case 15:
            self.manageGPO(session: session, iso15693Tag: iso15693Tag)
            break
        case 16:
            self.custom(session: session, iso15693Tag: iso15693Tag)
            break
        case 17:
            self.getExtendedSystemInfo(session: session, iso15693Tag: iso15693Tag)
            break
        @unknown default:
            session.invalidate(errorMessage: "Function not implemented")
            return
        }
    }
    
    func stopTest(session: NFCTagReaderSession){
        session.invalidate()
    }
    
    
    func resetToReady(session: NFCTagReaderSession , iso15693Tag: NFCISO15693Tag){
        
        iso15693Tag.resetToReady(requestFlags: [.address,.highDataRate]){ error  in
            if error != nil {
                session.invalidate(errorMessage: "resetToReady error . Please try again."+error.debugDescription)
                print(error!.localizedDescription)
                return
            }
            
            DispatchQueue.main.sync {
                // Informs TextView in Main Thread
                self.textView.text  = self.textView.text + "resetToReady : OK\n"
            }
            self.stopTest(session: session)
        }
    }
    
    func select(session: NFCTagReaderSession , iso15693Tag: NFCISO15693Tag){
        
        iso15693Tag.select(requestFlags: [.address,.highDataRate]){ error  in
            if error != nil {
                session.invalidate(errorMessage: "select error . Please try again."+error.debugDescription)
                print(error!.localizedDescription)
                return
            }
            
            DispatchQueue.main.sync {
                // Informs TextView in Main Thread
                self.textView.text  = self.textView.text + "select : OK\n"
            }
            self.stopTest(session: session)
        }
    }
    
    func stayQuiet(session: NFCTagReaderSession , iso15693Tag: NFCISO15693Tag){
        
        iso15693Tag.stayQuiet(){ error  in
            if error != nil {
                session.invalidate(errorMessage: "stayQuiet error . Please try again."+error.debugDescription)
                print(error!.localizedDescription)
                return
            }
            
            DispatchQueue.main.sync {
                // Informs TextView in Main Thread
                self.textView.text  = self.textView.text + "stayQuiet : OK\n"
            }
            self.stopTest(session: session)
        }
    }
    
    func getSystemInfo(session: NFCTagReaderSession , iso15693Tag: NFCISO15693Tag){
        DispatchQueue.global().async {
            let miOSIso15693Tag : iOSIso15693 = iOSIso15693.init(iso15693Tag)
            let response = miOSIso15693Tag.getSystemInfo()
            DispatchQueue.main.sync {
                let uidString = miOSIso15693Tag.id?.toHexString().replacingOccurrences(of: " ", with: "")
                self.textView.text  = self.textView.text + "IC Identifier = \(uidString)\n --> getSystemInfo = \(response?.toHexString())\n"
            }
            miOSIso15693Tag.sessionInvalidate(session: session)
        }
        
    }
    
    func getExtendedSystemInfo(session: NFCTagReaderSession , iso15693Tag: NFCISO15693Tag){
        DispatchQueue.global().async {
            let miOSIso15693Tag : iOSIso15693 = iOSIso15693.init(iso15693Tag, session: session)
            let response = miOSIso15693Tag.getExtendedSystemInfo()
            DispatchQueue.main.sync {
                let uidString = miOSIso15693Tag.id?.toHexString().replacingOccurrences(of: " ", with: "")
                self.textView.text  = self.textView.text + "IC Identifier = \(uidString)\n --> getExtendedSystemInfo = \(response?.toHexString())\n"
            }
            miOSIso15693Tag.sessionInvalidate(session: session)
        }
    }
    
    func lockBlock(session: NFCTagReaderSession , iso15693Tag: NFCISO15693Tag){
        
        iso15693Tag.lockBlock(requestFlags: [.address,.highDataRate],blockNumber: UInt8(mBlockNumberOrAddress & 0xFF)) {  (error: Error?) in
            if error != nil {
                session.invalidate(errorMessage: "lockBlock error . Please try again."+error.debugDescription)
                print(error!.localizedDescription)
                return
            }
            DispatchQueue.main.sync {
                // Informs TextView in Main Thread
                self.textView.text  = self.textView.text + "LockBlock 127 : OK\n"
            }
            self.stopTest(session: session)
        }
    }
    
    func getMultipleBlockSecurityStatus(session: NFCTagReaderSession , iso15693Tag: NFCISO15693Tag){
        
        iso15693Tag.getMultipleBlockSecurityStatus(requestFlags: [.address,.highDataRate],blockRange: NSRange(0..<255)) { blockStatus, error  in
            if error != nil {
                session.invalidate(errorMessage: "getMultipleBlockSecurityStatus error . Please try again."+error.debugDescription)
                print(error!.localizedDescription)
                return
            }
            
            DispatchQueue.main.sync {
                for n in blockStatus {
                    self.textView.text  = self.textView.text + "blockSecurityStatus \(n) \n"
                }
                // Informs TextView in Main Thread
                self.textView.text  = self.textView.text + "getMultipleBlockSecurityStatus : OK\n"
            }
            self.stopTest(session: session)
        }
    }
    
    func writeAFI(session: NFCTagReaderSession , iso15693Tag: NFCISO15693Tag){
        
        iso15693Tag.writeAFI(requestFlags: [.address,.highDataRate], afi: UInt8(mBufferToWrite & 0xFF)){ error  in
            if error != nil {
                session.invalidate(errorMessage: "writeAFI error . Please try again."+error.debugDescription)
                print(error!.localizedDescription)
                return
            }
            
            DispatchQueue.main.sync {
                // Informs TextView in Main Thread
                self.textView.text  = self.textView.text + "writeAFI : OK\n"
            }
            self.stopTest(session: session)
        }
    }
    
    func lockAFI(session: NFCTagReaderSession , iso15693Tag: NFCISO15693Tag){
        
        iso15693Tag.lockAFI(requestFlags: [.address,.highDataRate]){ error  in
            if error != nil {
                session.invalidate(errorMessage: "lockAFI error . Please try again."+error.debugDescription)
                print(error!.localizedDescription)
                return
            }
            
            DispatchQueue.main.sync {
                // Informs TextView in Main Thread
                self.textView.text  = self.textView.text + "lockAFI : OK\n"
            }
            self.stopTest(session: session)
        }
    }
    
    func writeDSFID(session: NFCTagReaderSession , iso15693Tag: NFCISO15693Tag){
        
        iso15693Tag.writeDSFID(requestFlags: [.address,.highDataRate], dsfid: UInt8(mBufferToWrite & 0xFF)){ error  in
            if error != nil {
                session.invalidate(errorMessage: "writeDSFID error . Please try again."+error.debugDescription)
                print(error!.localizedDescription)
                return
            }
            
            DispatchQueue.main.sync {
                // Informs TextView in Main Thread
                self.textView.text  = self.textView.text + "writeDSFID : OK\n"
            }
            self.stopTest(session: session)
            
        }
    }
    
    func lockDFSID(session: NFCTagReaderSession , iso15693Tag: NFCISO15693Tag){
        
        iso15693Tag.lockDFSID(requestFlags: [.address,.highDataRate]){ error  in
            if error != nil {
                session.invalidate(errorMessage: "lockDFSID error . Please try again."+error.debugDescription)
                print(error!.localizedDescription)
                return
            }
            
            DispatchQueue.main.sync {
                // Informs TextView in Main Thread
                self.textView.text  = self.textView.text + "lockDFSID : OK\n"
            }
            self.stopTest(session: session)
        }
    }
    
    func extendedLockBlock(session: NFCTagReaderSession , iso15693Tag: NFCISO15693Tag){
        
        iso15693Tag.extendedLockBlock(requestFlags: [.address,.highDataRate],blockNumber: Int(mBlockNumberOrAddress & 0xFFFF)) {  (error: Error?) in
            if error != nil {
                session.invalidate(errorMessage: "extendedLockBlock error . Please try again."+error.debugDescription)
                print(error!.localizedDescription)
                return
            }
            DispatchQueue.main.sync {
                // Informs TextView in Main Thread
                self.textView.text  = self.textView.text + "extendedLockBlock 0x0000 : OK\n"
            }
            self.stopTest(session: session)
        }
    }
    
    
    
    func readConfiguration(session: NFCTagReaderSession , iso15693Tag: NFCISO15693Tag){
        let iOSIso15693Tag : iOSIso15693 = iOSIso15693.init(iso15693Tag)
        iOSIso15693Tag.readConfiguration(address: UInt8(mBlockNumberOrAddress & 0xFF))
        {  (responseRead: Data?,error: TagError?) in
            
            if error != nil {
                session.invalidate(errorMessage: "readConfiguration error . Please try again."+error.debugDescription)
                print(error!.localizedDescription)
                return
            }
            
            DispatchQueue.main.sync {
                // Informs TextView in Main Thread
                let reponseString = responseRead!.toHexString()
                self.textView.text  = self.textView.text + "readConfiguration \(reponseString) : OK\n"
            }
            self.stopTest(session: session)
        }
    }
    
    func readDynConfiguration(session: NFCTagReaderSession , iso15693Tag: NFCISO15693Tag){
        let iOSIso15693Tag : iOSIso15693 = iOSIso15693.init(iso15693Tag)
        iOSIso15693Tag.readDynConfiguration(address: UInt8(mBlockNumberOrAddress & 0xFF))
        {  (responseRead: Data?,error: TagError?) in
            
            if error != nil {
                session.invalidate(errorMessage: "readDynConfiguration error . Please try again."+error.debugDescription)
                print(error!.localizedDescription)
                return
            }
            
            DispatchQueue.main.sync {
                // Informs TextView in Main Thread
                let reponseString = responseRead!.toHexString()
                self.textView.text  = self.textView.text + "readDynConfiguration \(reponseString) : OK\n"
            }
            self.stopTest(session: session)
        }
    }
    
    func writeConfiguration(session: NFCTagReaderSession , iso15693Tag: NFCISO15693Tag){
        let iOSIso15693Tag : iOSIso15693 = iOSIso15693.init(iso15693Tag)
        iOSIso15693Tag.writeConfiguration(address: UInt8(mBlockNumberOrAddress & 0xFF),data: UInt8(mBufferToWrite & 0xFF))
        {  (responseRead: Data?,error: TagError?) in
            
            if error != nil {
                session.invalidate(errorMessage: "writeConfiguration error . Please try again."+error.debugDescription)
                print(error!.localizedDescription)
                return
            }
            
            DispatchQueue.main.sync {
                self.textView.text  = self.textView.text + "writeConfiguration : OK\n"
            }
            self.stopTest(session: session)
        }
    }
    
    func writeDynConfiguration(session: NFCTagReaderSession , iso15693Tag: NFCISO15693Tag){
        let iOSIso15693Tag : iOSIso15693 = iOSIso15693.init(iso15693Tag)
        iOSIso15693Tag.writeDynConfiguration(address: UInt8(mBlockNumberOrAddress & 0xFF),data: UInt8(mBufferToWrite & 0xFF))
        {  (responseRead: Data?,error: TagError?) in
            
            if error != nil {
                session.invalidate(errorMessage: "writeDynConfiguration error . Please try again."+error.debugDescription)
                print(error!.localizedDescription)
                return
            }
            
            DispatchQueue.main.sync {
                self.textView.text  = self.textView.text + "writeDynConfiguration : OK\n"
            }
            self.stopTest(session: session)
        }
    }
    
    func manageGPO(session: NFCTagReaderSession , iso15693Tag: NFCISO15693Tag){
        DispatchQueue.global().async { [self] in
        let iOSIso15693Tag : iOSIso15693 = iOSIso15693.init(iso15693Tag)
        iOSIso15693Tag.manageGPO(data: UInt8(mBufferToWrite & 0xFF))
        {  (responseRead: Data?,error: TagError?) in
            
            if error != nil {
                session.invalidate(errorMessage: "manageGPO error . Please try again."+error.debugDescription)
                print(error!.localizedDescription)
                return
            }
            
            DispatchQueue.main.sync {
                self.textView.text  = self.textView.text + "manageGPO : OK\n"
            }
            self.stopTest(session: session)
        }
    }
    }
    
    func custom(session: NFCTagReaderSession , iso15693Tag: NFCISO15693Tag){
        let iOSIso15693Tag : iOSIso15693 = iOSIso15693.init(iso15693Tag)
        iOSIso15693Tag.customCommand(code: UInt8(mBlockNumberOrAddress & 0xFF), data: mBufferToWriteData as Data)
        {  (responseRead: Data?,error: TagError?) in
            
            if error != nil {
                session.invalidate(errorMessage: "custom error . Please try again."+error.debugDescription)
                print(error!.localizedDescription)
                return
            }
            
            DispatchQueue.main.sync {
                self.textView.text  = self.textView.text + "custom : OK\n"
            }
            self.stopTest(session: session)
        }
    }
    
    /* Picker Delegate */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.pickerListIndex = row
        
        isCustomCommand = false;
        if (row == 6 || row == 8 || row == 13 || row == 14 || row == 15 || row == 16){
            self.dataStackView.isHidden = false;
        }else{
            self.dataStackView.isHidden = true;
        }
        
        if (row == 4 || row == 11 || row == 12 || row == 10 || row == 13 || row == 14 || row == 16){
            if (row == 16){
                isCustomCommand = true;
                self.blockNumberLabel.text = "Custom Command";
            }else{
                self.blockNumberLabel.text = "Block Number";
            }
            self.blockNumberStackView.isHidden = false;
        }else{
            self.blockNumberStackView.isHidden = true;
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "System", size: 17)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = pickerList[row]
        pickerLabel?.textColor = UIColor.white
        
        return pickerLabel!
    }
    
}
