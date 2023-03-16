//
//  ST25TNANDEFUrlRecordViewController.swift
//  NFCTap 
//
//  Created by STMicroelectronics on 29/10/2020.
//  Copyright © 2020 STMicroelectronics. All rights reserved.
//

import Foundation


class ST25TNANDEFUrlRecordViewController: ST25NDEFUrlRecordViewController {
    
    internal var miOSReaderSession:iOSReaderSession!

    internal var mTag:ComStSt25sdkNFCTag!
    internal var mST25TNTag:ST25TNTag!


    internal var mUid:Data!
    internal var mCustomMessage:String!
    internal var mTapCode:String = ""

    internal var mAndefSeparatorAppended:Bool!
    internal var mAndefSeparator:String!
    internal var mAndefCustomMsgAppended:Bool!
    internal var mAndefUniqueTapCodeAppended:Bool!

    internal var mANDEFStartOffset:Int!
    internal var mUriWithoutANDEF:String = ""
    
    internal var mAndefDataSize:Int!
    
    //switchs process values used on Tag write
    private var mCustomMsgSwitchisOn :Bool!
    private var mTapCodeSwitchisOn :Bool!


    enum taskToDo {
        case initANDEF
        case updateANDEF
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
    
    
    @IBOutlet weak var andefSwitch: UISwitch!
    @IBAction func handleAndefSwitch(_ sender: UISwitch) {
    }
    
    
    @IBOutlet weak var separatorSwitch: UISwitch!
    @IBAction func handleSeparatorSwitch(_ sender: UISwitch) {
    }
    
    // separator
    @IBOutlet weak var separatorTextField: UITextField!
   
    @IBAction func separatorTextFieldChanged(_ sender: UITextField) {
        separatorFieldTapCode.text = sender.text
        mAndefSeparator = separatorFieldTapCode.text
        updateGeneratedUrlMessageAndSize()
    }
    
    // switchs
    @IBOutlet weak var customMsgSwitch: UISwitch!
    @IBOutlet weak var tapCodeSwitch: UISwitch!
    
    // switchs action
   @IBAction func customMsgSwitchChanged(_ sender: UISwitch) {
        manageFieldSwitch(sender: sender, button: customMsgButton, separator: separatorFieldTapCode)
        if (!customMsgSwitch.isOn || !tapCodeSwitch.isOn){
            separatorFieldTapCode.isHidden = true
        }else{
            separatorFieldTapCode.isHidden = false
        }
        updateGeneratedUrlMessageAndSize()

    }
    
    @IBAction func tapCodeSwitchChanged(_ sender: UISwitch) {
        manageFieldSwitch(sender: sender, button: tapCodeButton, separator: separatorFieldTapCode)
        if (!customMsgSwitch.isOn || !tapCodeSwitch.isOn){
            separatorFieldTapCode.isHidden = true
        }else{
            separatorFieldTapCode.isHidden = false
        }
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
        presentCustomMsgConfigurationController()
    }
    
    
    @IBOutlet weak var tapCodeButton: UIButton!
    @IBAction func tapCodeButtonAction(_ sender: UIButton) {
        displayInformation(title: "Tap code field content:", message: mTapCode)
    }
            
    // separator Label
    @IBOutlet weak var separatorFieldTapCode: UILabel!
    
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
        miOSReaderSession.startTagReaderSession()
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
        
    private func presentCustomMsgConfigurationController() {
        let mST25TVCCustomMsgConfigurationVC:ST25TVCCustomMsgConfigurationViewController = UIStoryboard(name: "ST25TVCANDEFUriConfiguration", bundle: nil).instantiateViewController(withIdentifier: "ST25TVCCustomMsgConfiguration") as! ST25TVCCustomMsgConfigurationViewController
        // Comment next line as it causes an issue when hitting "..." in tab bar
        mST25TVCCustomMsgConfigurationVC.setTitle("Custom Message Configuration")
        mST25TVCCustomMsgConfigurationVC.setCustomMessageLength(length: 14)
        mST25TVCCustomMsgConfigurationVC.setMessage("Please enter 14 ASCII characters")

        mST25TVCCustomMsgConfigurationVC.mCustomMessage = mCustomMessage
        mST25TVCCustomMsgConfigurationVC.delegate = self
        mST25TVCCustomMsgConfigurationVC.setCustomMessageLength(length: 14)
        self.present(mST25TVCCustomMsgConfigurationVC, animated: false, completion: nil)
    }
    
    private func initANDEF(withAreaProtection : Bool){
        readIfAndefEnabled()
        
        // MUST be read before others
        readSupportedFeatures()
        
        readConf()
        
        readTapCode()
        
        updateUI()
        
        readNDEFIfAny()
        
        UIHelper.UI {
            self.updateGeneratedUrlMessageAndSize()
        }
    }
    

    private func readNDEFIfAny(){
        var mNdefMsg = mST25TNTag.readNdefMessage()
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
                            let payloadOffsetInMemory = payloadOffsetInURIRecord + 18
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
    }
    
    private func readIfAndefEnabled(){
        // TODO : not supported yet mST25TNTag.isAndefEnabled()
        mANDEFStartOffset = Int(mST25TNTag.getAndefStartAddressInBytes())
    }
            
    private func readTapCode(){
        // Should not be visible on UI
        mTapCode = "XXX"
    }
    
    private func readCustomMessage(){
        mAndefCustomMsgAppended = mST25TNTag.isAndefCustomMsgEnabled()
        mCustomMessage = mST25TNTag.getAndefCustomMsg()
    }
    private func readSeparatorMessage(){
       // TODO mST25TNTag.isAndefSeparatorEnabled()
        mAndefSeparator = mST25TNTag.getAndefSeparator()
    }
    
    private func readConf(){
        readSeparatorMessage()
        readCustomMessage()
        // TODO : nit supported yet mST25TNTag.isAndefUidEnabled()
        mAndefUniqueTapCodeAppended = mST25TNTag.isUniqueTapCodeEnabled()
    }
    
    private func updateUI(){
        
        UIHelper.UI {
            // remove items if features not supported
            // Supported features or not

            //switchs
            self.customMsgSwitch.isOn = self.mAndefCustomMsgAppended
            self.tapCodeSwitch.isOn = self.mAndefUniqueTapCodeAppended
            
            // Button
            self.customMsgButton.isHidden = !self.customMsgSwitch.isOn
            self.tapCodeButton.isHidden = !self.tapCodeSwitch.isOn

            //Separator
            self.separatorTextField.text = self.mAndefSeparator
            self.separatorFieldTapCode.text = self.mAndefSeparator
            self.separatorFieldTapCode.isHidden = !self.customMsgSwitch.isOn
            
            // update Generated url
            self.updateGeneratedUrlMessageAndSize()
        }
    }
    
    private func readSwitchsUIValues() {
        //switchs
        self.mCustomMsgSwitchisOn = self.customMsgSwitch.isOn
        self.mTapCodeSwitchisOn = self.tapCodeSwitch.isOn
    }

    private func updateANDEF(withAreaProtection: Bool){
        writeANDEFConfigOnTag()
        // write URI.....
        mST25TNTag.writeAndefUri(with: self.mComStSt25sdkNdefUriRecord)
    }
    
    private func updateANDEFWithoutPwd(){
        updateANDEF(withAreaProtection: false)
    }
    
    private func writeANDEFConfigOnTag(){
        var message : String = ""

        mST25TNTag.setAndefSeparatorWith(mAndefSeparator)
        mAndefSeparatorAppended = true
                
        if mCustomMsgSwitchisOn != mAndefCustomMsgAppended {
            mST25TNTag.enableAndefCustomMsg(withBoolean: mCustomMsgSwitchisOn)
            mST25TNTag.setAndefCustomMsgWith(mCustomMessage)
            mAndefCustomMsgAppended = mCustomMsgSwitchisOn
        }
        
        if mTapCodeSwitchisOn != mAndefUniqueTapCodeAppended {
            mST25TNTag.enableUniqueTapCode(withBoolean: mTapCodeSwitchisOn)
            mAndefUniqueTapCodeAppended = mTapCodeSwitchisOn
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
        
        if true {
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
        } else {
            myMessage = myMessage + getGeneratedStringforANDEFUrl(mySwitch: customMsgSwitch)
            myMessage = myMessage + getGeneratedStringforANDEFUrl(mySwitch: tapCodeSwitch)
        }
        mAndefDataSize = myMessage.count
        return myAndefPrefix + myMessage
    }
    
    private func getGeneratedStringforANDEFUrl(mySwitch: UISwitch) -> String {
        if mySwitch.isOn == true {
            switch mySwitch {
            case customMsgSwitch:
                return mCustomMessage
            case tapCodeSwitch:
                return mTapCode
            default:
                return ""
            }
        } else {
            return ""
        }
    }
}



extension ST25TNANDEFUrlRecordViewController: ST25TVCCustomMsgConfigurationDelegate {
    
    func okButtonTapped(customMessage: String) {
        mCustomMessage = customMessage
    }
    
    func cancelButtonTapped() {
    }
    
}

extension ST25TNANDEFUrlRecordViewController: tagReaderSessionViewControllerDelegate {
    
    func handleTag(st25SDKTag: ComStSt25sdkNFCTag, uid: Data!) throws {
        self.mTag = st25SDKTag
        if (self.mTag is ST25TNTag){
            self.mUid = self.mTag.getUid()?.toNSData()
            self.mST25TNTag = self.mTag as? ST25TNTag
            self.mUid = uid
            if self.isSameTag(uid: uid) {
                switch mTaskToDo {
                case .initANDEF:
                    initANDEF(withAreaProtection: false)
                case .updateANDEF:
                    updateANDEFWithoutPwd()
                }
            } else {
                
                UIHelper.UI() {
                    self.warningAlert(message: "Tag has changed, please scan again the Tag ...")
                }
            }
        }else{
            UIHelper.UI() {
                self.warningAlert(message: "This is not a ST25TN Tag")
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
