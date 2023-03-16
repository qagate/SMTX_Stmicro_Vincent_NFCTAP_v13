//
//  ST25TACCFileEditorViewController.swift
//  NFCTap 
//
//  Created by STMICROELECTRONICS on 29/09/2021.
//  Copyright © 2021 STMicroelectronics. All rights reserved.
//

import UIKit
import CoreNFC

class ST25TACCFileEditorViewController: ST25UIViewController {
        
    @IBOutlet weak var ccFileLengthTextField: UITextField!
    @IBOutlet weak var mappingVersionTextField: UITextField!
    @IBOutlet weak var readMaxBytesTextField: UITextField!
    @IBOutlet weak var writeMaxBytesTextField: UITextField!
   
    @IBOutlet weak var TFieldOffset: UILabel!
    @IBOutlet weak var TFieldValue: UITextField!
    
    @IBOutlet weak var LFieldOffset: UILabel!
    @IBOutlet weak var LFieldValue: UITextField!
    
    @IBOutlet weak var FieldIDOffset: UILabel!
    @IBOutlet weak var FieldIDValue: UITextField!
 
    @IBOutlet weak var maxNdefFileSizeOffset: UILabel!
    @IBOutlet weak var maxNdefFileSizeValue: UITextField!
    
    @IBOutlet weak var readAccessRigthOffset: UILabel!
   @IBOutlet weak var readAccessRigthValue: UITextField!
    
    @IBOutlet weak var writeAccessRigthOffset: UILabel!
    @IBOutlet weak var writeAccessRigthValue: UITextField!
    
    @IBOutlet weak var ndefFileNumberPickerView: UIPickerView!
    
    //
    public var mNdefFileNumberPickerView = ["1"]
    public var mNdefFileNumberIndex:Int!
    
    @IBOutlet weak var ndefFileNumberStackView: UIStackView!
    
    @IBAction func handleReadCCFile(_ sender: Any){
        startNFCSession()
    }
    
    // Reference the NFC session
    // NFC & Tags infos
    internal var miOSReaderSession:iOSReaderSession!
    internal var mTag:ComStSt25sdkNFCTag!
    internal var mST25Type4ATag:ComStSt25sdkType4aType4Tag!
    internal var mUid:Data!
    internal var mCCFileData:Data!

    enum taskToDo {
        case readCCFile
    }
    internal var mTaskToDo:taskToDo = .readCCFile

    override func viewDidLoad() {
        super.viewDidLoad()
        mNdefFileNumberIndex = 1
        ndefFileNumberPickerView.delegate = self
        ndefFileNumberPickerView.dataSource = self
        ndefFileNumberPickerView.isHidden = false
        ndefFileNumberStackView.isHidden = true
        ndefFileNumberPickerView.selectRow(0, inComponent: 0, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startNFCSession()
    }
    
    private func startNFCSession(){
        miOSReaderSession = iOSReaderSession(atagReaderSessionViewControllerDelegate: self)
        miOSReaderSession.startTagReaderSession()
    }
    
    private func warningAlert(message : String) {
         DispatchQueue.main.async {
             let alert = UIAlertController(title: "CCFile Type4", message: message, preferredStyle: .alert)
             alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
             self.present(alert, animated: true, completion: nil)
         }
     }

    private func readCCFile(){
        let CCFileData:Data = mST25Type4ATag.readCCFile().toNSData()
        mCCFileData = CCFileData
        let CCFileLength = ComStSt25sdkHelper_convertHexStringToIntWithNSString_(
            ComStSt25sdkHelper_convertByteToHexStringWithByte_(jbyte(CCFileData[0]))+ComStSt25sdkHelper_convertByteToHexStringWithByte_(jbyte(CCFileData[1]))
        )
        UIHelper.UI { [self] in
            if (CCFileLength == 0x0F){
                ndefFileNumberStackView.isHidden = true
            }else if ((CCFileLength - 7 ) % 8 == 0){
                ndefFileNumberStackView.isHidden = false
                mNdefFileNumberPickerView.removeAll()
                // Update Combo Box
                for i in 1..<((CCFileLength - 7)/8)+1 {
                    // TODO for M24SR
                    mNdefFileNumberPickerView.append(String(format: "%d", i))
                }
                ndefFileNumberPickerView.reloadAllComponents()
            }else{
                warningAlert(message: "Error while reading CCFile")
            }
            
            if (CCFileLength >= 0x0F){
                ccFileLengthTextField.text = String(format: "%.4X",CCFileData[0]+CCFileData[1])
                mappingVersionTextField.text = String(format: "%.2X",CCFileData[2])
                readMaxBytesTextField.text = String(format: "%.4X",CCFileData[3]+CCFileData[4])
                writeMaxBytesTextField.text = String(format: "%.4X",CCFileData[5]+CCFileData[6])
                TFieldValue.text = String(format: "%.2X",CCFileData[7])
                LFieldValue.text = String(format: "%.2X",CCFileData[8])
                FieldIDValue.text = String(format: "%.4X",CCFileData[9]+CCFileData[10])
                maxNdefFileSizeValue.text = String(format: "%.4X",CCFileData[11]+CCFileData[12])
                readAccessRigthValue.text = String(format: "%.2X",CCFileData[13])
                writeAccessRigthValue.text = String(format: "%.2X",CCFileData[14])
  
            }
        }
    }
    
    private func updateCCFileContent(ndefFileNumber:UInt8){
        print("updateCCFileContent")
        let offset:Int = (Int(ndefFileNumber) - 1) * 8
        TFieldOffset.text = String(format: "0x%.4X",7+offset)
        TFieldValue.text  = String(format: "%.2X",mCCFileData[7+Int(offset)])
        
        LFieldOffset.text = String(format: "0x%.4X",8+offset)
        LFieldValue.text  = String(format: "%.2X",mCCFileData[8+Int(offset)])
        
        FieldIDOffset.text = String(format: "0x%.4X",9+offset)
        FieldIDValue.text  = String(format: "%.2X",mCCFileData[9+Int(offset)]+mCCFileData[10+Int(offset)])
     
        maxNdefFileSizeOffset.text = String(format: "0x%.4X",11+offset)
        maxNdefFileSizeValue.text  = String(format: "%.4X",mCCFileData[11+Int(offset)]+mCCFileData[12+Int(offset)])
        
        readAccessRigthOffset.text = String(format: "0x%.4X",13+offset)
        readAccessRigthValue.text  = String(format: "%.2X",mCCFileData[13+Int(offset)])
        
        writeAccessRigthOffset.text = String(format: "0x%.4X",14+offset)
        writeAccessRigthValue.text  = String(format: "%.2X",mCCFileData[14+Int(offset)])
        
    }
}

extension ST25TACCFileEditorViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    /* Picker Delegate */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return mNdefFileNumberPickerView.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.mNdefFileNumberPickerView[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.mNdefFileNumberIndex = row
        self.updateCCFileContent(ndefFileNumber: UInt8(self.mNdefFileNumberIndex+1))
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "System", size: 17)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = mNdefFileNumberPickerView[row]
        pickerLabel?.textColor = UIColor.white

        return pickerLabel!
    }
}

extension ST25TACCFileEditorViewController: tagReaderSessionViewControllerDelegate {
   
    func handleTag(st25SDKTag: ComStSt25sdkNFCTag, uid: Data!) throws {
        self.mTag = st25SDKTag
        if (self.mTag is ComStSt25sdkType4aType4Tag   ) {
            self.mST25Type4ATag = self.mTag as? ComStSt25sdkType4aType4Tag
            self.mUid = uid
            if self.isSameTag(uid: uid) {
                switch mTaskToDo {
                case .readCCFile:
                    readCCFile()
                }
            } else {

                UIHelper.UI() {
                    self.warningAlert(message: "Tag has changed, please scan again the Tag ...")
                }
            }
        }else{
            UIHelper.UI() {
                self.warningAlert(message: "This is not a Type4A Tag")
            }
        }
        
    }
    
    func handleTagSessionError(didInvalidateWithError error: Error) {
    }
    
    func handleTagST25SdkError(didInvalidateWithError error: NSException) {
        let stException:ComStSt25sdkSTException = error as! ComStSt25sdkSTException
        if stException.getError() == ComStSt25sdkSTException_STExceptionCode_get_INVALID_CCFILE(){
            self.warningAlert(message: "Invalid CCFile")
        }else{
            self.warningAlert(message: error.description)
        }
    }

}
