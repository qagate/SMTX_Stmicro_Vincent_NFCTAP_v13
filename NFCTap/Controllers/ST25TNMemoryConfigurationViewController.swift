//
//  ST25TNMemoryConfigurationViewController.swift
//  NFCTap 
//
//  Created by STMICROELECTRONICS on 20/07/2021.
//  Copyright © 2021 STMicroelectronics. All rights reserved.
//

import UIKit

class ST25TNMemoryConfigurationViewController: ST25UIViewController {
    
    // NFC & Tags infos
    internal var miOSReaderSession:iOSReaderSession!
    internal var mTag:ComStSt25sdkNFCTag!
    internal var mST25TNTag:ST25TNTag!
    internal var mUid:Data!

    enum taskToDo {
        case readConf
        case writeConf
        case checkTLV
        case setTLV
    }
    internal var mTaskToDo:taskToDo = .readConf
    
    // ST25TN
    internal var mCurrentMemoryConfiguration:ComStSt25sdkType2St25tnST25TNTag_ST25TNMemoryConfiguration = ComStSt25sdkType2St25tnST25TNTag_ST25TNMemoryConfiguration.INVALID_MEMORY_CONFIGURATION
    
    internal var mSelectedMemoryConfiguration:ComStSt25sdkType2St25tnST25TNTag_ST25TNMemoryConfiguration = ComStSt25sdkType2St25tnST25TNTag_ST25TNMemoryConfiguration.INVALID_MEMORY_CONFIGURATION



    @IBOutlet weak var myView: UIView!
    
    @IBOutlet weak var defaultModeImageView: UIImageView!
    @IBOutlet weak var mode1ImageView: UIImageView!
    @IBOutlet weak var mode2ImageView: UIImageView!
    
    @IBOutlet weak var T2THeaderLabel: UILabel!
    @IBOutlet weak var TLVsArea1Label: UILabel!
    @IBOutlet weak var SystemArea1Label: UILabel!
    @IBOutlet weak var TLVsArea2Label: UILabel!
    @IBOutlet weak var SystemArea2Label: UILabel!
    
    @IBOutlet weak var checkTLVButton: UIButton!
    @IBOutlet weak var writeConfButton: UIButton!
    
    @IBOutlet weak var selectedTagConfigurationTextView: UITextView!
    @IBOutlet weak var writeConfigurationWarningTextView: UITextView!
    
    @IBOutlet weak var T2THeaderSizeInBytesLabel: UILabel!
    @IBOutlet weak var T2THeaderSizeInBlocksLabel: UILabel!
    
    @IBOutlet weak var TLVsAreaSizeInBytes: UILabel!
    @IBOutlet weak var TLVsAreaSizeInBlocks: UILabel!

    @IBOutlet weak var SystemAreaInBytesLabel: UILabel!
    @IBOutlet weak var SystemAreaInBlocksLabel: UILabel!
    
  
    @IBOutlet weak var TotalInBytesLabel: UILabel!
    @IBOutlet weak var TotalInBlocksLabel: UILabel!
    
    @IBAction func handleDefaultMode(_ sender: Any) {
        defaultMode()
        mSelectedMemoryConfiguration = ComStSt25sdkType2St25tnST25TNTag_ST25TNMemoryConfiguration.TLVS_AREA_160_BYTES
    }
    private func defaultMode(){
        UIHelper.UI { [self] in
           updateUIForTLVSArea160Bytes()
            switch mCurrentMemoryConfiguration {
                case .TLVS_AREA_160_BYTES:
                    writeConfButton.isEnabled = false
                    writeConfButton.alpha = 0.5
                    writeConfigurationWarningTextView.text = ""
                    break
                case .EXTENDED_TLVS_AREA_192_BYTES:
                    writeConfButton.isEnabled = false
                    writeConfButton.alpha = 0.5
                    writeConfigurationWarningTextView.text = "Cannot come back to default mode"
                    break
                case .EXTENDED_TLVS_AREA_208_BYTES:
                    writeConfButton.isEnabled = false
                    writeConfButton.alpha = 0.5
                    writeConfigurationWarningTextView.text = "Cannot come back to default mode"
                    break
                default:
                    break
                
            }
        }
    }
    
    @IBAction func handleExtendedMode1(_ sender: Any) {
        extendedMode1()
        mSelectedMemoryConfiguration = ComStSt25sdkType2St25tnST25TNTag_ST25TNMemoryConfiguration.EXTENDED_TLVS_AREA_192_BYTES
    }
    private func extendedMode1(){
        UIHelper.UI { [self] in
            updateUIForTLVSArea192Bytes()
            switch mCurrentMemoryConfiguration {
                case .TLVS_AREA_160_BYTES:
                    writeConfButton.isEnabled = true
                    writeConfButton.alpha = 1
                    writeConfigurationWarningTextView.text = "Change to extended mode 1 is allowed\nPlease, note that this action is irreversible"
                    break
                case .EXTENDED_TLVS_AREA_192_BYTES:
                    writeConfButton.isEnabled = false
                    writeConfButton.alpha = 0.5
                    writeConfigurationWarningTextView.text = ""
                    break
                case .EXTENDED_TLVS_AREA_208_BYTES:
                    writeConfButton.isEnabled = false
                    writeConfButton.alpha = 0.5
                    writeConfigurationWarningTextView.text = "Cannot come back to extended mode 1"
                    break
                default:
                    break
                
            }
        }
    }
    
    @IBAction func handleExtendedMode2(_ sender: Any) {
        extendedMode2()
        mSelectedMemoryConfiguration = ComStSt25sdkType2St25tnST25TNTag_ST25TNMemoryConfiguration.EXTENDED_TLVS_AREA_208_BYTES
    }
    private func extendedMode2(){
        UIHelper.UI { [self] in
            updateUIForTLVSArea208Bytes()
            switch mCurrentMemoryConfiguration {
                case .TLVS_AREA_160_BYTES:
                    writeConfButton.isEnabled = true
                    writeConfButton.alpha = 1
                    writeConfigurationWarningTextView.text = "Change to extended mode 2 is allowed\nPlease, note that this action is irreversible"
                    break
                case .EXTENDED_TLVS_AREA_192_BYTES:
                    writeConfButton.isEnabled = true
                    writeConfButton.alpha = 1
                    writeConfigurationWarningTextView.text = "Change to extended mode 2 is allowed\nPlease, note that this action is irreversible"
                    break
                case .EXTENDED_TLVS_AREA_208_BYTES:
                    writeConfButton.isEnabled = false
                    writeConfButton.alpha = 0.5
                    writeConfigurationWarningTextView.text = ""
                    break
                default:
                    break
            }
        }
    }
    
    @IBAction func handleCheckTLV(_ sender: Any) {
        if (mCurrentMemoryConfiguration == .TLVS_AREA_160_BYTES){
            warningAlert(message: "Current memory configuration: Default Mode.\n No TLV needed for this mode\nDynamic Lock Area is located at block 44, right after the T2T Aread")
        }else{
            self.mTaskToDo = .checkTLV
            self.miOSReaderSession = iOSReaderSession(atagReaderSessionViewControllerDelegate: self)
            self.miOSReaderSession.startTagReaderSession()
        }
    }
    
    @IBAction func handleWriteConf(_ sender: Any) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Memory Configuration ", message: "You are about to change your tag's memory configuration\nThis operation is irreversible\n Do you want to write the new configuration anyway ? ", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                self.mTaskToDo = .writeConf
                self.miOSReaderSession = iOSReaderSession(atagReaderSessionViewControllerDelegate: self)
                self.miOSReaderSession.startTagReaderSession()
           }))
           
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        myView.isHidden = false
        self.mTaskToDo = .readConf
        miOSReaderSession = iOSReaderSession(atagReaderSessionViewControllerDelegate: self)
        miOSReaderSession.startTagReaderSession()
    }
   
    private func warningAlert(message : String) {
         DispatchQueue.main.async {
             let alert = UIAlertController(title: "Memory Configuration ", message: message, preferredStyle: .alert)
             alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
             self.present(alert, animated: true, completion: nil)
         }
     }
    
    
    //UI Updates
    private func updateUIForTLVSArea160Bytes(){
        defaultModeImageView.image = UIImage(named:"checked")
        mode1ImageView.image = UIImage(named:"unchecked")
        mode2ImageView.image = UIImage(named:"unchecked")

        TLVsArea2Label.text = ""
        TLVsArea2Label.backgroundColor = .stLightGreenColor()
        SystemArea2Label.text = ""
        SystemArea2Label.backgroundColor = .stLightGreenColor()
        
        T2THeaderSizeInBytesLabel.text = "16"
        T2THeaderSizeInBlocksLabel.text = "4"
        
        TLVsAreaSizeInBytes.text = "160"
        TLVsAreaSizeInBlocks.text = "40"
        
        SystemAreaInBytesLabel.text = "80"
        SystemAreaInBlocksLabel.text = "20"

        TotalInBytesLabel.text = "256"
        TotalInBlocksLabel.text = "64"
    }
    
    private func updateUIForTLVSArea192Bytes(){
        defaultModeImageView.image = UIImage(named:"unchecked")
        mode1ImageView.image = UIImage(named:"checked")
        mode2ImageView.image = UIImage(named:"unchecked")

        TLVsArea2Label.text = "TLVs Area"
        TLVsArea2Label.backgroundColor = .stLightVioletColor()
        SystemArea2Label.text = "System Area"
        SystemArea2Label.backgroundColor = .stLightGreenColor()
        
        T2THeaderSizeInBytesLabel.text = "16"
        T2THeaderSizeInBlocksLabel.text = "4"
        
        TLVsAreaSizeInBytes.text = "192"
        TLVsAreaSizeInBlocks.text = "48"
        
        SystemAreaInBytesLabel.text = "48"
        SystemAreaInBlocksLabel.text = "12"

        TotalInBytesLabel.text = "256"
        TotalInBlocksLabel.text = "64"
    }
    
    private func updateUIForTLVSArea208Bytes(){
        defaultModeImageView.image = UIImage(named:"unchecked")
        mode1ImageView.image = UIImage(named:"unchecked")
        mode2ImageView.image = UIImage(named:"checked")

        TLVsArea2Label.text = "TLVs Area"
        TLVsArea2Label.backgroundColor = .stLightVioletColor()
        SystemArea2Label.text = ""
        SystemArea2Label.backgroundColor = .stLightVioletColor()
        
        T2THeaderSizeInBytesLabel.text = "16"
        T2THeaderSizeInBlocksLabel.text = "4"
        
        TLVsAreaSizeInBytes.text = "208"
        TLVsAreaSizeInBlocks.text = "52"
        
        SystemAreaInBytesLabel.text = "32"
        SystemAreaInBlocksLabel.text = "8"

        TotalInBytesLabel.text = "256"
        TotalInBlocksLabel.text = "64"
    }

    private func readConf(){
        mCurrentMemoryConfiguration = mST25TNTag.getMemoryConfiguration()

        if (mST25TNTag.isST25TN512()){
            
        }else{
            UIHelper.UI {
                self.title = "ST25TN01K Memory Configuration"
            }
            switch(mCurrentMemoryConfiguration){
                case .TLVS_AREA_160_BYTES:
                    UIHelper.UI { [self] in
                        selectedTagConfigurationTextView.text = "Selected Tag Configuration:\nDefault Mode"
                        defaultMode()
                    }
                break
            case .EXTENDED_TLVS_AREA_192_BYTES:
                UIHelper.UI { [self] in
                    selectedTagConfigurationTextView.text = "Selected Tag Configuration:\nExtended Mode 1"
                    extendedMode1()
                }
            break
            case .EXTENDED_TLVS_AREA_208_BYTES:
                UIHelper.UI { [self] in
                    selectedTagConfigurationTextView.text = "Selected Tag Configuration:\nExtended Mode 2"
                    extendedMode2()
                }
            break

            default:
                UIHelper.UI { [self] in
                    warningAlert(message: "Selected Tag Configuration Invalid")
                    myView.isHidden = true
                }
                break
        
            }
        }
    }
    
    private func writeConf(){
        mST25TNTag.setMemoryConfigurationWith(mSelectedMemoryConfiguration)
    }

    private func checkTLV(){
        let tlvCheck = mST25TNTag.areTlvsCorrectForCurrentMemoryConfiguration()
        if (tlvCheck){
            UIHelper.UI { [self] in
                warningAlert(message: "Some TLVs are needed to : \n- Indicate the position of Dynamic Lock Area (block 44).\n - Skip blocks 45 to 51 of System Aread\n\n The current TLVs are correct")
            }
        }else{
            UIHelper.UI { [self] in
                let alert = UIAlertController(title: "check TLV ", message: "Some TLVs are needed to : \n- Indicate the position of Dynamic Lock Area (block 44).\n - Skip blocks 45 to 51 of System Aread\n\n The current TLVs are not correct. Do you want to set the correct ones ? ", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                    self.mTaskToDo = .setTLV
                    self.miOSReaderSession = iOSReaderSession(atagReaderSessionViewControllerDelegate: self)
                    self.miOSReaderSession.startTagReaderSession()
               }))
               
                alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }

        }
    }
    
    private func setTLV(){
        mST25TNTag.setTLVForCurrentMemoryConfiguration()
    }



}

extension ST25TNMemoryConfigurationViewController: tagReaderSessionViewControllerDelegate {
   
    func handleTag(st25SDKTag: ComStSt25sdkNFCTag, uid: Data!) throws {
        self.mTag = st25SDKTag
        if (self.mTag is ST25TNTag){
            self.mST25TNTag = self.mTag as? ST25TNTag
            self.mUid = uid
            if self.isSameTag(uid: uid) {
                switch mTaskToDo {
                case .readConf:
                    readConf()
                case .writeConf:
                    writeConf()
                case .checkTLV:
                    checkTLV()
                case .setTLV:
                    setTLV()
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
        self.warningAlert(message: error.description)
    }

}

