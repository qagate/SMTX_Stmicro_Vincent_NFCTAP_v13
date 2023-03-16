//
//  TagWriteMemoryViewController.swift
//  ST25NFCApp
//
//  Created by STMicroelectronics on 9/10/19.
//  Copyright © 2019 STMicroelectronics. All rights reserved.
//

import UIKit
import CoreNFC

class TagWriteMemoryGenViewController: ST25UIViewController,UIPickerViewDataSource, UIPickerViewDelegate {

    
    internal var mTag : ComStSt25sdkNFCTag!
    internal var miOSReaderSession:iOSReaderSession!
    internal var mST25TagMemorySize:Int!
    
    internal var mAreaPwd:Data!
    internal var mAreaAffectedPasswordNumber: Int!
    internal var mPasswordNumbersOfBits: Int!
    var mNumberOfAreas: Int8 = 1
    
    enum taskToDo {
        case getTagInfo
        case writeMemory
        case writeMemoryWithPwd
      }
    internal var mTaskToDo:taskToDo = .writeMemory

    private var mBlockAddress:UInt16!
    private var mBlockData:Data!
    private var bufferIOSByteArray : IOSByteArray!

    private var isMultiAreaTag = false
    private var mMemorySize:Int!
    private var mArea:Int!

    private var mNbFiles:Int=1
    private var mIndexUnitsList = 1
    
    //     @IBOutlet weak var blockData: UITextField!

    @IBOutlet weak var mStackViewArea: UIStackView!
    @IBOutlet weak var mAreaPickerView: UIPickerView!
    private var mAreaDataVisitInformation = [(uniqId:Int,availableSpace:Int)]()

    @IBOutlet weak var mStartLabel: UILabel!
    @IBOutlet weak var blockData: UITextView!
    
    @IBOutlet weak var blockAddress: UITextField!
    //@IBOutlet weak var blockData: UITextField!
    @IBOutlet weak var memoryTextView: UITextView!
    
    @IBAction func handleStart(_ sender: Any) {
        
        if mTag is ComStSt25sdkType5STType5Tag {
            if (blockAddress.text!.isEmpty || blockData.text!.isEmpty){
                displayAlert(title: "Bad Parameters", message: "Block Address or Block Data empty")
                return
            }
            
            if ((blockData.text!.count % 4) != 0) {
                displayAlert(title: "Bad Parameters", message: "Number of Data to write must be a multiple of 4")
                return
            }
        }

        if mArea != nil && mMemorySize != nil {
            self.mBlockAddress = UInt16(self.blockAddress.text!)!
            var bufferData:NSData!
            bufferIOSByteArray = ComStSt25sdkHelper.convertHexStringToByteArray(with: self.blockData.text)
            bufferData = bufferIOSByteArray?.toNSData() as NSData?
            
            self.mBlockData = Data(referencing: bufferData)
            self.memoryTextView.text = ""
            mTaskToDo = .writeMemory
            
            
            // run NFC to read NFC Tag Configuration
            self.miOSReaderSession = iOSReaderSession(atagReaderSessionViewControllerDelegate: self)
            self.miOSReaderSession.startTagReaderSession()
            
        } else {
            self.warningAlert(message: "Tag information not retrieved, go back and let mobile on Tag ")
        }
        
        

    }
    
    
    @IBOutlet weak var mFileNameForData: UITextField!
    @IBAction func readFromFile(_ sender: UIButton) {

        openImportDocumentPicker()
    }
    
    private func getTagInformation() {
        mMemorySize = Int(mTag.getMemSizeInBytes())
        if mTag is ComStSt25sdkType5STType5Tag {
            //print("Multi Area ....")
            if mTag is ComStSt25sdkType5STType5MultiAreaTag {
                mArea = Int((mTag as! ComStSt25sdkType5STType5MultiAreaTag).getAreaFromBlockAddress(with: jint(mBlockAddress)))
                isMultiAreaTag = true
                getPasswordNumberOfBytesInformationsForAreaProtectionHandling(area: mArea)
                UIHelper.UI() { [self] in
                    mStackViewArea.visibility = .invisible
                    mAreaPickerView.delegate = self
                    mStartLabel.text = "Start (Unit Block, Mem size: \(mMemorySize/4))"
                }
                
            }

        }
        
        if mTag is ComStSt25sdkType4aSTType4Tag {
            mNbFiles = Int((mTag as! ComStSt25sdkType4aSTType4Tag).getNbrOfFiles())
            if (mNbFiles > 1) {
                isMultiAreaTag = true
                mArea = 1
                 mNumberOfAreas = Int8(mNbFiles)
                 mAreaDataVisitInformation.removeAll()
                 for index in 1...mNumberOfAreas {
                     let size = (mTag as! ComStSt25sdkType4aSTType4Tag).getMaxFileSize(with: jint(index))
                     mAreaDataVisitInformation.append((Int(index),Int(size)))
                 }
                getPasswordNumberOfBytesInformationsForAreaProtectionHandling(area: mArea)
                UIHelper.UI() { [self] in
                    mStackViewArea.visibility = .visible
                    mAreaPickerView.delegate = self
                    mAreaPickerView.dataSource = self
                    mStartLabel.text = "Start (Unit Byte, Mem size: \(mMemorySize*1))"
                    
                    mAreaPickerView.reloadAllComponents()
                }
            }
                
        }
        if mTag is ComStSt25sdkType2Type2Tag {
            mArea = 1
            getPasswordNumberOfBytesInformationsForAreaProtectionHandling(area: mArea)
            UIHelper.UI() { [self] in
                mStackViewArea.visibility = .invisible
                mAreaPickerView.delegate = self
                mStartLabel.text = "Start (Unit Block, Mem size: \(mMemorySize/4))"
                
            }
        }

    }
    
    
    func openImportDocumentPicker() {
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.item"], in: .import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        documentPicker.shouldShowFileExtensions = true
        documentPicker.allowsMultipleSelection = false

        self.present(documentPicker, animated: true, completion: {  })
    }

    
    private func displayAlert(title:String, message:String)->() {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func displayBlockInfo(blockNumber:UInt, buffer:Data ) {
        var complementedBuffer:Data!
        var isComplemented:Bool!

        if buffer.count % 4 == 0 {
            
            complementedBuffer = Data.init(buffer)
            isComplemented = false
        } else {
            // Completion needed
            var completionBytes = ((buffer.count - buffer.count % 4) + 4) - buffer.count
            var tmpBuffer:Data = Data.init(repeating: 0x00,count: completionBytes)
            complementedBuffer = Data.init(buffer)
            complementedBuffer.append(tmpBuffer)
            isComplemented = true

            
        }
        // display
        if self.mTag is ComStSt25sdkType5Type5Tag {
            displayBlockInfoWithoutCompletion(buffer: complementedBuffer, rawLabel: "Block", isBlock: true, isComplemented: isComplemented, lengthToDisplay: UInt16(buffer.count))
            
        }
        if self.mTag is ComStSt25sdkType4aType4Tag {
            displayBlockInfoWithoutCompletion(buffer: complementedBuffer, rawLabel: "Addr", isBlock: false, isComplemented: isComplemented, lengthToDisplay: UInt16(buffer.count))

        }
        if self.mTag is ComStSt25sdkType2Type2Tag {
            displayBlockInfoWithoutCompletion(buffer: complementedBuffer, rawLabel: "Addr", isBlock: false, isComplemented: isComplemented, lengthToDisplay: UInt16(buffer.count))

        }
    }
    
    private func displayBlockInfoWithoutCompletion(buffer:Data?, rawLabel:String, isBlock:Bool, isComplemented: Bool, lengthToDisplay: UInt16) {
        if let response = buffer {
            var blockNumber:Int = Int(self.blockAddress.text!)!
            var alignement = 0
            var loopForDisplayLimit:UInt16 = 0
                for index in stride(from: 0, to: response.count-1, by: 4){
                    var tmpBuffer:Data=Data()
                    if isComplemented && index + 4 > lengthToDisplay {
                        let overlap = Int(lengthToDisplay) - Int(index)
                        if index+Int(overlap) < buffer!.count {
                            tmpBuffer = response[index...(index + (Int(overlap) == 0 ? 0:Int(overlap)-1))]
                            alignement = buffer!.count - Int(lengthToDisplay)
                        } else {
                            tmpBuffer = response[index...index+3]

                        }
                    } else {
                        tmpBuffer = response[index...index+3]
                    }
                    self.memoryTextView.text += "\(rawLabel) \(String(format: "%04d", blockNumber)):      "
                    self.memoryTextView.text += tmpBuffer.toHexString().uppercased()
                    if alignement > 0 {
                        for algn in 1...alignement {
                            self.memoryTextView.text += "      "
                        }
                    }
                    self.memoryTextView.text += "      "
                    for hexval in tmpBuffer {
                        var asciiVal:Character!
                        if (hexval > 0x20) {
                          asciiVal = Character(UnicodeScalar(hexval))
                        }else{
                          asciiVal = Character(".")
                        }
                        self.memoryTextView.text += String(asciiVal)
                        self.memoryTextView.text += " "
                    }
                    self.memoryTextView.text += "\n"
                    if isBlock {
                        blockNumber += 1
                    } else {
                        // Address
                        blockNumber += 4
                    }
                }
        }
    }

   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mStackViewArea.visibility = .invisible
        
        self.mBlockAddress = UInt16(self.blockAddress.text!)!


        // detect Tag
        mTaskToDo = .getTagInfo
        self.miOSReaderSession = iOSReaderSession(atagReaderSessionViewControllerDelegate: self)
        if self.miOSReaderSession.mTagSystemInfo != nil {
            mTag = self.miOSReaderSession.mTagSystemInfo.getTagInstance()
        }
        self.miOSReaderSession.startTagReaderSession()

    }

    private func getAreaFromByteAddressType5(addr : Int) -> Int {
        var area:Int = 1
        SwiftTryCatch.try({
            do {
                try area = Int((self.mTag as! ComStSt25sdkType5STType5MultiAreaTag).getAreaFromByteAddress(with: jint(addr)))
            } catch {
                area = -1
                
            }
        }
        , catch: { (error) in
            area = -1
        }
        , finallyBlock: {
        })
        return area
    }
    private func getAreaFromByteAddressType2(addr : Int) -> Int {
        var area:Int = 1
        // Only one area for time being
        return area
    }
    
    
    private func getPasswordNumberOfBytesInformationsForAreaProtectionHandling(area: Int) {
        if mTag is ST25TVTag {
            getPasswordNumberOfBytesInformationsForAreaProtectionHandling(area: area, tag: mTag as! ST25TVTag)
            
        } else if mTag is ST25TVCTag {
            getPasswordNumberOfBytesInformationsForAreaProtectionHandling(area: area, tag: mTag as! ST25TVCTag)
            
        } else if mTag is ST25DVTag {
            getPasswordNumberOfBytesInformationsForAreaProtectionHandling(area: area, tag: mTag as! ST25DVTag)
        } else if mTag is ST25DVCTag {
            getPasswordNumberOfBytesInformationsForAreaProtectionHandling(area: area, tag: mTag as! ST25DVCTag)
        } else if mTag is ST25TV16KTag {
            getPasswordNumberOfBytesInformationsForAreaProtectionHandling(area: area, tag: mTag as! ST25TV16KTag)
        } else if mTag is ST25TV64KTag {
            getPasswordNumberOfBytesInformationsForAreaProtectionHandling(area: area, tag: mTag as! ST25TV64KTag)
        } else if self.mTag is ST25DVPwmTag {
            getPasswordNumberOfBytesInformationsForAreaProtectionHandling(area: area, tag: mTag as! ST25DVPwmTag)
        } else if self.mTag is ComStSt25sdkType4aSTType4Tag {
            getPasswordNumberOfBytesInformationsForAreaProtectionHandling(area: area, tag: mTag as! ComStSt25sdkType4aSTType4Tag)
            
        } else if self.mTag is ComStSt25sdkType2Type2Tag {
            getPasswordNumberOfBytesInformationsForAreaProtectionHandling(area: area, tag: mTag as! ComStSt25sdkType2Type2Tag)
            
        } else {
            UIHelper.UI() {
                self.warningAlert(message: "Feature not yet managed")
            }
            
        }

    }
    
    private func getPasswordNumberOfBytesInformationsForAreaProtectionHandling(area: Int, tag: ST25TVTag) {
        mNumberOfAreas = Int8(tag.getNumberOfAreas())

    }
    private func getPasswordNumberOfBytesInformationsForAreaProtectionHandling(area: Int, tag: ST25TVCTag) {
        mNumberOfAreas = Int8(tag.getNumberOfAreas())
    }
    
    private func getPasswordNumberOfBytesInformationsForAreaProtectionHandling(area: Int, tag: ST25DVTag) {
        mPasswordNumbersOfBits = 64
        // Get the password number in case of protected area
        mAreaAffectedPasswordNumber = (Int)(tag.getPasswordNumber(with: jint(area)))
        if (mAreaAffectedPasswordNumber != 0){
            mPasswordNumbersOfBits = (Int)(tag.getAreaPasswordLength(with: jint(area)))
        }
    }
    
    private func getPasswordNumberOfBytesInformationsForAreaProtectionHandling(area: Int, tag: ST25DVCTag) {
        // Get the password number in case of protected area
        mAreaAffectedPasswordNumber = (Int)(tag.getPasswordNumber(with: jint(area)))
        if (mAreaAffectedPasswordNumber != 0){
            mPasswordNumbersOfBits = (Int)(tag.getAreaPasswordLength(with: jint(area)))
        }
    }
    
    private func getPasswordNumberOfBytesInformationsForAreaProtectionHandling(area: Int, tag: ST25TV16KTag) {
        // Get the password number in case of protected area
        mAreaAffectedPasswordNumber = (Int)(tag.getPasswordNumber(with: jint(area)))
        if (mAreaAffectedPasswordNumber != 0){
            mPasswordNumbersOfBits = (Int)(tag.getAreaPasswordLength(with: jint(area)))
        }
    }
    private func getPasswordNumberOfBytesInformationsForAreaProtectionHandling(area: Int, tag: ST25TV64KTag) {
        // Get the password number in case of protected area
        mAreaAffectedPasswordNumber = (Int)(tag.getPasswordNumber(with: jint(area)))
        if (mAreaAffectedPasswordNumber != 0){
            mPasswordNumbersOfBits = (Int)(tag.getAreaPasswordLength(with: jint(area)))
        }
    }
    private func getPasswordNumberOfBytesInformationsForAreaProtectionHandling(area: Int, tag: ST25DVPwmTag) {
        mNumberOfAreas = Int8(tag.getNumberOfAreas())

    }
    
    private func getPasswordNumberOfBytesInformationsForAreaProtectionHandling(area: Int, tag: ComStSt25sdkType4aSTType4Tag) {
         mPasswordNumbersOfBits = 64
         // Get the password number in case of protected area
         mAreaAffectedPasswordNumber = mArea
         mMemorySize = Int(tag.getMaxFileSize(with: jint(mArea)))
         if (mAreaAffectedPasswordNumber != 0){
             mPasswordNumbersOfBits = Int(tag.getReadPasswordLengthInBytes(with: jint(mArea)) * 8)
         }
         
     }
    private func getPasswordNumberOfBytesInformationsForAreaProtectionHandling(area: Int, tag: ComStSt25sdkType2Type2Tag ) {
        mAreaAffectedPasswordNumber = mArea
        mNumberOfAreas = 1
    }

    
    private func presentPwd(area: Int) {
        if mTag is ST25TVTag {
            if area == ComStSt25sdkType5St25tvST25TVTag_ST25TV_AREA1_PASSWORD_ID {
                (mTag as! ST25TVTag).presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25tvST25TVTag_ST25TV_AREA1_PASSWORD_ID), password: mAreaPwd)
            } else {
                (mTag as! ST25TVTag).presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25tvST25TVTag_ST25TV_AREA2_PASSWORD_ID), password: mAreaPwd)
            }
        } else if mTag is ST25TVCTag {
            if area == ComStSt25sdkType5St25tvST25TVTag_ST25TV_AREA1_PASSWORD_ID {
                (mTag as! ST25TVCTag).presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25tvST25TVTag_ST25TV_AREA1_PASSWORD_ID), password: mAreaPwd)
            } else {
                (mTag as! ST25TVCTag).presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25tvST25TVTag_ST25TV_AREA2_PASSWORD_ID), password: mAreaPwd)
            }
        } else if mTag is ST25DVTag {
            (mTag as! ST25DVTag).presentPassword(passwordNumber: UInt8(mAreaAffectedPasswordNumber), password: mAreaPwd)
        } else if mTag is ST25DVCTag {
            (mTag as! ST25DVCTag).presentPassword(passwordNumber: UInt8(mAreaAffectedPasswordNumber), password: mAreaPwd)
        } else if mTag is ST25TV16KTag {
            (mTag as! ST25TV16KTag).presentPassword(passwordNumber: UInt8(mAreaAffectedPasswordNumber), password: mAreaPwd)
        } else if mTag is ST25TV64KTag {
            (mTag as! ST25TV64KTag).presentPassword(passwordNumber: UInt8(mAreaAffectedPasswordNumber), password: mAreaPwd)
        } else if self.mTag is ST25DVPwmTag {
            if area == ComStSt25sdkType5St25dvpwmST25DVPwmTag_ST25DVPWM_AREA1_PASSWORD_ID {
                (mTag as! ST25DVPwmTag).presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25dvpwmST25DVPwmTag_ST25DVPWM_AREA1_PASSWORD_ID), password: mAreaPwd)
            } else {
                (mTag as! ST25DVPwmTag).presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25dvpwmST25DVPwmTag_ST25DVPWM_AREA2_PASSWORD_ID), password: mAreaPwd)
            }
        } else if mTag is ComStSt25sdkType4aSTType4Tag {
            (mTag as! ComStSt25sdkType4aSTType4Tag).verifyWritePassword(with: jint(area), with: IOSByteArray(nsData: mAreaPwd))
        } else {
            UIHelper.UI() {
                self.warningAlert(message: "Tag doesn't support this feature")
            }
            return
        }

    }
    
    
    private func writeMemoryContentWithPwd(){
        // Pwd
        getPasswordNumberOfBytesInformationsForAreaProtectionHandling(area: mArea)
        presentPwd(area: self.mArea)
        writeMemoryContent(withProtection: true)
    }

    private func writeMemoryContent(withProtection: Bool? = false){
        var response:Data!

        var startItem : UInt16 = 0
        var nbItems : UInt16 = UInt16(self.mBlockData.count)

        if self.mTag is ComStSt25sdkType5Type5Tag {
            startItem = self.mBlockAddress * 4
            
            if self.mTag is ComStSt25sdkType5STType5Tag &&  self.mTag is ComStSt25sdkType5STType5MultiAreaTag {
                self.mArea = getAreaFromByteAddressType5(addr: Int(startItem))
            }
            // impossible to find Area from @
            if self.mArea == -1 {
                UIHelper.UI() { [self] in
                    UIHelper.warningAlert(viewController: self, title: "Write of several areas or capacity limit or area protected : ", message: "not yet managed")
                    return
                }

            }
            // Multiple Area read
            let areax = getAreaFromByteAddressType5(addr: Int(startItem))
            let areay = getAreaFromByteAddressType5(addr: Int(startItem + nbItems))
            if  areax != areay
            {
                // Two consecutive area - not possible to read
                UIHelper.UI() { [self] in
                    UIHelper.warningAlert(viewController: self, title: "Write of several areas or capacity limit :", message: "not yet managed")
                }
                return
            } else {

                self.mTag.writeBytes(with: jint(startItem), with: bufferIOSByteArray)

            }

            
        }
        if self.mTag is ComStSt25sdkType4aType4Tag {
            startItem = self.mBlockAddress
            // Assume Area number is FileID
            if (startItem >= 0 && bufferIOSByteArray != nil && (Int(startItem) + Int(bufferIOSByteArray.length())) < mAreaDataVisitInformation[mArea-1].availableSpace) {
               
                if withProtection!  && self.mTag is ComStSt25sdkType4aSTType4Tag {
                    (self.mTag as! ComStSt25sdkType4aSTType4Tag).writeBytes(with: jint(mArea), with: jint(startItem), with: bufferIOSByteArray, with: IOSByteArray(nsData: mAreaPwd))
                } else {
                    (self.mTag as! ComStSt25sdkType4aType4Tag).writeBytes(with: jint(self.mIndexUnitsList), with: jint(startItem), with: bufferIOSByteArray)
                }
            } else {
                let bufferSize = bufferIOSByteArray != nil ? bufferIOSByteArray.length():0
                UIHelper.UI() { [self] in
                    UIHelper.warningAlert(viewController: self, title: "Wrong Write parameters or capacity limit :", message: "Start: \(startItem) Number of items: \(bufferSize)")
                }
                return
            }
            
            //(self.mTag as! ComStSt25sdkType4aType4Tag).writeBytes(with: jint(mIndexUnitsList), with: jint(startItem), with: bufferIOSByteArray)

        }
        if self.mTag is ComStSt25sdkType2Type2Tag {
            startItem = self.mBlockAddress * 4

            self.mArea = getAreaFromByteAddressType2(addr: Int(startItem))
            // impossible to find Area from @
            if self.mArea == -1 {
                UIHelper.UI() { [self] in
                    UIHelper.warningAlert(viewController: self, title: "Read of several areas or capacity limit or area protected and not yet managed", message: response!.toHexString())
                    return
                }

            }
            self.mTag.writeBytes(with: jint(startItem), with: bufferIOSByteArray)


        }
        
        UIHelper.UI() { [self] in
            let blockNumber:UInt = UInt(startItem)
            self.displayBlockInfo(blockNumber: blockNumber, buffer: self.mBlockData)
        }

    }


    func retrieveDataForFilename(_ url: URL) -> Data? {
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            fatalError("Can't get data at url:\(url)")
        }
       
    }
    
    
    
    private func getCurrentPwdForArea(type : String) {
        let mST25PasswordVC:ST25PasswordViewController = UIStoryboard(name: "ST25Password", bundle: nil).instantiateViewController(withIdentifier: "ST25PasswordID") as! ST25PasswordViewController
        mST25PasswordVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        mST25PasswordVC.setTitle("Enter current \(type) pwd for area \(String(describing: self.mArea!))")
        
        if mTag is ST25TVTag || self.mTag is ST25DVPwmTag || mTag is ST25TVCTag {
            if  self.mNumberOfAreas == 2 {
                mST25PasswordVC.setMessage("(32 bits hexadecimal format)")
                mST25PasswordVC.numberOfBytes = 4
            } else {
                mST25PasswordVC.setMessage("(64 bits hexadecimal format)")
                mST25PasswordVC.numberOfBytes = 8
            }
        } else if mTag is ST25DVTag || mTag is ST25DVCTag || mTag is ST25TV16KTag || mTag is ST25TV64KTag {
            if mPasswordNumbersOfBits/8 == 8 {
                // DV Area pwd on 64 bits
                mST25PasswordVC.setMessage("64 bits hexadecimal format for pwd :\(String(mAreaAffectedPasswordNumber))")
                mST25PasswordVC.numberOfBytes = 8
            } else {
                UIHelper.UI() {
                    self.warningAlert(message: "Wrong area or password length")
                }
                
                return
            }
        } else if mTag is ComStSt25sdkType4aSTType4Tag {
            // Type4
             mST25PasswordVC.setMessage("128 bits hexadecimal format for pwd :\(String(mAreaAffectedPasswordNumber))")
             mST25PasswordVC.numberOfBytes = 16
         } else {
            UIHelper.UI() {
                self.warningAlert(message: "Tag doesn't support this feature")
            }
            
            return
        }
        
        mST25PasswordVC.delegate = self
        self.present(mST25PasswordVC, animated: false, completion: nil)
    }
    
    private func warningAlert(message : String) {
        UIHelper.warningAlert(viewController: self, title : "Write memory" , message: message)
    }
    
    
    /* Picker Delegate */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.mNbFiles
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "Area\(row+1)"
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //self.mUrlTextField.text = self.list[row]
        //self.mDropDown.isHidden = true
        self.mIndexUnitsList = row+1
        if mTag is ComStSt25sdkType4aSTType4Tag && mAreaDataVisitInformation.count > 1 {
            let areaSize = mAreaDataVisitInformation[row].availableSpace
            mStartLabel.text = "Start (Unit Byte, Mem size: \(areaSize))"
            self.memoryTextView.text = ""

        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "System", size: 17)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = "Area\(row+1)"
        pickerLabel?.textColor = UIColor.white

        return pickerLabel!
    }

}


extension TagWriteMemoryGenViewController: ST25PasswordViewDelegate {
    func okButtonTapped(pwdValue: Data) {
        if self.mTaskToDo == .writeMemoryWithPwd {
            //print(pwdValue.toHexString())
            DispatchQueue.main.async {
                self.mAreaPwd = pwdValue
                self.mTaskToDo = .writeMemoryWithPwd
                self.miOSReaderSession.startTagReaderSession()
            }
        }

    }
    
    func cancelButtonTapped() {

        if self.mTaskToDo == .writeMemoryWithPwd {
            self.miOSReaderSession.stopTagReaderSession("Command stopped: by user")        }
    }
    
}

extension TagWriteMemoryGenViewController: tagReaderSessionViewControllerDelegate {
   
    func handleTag(st25SDKTag: ComStSt25sdkNFCTag, uid: Data!) throws {
        self.mTag = st25SDKTag
        // Check if tag has changed
        if (!isSameTag(uid: uid)) {
            miOSReaderSession.stopTagReaderSession("Tag has changed, please scan again the Tag ...")
            return
        }
        
        
        switch mTaskToDo {
        case .writeMemory :
            //UIHelper.warningAlert(viewController: self, title: "ST25 Read memory ", message: "Not yet implemented")
            //mST25TagMemorySize = Int(mST25DVTag.getMemSizeInBytes())
            writeMemoryContent()

            
        case .getTagInfo:
            getTagInformation()
        case .writeMemoryWithPwd:
            writeMemoryContentWithPwd()
        
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
        if error is ComStSt25sdkSTException {
            let errorST25SDK = error as! ComStSt25sdkSTException
            if self.mTaskToDo == .writeMemory {
                //            print("Error SDK \(errorST25SDK)")
                //            print("Error SDK \(errorST25SDK.getError())")
                //            print("Error SDK \(errorST25SDK.getMessage())")
                if ((errorST25SDK.getMessage()?.contains(ComStSt25sdkSTException_STExceptionCode.PASSWORD_NEEDED.description()))! ||
                    (errorST25SDK.getMessage()?.contains(ComStSt25sdkSTException_STExceptionCode.ISO15693_BLOCK_IS_LOCKED.description()))! ||
                    (errorST25SDK.getMessage()?.contains(ComStSt25sdkSTException_STExceptionCode.ISO15693_BLOCK_PROTECTED.description()))! ||
                    (errorST25SDK.getMessage()?.contains(ComStSt25sdkSTException_STExceptionCode.WRONG_SECURITY_STATUS.description()))!){                    DispatchQueue.main.async {
                        self.mTaskToDo = .writeMemoryWithPwd
                        self.getCurrentPwdForArea(type: "write")
                    }
                } else {
                    DispatchQueue.main.async {
                        self.warningAlert(message: "Command failed: \(error.description)")
                        self.miOSReaderSession.stopTagReaderSession("Command failed: \(error.description)")

                    }
                }
                
            }
        } else {
            miOSReaderSession.stopTagReaderSession("Command failed: \(error.description)")
        }

    }

}


extension TagWriteMemoryGenViewController: UIDocumentPickerDelegate {
  
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        var data = retrieveDataForFilename(urls[0])
        mFileNameForData.text = urls[0].lastPathComponent + " (" + "\(data!.count)" + ")"
        blockData.text = ComStSt25sdkHelper_convertByteArrayToHexStringWithByteArray_(IOSByteArray(nsData: data))
        controller.dismiss(animated: true)
    }
    
    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        mFileNameForData.text = "data.bin"
        controller.dismiss(animated: true)
    }
}
