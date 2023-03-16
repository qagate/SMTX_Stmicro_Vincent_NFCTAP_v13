//
//  ST25Type4aGpoManagement.swift
//  NFCTap 
//
//  Created by STMicroelectronics on 30/11/2021.
//  Copyright © 2021 STMicroelectronics. All rights reserved.
//

import UIKit

class ST25Type4aGpoManagement: ST25UIViewController {

    @IBAction func handleInterruptButton(_ sender: Any) {
        self.mTaskToDo = .sendInterruptCommand
        self.startNFCSession()
    }
    
    @IBAction func handleSetGpo(_ sender: Any) {
        self.mTaskToDo = .setGPOCommand
        self.startNFCSession()
    }
    
    @IBAction func handleResetGpo(_ sender: Any) {
        self.mTaskToDo = .resetGPOCommand
        self.startNFCSession()
    }

    
    // Reference the NFC session
    // NFC & Tags infos
    internal var miOSReaderSession:iOSReaderSession!
    internal var mTag:ComStSt25sdkNFCTag!
    internal var mUid:Data!

    enum taskToDo {
        case sendInterruptCommand
        case setGPOCommand
        case resetGPOCommand
    }
    internal var mTaskToDo:taskToDo = .sendInterruptCommand

    override func viewDidLoad() {
        super.viewDidLoad()
   }
    
    private func startNFCSession(){
        miOSReaderSession = iOSReaderSession(atagReaderSessionViewControllerDelegate: self)
        miOSReaderSession.startTagReaderSession()
    }
    
    private func warningAlert(message : String) {
         DispatchQueue.main.async {
             let alert = UIAlertController(title: "GPO Configuration", message: message, preferredStyle: .alert)
             alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
             self.present(alert, animated: true, completion: nil)
         }
     }

    private func sendInterruptCommand() {
        (mTag as! ComStSt25sdkType4aSTType4Tag).invalidateCache()
        if (mTag is ComStSt25sdkType4aSt25taST25TATag){
            let gpoTag:ComStSt25sdkType4aSt25taST25TAGpoTag = ComStSt25sdkType4aSt25taST25TAGpoTag.init(comStSt25sdkRFReaderInterface: miOSReaderSession.mComStSt25sdkRFReaderInterface, with: IOSByteArray.init(nsData: mUid))
            gpoTag.sendInterruptCommand()
        }else{
            let gpoTag:ComStSt25sdkType4aM24srtahighdensityM24SRTag = ComStSt25sdkType4aM24srtahighdensityM24SRTag.init(comStSt25sdkRFReaderInterface: miOSReaderSession.mComStSt25sdkRFReaderInterface, with: IOSByteArray.init(nsData: mUid))
            gpoTag.sendInterruptCommand()
        }
    }
    
    private func setGPOCommand() {
        (mTag as! ComStSt25sdkType4aSTType4Tag).invalidateCache()
        if (mTag is ComStSt25sdkType4aSt25taST25TATag){
            let gpoTag:ComStSt25sdkType4aSt25taST25TAGpoTag = ComStSt25sdkType4aSt25taST25TAGpoTag.init(comStSt25sdkRFReaderInterface: miOSReaderSession.mComStSt25sdkRFReaderInterface, with: IOSByteArray.init(nsData: mUid))
            gpoTag.setStateControlCommandWith(1)
        }else{
            let gpoTag:ComStSt25sdkType4aM24srtahighdensityM24SRTag = ComStSt25sdkType4aM24srtahighdensityM24SRTag.init(comStSt25sdkRFReaderInterface: miOSReaderSession.mComStSt25sdkRFReaderInterface, with: IOSByteArray.init(nsData: mUid))
            gpoTag.setStateControlCommandWith(1)
        }
    }
    
    private func resetGPOCommand() {
        (mTag as! ComStSt25sdkType4aSTType4Tag).invalidateCache()
        if (mTag is ComStSt25sdkType4aSt25taST25TATag){
            let gpoTag:ComStSt25sdkType4aSt25taST25TAGpoTag = ComStSt25sdkType4aSt25taST25TAGpoTag.init(comStSt25sdkRFReaderInterface: miOSReaderSession.mComStSt25sdkRFReaderInterface, with: IOSByteArray.init(nsData: mUid))
            gpoTag.setStateControlCommandWith(0)
        }else{
            let gpoTag:ComStSt25sdkType4aM24srtahighdensityM24SRTag = ComStSt25sdkType4aM24srtahighdensityM24SRTag.init(comStSt25sdkRFReaderInterface: miOSReaderSession.mComStSt25sdkRFReaderInterface, with: IOSByteArray.init(nsData: mUid))
            gpoTag.setStateControlCommandWith(0)
        }
    }

}

extension ST25Type4aGpoManagement: tagReaderSessionViewControllerDelegate {
   
    func handleTag(st25SDKTag: ComStSt25sdkNFCTag, uid: Data!) throws {
        self.mTag = st25SDKTag
        if (self.mTag is ComStSt25sdkType4aSt25taST25TATag || self.mTag is ComStSt25sdkType4aM24srtahighdensityM24SRTAHighDensityTag) {
            self.mUid = uid
            if self.isSameTag(uid: uid) {
                switch mTaskToDo {
                case .sendInterruptCommand:
                    sendInterruptCommand()
                case .setGPOCommand:
                    setGPOCommand()
                case .resetGPOCommand:
                    resetGPOCommand()
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
        switch stException.getError() {
        case ComStSt25sdkSTException_STExceptionCode_get_INVALID_CMD_PARAM():
            self.warningAlert(message: "The GPO's configuration does not allow to send this command. Please, check GPO configuration in system file")
        case ComStSt25sdkSTException_STExceptionCode_get_CMD_FAILED():
            self.warningAlert(message: "GPO Command Failed. Make sure the tag is still in the field")
        default:
            self.warningAlert(message: "GPO Command Failed. Unknown Reason")
        }
    }

}
