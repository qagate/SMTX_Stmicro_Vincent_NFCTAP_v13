//
//  TagReadMemoryViewController.swift
//  ST25NFCApp
//
//  Created by STMicroelectronics on 9/9/19.
//  Copyright © 2019 STMicroelectronics. All rights reserved.
//

import UIKit
import CoreNFC

/// <#Description#>
class TagReadMemoryViewController: ST25UIViewController,NFCTagReaderSessionDelegate,UIPickerViewDataSource, UIPickerViewDelegate {

    // Reference the NFC session
    private var tagSession: NFCTagReaderSession!
    private let coreNFCQueue = DispatchQueue(label: "coreNFCQueue")

    //
    private var mUnitsList = [
    "readSingleBlock ",
    "readMultipleBlocks",
    "extendedReadSingleBlocks",
    "extendedReadMultipleBlocks",
    "fastReadSingleBlock ",
    "fastReadMultipleBlocks",
    "fastExtendedReadSingleBlocks",
    "fastExtendedReadMultipleBlocks"
    ]
    
    private var mIndexUnitsList:Int!
    private var startAddress:UInt16!
    private var numberOfItems:UInt16!
    
    private var mResponseBuffer:Data?

    
    @IBOutlet weak var unitsPickerView: UIPickerView!
    @IBOutlet weak var startAddressTextField: UITextField!
    @IBOutlet weak var numberOfItemsTextField: UITextField!
    @IBOutlet weak var memoryTextView: UITextView!
    
    var mSemaphore:DispatchSemaphore!
    
    @IBAction func startButton(_ sender: Any) {
        self.memoryTextView.text = ""
        startSession()
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
        unitsPickerView.delegate = self
        mIndexUnitsList = 0
        // Do any additional setup after loading the view.
        mSaveToFileButton.isUserInteractionEnabled = false
        mSaveToFileButton.alpha = 0.5
        
        // Used to scroll up view. Keyboard is hidden textview
        mFileNameTextField.delegate = self



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
            }
            else {
                print("Can't open file to write.")
            }
        }
        else {
            // if file does not exist write data for the first time
            do{
                try data.write(to: fileurl, options: .atomic)
            }catch {
                print("Unable to write in new file.")
            }
        }

    }
    
    private func displayBlockInfo(blockNumber:UInt, buffer:Data? ) {
        if let response = buffer {
            var blockNumber:Int = Int(self.startAddressTextField.text!)!
            if response != nil && response.count > 4 && response[0] == 0x00 {
                for index in stride(from: 1, to: response.count-1, by: 4){
                    let tmpBuffer:Data  = response[index...index+3]
                    self.memoryTextView.text += "Block \(blockNumber)\t:\t"
                    self.memoryTextView.text += tmpBuffer.toHexString().uppercased()
                    self.memoryTextView.text += "\t"
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
                    blockNumber += 1
                }
            } else {
                UIHelper.warningAlert(viewController: self, title: "Command error", message: response.toHexString())
            }

        }
    }
    
    private func setDataForFile(response : Data) {
        if response != nil && response.count > 4 && response[0] == 0x00 {
            mResponseBuffer = response[1...response.count-1]
            mSaveToFileButton.isUserInteractionEnabled = true
            mSaveToFileButton.alpha = 1
        } else {
            mResponseBuffer = nil
            mSaveToFileButton.isUserInteractionEnabled = false
            mSaveToFileButton.alpha = 0.5


        }
    }
    
    
    func startSession() {
        
        startAddress  = UInt16(self.startAddressTextField.text!)!
        numberOfItems = UInt16(self.numberOfItemsTextField.text!)!

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
         tagSession = NFCTagReaderSession(pollingOption: [.iso15693], delegate: self, queue: self.coreNFCQueue)
         tagSession?.alertMessage = "Hold your smartphone near an NFC Type5 tag"
         tagSession?.begin()
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
                 //session.restartPolling()
             return
        }
     
         let miOSIso15693Tag : iOSIso15693 = iOSIso15693.init(iso15693Tag)
        
        session.connect(to: tags.first!) { [self] (error: Error?) in
             if error != nil {
                 session.invalidate(errorMessage: "Connection error. Please try again.")
                 return
             }

            let tagUIDString:String = miOSIso15693Tag.id!.toHexString().replacingOccurrences(of: " ", with: "")
            session.alertMessage = "Tag UID : \(tagUIDString)"
            
            if (self.mIndexUnitsList == 0){
                if self.startAddress > UInt8.max {
                    session.invalidate(errorMessage: "Invalid Start @ : \(self.startAddress). Please try again.")

                } else {
                    DispatchQueue.global().async {
                        var response = miOSIso15693Tag.readSingleBlock(address: UInt8(self.startAddress))
                        DispatchQueue.main.sync {
                            let blockNumber:UInt = UInt(self.startAddress)
                            self.displayBlockInfo(blockNumber: blockNumber, buffer: response)
                            setDataForFile(response: response!)
                        }
                        miOSIso15693Tag.sessionInvalidate(session: session)
                    }
                }

            }
            
            if (self.mIndexUnitsList == 1){
                if self.startAddress > UInt8.max || UInt16(self.startAddress+self.numberOfItems) > UInt8.max || self.numberOfItems > 65 {
                    session.invalidate(errorMessage: "Invalid Start @ : \(self.startAddress) or Nb of items : \(self.numberOfItems). Please try again.")

                } else {
                    DispatchQueue.global().async {
                        var response = miOSIso15693Tag.readMultipleBlocks(range: UInt16(self.startAddress)..<UInt16(self.startAddress+self.numberOfItems))
                        DispatchQueue.main.sync {
                            let blockNumber:UInt = UInt(self.startAddress)
                            self.displayBlockInfo(blockNumber: blockNumber, buffer: response)
                            setDataForFile(response: response!)

                        }
                        miOSIso15693Tag.sessionInvalidate(session: session)
                    }
                }

            }
            
            if (self.mIndexUnitsList == 2){
                DispatchQueue.global().async {
                    var response = miOSIso15693Tag.extendedReadSingleBlock(address: UInt16(self.startAddress))
                    
                    DispatchQueue.main.sync {
                        let blockNumber:UInt = UInt(self.startAddress)
                        self.displayBlockInfo(blockNumber: blockNumber, buffer: response)
                        setDataForFile(response: response!)

                    }

                    miOSIso15693Tag.sessionInvalidate(session: session)
                 }
            }
            
            if (self.mIndexUnitsList == 3){
                if self.numberOfItems > 65 {
                    // Limitation iOS API coded on one byte instead of two
                    if self.numberOfItems < 2049 &&  self.startAddress + self.numberOfItems < 2049 {
                        var tmpBuffer:Data = Data.init(repeating: 0x00,count: 1)

                        DispatchQueue.global().async {
                            var blockNumber:Int = Int(self.startAddress)

                            for index in 0...self.numberOfItems-1 {
                                var addr = UInt16(blockNumber) + index
                                var response = miOSIso15693Tag.extendedReadSingleBlock(address: UInt16(addr))
                                if response![0] == 0 {
                                    tmpBuffer.append(contentsOf: response![1...response!.count-1])
                                } else {
                                    //error in cmd response
                                }
                            }
                            DispatchQueue.main.sync {
                                let blockNumber:UInt = UInt(self.startAddress)
                                self.displayBlockInfo(blockNumber: blockNumber, buffer: tmpBuffer)
                                setDataForFile(response: tmpBuffer)

                            }
                            miOSIso15693Tag.sessionInvalidate(session: session)
                        }


                    } else {
                        session.invalidate(errorMessage: "Number of items must be in 1..2048 max and in accordance with start. Please try again.")

                    }


                } else {
                    DispatchQueue.global().async {
                        var response = miOSIso15693Tag.extendedReadMultipleBlocks(range: UInt16(self.startAddress)..<UInt16(self.startAddress+self.numberOfItems))
                        
                        DispatchQueue.main.sync {
                            let blockNumber:UInt = UInt(self.startAddress)
                            self.displayBlockInfo(blockNumber: blockNumber, buffer: response)
                            setDataForFile(response: response!)

                        }

                        miOSIso15693Tag.sessionInvalidate(session: session)
                     }
                }

           }
            
            if (self.mIndexUnitsList == 4){
                if self.startAddress > UInt8.max || UInt16(self.startAddress+self.numberOfItems) > UInt8.max {
                    session.invalidate(errorMessage: "Invalid Start @ : \(self.startAddress) or Nb of items : \(self.numberOfItems). Please try again.")

                } else {
                    DispatchQueue.global().async {
                        var response = miOSIso15693Tag.fastReadSingleBlock(address: UInt8(self.startAddress))
                        
                        DispatchQueue.main.sync {
                            let blockNumber:UInt = UInt(self.startAddress)
                            self.displayBlockInfo(blockNumber: blockNumber, buffer: response)
                            setDataForFile(response: response!)

                        }

                        miOSIso15693Tag.sessionInvalidate(session: session)
                     }
                }

           }
            
            if (self.mIndexUnitsList == 5){
                if self.startAddress > UInt8.max || UInt16(self.startAddress+self.numberOfItems) > UInt8.max || self.numberOfItems > 65  {
                    session.invalidate(errorMessage: "Invalid Start @ : \(self.startAddress) or Nb of items : \(self.numberOfItems). Please try again.")

                } else {
                    DispatchQueue.global().async {
                        var response = miOSIso15693Tag.fastReadMultipleBlocks(range: UInt8(self.startAddress)..<UInt8(self.startAddress+self.numberOfItems))
                        
                        DispatchQueue.main.sync {
                            let blockNumber:UInt = UInt(self.startAddress)
                            self.displayBlockInfo(blockNumber: blockNumber, buffer: response)
                            setDataForFile(response: response!)

                        }

                        miOSIso15693Tag.sessionInvalidate(session: session)
                     }
                    
                }

            }
            
            if (self.mIndexUnitsList == 6){
                DispatchQueue.global().async {
                    var response = miOSIso15693Tag.fastExtendedReadSingleBlock(address: UInt16(self.startAddress))
                    
                    DispatchQueue.main.sync {
                        let blockNumber:UInt = UInt(self.startAddress)
                        self.displayBlockInfo(blockNumber: blockNumber, buffer: response)
                        setDataForFile(response: response!)

                    }

                    miOSIso15693Tag.sessionInvalidate(session: session)
                 }
            }
            
            if (self.mIndexUnitsList == 7){
                
                if self.numberOfItems > 65 {
                    session.invalidate(errorMessage: "Max number of blocks reached (Max 65). Please try again.")
                } else {
                    DispatchQueue.global().async {
                        var response = miOSIso15693Tag.fastExtendedReadMultipleBlocks(range: UInt16(self.startAddress)..<UInt16(self.startAddress+self.numberOfItems))
                        
                        DispatchQueue.main.sync {
                            let blockNumber:UInt = UInt(self.startAddress)
                            self.displayBlockInfo(blockNumber: blockNumber, buffer: response)
                            setDataForFile(response: response!)

                        }

                        miOSIso15693Tag.sessionInvalidate(session: session)
                     }
                    
                }

            }
        } // connect
    }
    
    /* Picker Delegate */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return mUnitsList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.mUnitsList[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //self.mUrlTextField.text = self.list[row]
        //self.mDropDown.isHidden = true
        self.mIndexUnitsList = row
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "System", size: 17)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = mUnitsList[row]
        pickerLabel?.textColor = UIColor.white

        return pickerLabel!
    }


}
