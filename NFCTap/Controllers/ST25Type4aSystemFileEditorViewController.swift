//
//  ST25Type4aSystemFileEditorViewController.swift
//  NFCTap 
//
//  Created by STMICROELECTRONICS on 29/09/2021.
//  Copyright © 2021 STMicroelectronics. All rights reserved.
//

import UIKit
import CoreNFC

class ST25Type4aSystemFileEditorViewController: ST25UIViewController {
        
    // Common items
    @IBOutlet weak var systemFileLengthTextField: UITextField!
    @IBOutlet weak var uidTextField: UITextField!
    @IBOutlet weak var memorySizeTextField: UITextField!
    @IBOutlet weak var icRefTextField: UITextField!
    
    // ST25TA
    @IBOutlet weak var st25TAStackView: UIStackView!
    @IBOutlet weak var st25TAGpoTextField: UITextField!
    @IBOutlet weak var st25TAEventCounterTextField: UITextField!
    @IBOutlet weak var st25TACounterTextField: UITextField!
    @IBOutlet weak var st25TAVersionTextField: UITextField!
    
    @IBAction func handleGPOTextField(_ sender: Any) {
    }
    
    @IBOutlet weak var updateGpoStackView: UIStackView!
    @IBOutlet weak var updateGPOConfigButton: UIButton!
    @IBOutlet weak var updateGpoTextField: UITextField!
    
    //M24SR
    @IBOutlet weak var m24srStackView: UIStackView!
    @IBOutlet weak var m24srI2CProtectTextField: UITextField!
    @IBOutlet weak var m24srI2CwdgTextField: UITextField!
    @IBOutlet weak var m24srGpoTextField: UITextField!
    @IBOutlet weak var m24srSTReservedTextField: UITextField!
    @IBOutlet weak var m24srRFEnable: UITextField!
    @IBOutlet weak var m24srNumberNdefTextField: UITextField!
    
    
    var valueToWrite:Data!
    @IBAction func updateGPOConfig(_ sender: Any) {
        let value:UInt8 = UInt8(ComStSt25sdkHelper_convertHexStringToByteWithNSString_(updateGpoTextField.text))
        valueToWrite = Data([value])

        //
        mTaskToDo = .updateST25TAGpoConfig
        startNFCSession()
    }

    
    @IBOutlet weak var eventCounterStackView: UIStackView!
    @IBOutlet weak var eventCounterTextField: UITextField!
    @IBOutlet weak var updateEventCounterButton: UIButton!
    @IBAction func handleEventCounterTextField(_ sender: Any) {
    }
    @IBAction func updateEventCounter(_ sender: Any) {
        let value:UInt8 = UInt8(ComStSt25sdkHelper_convertHexStringToByteWithNSString_(eventCounterTextField.text))
        valueToWrite = Data([value])

        //
        mTaskToDo = .updateST25TAEventCounterConfig
        startNFCSession()
    }

    
    // M24SR
    @IBOutlet weak var m24SRndefFileNumberStackView: UIStackView!
    @IBOutlet weak var m24SRndefFileNumberPickerView: UIPickerView!
    public var mNdefFileNumberPickerView = ["1","2","3","4","5","6","7","8"]
    public var mNdefFileNumberIndex:Int!
    public var mNdefFileWritable:Bool =  false
    public var mCurrentNdefFileNumber:Int = 0
    public var mNewNdefFileNumber:Int = 0
    
    
    @IBOutlet weak var updateFileNumberButton: UIButton!
    
    @IBAction func handleUpdateFileNumber(_ sender: Any) {
        //
        mTaskToDo = .updatem24SRNDEFFileNumber
        startNFCSession()
    }
    
    
    // Common actions
    @IBAction func handleReadSystemFile(_ sender: Any) {
        //
        m24SRndefFileNumberStackView.isHidden = true
        updateGpoStackView.isHidden = true
        eventCounterStackView.isHidden = true
        
        //
        mTaskToDo = .readSystemFile
        startNFCSession()
    }
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    // Reference the NFC session
    // NFC & Tags infos
    internal var miOSReaderSession:iOSReaderSession!
    internal var mTag:ComStSt25sdkNFCTag!
    internal var mUid:Data!
    internal var mSystemFileData:Data!

    enum taskToDo {
        case readSystemFile
        case updateST25TAGpoConfig
        case updateST25TAEventCounterConfig
        case updatem24SRNDEFFileNumber
    }
    internal var mTaskToDo:taskToDo = .readSystemFile

    override func viewDidLoad() {
        super.viewDidLoad()
        mNdefFileNumberIndex = 1

        // Common text fields
        systemFileLengthTextField.delegate = self
        uidTextField.delegate = self
        memorySizeTextField.delegate = self
        icRefTextField.delegate = self

        // ST25TA Text Fields
        st25TACounterTextField.delegate = self
        st25TAGpoTextField.delegate = self
        st25TAEventCounterTextField.delegate = self
        updateGpoTextField.delegate = self
        eventCounterTextField.delegate = self
        st25TAVersionTextField.delegate = self
        
        
        // M24SR Text Fields
        m24srRFEnable.delegate = self
        m24srGpoTextField.delegate = self
        m24srI2CProtectTextField.delegate = self
        m24srI2CwdgTextField.delegate = self
        m24srNumberNdefTextField.delegate = self
        m24srSTReservedTextField.delegate = self
        
        
        m24SRndefFileNumberPickerView.delegate = self
        m24SRndefFileNumberPickerView.dataSource = self
        m24SRndefFileNumberPickerView.selectRow(0, inComponent: 0, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //
        m24srStackView.isHidden = true
        m24SRndefFileNumberStackView.isHidden = true
        updateGpoStackView.isHidden = true
        eventCounterStackView.isHidden = true
        
        //
        mTaskToDo = .readSystemFile
        startNFCSession()
    }
    
    private func startNFCSession(){
        miOSReaderSession = iOSReaderSession(atagReaderSessionViewControllerDelegate: self)
        miOSReaderSession.startTagReaderSession()
    }
    
    private func warningAlert(message : String) {
         DispatchQueue.main.async {
             let alert = UIAlertController(title: "System File Type4", message: message, preferredStyle: .alert)
             alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
             self.present(alert, animated: true, completion: nil)
         }
     }

    private func readSystemFile(){
 
        (mTag as! ComStSt25sdkType4aSTType4Tag).invalidateCache()
        
        mSystemFileData = (mTag as! ComStSt25sdkType4aSTType4Tag).readSysFile().toNSData()
        let systemFileLength = ComStSt25sdkHelper_convertHexStringToIntWithNSString_(
            ComStSt25sdkHelper_convertByteToHexStringWithByte_(jbyte(mSystemFileData[0]))+ComStSt25sdkHelper_convertByteToHexStringWithByte_(jbyte(mSystemFileData[1]))
        )
        /*
        // check if file are protected in M24SR
        mNdefFileWritable = true

        if (mTag is ComStSt25sdkType4aM24srtahighdensityM24SRTAHighDensityTag){
            mCurrentNdefFileNumber = Int(mSystemFileData[7])
            mNewNdefFileNumber = mCurrentNdefFileNumber

            for file in 1..<mCurrentNdefFileNumber+1 {
                let readWriteProtection:ComStSt25sdkTagHelper_ReadWriteProtection = (mTag as! ComStSt25sdkType4aM24srtahighdensityM24SRTAHighDensityTag).getReadWriteProtection(with: jint(file))
                if (readWriteProtection != .READABLE_AND_WRITABLE){
                    mNdefFileWritable = false
                    break
                }
            }
        }
 */
        
        UIHelper.UI { [self] in
            if (mTag is ComStSt25sdkType4aSt25taST25TATag){
                st25TAStackView.isHidden = false
                m24srStackView.isHidden = true
                m24SRndefFileNumberStackView.isHidden = true
                
                systemFileLengthTextField.text = String(format: "%.4X",mSystemFileData[0]+mSystemFileData[1])
                st25TAGpoTextField.text = String(format: "%.2X",mSystemFileData[2])
                st25TAGpoTextField.textColor = UIColor.stDarkBlueColor()
                st25TAEventCounterTextField.text = String(format: "%.2X",mSystemFileData[3])
                st25TAEventCounterTextField.textColor = UIColor.stDarkBlueColor()
                st25TACounterTextField.text = String(format: "%.6X",mSystemFileData[4]+mSystemFileData[5]+mSystemFileData[6])
                st25TAVersionTextField.text = String(format: "%.2X",mSystemFileData[7])
                let uidData:Data = mSystemFileData[8...14]
                uidTextField.text = uidData.toHexString()
                memorySizeTextField.text = String(format: "%.4X",mSystemFileData[15]+mSystemFileData[16])
                icRefTextField.text = String(format: "%.2X",mSystemFileData[17])
            }else {
                st25TAStackView.isHidden = true
                m24srStackView.isHidden = false
                
                systemFileLengthTextField.text = String(format: "%.4X",mSystemFileData[0]+mSystemFileData[1])
                
                m24srI2CProtectTextField.text = String(format: "%.2X",mSystemFileData[2])
                m24srI2CwdgTextField.text = String(format: "%.2X",mSystemFileData[3])
                m24srGpoTextField.text = String(format: "%.2X",mSystemFileData[4])
                m24srSTReservedTextField.text = String(format: "%.2X",mSystemFileData[5])
                m24srRFEnable.text = String(format: "%.2X",mSystemFileData[6])
                m24srNumberNdefTextField.text = String(format: "%.2X",mSystemFileData[7])
                
                let uidSize:UInt8 = UInt8(0x07 - (0x12 - systemFileLength))
                let uidData:Data = mSystemFileData[8...8+uidSize-1]
                uidTextField.text = uidData.toHexString()
                
                
                memorySizeTextField.text = String(format: "%.2X%.2X",mSystemFileData[8+Int(uidSize)],mSystemFileData[9+Int(uidSize)])
                icRefTextField.text = String(format: "%.2X",mSystemFileData[10+Int(uidSize)])
            }
        }
    }
    
    private func checkReadWriteAccess() {
        // check if file are protected in M24SR
        mNdefFileWritable = true

        if (mTag is ComStSt25sdkType4aM24srtahighdensityM24SRTAHighDensityTag){
            mCurrentNdefFileNumber = Int(mSystemFileData[7])
            mNewNdefFileNumber = mCurrentNdefFileNumber

            for file in 1..<mCurrentNdefFileNumber+1 {
                let readWriteProtection:ComStSt25sdkTagHelper_ReadWriteProtection = (mTag as! ComStSt25sdkType4aM24srtahighdensityM24SRTAHighDensityTag).getReadWriteProtection(with: jint(file))
                if (readWriteProtection != .READABLE_AND_WRITABLE){
                    mNdefFileWritable = false
                    break
                }
            }
        }
    }
    
    private func updateST25TAGpoConfig() {
        (mTag as! ComStSt25sdkType4aSTType4Tag).invalidateCache()
        (mTag as! ComStSt25sdkType4aSTType4Tag).writeBytes(with: ComStSt25sdkType4aSTType4Tag_SYS_FILE_IDENTIFIER, with: 0x0002, with: IOSByteArray.init(nsData: valueToWrite))
    }
    
    private func updateST25TAEventCounterConfig() {
        (mTag as! ComStSt25sdkType4aSTType4Tag).invalidateCache()
        (mTag as! ComStSt25sdkType4aSTType4Tag).writeBytes(with: ComStSt25sdkType4aSTType4Tag_SYS_FILE_IDENTIFIER, with: 0x0003, with: IOSByteArray.init(nsData: valueToWrite))
    }
    
    private func updatem24SRNDEFFileNumber() {
        if (self.mNewNdefFileNumber != self.mCurrentNdefFileNumber){
            (mTag as! ComStSt25sdkType4aM24srtahighdensityM24SRTAHighDensityTag).invalidateCache()
            (mTag as! ComStSt25sdkType4aM24srtahighdensityM24SRTAHighDensityTag).setNbrOfFilesWith(jint(self.mNewNdefFileNumber)+1)
        }
        self.mCurrentNdefFileNumber = self.mNewNdefFileNumber
        UIHelper.UI { [self] in
            m24srNumberNdefTextField.textColor = UIColor.stDarkBlueColor()
        }
    }
    
    // Use this if you have a UITextField
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if (textField != updateGpoTextField && textField != eventCounterTextField){
            updateGpoStackView.isHidden = true
            eventCounterStackView.isHidden = true
            descriptionTextView.text = ""
        }
        
        // Field Description
        if textField == systemFileLengthTextField {
            let systemFileLengthDescription:String = "Indicates the size (in bytes) of the system file, including this field"
            descriptionTextView.text = systemFileLengthDescription
            return false
        }
        
        if textField == st25TAGpoTextField{
            updateGpoStackView.isHidden = false
            updateGpoTextField.text = st25TAGpoTextField.text
            
            let value:UInt8 = UInt8(ComStSt25sdkHelper_convertHexStringToIntWithNSString_(st25TAGpoTextField.text))
            let GpoBit7:UInt8 = (value >> 7) & 0x01
            let GpoBit6To4:UInt8 = (value >> 4) & 0x07
            let GpoBit3To0:UInt8 = value & 0x07
            var GpoDescription:String! = String("b7 : GPO config lock bit = \(String(GpoBit7, radix: 2))\n")
            GpoDescription = GpoDescription + String("\n")
            GpoDescription = GpoDescription + String("b6:b4 : GPO config = \(String(GpoBit6To4, radix: 2))\n")
            GpoDescription = GpoDescription + String(" - 0b000: Not used\n")
            GpoDescription = GpoDescription + String(" - 0b001: Session Opened\n")
            GpoDescription = GpoDescription + String(" - 0b010: WIP\n")
            GpoDescription = GpoDescription + String(" - 0b011: MIP\n")
            GpoDescription = GpoDescription + String(" - 0b100: Interrupt\n")
            GpoDescription = GpoDescription + String(" - 0b101: State Control\n")
            GpoDescription = GpoDescription + String(" - 0b110: RF Busy\n")
            GpoDescription = GpoDescription + String(" - 0b111: Field Detect\n")
            GpoDescription = GpoDescription + String("\n")
            GpoDescription = GpoDescription + String("b3:b0 : ST Reserved = \(String(GpoBit3To0, radix: 2))\n")
 
            descriptionTextView.text = GpoDescription
            return false
        }
        
        if textField == st25TAEventCounterTextField {
            eventCounterStackView.isHidden = false
            eventCounterTextField.text = st25TAEventCounterTextField.text

            let value:UInt8 = UInt8(ComStSt25sdkHelper_convertHexStringToIntWithNSString_(st25TAEventCounterTextField.text))
            let Bit7:UInt8 = (value >> 7) & 0x01
            let Bit6To2:UInt8 = (value >> 6) & 0x7F
            let Bit1:UInt8 = (value >> 1) & 0x01
            let Bit0:UInt8 = value & 0x01
            var Description:String! = String("b7 : Counter config lock bit = \(String(Bit7, radix: 2))\n")
            Description = Description + String("\n")
            Description = Description + String("b6:b2 : RFU = \(String(Bit6To2, radix: 2))\n")
            Description = Description + String("\n")
            Description = Description + String("b1 : Counter Enable  bit = \(String(Bit1, radix: 2))\n")
            Description = Description + String(" - 0: disable\n")
            Description = Description + String(" - 1: enable\n")
            Description = Description + String("\n")
            Description = Description + String("b0 : Counter Increment bit = \(String(Bit0, radix: 2))\n")
 
            descriptionTextView.text = Description
            return false
        }
        
        if textField == st25TACounterTextField {
            descriptionTextView.text = "Actual value of the counter"
            return false
        }
        
        if textField == st25TAVersionTextField {
            descriptionTextView.text = "Indicate the product version"
            return false
        }
   
        // M245SR
        if textField == m24srI2CProtectTextField{
            descriptionTextView.text = ""
            return false
        }
        if textField == m24srI2CwdgTextField{
            descriptionTextView.text = ""
            return false
        }
        if textField == m24srGpoTextField{
            let value:UInt8 = UInt8(ComStSt25sdkHelper_convertHexStringToIntWithNSString_(m24srGpoTextField.text))
            let GpoBit7:UInt8 = (value >> 7) & 0xF
            let GpoBit6To4:UInt8 = (value >> 4) & 0x07
            let GpoBit3:UInt8 = (value >> 3) & 0x01
            let GpoBit2To0:UInt8 = value & 0x07
            
            var GpoDescription:String! = String("b7 : RFU = \(String(GpoBit7, radix: 2))\n")
            GpoDescription = GpoDescription + String("\n")
            GpoDescription = GpoDescription + String("b6:b4 : When  RF Session is open = \(String(GpoBit6To4, radix: 2))\n")
            GpoDescription = GpoDescription + String(" - 0b000: High Impedance\n")
            GpoDescription = GpoDescription + String(" - 0b001: Session Opened\n")
            GpoDescription = GpoDescription + String(" - 0b010: WIP\n")
            GpoDescription = GpoDescription + String(" - 0b011: MIP\n")
            GpoDescription = GpoDescription + String(" - 0b100: Interrupt\n")
            GpoDescription = GpoDescription + String(" - 0b101: State Control\n")
            GpoDescription = GpoDescription + String(" - 0b110: RF Busy\n")
            GpoDescription = GpoDescription + String(" - 0b111: RFU\n")
            GpoDescription = GpoDescription + String("\n")
            GpoDescription = GpoDescription + String("b3 : RFU = \(String(GpoBit3, radix: 2))\n")
            GpoDescription = GpoDescription + String("\n")
            GpoDescription = GpoDescription + String("b2:b0 : When I2C Session is open = \(String(GpoBit2To0, radix: 2))\n")
            GpoDescription = GpoDescription + String(" - 0b000: High Impedance\n")
            GpoDescription = GpoDescription + String(" - 0b001: Session Opened\n")
            GpoDescription = GpoDescription + String(" - 0b010: WIP\n")
            GpoDescription = GpoDescription + String(" - 0b011: I2C Answer Ready\n")
            GpoDescription = GpoDescription + String(" - 0b100: Interrupt\n")
            GpoDescription = GpoDescription + String(" - 0b101: State Control\n")
            GpoDescription = GpoDescription + String(" - 0b110: RFU\n")
            GpoDescription = GpoDescription + String(" - 0b111: RFU\n")
            GpoDescription = GpoDescription + String("\n")
            
            descriptionTextView.text = GpoDescription
 
            return false
        }
        if textField == m24srSTReservedTextField{
            descriptionTextView.text = "ST Reserved"
            return false
        }
        
        if textField == m24srRFEnable{
            let value:UInt8 = UInt8(ComStSt25sdkHelper_convertHexStringToIntWithNSString_(m24srRFEnable.text))
            let GpoBit7:UInt8 = (value >> 7) & 0xF
            let GpoBit6To4:UInt8 = (value >> 4) & 0x07
            let GpoBit3:UInt8 = (value >> 3) & 0x01
            let GpoBit2To1:UInt8 = (value >> 1) & 0x03
            let GpoBit0:UInt8 = value & 0x1
            
            var DescriptionTmp:String! = String("b7 : RF Field Information = \(String(GpoBit7, radix: 2))\n")
            DescriptionTmp = DescriptionTmp + String(" - 0: The field is off\n")
            DescriptionTmp = DescriptionTmp + String(" - 1: The field is on\n")
            DescriptionTmp = DescriptionTmp + String("\n")
            DescriptionTmp = DescriptionTmp + String("b6:b4 : RFU = \(String(GpoBit6To4, radix: 2))\n")
            DescriptionTmp = DescriptionTmp + String("\n")
            DescriptionTmp = DescriptionTmp + String("b3 : RFU = \(String(GpoBit3, radix: 2))\n")
            DescriptionTmp = DescriptionTmp + String("\n")
            DescriptionTmp = DescriptionTmp + String("b2:b1 : RFU = \(String(GpoBit2To1, radix: 2))\n")
            DescriptionTmp = DescriptionTmp + String("\n")
            DescriptionTmp = DescriptionTmp + String("b0 : Decoding Status Information = \(String(GpoBit0, radix: 2))\n")
            DescriptionTmp = DescriptionTmp + String(" - 0: does not decode the command received from RF\n")
            DescriptionTmp = DescriptionTmp + String(" - 1: decodes the command received from RF\n")

            descriptionTextView.text = DescriptionTmp
 
            return false
        }
        if textField == m24srNumberNdefTextField{
            let value:UInt8 = UInt8(ComStSt25sdkHelper_convertHexStringToIntWithNSString_(m24srNumberNdefTextField.text))+1
            descriptionTextView.text = "M24SR configured with \(value) files(s)\n"
            
            if (mNdefFileWritable == true){
                m24SRndefFileNumberStackView.isHidden = false
                m24SRndefFileNumberPickerView.selectRow(Int(value)-1, inComponent: 0, animated: true)
            }else{
                warningAlert(message: "Number of files cannot be changed while some files are protected in RW.\nPlease remove the files protections first")
            }
            
            return false
        }


        // Common
        if textField == uidTextField{
            descriptionTextView.text = "IC's UID"
            return false
        }

        if textField == memorySizeTextField{
            descriptionTextView.text = "IC's Memory size"
            return false
        }

        if textField == icRefTextField{
            descriptionTextView.text = "IC's Product Code"
            return false
        }
        
        

        
        return true
    }
    
    override func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == updateGpoTextField ){
            st25TAGpoTextField.text = updateGpoTextField.text
            st25TAGpoTextField.textColor = UIColor.stRedColor()
            updateGPOConfigButton.alpha = 1
            updateGPOConfigButton.isEnabled = true

        }
        
        if (textField == eventCounterTextField){
            st25TAEventCounterTextField.text = eventCounterTextField.text
            st25TAEventCounterTextField.textColor = UIColor.stRedColor()
            updateEventCounterButton.alpha = 1
            updateEventCounterButton.isEnabled = true

        }

    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Limit number of TextField Entry
        var maxLen:UInt8 = 2 // By default
        
        var handleTextField:Bool = true

        // Field Length
        if textField == updateGpoTextField {
            maxLen = 2
            updateGPOConfigButton.alpha = 0.5
            updateGPOConfigButton.isEnabled = false

        }else if textField == eventCounterTextField {
            maxLen = 2
            updateEventCounterButton.alpha = 0.5
            updateEventCounterButton.isEnabled = false

        }else{
            handleTextField = false
        }
        
        
        if (handleTextField == true){
            
            // We ignore any change that doesn't add characters to the text field.
            // These changes are things like character deletions and cuts, as well
            // as moving the insertion point.
            //
            // We still return true to allow the change to take place.
            if string.count == 0 {
                return true
            }
            
            // Check to see if the text field's contents still fit the constraints
            // with the new content added to it.
            // If the contents still fit the constraints, allow the change
            // by returning true; otherwise disallow the change by returning false.
            let currentText = textField.text ?? ""
            let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
            
            // Regx For XXX textField : only accept Hex Values
            let range = NSRange(location: 0, length: string.utf8.count)
            let regex = try! NSRegularExpression(pattern: "[A-Fa-f0-9]")
            return prospectiveText.count <= maxLen && regex.firstMatch(in: string, options: [], range: range) != nil
        } else {
            return true
        }
        
    }
}

extension ST25Type4aSystemFileEditorViewController: UIPickerViewDataSource, UIPickerViewDelegate {
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
        self.mNewNdefFileNumber = Int(self.mNdefFileNumberPickerView[row])!-1
        
        if (self.mNewNdefFileNumber != self.mCurrentNdefFileNumber){
            m24srNumberNdefTextField.textColor = UIColor.stRedColor()
        }else{
            m24srNumberNdefTextField.textColor = UIColor.stDarkBlueColor()
        }
        m24srNumberNdefTextField.text = String(format: "%.2X",Int(self.mNdefFileNumberPickerView[row])!-1)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "System", size: 17)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = mNdefFileNumberPickerView[row]
        pickerLabel?.textColor = UIColor.stDarkBlueColor()

        return pickerLabel!
    }
}

extension ST25Type4aSystemFileEditorViewController: tagReaderSessionViewControllerDelegate {
   
    func handleTag(st25SDKTag: ComStSt25sdkNFCTag, uid: Data!) throws {
        self.mTag = st25SDKTag
        if (self.mTag is ComStSt25sdkType4aSt25taST25TATag || self.mTag is ComStSt25sdkType4aM24srtahighdensityM24SRTAHighDensityTag) {
            self.mUid = uid
            if self.isSameTag(uid: uid) {
                switch mTaskToDo {
                case .readSystemFile:
                    readSystemFile()
                    checkReadWriteAccess()
                case .updateST25TAGpoConfig:
                    updateST25TAGpoConfig()
                case .updateST25TAEventCounterConfig:
                    updateST25TAEventCounterConfig()
                case .updatem24SRNDEFFileNumber:
                    updatem24SRNDEFFileNumber()
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
        self.warningAlert(message: stException.description())
    }

}
