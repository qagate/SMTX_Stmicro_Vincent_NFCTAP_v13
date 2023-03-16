//
//  ST25TVCANDEFUrlRecordViewController.swift
//  NFCTap 
//
//  Created by STMicroelectronics on 29/10/2020.
//  Copyright © 2020 STMicroelectronics. All rights reserved.
//

import Foundation


class ST25TVCANDEFUrlRecordViewController: ST25NDEFUrlRecordViewController {
    
    internal var miOSReaderSession:iOSReaderSession!
    internal var mPwd:Data!
    internal var mAreaReadPwd:Data!
    internal var mAreaWritePwd:Data!

    internal var mTag:ComStSt25sdkNFCTag!
    internal var mST25TVCTag:ST25TVCTag!
    internal var mNumberOfAreas: Int8 = 1

    internal var mUid:Data!
    internal var mCustomMessage:String!
    // Tamper Messages status
    
    internal var tamperStatus:String = ""
    internal var tamperEvent:String = ""
    
    internal var mSignatureIOSByteArray:IOSByteArray!
    
    internal var mTapCode:String = ""

    internal var mAndefSeparatorAppended:Bool!
    internal var mAndefSeparator:String!
    internal var mAndefUIDAppended:Bool!
    internal var mAndefCustomMsgAppended:Bool!
    internal var mAndefUniqueTapCodeAppended:Bool!
    internal var mAndefTamperDetectMsgAppended:Bool!

    internal var mTamperDetectLockedField:Bool!
    internal var mAndefConfigurationLockedField:Bool!

    internal var mTamperDetectSupported:Bool!
    
    internal var mAndefEnabled:Bool!
    
    internal var mANDEFStartOffset:Int!
    internal var mUriWithoutANDEF:String = ""
    
    internal var mAndefDataSize:Int!
    
    //switchs process values used on Tag write
    private var mEnableANDEFSwitchisOn :Bool!
    private var mSeparatorSwitchisOn  :Bool!
    private var mUidSwitchisOn :Bool!
    private var mCustomMsgSwitchisOn :Bool!
    private var mTapCodeSwitchisOn :Bool!
    private var mTamperDetectSwitchisOn :Bool!

    enum taskToDo {
        case initANDEF
        case updateANDEF
        case initANDEFWithPwd
        case updateANDEFWithPwd
    }
    internal var mTaskToDo:taskToDo = .initANDEF
    
    @IBAction func validateANDEFToTag(_ sender: UIButton) {
        self.mTaskToDo = .updateANDEF
        // go the UI switchs values
        readSwitchsUIValues()
        // update uri content
        updateNDEFRecordMessage()
        
        miOSReaderSession = iOSReaderSession(atagReaderSessionViewControllerDelegate: self)
        miOSReaderSession.startTagReaderSession()
   }
    
    // Views for ANDEF features
    @IBOutlet weak var separatorView: UIStackView!
    
    @IBOutlet weak var selectANDEFFieldLabel: UILabel!
    @IBOutlet weak var switchsViews: UIView!
    
    @IBOutlet weak var andefStructureView: UIView!
    @IBOutlet weak var andefGeneratedView: UIStackView!
    
    
    // ANDEF switch
    @IBOutlet weak var mANDEFSwitch: UISwitch!
    @IBAction func enableANDEFSwitchAction(_ sender: UISwitch) {
        if sender.isOn {
            enableANDEFUI(enable: false)
        } else {
            enableANDEFUI(enable: true)

        }
    }
    private func enableANDEFUI(enable:Bool) {
        separatorView.isHidden = enable
        selectANDEFFieldLabel.isHidden = enable
        switchsViews.isHidden = enable
        andefStructureView.isHidden = enable
        andefGeneratedView.isHidden = enable

    }
    // separator
    @IBOutlet weak var separatorTextField: UITextField!
    @IBAction func separatorTextFieldChanged(_ sender: UITextField) {
        separatorFieldCustomMsg.text = sender.text
        separatorFieldTapCode.text = sender.text
        separatorFieldTamper.text = sender.text
    }
    @IBOutlet weak var separatorSwitch: UISwitch!
    @IBAction func separatorSwitchAction(_ sender: UISwitch) {
        if sender.isOn {
            separatorFieldCustomMsg.isHidden = false
            separatorFieldTapCode.isHidden = false
            separatorFieldTamper.isHidden = false
            manageSwitchsWithSeparator()
            
        } else {
            separatorFieldCustomMsg.isHidden = true
            separatorFieldTapCode.isHidden = true
            separatorFieldTamper.isHidden = true
        }
        updateGeneratedUrlMessageAndSize()

    }
    
    // switchs
    @IBOutlet weak var uidSwitch: UISwitch!
    @IBOutlet weak var customMsgSwitch: UISwitch!
    @IBOutlet weak var tapCodeSwitch: UISwitch!
    @IBOutlet weak var tamperDetectSwitch: UISwitch!
    
    // switchs action
    
    @IBAction func uidSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            uidButton.isHidden = false
        } else {
            uidButton.isHidden = true
        }
        updateGeneratedUrlMessageAndSize()
        
    }
    
    @IBAction func customMsgSwitchChanged(_ sender: UISwitch) {
        manageFieldSwitch(sender: sender, button: customMsgButton, separator: separatorFieldCustomMsg)
        updateGeneratedUrlMessageAndSize()

    }
    
    @IBAction func tapCodeSwitchChanged(_ sender: UISwitch) {
        manageFieldSwitch(sender: sender, button: tapCodeButton, separator: separatorFieldTapCode)
        updateGeneratedUrlMessageAndSize()
        
    }
    
    @IBAction func tamperDetectSwitchChanged(_ sender: UISwitch) {
        manageFieldSwitch(sender: sender, button: tamperDetectButton, separator: separatorFieldTamper)
        updateGeneratedUrlMessageAndSize()

    }
    
    private func manageSwitchsWithSeparator() {
        manageFieldSwitch(sender: customMsgSwitch, button: customMsgButton, separator: separatorFieldCustomMsg)
        manageFieldSwitch(sender: tapCodeSwitch, button: tapCodeButton, separator: separatorFieldTapCode)
        manageFieldSwitch(sender: tamperDetectSwitch, button: tamperDetectButton, separator: separatorFieldTamper)
        updateGeneratedUrlMessageAndSize()

    }
    
    
    private func manageFieldSwitch(sender: UISwitch, button: UIButton, separator : UILabel) {
        if sender.isOn {
            button.isHidden = false
            separator.isHidden = false
        } else {
            button.isHidden = true
            separator.isHidden = true
        }
    }
    // buttons
    @IBOutlet weak var uidButton: UIButton!
    @IBAction func uidButtonAction(_ sender: UIButton) {
        displayInformation(title: "UID field content:", message: self.mUid.toHexString())
    }
    
        
    @IBOutlet weak var customMsgButton: UIButton!
    @IBAction func customMsgButtonAction(_ sender: UIButton) {
        if !mAndefConfigurationLockedField {
            presentCustomMsgConfigurationController()
        } else {
            displayInformation(title: "Custom message field :", message: "Configuration locked")
        }
    }
    
    
    @IBOutlet weak var tapCodeButton: UIButton!
    @IBAction func tapCodeButtonAction(_ sender: UIButton) {
        presentUniqueTapCodeConfigurationController()
    }
        
    @IBOutlet weak var tamperDetectButton: UIButton!
    @IBAction func tamperDetectButtonAction(_ sender: UIButton) {
        // check if conf locked
        if !mTamperDetectLockedField {
            presentTamperDetectConfigurationController()

        } else {
            displayInformation(title: "Tamper detect field :", message: "Configuration locked")
        }
    }
    
    // separator Label
    @IBOutlet weak var separatorFieldTamper: UILabel!
    @IBOutlet weak var separatorFieldTapCode: UILabel!
    @IBOutlet weak var separatorFieldCustomMsg: UILabel!
    
    
    @IBOutlet weak var mGeneratedUrlTextView: UITextView!
    
    @IBOutlet weak var mGeneratedUrlDataSizeTextField: UILabel!
    
    private func updateGeneratedUrlMessageAndSize() {
        self.mGeneratedUrlTextView.text = self.buildANDEFGeneratedUrl()
        self.mGeneratedUrlDataSizeTextField.text = String(mAndefDataSize)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        separatorTextField.delegate = self
        
        // Default custom message
        mCustomMessage = ""
        mGeneratedUrlTextView.isUserInteractionEnabled = false
        mGeneratedUrlTextView.textContainerInset = UIEdgeInsets.zero;
        mGeneratedUrlTextView.textContainer.lineFragmentPadding = 0;
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.mTaskToDo = .initANDEF
        miOSReaderSession = iOSReaderSession(atagReaderSessionViewControllerDelegate: self)
        presentPwdController()
        
    }
    
    private func presentPwdController() {
        let mST25PasswordVC:ST25PasswordViewController = UIStoryboard(name: "ST25Password", bundle: nil).instantiateViewController(withIdentifier: "ST25PasswordID") as! ST25PasswordViewController
        mST25PasswordVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        mST25PasswordVC.setTitle("Enter configuration password")
        mST25PasswordVC.setMessage("(32 bits hexadecimal format)")
        mST25PasswordVC.numberOfBytes = 4
        mST25PasswordVC.delegate = self
        self.present(mST25PasswordVC, animated: false, completion: nil)
    }
    
    private func setPwd() {
        mST25TVCTag.presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25tvcST25TVCTag_ST25TVC_CONFIGURATION_PASSWORD_ID), password: mPwd)
    }
 
    private func setReadPwdForArea() {
        mST25TVCTag.presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25tvcST25TVCTag_ST25TVC_AREA1_PASSWORD_ID  ), password: mAreaReadPwd)
    }
    private func setWritePwdForArea() {
        mST25TVCTag.presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25tvcST25TVCTag_ST25TVC_AREA1_PASSWORD_ID  ), password: mAreaWritePwd)
    }
    // Use this if you have a UITextField
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == separatorTextField {
            
            // get the current text, or use an empty string if that failed
            let currentText = textField.text ?? ""
            
            // attempt to read the range they are trying to change, or exit if we can't
            guard let stringRange = Range(range, in: currentText) else { return false }
            
            // add their new text to the existing text
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            // make sure the result is under 16 characters
            return updatedText.count <= 1
        } else {
            return true
        }
        
    }
    
    private func warningAlert(message : String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "ANDEF uri ", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func displayInformation(title: String, message : String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
  
    private func presentUniqueTapCodeConfigurationController() {
        let mST25TVCUTCViewControllerVC:ST25TVCUniqueTapCodeViewController = UIStoryboard(name: "ST25TVCUniqueTapCode", bundle: nil).instantiateViewController(withIdentifier: "ST25TVCUniqueTapCodeViewController") as! ST25TVCUniqueTapCodeViewController
        self.present(mST25TVCUTCViewControllerVC, animated: false, completion: nil)
    }

    private func presentTamperDetectConfigurationController() {
        let mST25TVCTamperViewControllerVC:ST25TVCTamperViewController = UIStoryboard(name: "ST25TVCTamper", bundle: nil).instantiateViewController(withIdentifier: "ST25TVCTamperViewController") as! ST25TVCTamperViewController
        // Comment next line as it causes an issue when hitting "..." in tab bar
        //mST25TVCTamperViewControllerVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        mST25TVCTamperViewControllerVC.delegate = self
        self.present(mST25TVCTamperViewControllerVC, animated: false, completion: nil)
    }
    
    private func presentCustomMsgConfigurationController() {
        let mST25TVCCustomMsgConfigurationVC:ST25TVCCustomMsgConfigurationViewController = UIStoryboard(name: "ST25TVCANDEFUriConfiguration", bundle: nil).instantiateViewController(withIdentifier: "ST25TVCCustomMsgConfiguration") as! ST25TVCCustomMsgConfigurationViewController
        // Comment next line as it causes an issue when hitting "..." in tab bar
        //mST25TVCCustomMsgConfigurationVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        mST25TVCCustomMsgConfigurationVC.setTitle("Custom Message Configuration")
        mST25TVCCustomMsgConfigurationVC.setCustomMessageLength(length: 8)
        mST25TVCCustomMsgConfigurationVC.setMessage("Please enter 8 ASCII characters")

        mST25TVCCustomMsgConfigurationVC.mCustomMessage = mCustomMessage
        mST25TVCCustomMsgConfigurationVC.delegate = self
        self.present(mST25TVCCustomMsgConfigurationVC, animated: false, completion: nil)
    }
    
    private func initANDEF(withAreaProtection : Bool){
        setPwd()
        
        readIfAndefEnabled()
        
        // MUST be read before others
        readSupportedFeatures()
        
        readLockedFields()
        readConf()
        
        readTamperStatus()
        readTapCode()
        
        updateUI()
        
        if withAreaProtection {
            setReadPwdForArea()
        }
        readNDEFIfAny()
        
        UIHelper.UI {
            self.updateGeneratedUrlMessageAndSize()
        }
    }
    

    private func readNDEFIfAny(){
        var mNdefMsg = mST25TVCTag.readNdefMessage()
        // retrieve uri data
        if ((mNdefMsg != nil && mNdefMsg!.getNbrOfRecords() <= 0) || mNdefMsg == nil ) {
            // ok .. default values
            UIHelper.UI {
                self.displayInformation(title: "ANDEF configuration", message: "No URI record found. Default values used")
            }

        }else{
            if (mNdefMsg != nil && mNdefMsg!.getNbrOfRecords() > 1){
                // No ANDEF when more than uri record
                UIHelper.UI {
                    self.displayInformation(title: "ANDEF configuration WARNING", message: "More than one record detected. \n Please delete non URI records first ! \nIf you continue, content will be lost on tag update")
                }

            } else {
                // one record uri or not
                if getURIRecord(ndefMsg: mNdefMsg!) {
                    // uri detected
                    UIHelper.UI {
                        self.updateNDEFRecordUI()
                        if self.mUriWithoutANDEF != "" {
                            self.mUrlTextField.text = String(self.mUriWithoutANDEF)
                        }
                    }

                } else {
                    // no uri
                    UIHelper.UI {
                        self.displayInformation(title: "ANDEF configuration WARNING", message: "One record detected but not a compatible one. \n Please delete non URI records first ! \nIf you continue, content will be lost on tag update")
                    }
                }
            }
        }
        
    }
    
    private func getURIRecord(ndefMsg: ComStSt25sdkNdefNDEFMsg) -> Bool{
        var uriDetected = false
        mUriWithoutANDEF = ""
        let nbRecords = ndefMsg.getNbrOfRecords()
        if nbRecords > 0 {
            for it in 0 ..< nbRecords{
                let rcd = ndefMsg.getNDEFRecord(with: it)
                switch (rcd)
                {
                case  is ComStSt25sdkNdefUriRecord :
                    // Check URI type and call dedicated function
                    let ndefUriRecord = NDEFUriRecords(ndefRecord: (rcd as! ComStSt25sdkNdefUriRecord))
                    switch ndefUriRecord.NDEFUriRecordsType {
                    case .kUrl :
                        uriDetected = true
                        self.mComStSt25sdkNdefUriRecord = rcd as! ComStSt25sdkNdefUriRecord
                        let mNdefBytes = ndefMsg.serialize()
                        let mCurrentPayload = self.mComStSt25sdkNdefUriRecord.getPayload()
                        var payloadOffsetInURIRecord = findSubArrayPosition(arrayToSearch: mNdefBytes!, patternToFind: mCurrentPayload!)
                        
                        if payloadOffsetInURIRecord != -1 {
                            // Prefix ID
                            payloadOffsetInURIRecord = payloadOffsetInURIRecord + 1
                            // CC File + 2 bytes for NDEF Header
                            let payloadOffsetInMemory = payloadOffsetInURIRecord + 6
                            if (mANDEFStartOffset < payloadOffsetInMemory) {
                                // Warning invalid start offset
                                print("ANDEF Warning invalid start offset \n")
                                uriDetected = false
                                return uriDetected
                            }
                            let nbOfBytesToKeep = mANDEFStartOffset - payloadOffsetInMemory
                            let uri = mComStSt25sdkNdefUriRecord.getContent()
                            self.mUriWithoutANDEF = String((uri?.prefix(nbOfBytesToKeep))!)
                        }
                    default:
                        uriDetected = false
                    }
                    break
                                        
                default:
                    break
                }
                
            }
        }
        return uriDetected
    }
    
    public func  findSubArrayPosition(arrayToSearch: IOSByteArray , patternToFind: IOSByteArray) -> Int {
        let arrayToSearchToNSData = arrayToSearch.toNSData()!
        let patternToFindToNSData = patternToFind.toNSData()!

        //for( i = 0; i < arrayToSearch.length - patternToFind.length+1; ++i)
        for i in 0..<arrayToSearchToNSData.count - patternToFindToNSData.count + 1 {
            var found = true;
            
            for j in 0..<patternToFindToNSData.count {
            //for(int j = 0; j < patternToFind.length; ++j) {
                if (arrayToSearchToNSData [i+j] != patternToFindToNSData[j]) {
                    found = false;
                    break;
                }
            }
            if (found) {
                return i
            }
        }
        return -1;
    }
    

    private func readSupportedFeatures(){
        // WARNING - to be completed when API available
       self.mTamperDetectSupported  = mST25TVCTag.isTamperDetectSupported()
    }
    
    private func readIfAndefEnabled(){
        mAndefEnabled = mST25TVCTag.isAndefEnabled()
        mANDEFStartOffset = Int(mST25TVCTag.getAndefStartAddressInBytes())
        
    }
    
    private func readTamperStatus(){
        if self.mTamperDetectSupported {
            self.tamperStatus = mST25TVCTag.getTamperDetectLoopStatusString()
            self.tamperEvent  = mST25TVCTag.getTamperDetectEventStatusString()
        }
    }
        
    private func readTapCode(){
        mTapCode = mST25TVCTag.readUniqueTapCode()
    }
    
    private func readLockedFields(){
        if mTamperDetectSupported {
            mTamperDetectLockedField = mST25TVCTag.isTamperDetectConfigurationLocked()
        }
        mAndefConfigurationLockedField = mST25TVCTag.isAndefConfigurationLocked()
    }
    
    private func readCustomMessage(){
        mAndefCustomMsgAppended = mST25TVCTag.isAndefCustomMsgEnabled()
        if (!mAndefConfigurationLockedField) {
            mCustomMessage = mST25TVCTag.getAndefCustomMsg()
        } else {
            mCustomMessage = "????????"
        }
    }
    private func readSeparatorMessage(){
        mAndefSeparatorAppended = mST25TVCTag.isAndefSeparatorEnabled()
        if (!mAndefConfigurationLockedField) {
            mAndefSeparator = mST25TVCTag.getAndefSeparator()
        } else {
            mAndefSeparator = "?"
        }
    }
    private func readConf(){
        readSeparatorMessage()
        readCustomMessage()

        mAndefUIDAppended = mST25TVCTag.isAndefUidEnabled()
        mAndefUniqueTapCodeAppended = mST25TVCTag.isUniqueTapCodeEnabled()
        
        if mTamperDetectSupported {
            mAndefTamperDetectMsgAppended = mST25TVCTag.isAndefTamperDetectMsgEnabled()
        } else {
            mAndefTamperDetectMsgAppended = false
        }
                
        // read memory configuration for PWD area
        mNumberOfAreas = Int8(mST25TVCTag.getNumberOfAreas())
        
    }
    
    private func updateUI(){
        
        UIHelper.UI {
            // remove items if features not supported
            // Supported features or not

           if !self.mTamperDetectSupported {
                self.tamperDetectSwitch.isOn = false
                self.mTamperDetectSwitchisOn = false
                self.tamperDetectSwitch.visibility = UIView.Visibility.invisible
                self.tamperDetectButton.isHidden = true
            } else {
                self.tamperDetectSwitch.isOn = self.mAndefTamperDetectMsgAppended
            }
            
            // ANDEF enabled ?
            self.mANDEFSwitch.isOn = self.mAndefEnabled
            self.enableANDEFUI(enable: !self.mAndefEnabled)
            
            //switchs
            self.separatorSwitch.isOn = self.mAndefSeparatorAppended
            self.uidSwitch.isOn = self.mAndefUIDAppended
            self.customMsgSwitch.isOn = self.mAndefCustomMsgAppended
            self.tapCodeSwitch.isOn = self.mAndefUIDAppended

            
            //Separator
            self.separatorTextField.text = self.mAndefSeparator
            
            
            // update Configuration buttons
            self.manageSwitchsWithSeparator()
            self.uidSwitchChanged(self.uidSwitch)
            
            // update Generated url
            self.updateGeneratedUrlMessageAndSize()

            
        }
    }
    
    private func readSwitchsUIValues() {
        //switchs
        self.mEnableANDEFSwitchisOn = self.mANDEFSwitch.isOn
        self.mSeparatorSwitchisOn = self.separatorSwitch.isOn
        self.mUidSwitchisOn = self.uidSwitch.isOn
        self.mCustomMsgSwitchisOn = self.customMsgSwitch.isOn
        self.mTapCodeSwitchisOn = self.tapCodeSwitch.isOn
        self.mTamperDetectSwitchisOn = self.tamperDetectSwitch.isOn
    }

    
    private func updateANDEF(withAreaProtection: Bool){
        if !mAndefConfigurationLockedField {
            setPwd()
            writeANDEFConfigOnTag()
            // write URI.....
            if withAreaProtection {
                setWritePwdForArea()
            }
            if mAndefEnabled {
                mST25TVCTag.writeAndefUri(with: self.mComStSt25sdkNdefUriRecord)
            } else {
                var myNdefMsg = ComStSt25sdkNdefNDEFMsg(comStSt25sdkNdefNDEFRecord: self.mComStSt25sdkNdefUriRecord)
                mST25TVCTag.writeNdefMessage(with: myNdefMsg)
            }
        } else {
            UIHelper.UI { [self] in
            displayInformation(title: "ANDEF configuration", message: "Configuration locked !")
            }
        }
    }
    private func updateANDEFWithoutPwd(){
        updateANDEF(withAreaProtection: false)
    }
    private func updateANDEFWithPwd(){
        updateANDEF(withAreaProtection: true)
    }
    
    private func writeANDEFConfigOnTag(){
        var message : String = ""
        if mEnableANDEFSwitchisOn != mAndefEnabled {
            if !mAndefConfigurationLockedField {
                mST25TVCTag.enableAndef(withBoolean: mEnableANDEFSwitchisOn)
                mAndefEnabled = mEnableANDEFSwitchisOn
            } else {
                message = message + "Update Enable ANDEF field failed - Configuration locked \n"
                
            }

        }
        if mSeparatorSwitchisOn != mAndefSeparatorAppended {
            mST25TVCTag.setAndefSeparatorWith(mAndefSeparator)
            mST25TVCTag.enableAndefSeparator(withBoolean: mSeparatorSwitchisOn)
            mAndefSeparatorAppended = mSeparatorSwitchisOn
        }
        if mUidSwitchisOn  != mAndefUIDAppended {
            mST25TVCTag.enableAndefUid(withBoolean: mUidSwitchisOn)
            mAndefUIDAppended = mUidSwitchisOn
        }
                
        if mCustomMsgSwitchisOn != mAndefCustomMsgAppended {
            mST25TVCTag.enableAndefCustomMsg(withBoolean: mCustomMsgSwitchisOn)
            mST25TVCTag.setAndefCustomMsgWith(mCustomMessage)
            mAndefCustomMsgAppended = mCustomMsgSwitchisOn
        }
        
        if mTapCodeSwitchisOn != mAndefUniqueTapCodeAppended {
            mST25TVCTag.enableAndefUniqueTapCode(withBoolean: mTapCodeSwitchisOn)
            mAndefUniqueTapCodeAppended = mTapCodeSwitchisOn
        }
        

        if mTamperDetectSwitchisOn != mAndefTamperDetectMsgAppended {
            if !mTamperDetectLockedField {
                mST25TVCTag.enableAndefTamperDetectMsg(withBoolean: mTamperDetectSwitchisOn)
                mAndefTamperDetectMsgAppended = mTamperDetectSwitchisOn
            } else {
                    message = message + "Update Tamper detect field failed - Tamper configuration locked \n"
            }
        }
        if message != "" {
            displayInformation(title: "ANDEF write configuration", message: message)
        }
        
    }
    
    // Needed to handle url on server
    private func addQuestionMarktoURI() {
        let txt = mUrlTextField.text!
        if !txt.contains("?") {
            mUrlTextField.text = txt+"?data="
        }
    }
    
    public override func updateNDEFRecordMessage() -> ComStSt25sdkNdefUriRecord {
        
        // Create ST25SDK NDEF URI
        mComStSt25sdkNdefUriRecord = ComStSt25sdkNdefUriRecord()
        let uriIdCode = ComStSt25sdkNdefUriRecord_NdefUriIdCode_fromOrdinal(UInt(mIndexListScheme)) as ComStSt25sdkNdefUriRecord_NdefUriIdCode
        mComStSt25sdkNdefUriRecord.setUriIDWith(uriIdCode)
        addQuestionMarktoURI()
        mComStSt25sdkNdefUriRecord.setContentWith(mUrlTextField.text)
        return mComStSt25sdkNdefUriRecord
    }

    
    private func buildANDEFGeneratedUrl() -> String{
        var myMessage:String = ""
        var myAndefPrefix: String = ""
        if mComStSt25sdkNdefUriRecord != nil {
            let ndefCode = mComStSt25sdkNdefUriRecord.getUriID()
            let indexListScheme = Int(ComStSt25sdkNdefUriRecord.getUriCodePositionInList(with: ndefCode!))
            myAndefPrefix = mListScheme[indexListScheme]
        } else {
            myAndefPrefix = mListScheme[1]
        }
        myAndefPrefix = myAndefPrefix + mUrlTextField.text!
        
        // add question mark to uri
        //myMessage = myMessage + "?"
        
        
        myMessage = myMessage + getGeneratedStringforANDEFUrl(mySwitch: uidSwitch)
        
        if separatorSwitch.isOn == true {
            var tmp:String = ""
            tmp = getGeneratedStringforANDEFUrl(mySwitch: customMsgSwitch)
            if tmp != "" {
                if myMessage != "" {
                    myMessage = myMessage + mAndefSeparator + tmp
                } else {
                    myMessage = myMessage + tmp
                }
                
            }
            
            tmp = getGeneratedStringforANDEFUrl(mySwitch: tapCodeSwitch)
            if tmp != "" {
                if myMessage != "" {
                    myMessage = myMessage + mAndefSeparator + tmp
                } else {
                    myMessage = myMessage + tmp
                }
            }
                        
            tmp = getGeneratedStringforANDEFUrl(mySwitch: tamperDetectSwitch)
            if tmp != "" {
                if myMessage != "" {
                    myMessage = myMessage + mAndefSeparator + tmp
                } else {
                    myMessage = myMessage + tmp
                }
            }
        } else {
            myMessage = myMessage + getGeneratedStringforANDEFUrl(mySwitch: customMsgSwitch)
            myMessage = myMessage + getGeneratedStringforANDEFUrl(mySwitch: tapCodeSwitch)
            myMessage = myMessage + getGeneratedStringforANDEFUrl(mySwitch: tamperDetectSwitch)
            
        }
        mAndefDataSize = myMessage.count
        return myAndefPrefix + myMessage
    }
    
    private func getGeneratedStringforANDEFUrl(mySwitch: UISwitch) -> String {
        if mySwitch.isOn == true {
            switch mySwitch {
            case uidSwitch:
                return mUid.hexEncodedString().uppercased()
            case customMsgSwitch:
                return mCustomMessage
            case tapCodeSwitch:
                return mTapCode
            case tamperDetectSwitch:
                return self.tamperEvent + self.tamperStatus
            default:
                return ""
            }
        } else {
            return ""
        }
    }
    
    
    private func getCurrentPwdForArea(type : String) {
        let mST25PasswordVC:ST25PasswordViewController = UIStoryboard(name: "ST25Password", bundle: nil).instantiateViewController(withIdentifier: "ST25PasswordID") as! ST25PasswordViewController
        mST25PasswordVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        // ANDEF MUST be on area 1
        mST25PasswordVC.setTitle("Enter current \(type) area 1 password")
        
        if mTag is ST25TVCTag {
            if  self.mNumberOfAreas == 2 {
                mST25PasswordVC.setMessage("(32 bits hexadecimal format)")
                mST25PasswordVC.numberOfBytes = 4
            } else {
                mST25PasswordVC.setMessage("(64 bits hexadecimal format)")
                mST25PasswordVC.numberOfBytes = 8
            }
        } else {
            UIHelper.UI() {
                self.warningAlert(message: "Tag doesn't support this feature")
            }
            
            return
        }
        
        mST25PasswordVC.delegate = self
        self.present(mST25PasswordVC, animated: false, completion: nil)
    }

}

extension ST25TVCANDEFUrlRecordViewController: ST25TVCCustomMsgConfigurationDelegate {
    
    func okButtonTapped(customMessage: String) {
        mCustomMessage = customMessage
    }
    
    func cancelButtonTapped() {
        
    }
    
}

extension ST25TVCANDEFUrlRecordViewController: ST25TVCTamperViewControllerDelegate {
    func okButtonTapped(tamperStatus: String, tamperHistory: String) {
        self.tamperEvent = tamperHistory
        self.tamperStatus = tamperStatus
        self.updateGeneratedUrlMessageAndSize()
        self.dismiss(animated: false, completion: nil)
    }
}

extension ST25TVCANDEFUrlRecordViewController: ST25PasswordViewDelegate {
    func okButtonTapped(pwdValue: Data) {
        if mTaskToDo == .initANDEFWithPwd {
            self.mAreaReadPwd = pwdValue
            self.miOSReaderSession.startTagReaderSession()

        } else if mTaskToDo == .updateANDEFWithPwd {
            self.mAreaWritePwd = pwdValue
            self.miOSReaderSession.startTagReaderSession()

        } else {
            self.mPwd = pwdValue
            self.miOSReaderSession.startTagReaderSession()
        }
    }
    
}


extension ST25TVCANDEFUrlRecordViewController: tagReaderSessionViewControllerDelegate {
    
    func handleTag(st25SDKTag: ComStSt25sdkNFCTag, uid: Data!) throws {
        self.mTag = st25SDKTag
        if (self.mTag is ST25TVCTag){
            self.mUid = self.mTag.getUid()?.toNSData()
            self.mST25TVCTag = self.mTag as? ST25TVCTag
            self.mUid = uid
            if self.isSameTag(uid: uid) {
                switch mTaskToDo {
                case .initANDEF:
                    initANDEF(withAreaProtection: false)
                case .updateANDEF:
                    updateANDEFWithoutPwd()
                case .initANDEFWithPwd:
                    initANDEF(withAreaProtection: true)
                case .updateANDEFWithPwd:
                    updateANDEFWithPwd()
                }
            } else {
                
                UIHelper.UI() {
                    self.warningAlert(message: "Tag has changed, please scan again the Tag ...")
                }
            }
        }else{
            UIHelper.UI() {
                self.warningAlert(message: "This is not a ST25TVC gitTag")
            }
        }
        
    }
    
    func handleTagSessionError(didInvalidateWithError error: Error) {
    }
    
    func handleTagST25SdkError(didInvalidateWithError error: NSException) {
        //self.warningAlert(message: error.description)
        if error is ComStSt25sdkSTException {
            let errorST25SDK = error as! ComStSt25sdkSTException
            
            if self.mTaskToDo == .initANDEF{
                if (errorST25SDK.getMessage()?.contains(ComStSt25sdkSTException_STExceptionCode.PASSWORD_NEEDED.description()))! ||
                    (errorST25SDK.getMessage()?.contains(ComStSt25sdkSTException_STExceptionCode.ISO15693_BLOCK_PROTECTED.description()))!
                    {
                    UIHelper.UI() {
                        self.mTaskToDo = .initANDEFWithPwd
                        self.getCurrentPwdForArea(type: "read")
                    }
                    
                } else {
                    UIHelper.UI() {
                        self.warningAlert(message: "Command failed: \(error.description)")
                    }
                }
            }
            if self.mTaskToDo == .updateANDEF {
                //            print("Error SDK \(errorST25SDK)")
                //            print("Error SDK \(errorST25SDK.getError())")
                //            print("Error SDK \(errorST25SDK.getMessage())")
                if ((errorST25SDK.getMessage()?.contains(ComStSt25sdkSTException_STExceptionCode.PASSWORD_NEEDED.description()))! ||
                    (errorST25SDK.getMessage()?.contains(ComStSt25sdkSTException_STExceptionCode.ISO15693_BLOCK_IS_LOCKED.description()))!){
                    UIHelper.UI() {
                        self.mTaskToDo = .updateANDEFWithPwd
                        self.getCurrentPwdForArea(type: "write")
                    }
                } else {
                    UIHelper.UI() {
                        self.warningAlert(message: "Command failed: \(error.description)")
                    }
                }
                
            }

        } else {
            // NSException
            print(error.reason)
        }
    }
    
}
