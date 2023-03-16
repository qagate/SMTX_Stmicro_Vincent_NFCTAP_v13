//
//  Type5CCFileViewController.swift
//  NFCTap 
//
//  Created by STMICROELECTRONICS on 21/04/2021.
//  Copyright © 2021 STMicroelectronics. All rights reserved.
//

import UIKit
import CoreNFC

class Type5CCFileViewController: ST25UIViewController {

    @IBOutlet weak var byte0TextField: UITextField!
    @IBOutlet weak var byte1TextField: UITextField!
    @IBOutlet weak var byte2TextField: UITextField!
    @IBOutlet weak var byte3TextField: UITextField!
    @IBOutlet weak var byte4TextField: UITextField!
    @IBOutlet weak var byte5TextField: UITextField!
    @IBOutlet weak var byte6TextField: UITextField!
    @IBOutlet weak var byte7TextField: UITextField!
    @IBOutlet weak var stackView8ByteCCFile: UIStackView!
   
    @IBOutlet weak var extendedCCFileSwitch: UISwitch!
    
    @IBAction func handleReadButton(_ sender: UIButton) {
        startReadSession()
    }
    
    private func startReadSession() {
        self.mTaskToDo = .readCC
        miOSReaderSession = iOSReaderSession(atagReaderSessionViewControllerDelegate: self)
        miOSReaderSession.startTagReaderSession()
    }
    
    @IBAction func handleWritteButton(_ sender: UIButton) {
        if (isByteTextFieldCorrect)(){
            self.mTaskToDo = .writeCC
            mBufferCCFileToWrite = [jbyte]()
            
            mBufferCCFileToWrite?.append(ComStSt25sdkHelper.convertHexStringToByte(with: byte0TextField.text))
            mBufferCCFileToWrite?.append(ComStSt25sdkHelper.convertHexStringToByte(with: byte1TextField.text))
            mBufferCCFileToWrite?.append(ComStSt25sdkHelper.convertHexStringToByte(with: byte2TextField.text))
            mBufferCCFileToWrite?.append(ComStSt25sdkHelper.convertHexStringToByte(with: byte3TextField.text))
            if (!stackView8ByteCCFile.isHidden){
                mBufferCCFileToWrite?.append(ComStSt25sdkHelper.convertHexStringToByte(with: byte4TextField.text))
                mBufferCCFileToWrite?.append(ComStSt25sdkHelper.convertHexStringToByte(with: byte5TextField.text))
                mBufferCCFileToWrite?.append(ComStSt25sdkHelper.convertHexStringToByte(with: byte6TextField.text))
                mBufferCCFileToWrite?.append(ComStSt25sdkHelper.convertHexStringToByte(with: byte7TextField.text))
            }

            miOSReaderSession = iOSReaderSession(atagReaderSessionViewControllerDelegate: self)
            miOSReaderSession.startTagReaderSession()
        }
   }
    
    internal  var writeNDEFNullTLV:Bool = false
    @IBOutlet weak var nullTLVSwitch: UISwitch!
    @IBAction func handleNDEFNullTlv(_ sender: UISwitch) {
        writeNDEFNullTLV = sender.isOn
    }
    
    @IBAction func handle8byteCCFile(_ sender: UISwitch) {
        stackView8ByteCCFile.isHidden = !sender.isOn
    }
    
    //NFC
    internal var miOSReaderSession:iOSReaderSession!
    internal var mPwd:Data!
    internal var mTag:ComStSt25sdkNFCTag!
    internal var mType5Tag:ComStSt25sdkType5Type5Tag!
    internal var mUid:Data!

    enum taskToDo {
        case readCC
        case writeCC
    }
    internal var mTaskToDo:taskToDo = .readCC

    internal var mBufferCCFileToWrite:[jbyte]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        byte0TextField.delegate = self
        byte1TextField.delegate = self
        byte2TextField.delegate = self
        byte3TextField.delegate = self
        byte4TextField.delegate = self
        byte5TextField.delegate = self
        byte6TextField.delegate = self
        byte7TextField.delegate = self
        


    }
    
    private func updateFields(ccfileType5:CCFileType5) {
        do {
            let CCFile: [UInt8] = try ccfileType5.getCC()
            updateTextFields(data: Data(CCFile))
        } catch {
            var bufferCCFileInvalid:Data = Data(ccfileType5.firstBlock)
            if (ccfileType5.getCCLength() > 4){
                bufferCCFileInvalid.append(Data(ccfileType5.secondBlock))
            }
            updateTextFields(data: bufferCCFileInvalid)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let tagInfo:TagInfo = (TabItem.TagInfo.mainVC as! ST25TagInformationViewController).mTagSystemInfo!
        let ccfileType5:CCFileType5 = tagInfo.getCCFileType5()
        if ccfileType5.isValidCCFile() {
            // do nothing CC is uptodate
            //updateFields(ccfileType5: ccfileType5)
            startReadSession()
        } else {
            // Try to read CC file - Can be fron CCFile controler update or NDEF update
            startReadSession()
        }
    }
    
    private func updateTextFields(data:Data) {
        byte0TextField.text =  getTwoLastDigit(jint(data[0]))
        byte1TextField.text = getTwoLastDigit(jint(data[1]))
        byte2TextField.text = getTwoLastDigit(jint(data[2]))
        byte3TextField.text = getTwoLastDigit(jint(data[3]))
        if (data.count > 4){
            stackView8ByteCCFile.isHidden = false
            extendedCCFileSwitch.isOn = true
            byte4TextField.text = getTwoLastDigit(jint(data[4]))
            byte5TextField.text = getTwoLastDigit(jint(data[5]))
            byte6TextField.text = getTwoLastDigit(jint(data[6]))
            byte7TextField.text = getTwoLastDigit(jint(data[7]))
            
        }else{
            stackView8ByteCCFile.isHidden = true
            extendedCCFileSwitch.isOn = false
        }
   }
    
    private func isByteTextFieldCorrect() -> Bool {
        if (!stackView8ByteCCFile.isHidden){
            if (!byte2TextField!.text!.contains("00")){
                self.warningAlert(message: "Byte 2 must be equal 0x00")
                return false
            }
        }else{
            if (byte2TextField!.text!.contains("00")){
                self.warningAlert(message: "Byte 2 cannot be equal 0x00")
                return false
            }
        }
        return true
    }
    
    private func getTwoLastDigit(_ value:jint) -> String {
        var str:String = ComStSt25sdkHelper.convertIntToHexFormatString(with: value)
        let index = str.index(str.endIndex, offsetBy: -2)
        return String(str[index...])
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
          guard CharacterSet(charactersIn: "0123456789AaBbCcDdEeFf").isSuperset(of: CharacterSet(charactersIn: string)) else {
              return false
          }
        return range.location < 2
    }
    
    private func warningAlert(message : String) {
         DispatchQueue.main.async {
             let alert = UIAlertController(title: "CC File  ", message: message, preferredStyle: .alert)
             alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
             self.present(alert, animated: true, completion: nil)
         }
     }
    
    
    // NFC ST25SDK
    private func readCCFile(){
        SwiftTryCatch.try({
                do {
                    let response:Data? = try self.mType5Tag.readCCFile().toNSData()
                    UIHelper.UI() { [self] in
                        updateTextFields(data: response!)
                    }
                } catch {
                    // Catch something here if not handling throw from ObjC
                }
            }
            , catch: { (errorNSException) in
                let error:ComStSt25sdkSTException? = errorNSException as? ComStSt25sdkSTException
                print(error?.getError())
                if (error?.getError().toNSEnum() == ComStSt25sdkSTException_STExceptionCode_Enum.INVALID_CCFILE){
                    if (error?.getErrorData().toNSData().count == 4 || error?.getErrorData().toNSData().count == 16){
                        let response:Data? = error?.getErrorData().toNSData()
                        UIHelper.UI() { [self] in
                            updateTextFields(data: response!)
                        }
                    }else{
                        UIHelper.UI() {
                            self.warningAlert(message: "NO CCFile Found. Could not find a valid CCFile")
                        }
                    }
                }else{
                    
                }
            }
            , finallyBlock: {
                // Does Nothing
            })
        
    }
    
    private func writeCCFile(){
        let bufferIOSByteArray:IOSByteArray = IOSByteArray.init(bytes: mBufferCCFileToWrite, count: UInt(mBufferCCFileToWrite!.count))
        self.mType5Tag.writeCCFile(with: bufferIOSByteArray)
        if (writeNDEFNullTLV){
            let ndefRecordNullTlv:ComStSt25sdkNdefEmptyRecord = ComStSt25sdkNdefEmptyRecord.init()
            self.mType5Tag.writeNdefMessage(with: ComStSt25sdkNdefNDEFMsg.init(comStSt25sdkNdefNDEFRecord: ndefRecordNullTlv),withBoolean:false)
        }
    }


}

extension Type5CCFileViewController: tagReaderSessionViewControllerDelegate {
   
    func handleTag(st25SDKTag: ComStSt25sdkNFCTag, uid: Data!) throws {
        self.mType5Tag = st25SDKTag as? ComStSt25sdkType5Type5Tag
        self.mUid = uid
        if self.isSameTag(uid: uid) {
            switch mTaskToDo {
            case .readCC:
                readCCFile()
            case .writeCC:
                writeCCFile()
             }
        } else {

            UIHelper.UI() {
                self.warningAlert(message: "Tag has changed, please scan again the Tag ...")
            }
        }
    }
    
    func handleTagSessionError(didInvalidateWithError error: Error) {
    }
    
    func handleTagST25SdkError(didInvalidateWithError error: NSException) {
        self.warningAlert(message: error.description)
    }

}
