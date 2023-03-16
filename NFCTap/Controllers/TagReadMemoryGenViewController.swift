//
//  TagReadMemoryViewController.swift
//  ST25NFCApp
//
//  Created by STMicroelectronics on 9/9/19.
//  Copyright © 2019 STMicroelectronics. All rights reserved.
//

import UIKit
import CoreNFC
import Network

/// <#Description#>
class TagReadMemoryGenViewController: ST25UIViewController, UIPickerViewDataSource, UIPickerViewDelegate  {

    internal var mTag : ComStSt25sdkNFCTag!
    internal var miOSReaderSession:iOSReaderSession!
    internal var mST25TagMemorySize:Int!
    
    internal var mAreaPwd:Data!
    internal var mAreaAffectedPasswordNumber: Int!
    internal var mPasswordNumbersOfBits: Int!
    var mNumberOfAreas: Int8 = 1

    enum taskToDo {
        case getTagInfo
        case readMemory
        case readMemoryWithPwd
      }
    internal var mTaskToDo:taskToDo = .readMemory
    
    private var startAddress:UInt16!
    private var numberOfItems:UInt16!
    
    private var mResponseBuffer:Data?

    private var isMultiAreaTag = false
    private var mMemorySize:Int!
    private var mNbFiles:Int=1
    private var mArea:Int!
    private var mIndexUnitsList = 1

    @IBOutlet weak var mStackViewArea: UIStackView!
    @IBOutlet weak var mAreaPickerView: UIPickerView!
    private var mAreaDataVisitInformation = [(uniqId:Int,availableSpace:Int)]()

    
    @IBOutlet weak var mStartLabel: UILabel!
    
    
    @IBOutlet weak var startAddressTextField: UITextField!
    @IBOutlet weak var numberOfItemsTextField: UITextField!
    @IBOutlet weak var memoryTextView: UITextView!
    
    var mSemaphore:DispatchSemaphore!
    
    @IBAction func startButton(_ sender: Any) {
        self.memoryTextView.text = ""
        if mArea != nil && mMemorySize != nil {
            mTaskToDo = .readMemory
            
            startAddress  = UInt16(self.startAddressTextField.text!)!
            numberOfItems = UInt16(self.numberOfItemsTextField.text!)!
            
            // run NFC to read NFC Tag Configuration
            self.miOSReaderSession = iOSReaderSession(atagReaderSessionViewControllerDelegate: self)
            self.miOSReaderSession.startTagReaderSession()

        } else {
            self.warningAlert(message: "Tag information not retrieved, go back and let mobile on Tag ")
        }
        
    }
    
    @IBOutlet weak var mFileNameTextField: UITextField!
    @IBOutlet weak var mSaveToFileButton: UIButton!
    
    @IBAction func saveToFile(_ sender: UIButton) {
        var  fileName = mFileNameTextField.text
        if fileName == "" {
            fileName = "data.bin"
            mFileNameTextField.text = fileName
        }
        writeToFile(data: mResponseBuffer!, fileName: fileName!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mSaveToFileButton.isUserInteractionEnabled = false
        mSaveToFileButton.alpha = 0.5
        
        // Used to scroll up view. Keyboard is hidden textview
        mFileNameTextField.delegate = self
        

        startAddress  = UInt16(self.startAddressTextField.text!)!
        numberOfItems = UInt16(self.numberOfItemsTextField.text!)!
        
        mStackViewArea.visibility = .invisible
        
        //mAreaPickerView.delegate = self

        
        // detect Tag
        mTaskToDo = .getTagInfo
        self.miOSReaderSession = iOSReaderSession(atagReaderSessionViewControllerDelegate: self)
        if self.miOSReaderSession.mTagSystemInfo != nil {
            mTag = self.miOSReaderSession.mTagSystemInfo.getTagInstance()
        }

        self.miOSReaderSession.startTagReaderSession()
    }
    
    private func getTagInformation() {
        mMemorySize = Int(mTag.getMemSizeInBytes())
        if mTag is ComStSt25sdkType5STType5Tag {
            //print("Multi Area ....")
            if mTag is ComStSt25sdkType5STType5MultiAreaTag {
                mArea = Int((mTag as! ComStSt25sdkType5STType5MultiAreaTag).getAreaFromBlockAddress(with: jint(startAddress)))
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
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        //view.setNeedsLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // call the 'keyboardWillShow' function when the view controller receive notification that keyboard is going to be shown
        NotificationCenter.default.addObserver(self, selector: #selector(TagReadMemoryViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)


        // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
       NotificationCenter.default.addObserver(self, selector: #selector(TagReadMemoryViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

    }

    private var mViewPosition: CGFloat = 0
    private var mInitialPosition : Bool = false
    private var shouldMoveViewUp : Bool = false
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {

          // if keyboard size is not available for some reason, dont do anything
          return
        }

        //var shouldMoveViewUp = false

        // if active text field is not nil
        if let activeTextField = activeTextField {

          let bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: self.view).maxY;
          
          let topOfKeyboard = self.view.frame.height - keyboardSize.height

          // if the bottom of Textfield is below the top of keyboard, move up
          if bottomOfTextField > topOfKeyboard {
              shouldMoveViewUp = true
              if !mInitialPosition {
                  mViewPosition = self.view.frame.origin.y
                  mInitialPosition = true

              }

          }
            // debug
            //var offset = keyboardSize.height - (self.view.frame.height - activeTextField.frame.origin.y - activeTextField.frame.height)
            //print("toffset: \(offset)")
            //print("keyboardsize: \(keyboardSize.height)")
            //print("view origin: \(self.view.frame.origin.y)")
        }

        if(shouldMoveViewUp) {
          self.view.frame.origin.y = 0 - keyboardSize.height
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
      // move back the root view origin to zero
        if(shouldMoveViewUp) {
            self.view.frame.origin.y = mViewPosition
            mInitialPosition = true
            shouldMoveViewUp = false
        }
        //print("view origin return: \(self.view.frame.origin.y)")
    }
    
    
    func writeToFile(data: Data, fileName: String){
        // get path of directory
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            return
        }
        // create file url
        let fileurl =  directory.appendingPathComponent("\(fileName)")
    // if file exists then write data
        if FileManager.default.fileExists(atPath: fileurl.path) {
            if let fileHandle = FileHandle(forWritingAtPath: fileurl.path) {
                // seekToEndOfFile, writes data at the last of file(appends not override)
                fileHandle.truncateFile(atOffset: 0)
                fileHandle.write(data)
                fileHandle.closeFile()
                UIHelper.UI() { [self] in
                    UIHelper.warningAlert(viewController: self, title: "Data stored to file :", message: "\(fileName)")
                }

            }
            else {
                print("Can't open file to write.")
                UIHelper.UI() { [self] in
                    UIHelper.warningAlert(viewController: self, title: "Can't open file to write :", message: "\(fileName)")
                }
            }
        }
        else {
            // if file does not exist write data for the first time
            do{
                try data.write(to: fileurl, options: .atomic)
                UIHelper.UI() { [self] in
                    UIHelper.warningAlert(viewController: self, title: "Data stored to file :", message: "\(fileName)")
                }
            }catch {
                print("Unable to write in new file.")
                UIHelper.UI() { [self] in
                    UIHelper.warningAlert(viewController: self, title: "Unable to write in new file :", message: "\(fileName)")
                }
            }
        }

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
            var blockNumber:Int = Int(self.startAddressTextField.text!)!
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
    
    private func setDataForFile(response : Data) {
        if response != nil && response.count > 4  {
            mResponseBuffer = response[0...response.count-1]
            mSaveToFileButton.isUserInteractionEnabled = true
            mSaveToFileButton.alpha = 1
        } else {
            mResponseBuffer = nil
            mSaveToFileButton.isUserInteractionEnabled = false
            mSaveToFileButton.alpha = 0.5


        }
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
            (mTag as! ComStSt25sdkType4aSTType4Tag).verifyReadPassword(with: jint(area), with: IOSByteArray(nsData: mAreaPwd))
        } else {
            UIHelper.UI() {
                self.warningAlert(message: "Tag doesn't support this feature")
            }
            return
        }
    }
    
    // NFC ST25SDK
    private func readMemoryContentWithPwd(){
        // Pwd
        getPasswordNumberOfBytesInformationsForAreaProtectionHandling(area: mArea)
        presentPwd(area: self.mArea)
        readMemoryContent(withProtection: true)
    }
    
    private func readMemoryContent(withProtection: Bool? = false){
        var response:Data!
        var startItem : UInt16 = 0
        var nbItems : UInt16 = 2
        if self.mTag is ComStSt25sdkType5Type5Tag {
            startItem = self.startAddress * 4
            nbItems = self.numberOfItems * 4
            
            
            if self.mTag is ComStSt25sdkType5STType5Tag &&  self.mTag is ComStSt25sdkType5STType5MultiAreaTag {
                self.mArea = getAreaFromByteAddressType5(addr: Int(startItem))
            }
            // impossible to find Area from @
            if self.mArea == -1 {
                UIHelper.UI() { [self] in
                    UIHelper.warningAlert(viewController: self, title: "Read of several areas or capacity limit or area protected :", message: "not yet managed")
                    return
                }

            }
            // Multiple Area read
            var areax:Int = 1
            var areay:Int = 1
            // Check if not consecutives areas
            if self.mTag is ComStSt25sdkType5STType5Tag &&  self.mTag is ComStSt25sdkType5STType5MultiAreaTag {
               areax = getAreaFromByteAddressType5(addr: Int(startItem))
               areay = getAreaFromByteAddressType5(addr: Int(startItem + nbItems))
            }
            if  areax != areay
            {
                // Two consecutive area - not possible to read
                UIHelper.UI() { [self] in
                    UIHelper.warningAlert(viewController: self, title: "Read of several areas or capacity limit :", message: "not yet managed")
                }
                return
            } else {
                response = self.mTag.readBytes(with: jint(startItem), with: jint(nbItems)).toNSData()

            }
            
        }
        if self.mTag is ComStSt25sdkType4aType4Tag {
            startItem = self.startAddress
            nbItems = self.numberOfItems
            // Assume Area number is FileID
            if (startItem >= 0 && startItem + nbItems < mAreaDataVisitInformation[mArea-1].availableSpace) {
               
                if withProtection!  && self.mTag is ComStSt25sdkType4aSTType4Tag {
                    response =  (self.mTag as! ComStSt25sdkType4aSTType4Tag).readBytes(with: jint(mArea), with: 0, with: jint(nbItems), with: IOSByteArray(nsData: mAreaPwd)).toNSData()
                } else {
                    response = (self.mTag as! ComStSt25sdkType4aType4Tag).readBytes(with: jint(self.mIndexUnitsList), with: jint(startItem), with: jint(nbItems)).toNSData()
                }
            } else {
                UIHelper.UI() { [self] in
                    UIHelper.warningAlert(viewController: self, title: "Wrong Read parameters or capacity limit :", message: "Start: \(startItem) Number of items: \(nbItems)")
                }
                return
            }

        }
        if self.mTag is ComStSt25sdkType2Type2Tag {
            startItem = self.startAddress * 4
            nbItems = self.numberOfItems * 4

            self.mArea = getAreaFromByteAddressType2(addr: Int(startItem))
            // impossible to find Area from @
            if self.mArea == -1 {
                UIHelper.UI() { [self] in
                    UIHelper.warningAlert(viewController: self, title: "Read of several areas or capacity limit or area protected and not yet managed", message: response!.toHexString())
                    return
                }

            }
            
            response = self.mTag.readBytes(with: jint(startItem), with: jint(nbItems)).toNSData()

        }
        
        //print(response?.toHexString())
        if response!.count < nbItems {
            // cmd issue
            UIHelper.UI() { [self] in
                UIHelper.warningAlert(viewController: self, title: "Command error", message: response!.toHexString())
            }
        } else {
            UIHelper.UI() { [self] in

                let blockNumber:UInt = UInt(self.startAddress)
                self.displayBlockInfo(blockNumber: blockNumber, buffer: response)
                setDataForFile(response: response!)
            }
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
        UIHelper.warningAlert(viewController: self, title : "Read memory" , message: message)
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

extension TagReadMemoryGenViewController: ST25PasswordViewDelegate {
    func okButtonTapped(pwdValue: Data) {
        if self.mTaskToDo == .readMemoryWithPwd {
            //print(pwdValue.toHexString())
            DispatchQueue.main.async {
                self.mAreaPwd = pwdValue
                self.mTaskToDo = .readMemoryWithPwd
                self.miOSReaderSession.startTagReaderSession()
            }
        }

    }
    
    func cancelButtonTapped() {

        if self.mTaskToDo == .readMemoryWithPwd {
            self.miOSReaderSession.stopTagReaderSession("Command stopped: by user")        }
    }
    
}

extension TagReadMemoryGenViewController: tagReaderSessionViewControllerDelegate {
   
    func handleTag(st25SDKTag: ComStSt25sdkNFCTag, uid: Data!) throws {
        self.mTag = st25SDKTag
        // Check if tag has changed
        if (!isSameTag(uid: uid)) {
            miOSReaderSession.stopTagReaderSession("Tag has changed, please scan again the Tag ...")
            return
        }
        
        
        switch mTaskToDo {
        case .readMemory:
            //UIHelper.warningAlert(viewController: self, title: "ST25 Read memory ", message: "Not yet implemented")
            //mST25TagMemorySize = Int(mST25DVTag.getMemSizeInBytes())
            readMemoryContent()

            
        case .getTagInfo:
            getTagInformation()

        case .readMemoryWithPwd:
            readMemoryContentWithPwd()
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
            if self.mTaskToDo == .readMemory {
                //            print("Error SDK \(errorST25SDK)")
                //            print("Error SDK \(errorST25SDK.getError())")
                //            print("Error SDK \(errorST25SDK.getMessage())")
                if ((errorST25SDK.getMessage()?.contains(ComStSt25sdkSTException_STExceptionCode.PASSWORD_NEEDED.description()))! ||
                    (errorST25SDK.getMessage()?.contains(ComStSt25sdkSTException_STExceptionCode.ISO15693_BLOCK_IS_LOCKED.description()))! ||
                    (errorST25SDK.getMessage()?.contains(ComStSt25sdkSTException_STExceptionCode.ISO15693_BLOCK_PROTECTED.description()))! ||
                    (errorST25SDK.getMessage()?.contains(ComStSt25sdkSTException_STExceptionCode.WRONG_SECURITY_STATUS.description()))!){
                    DispatchQueue.main.async {
                        self.mTaskToDo = .readMemoryWithPwd
                        self.getCurrentPwdForArea(type: "read")
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
