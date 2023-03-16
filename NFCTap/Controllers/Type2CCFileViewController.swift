//
//  Type2CCFileViewController.swift
//  NFCTap 
//
//  Created by STMICROELECTRONICS on 21/04/2021.
//  Copyright © 2021 STMicroelectronics. All rights reserved.
//

import UIKit
import CoreNFC

class Type2CCFileViewController: ST25UIViewController {

    @IBOutlet weak var byte0TextField: UITextField!
    @IBOutlet weak var byte1TextField: UITextField!
    @IBOutlet weak var byte2TextField: UITextField!
    @IBOutlet weak var byte3TextField: UITextField!

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

            miOSReaderSession = iOSReaderSession(atagReaderSessionViewControllerDelegate: self)
            miOSReaderSession.startTagReaderSession()
        }
   }
    
    //NFC
    internal var miOSReaderSession:iOSReaderSession!
    internal var mPwd:Data!
    internal var mTag:ComStSt25sdkNFCTag!
    internal var mType2Tag:ComStSt25sdkType2Type2Tag!
    internal var mUid:Data!
    
    //CCFile Data
    internal var mCCFileData:Data?

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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startReadSession()
    }
    
    func setCCFileData(aCCFile:Data) {
        mCCFileData = aCCFile
    }
    
    private func updateTextFields(data:Data) {
        byte0TextField.text =  getTwoLastDigit(jint(data[0]))
        byte1TextField.text = getTwoLastDigit(jint(data[1]))
        byte2TextField.text = getTwoLastDigit(jint(data[2]))
        byte3TextField.text = getTwoLastDigit(jint(data[3]))
   }
    
    private func isByteTextFieldCorrect() -> Bool {
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
            self.mCCFileData = self.mType2Tag.readCCFile().toNSData()
                UIHelper.UI() { [self] in
                    updateTextFields(data: mCCFileData!)
                }
            }
            , catch: { (errorNSException) in
                let error:ComStSt25sdkSTException? = errorNSException as? ComStSt25sdkSTException
                print(error?.getError())
                if (error?.getError().toNSEnum() == ComStSt25sdkSTException_STExceptionCode_Enum.INVALID_CCFILE){
                    if (error?.getErrorData().toNSData().count == 4 || error?.getErrorData().toNSData().count == 16){
                        self.mCCFileData = error?.getErrorData().toNSData()
                        UIHelper.UI() { [self] in
                            updateTextFields(data: self.mCCFileData!)
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
        self.mType2Tag.writeCCFile(with: bufferIOSByteArray)
    }


}

extension Type2CCFileViewController: tagReaderSessionViewControllerDelegate {
   
    func handleTag(st25SDKTag: ComStSt25sdkNFCTag, uid: Data!) throws {
        self.mType2Tag = (st25SDKTag as? ComStSt25sdkType2Type2Tag)!
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
