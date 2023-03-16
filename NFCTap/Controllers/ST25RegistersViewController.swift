//
//  ST25RegistersViewController.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 05/02/2020.
//  Copyright © 2020 STMicroelectronics. All rights reserved.
//

import UIKit
import CoreNFC



class ST25RegistersViewController: ST25UIViewController {

    internal var mTag:ComStSt25sdkNFCTag!
    internal var miOSReaderSession:iOSReaderSession!
    internal var mST25ConfigurationPwd:Data!
    
    let cellIdCustom = "registerCellCustom"
    let cellId = "registerCell"

    enum actionOnRegisterToDo {
        case write
        case refresh
    }
    
    var mCurrentIndexforRegisterAction : Int = 0
    
    
    var mRegistersList: JavaUtilList!
    let mRegisterLibrary = RegisterLibrary.shared
    var mLisOfRegisterToBeUpdated = [RegisterInformation]()

    // Tmp List to know what kind of register list to handle.
    internal var mST25DVDynamicRegister:Bool = false
    internal var mStaticRegisterList:JavaUtilList!
    internal var mDynregisterList:JavaUtilList!
    
    enum taskToDo {
        case getRegistersConf
        case getRegistersConfWithPwd
        case writeRegisterValueToTag
        case readRegisterValueFromTag
        case readRegisterValueFromTagWithPwd
        case writeRegistersConf
    }
    
    internal var mTaskToDo:taskToDo = .getRegistersConf
        
    @IBOutlet weak var mRegistersTableView: UITableView!
    
    @IBAction func refreshRegisterList(_ sender: UIButton) {
        if (mTag is ST25TVCTag) {
            self.mTaskToDo = .getRegistersConfWithPwd
            UIHelper.UI {
                self.presentPwdController()
            }

        } else {
            mTaskToDo = .getRegistersConf
            miOSReaderSession.startTagReaderSession()
        }
    }
    
    @IBAction func userTappedBackground(sender: AnyObject) {
      view.endEditing(true)
    }
    
    @IBAction func writeAllRegistersToTag(_ sender: UIButton) {
            mTaskToDo = .writeRegistersConf
        if (mTag is ST25TNTag){
            self.miOSReaderSession.startTagReaderSession()
        }else{
            presentPwdController()
        }
    }
    
    func setDynRegister(isDynamicRegister:Bool){
        mST25DVDynamicRegister = isDynamicRegister
        if (mST25DVDynamicRegister == false){
            self.mRegistersList = self.mStaticRegisterList
        }else{
            self.mRegistersList = self.mDynregisterList
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Used to scroll up view. Keyboard is hidden textview
//       NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);
//
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);

        
        // Check if Dynamic or static register list. Depending on tabBar Name
        if ((self.tabBarItem.title?.contains("Dynamic"))!){
            mST25DVDynamicRegister = true
        }else{
            mST25DVDynamicRegister = false
        }
        
        mRegisterLibrary.clear()
        if mLisOfRegisterToBeUpdated != nil {
            mLisOfRegisterToBeUpdated.removeAll()
        }
        self.mRegistersTableView.register(RegisterCell.self, forCellReuseIdentifier: cellIdCustom)
        self.mRegistersTableView.dataSource = self
        self.mRegistersTableView.delegate = self
        self.mRegistersTableView.rowHeight = UITableView.automaticDimension
        self.mRegistersTableView.estimatedRowHeight = 80.0; // set to whatever your "average" cell height is
        self.mRegistersTableView.keyboardDismissMode = .interactive

        self.miOSReaderSession = iOSReaderSession(atagReaderSessionViewControllerDelegate: self)
        mTaskToDo = .getRegistersConf
        miOSReaderSession.startTagReaderSession()
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = -150 // Move view 150 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 20 // Move view to original position
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (mST25DVDynamicRegister == false){
            self.title = "Registers management"
            if (self.mStaticRegisterList != nil) {
                self.mRegistersList = self.mStaticRegisterList
            }
        }else{
            self.title = "Dynamic Registers management"
            if (self.mDynregisterList != nil) {
                self.mRegistersList = self.mDynregisterList
            }
        }
        if (self.mRegistersList != nil){
            buildRegisterLibrary()
        }
        mRegistersTableView.reloadData()
    }
 
    override func viewDidDisappear(_ animated: Bool) {
        // Update Lists when view Disapears
        if (mST25DVDynamicRegister == false){
            self.mStaticRegisterList = self.mRegistersList
        }else{
            self.mDynregisterList = self.mRegistersList
        }
    }
       

    private func readTagRegistersConfiguration() {
        if mTag is ST25TVTag {
            readTagRegistersConfiguration(tag: mTag as! ST25TVTag)
        }else if  mTag is ST25DVTag {
            readTagRegistersConfiguration(tag: mTag as! ST25DVTag)
        } else if mTag is ST25DVPwmTag {
            readTagRegistersConfiguration(tag: mTag as! ST25DVPwmTag)
        } else if mTag is ST25TV64KTag {
            readTagRegistersConfiguration(tag: mTag as! ST25TV64KTag)
        } else if mTag is ST25TV16KTag {
            readTagRegistersConfiguration(tag: mTag as! ST25TV16KTag)
		} else if mTag is ST25TVCTag {
            self.miOSReaderSession.stopTagReaderSession()
            self.mTaskToDo = .getRegistersConfWithPwd
            UIHelper.UI {
                self.presentPwdController()
            }
        } else if mTag is ST25TNTag {
            readTagRegistersConfiguration(tag: mTag as! ST25TNTag)
        }
        UIHelper.UI() {
            if self.mRegistersList != nil {
                self.mRegistersTableView.reloadData()
            }
        }
     }

    private func readTagRegistersConfiguration(tag:ST25TVTag) {
        tag.invalidateCache()
        tag.refreshRegistersStatus()
    
        self.mRegistersList = tag.getRegisterList()
        self.buildRegisterLibrary()
    }
    private func readTagRegistersConfiguration(tag:ST25DVPwmTag) {
        tag.invalidateCache()
        tag.refreshRegistersStatus()
    
        self.mRegistersList = tag.getRegisterList()
        self.buildRegisterLibrary()
    }
    
    private func readTagRegistersConfiguration(tag:ST25DVTag) {
        tag.invalidateCache()
        
        if (!mST25DVDynamicRegister){
            tag.refreshRegistersStatus()
            self.mRegistersList = tag.getRegisterList()
        }else{
            tag.refreshDynamicRegistersStatus()
            self.mRegistersList = tag.getDynamicRegisterList()
        }
        self.buildRegisterLibrary()
    }

	private func readTagRegistersConfiguration(tag:ST25DVCTag) {
        tag.invalidateCache()
        
        if (!mST25DVDynamicRegister){
            tag.refreshRegistersStatus()
            self.mRegistersList = tag.getRegisterList()
        }else{
            tag.refreshDynamicRegistersStatus()
            self.mRegistersList = tag.getDynamicRegisterList()
        }
        self.buildRegisterLibrary()
    }

    private func readTagRegistersConfiguration(tag:ST25TV16KTag) {
        tag.invalidateCache()
        tag.refreshRegistersStatus()
    
        self.mRegistersList = tag.getRegisterList()
        self.buildRegisterLibrary()
    }
    private func readTagRegistersConfiguration(tag:ST25TV64KTag) {
        tag.invalidateCache()
        tag.refreshRegistersStatus()
    
        self.mRegistersList = tag.getRegisterList()
        self.buildRegisterLibrary()
    }

    private func readTagRegistersConfiguration(tag:ST25TVCTag) {
        tag.invalidateCache()
        tag.refreshRegistersStatus()
    
        self.mRegistersList = tag.getRegisterList()
        self.buildRegisterLibrary()
    }

    private func readTagRegistersConfigurationWithPwd(tag:ST25TVCTag) {
        tag.presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25tvcST25TVCTag_ST25TVC_CONFIGURATION_PASSWORD_ID), password: mST25ConfigurationPwd!)
        updateRegisterLibraryReference(updadedRegisterList: (tag.getRegisterList())!)

        tag.invalidateCache()
        tag.refreshRegistersStatus()
    
        self.mRegistersList = tag.getRegisterList()
        self.buildRegisterLibrary()
        UIHelper.UI() {
            if self.mRegistersList != nil {
                self.mRegistersTableView.reloadData()
            }
        }

    }

    private func readTagRegistersConfiguration(tag:ST25TNTag) {
        tag.invalidateCache()
        tag.refreshRegistersStatus()
    
        self.mRegistersList = tag.getRegisterList()
        self.buildRegisterLibrary()
    }

    
    private func buildRegisterLibrary() {
        mRegisterLibrary.clear()
        let numberOfRegisters = self.mRegistersList.size()
        let registerArray = self.mRegistersList

        for index in 0..<numberOfRegisters {
            let register : ComStSt25sdkSTRegister = registerArray?.getWith(jint(index)) as! ComStSt25sdkSTRegister
            var locked = false;
            if (mTag is ST25TVCTag) {
               // locked = (mTag as! ST25TVCTag).isFeatureLocked(with: register.getAddress())
                SwiftTryCatch.try({
                    locked = (self.mTag as! ST25TVCTag).isFeatureLocked(with: register.getAddress())
                    let registerInfo =  RegisterInformation(register: register, locked: locked)
                    self.mRegisterLibrary.add(registerInfo)
                    }
                    , catch: { (error) in
                        print("buildRegisterLibrary: \(index) - \(register.getAddress()) - \(register.getParameterAddress())")

                    }
                    , finallyBlock: {
                    })
            } else {
                let registerInfo =  RegisterInformation(register: register, locked: locked)
                mRegisterLibrary.add(registerInfo)
            }

        }
    }
    
    private func updateRegisterLibraryReference(updadedRegisterList : JavaUtilList) {
        let numberOfRegisters : Int = Int(updadedRegisterList.size())
        self.mRegistersList = updadedRegisterList
        if self.mRegisterLibrary.registers.count == numberOfRegisters {
            for index in 0..<numberOfRegisters {
                let register : ComStSt25sdkSTRegister = updadedRegisterList.getWith(jint(index)) as! ComStSt25sdkSTRegister
                let registerInfo =  RegisterInformation(register: register, newValue: Int(self.mRegisterLibrary.registers[index].mValue))
                mRegisterLibrary.update(registerInfo, index: index)
            }
        }
    }
    
    
    private func buildListOfRegistersToBeUpdated() {
        if mLisOfRegisterToBeUpdated != nil {
            mLisOfRegisterToBeUpdated.removeAll()
        }
        let nbRegisters = self.mRegisterLibrary.registers.count
        for index in 0 ..< nbRegisters{
            if (self.mRegisterLibrary.registers[index].isValueUpdated  && (!self.mRegisterLibrary.registers[index].islocked && (self.mRegisterLibrary.registers[index].mRegister.getAccessRights() != ComStSt25sdkSTRegister_RegisterAccessRights.REGISTER_READ_ONLY))) {                
			// build list of register to update
                mLisOfRegisterToBeUpdated.append(self.mRegisterLibrary.registers[index])
            }
        }
    }
    
    private func writeRegisterValueToTag(register : RegisterInformation) {
        let value = register.mValue
        if mTag is ST25TVTag {
            (mTag as! ST25TVTag).presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25tvST25TVTag_ST25TV_CONFIGURATION_PASSWORD_ID), password: mST25ConfigurationPwd)
        }else if mTag is ST25DVTag {
            (mTag as! ST25DVTag).presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25dvST25DVTag_ST25DV_CONFIGURATION_PASSWORD_ID), password: mST25ConfigurationPwd)
        } else if mTag is ST25DVCTag {
            (mTag as! ST25DVCTag).presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25dvST25DVTag_ST25DV_CONFIGURATION_PASSWORD_ID), password: mST25ConfigurationPwd)
        } else if self.mTag is ST25DVPwmTag {
            (mTag as! ST25DVPwmTag).presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25dvpwmST25DVPwmTag_ST25DVPWM_CONFIGURATION_PASSWORD_ID), password: mST25ConfigurationPwd)

        } else if mTag is ST25TV16KTag {
            (mTag as! ST25TV16KTag).presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25dvST25TV16KTag.ST25TVHighDensity_CONFIGURATION_PASSWORD_ID), password: mST25ConfigurationPwd)
        } else if mTag is ST25TV64KTag {
            (mTag as! ST25TV64KTag).presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25dvST25TV64KTag.ST25TVHighDensity_CONFIGURATION_PASSWORD_ID), password: mST25ConfigurationPwd)
        } else if self.mTag is ST25TVCTag {
            (mTag as! ST25TVCTag).presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25tvcST25TVCTag_ST25TVC_CONFIGURATION_PASSWORD_ID), password: mST25ConfigurationPwd!)
            updateRegisterLibraryReference(updadedRegisterList: ((self.mTag as! ST25TVCTag).getRegisterList())!)
            self.mRegisterLibrary.registers[self.mCurrentIndexforRegisterAction].mRegister.setRegisterValueWith(jint(value))
            self.mRegisterLibrary.registers[self.mCurrentIndexforRegisterAction].alignRegisterInformationValues()
            UIHelper.UI {
                self.mRegistersTableView.reloadData()
            }
            return
        }
        
        register.mRegister.setRegisterValueWith(jint(value))
        register.alignRegisterInformationValues()
        UIHelper.UI {
            self.mRegistersTableView.reloadData()
        }
        
    }
    
    private func writeRegistersToTag() {
        if self.mLisOfRegisterToBeUpdated != nil && self.mLisOfRegisterToBeUpdated.count > 0 {
            if mTag is ST25TVTag {
                (mTag as! ST25TVTag).presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25tvST25TVTag_ST25TV_CONFIGURATION_PASSWORD_ID), password: mST25ConfigurationPwd)
            }else if mTag is ST25DVTag {
                (mTag as! ST25DVTag).presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25dvST25DVTag_ST25DV_CONFIGURATION_PASSWORD_ID), password: mST25ConfigurationPwd)
            } else if mTag is ST25DVCTag {
                (mTag as! ST25DVCTag).presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25dvST25DVTag_ST25DV_CONFIGURATION_PASSWORD_ID), password: mST25ConfigurationPwd)
            } else if mTag is ST25TV16KTag {
                (mTag as! ST25TV16KTag).presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25dvST25TV16KTag.ST25TVHighDensity_CONFIGURATION_PASSWORD_ID), password: mST25ConfigurationPwd)
            } else if mTag is ST25TV64KTag {
                (mTag as! ST25TV16KTag).presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25dvST25TV64KTag.ST25TVHighDensity_CONFIGURATION_PASSWORD_ID), password: mST25ConfigurationPwd)
            } else if self.mTag is ST25DVPwmTag {
                (mTag as! ST25DVPwmTag).presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25dvpwmST25DVPwmTag_ST25DVPWM_CONFIGURATION_PASSWORD_ID), password: mST25ConfigurationPwd)
            } else if self.mTag is ST25TVCTag {
                (mTag as! ST25TVCTag).presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25tvcST25TVCTag_ST25TVC_CONFIGURATION_PASSWORD_ID), password: mST25ConfigurationPwd!)
                updateRegisterLibraryReference(updadedRegisterList: ((self.mTag as! ST25TVCTag).getRegisterList())!)
                // need to rebuild list as register list has been updated before
                buildListOfRegistersToBeUpdated()
            }

            for index in 0..<self.mLisOfRegisterToBeUpdated.count {
                let reg = self.mLisOfRegisterToBeUpdated[index].mRegister
                let val = self.mLisOfRegisterToBeUpdated[index].mValue
                
                //print("Updating Register \(reg.getName()) with value \(val)")
                self.mLisOfRegisterToBeUpdated[index].mRegister.setRegisterValueWith(jint(val))
                self.mLisOfRegisterToBeUpdated[index].alignRegisterInformationValues()

            }
            UIHelper.UI() {
                self.mRegistersTableView.reloadData()
            }
        }else {
            UIHelper.UI() {
                self.warningAlert(message: "No update on register value, please make changed to register value first !")
            }
        }
    }
 
    private func readRegisterValueFromTag(register : RegisterInformation) {
        register.mRegister.invalidateCache()
        let value = register.mRegister.getValue()
        self.mRegisterLibrary.registers[self.mCurrentIndexforRegisterAction].mValue = Int(value)
        self.mRegisterLibrary.registers[self.mCurrentIndexforRegisterAction].alignRegisterInformationValues()
        UIHelper.UI() {
            self.mRegistersTableView.reloadData()
        }
    }
  
    private func readRegisterValueFromTagWithPwd(tag:ST25TVCTag) {
        tag.presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25tvcST25TVCTag_ST25TVC_CONFIGURATION_PASSWORD_ID), password: mST25ConfigurationPwd!)
        updateRegisterLibraryReference(updadedRegisterList: (tag.getRegisterList())!)
        self.mRegisterLibrary.registers[self.mCurrentIndexforRegisterAction].mRegister.invalidateCache()

        let value = self.mRegisterLibrary.registers[self.mCurrentIndexforRegisterAction].mRegister.getValue()
        self.mRegisterLibrary.registers[self.mCurrentIndexforRegisterAction].mValue = Int(value)
        self.mRegisterLibrary.registers[self.mCurrentIndexforRegisterAction].alignRegisterInformationValues()
        UIHelper.UI() {
            self.mRegistersTableView.reloadData()
        }
    }

      
    private func warningAlert(message : String) {
        UIHelper.warningAlert(viewController: self, title : "Registers management" , message: message)
    }

    private func presentPwdController() {
        let mST25PasswordVC:ST25PasswordViewController = UIStoryboard(name: "ST25Password", bundle: nil).instantiateViewController(withIdentifier: "ST25PasswordID") as! ST25PasswordViewController
        mST25PasswordVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        mST25PasswordVC.setTitle("Enter configuration password")

        if mTag is ST25TVTag || mTag is ST25DVPwmTag || mTag is ST25TVCTag{
            mST25PasswordVC.setMessage("(32 bits hexadecimal format)")
            mST25PasswordVC.numberOfBytes = 4
        } else if mTag is ST25TV16KTag || mTag is ST25TV64KTag {
            mST25PasswordVC.setMessage("(64 bits hexadecimal format)")
            mST25PasswordVC.numberOfBytes = 8
        } else{ // Default DV/DVC
            mST25PasswordVC.setMessage("(64 bits hexadecimal format)")
            mST25PasswordVC.numberOfBytes = 8
        }
        
        mST25PasswordVC.delegate = self
        self.present(mST25PasswordVC, animated: false, completion: nil)
    }
    

}

extension ST25RegistersViewController: tagReaderSessionViewControllerDelegateWithFinallyBlock {
    
    func handleTag(st25SDKTag: ComStSt25sdkNFCTag, uid: Data!) throws {
        self.mTag = st25SDKTag
        if self.isSameTag(uid: uid) {
            // needed to have Registers iOSReader Interface aligned with Tag
            if self.mTag is ST25TVTag {
                updateRegisterLibraryReference(updadedRegisterList: ((self.mTag as! ST25TVTag).getRegisterList())!)
            } else if self.mTag is ST25DVPwmTag {
                updateRegisterLibraryReference(updadedRegisterList: ((self.mTag as! ST25DVPwmTag).getRegisterList())!)

            } else if self.mTag is ST25DVTag {
                if(!mST25DVDynamicRegister){
                    updateRegisterLibraryReference(updadedRegisterList: ((self.mTag as! ST25DVTag).getRegisterList())!)
                }else{
                    updateRegisterLibraryReference(updadedRegisterList: ((self.mTag as! ST25DVTag).getDynamicRegisterList())!)
                }
            } else if self.mTag is ST25DVCTag {
                if(!mST25DVDynamicRegister){
                    updateRegisterLibraryReference(updadedRegisterList: ((self.mTag as! ST25DVCTag).getRegisterList())!)
                }else{
                    updateRegisterLibraryReference(updadedRegisterList: ((self.mTag as! ST25DVCTag).getDynamicRegisterList())!)
                }
            } else if self.mTag is ST25TV16KTag {
                    updateRegisterLibraryReference(updadedRegisterList: ((self.mTag as! ST25TV16KTag).getRegisterList())!)
            } else if self.mTag is ST25TV64KTag {
                    updateRegisterLibraryReference(updadedRegisterList: ((self.mTag as! ST25TV64KTag).getRegisterList())!)
            } else if self.mTag is ST25TNTag {
                    updateRegisterLibraryReference(updadedRegisterList: ((self.mTag as! ST25TNTag).getRegisterList())!)
            } else if self.mTag is ST25TVCTag {
                if ( mTaskToDo != .getRegistersConfWithPwd && mTaskToDo != .readRegisterValueFromTagWithPwd && mTaskToDo != .writeRegistersConf && mTaskToDo != .writeRegisterValueToTag) {
                    updateRegisterLibraryReference(updadedRegisterList: ((self.mTag as! ST25TVCTag).getRegisterList())!)
                }
            } else {
                miOSReaderSession.stopTagReaderSession("Tag feature not handled ...")
                return
            }

            switch mTaskToDo {
            case .getRegistersConf:
                readTagRegistersConfiguration()
            case .getRegistersConfWithPwd:
                if self.mTag is ST25TVCTag {
                    readTagRegistersConfigurationWithPwd(tag: mTag as! ST25TVCTag)
                } else {
                    miOSReaderSession.stopTagReaderSession("Tag feature not supported ...")
                }
            case .writeRegisterValueToTag:
                writeRegisterValueToTag(register: self.mRegisterLibrary.registers[mCurrentIndexforRegisterAction])
            case .readRegisterValueFromTag:
                readRegisterValueFromTag(register: self.mRegisterLibrary.registers[mCurrentIndexforRegisterAction])
            case .readRegisterValueFromTagWithPwd:
                if self.mTag is ST25TVCTag {
                    readRegisterValueFromTagWithPwd(tag: mTag as! ST25TVCTag)
                } else {
                    miOSReaderSession.stopTagReaderSession("Tag feature not supported ...")
                }
            case .writeRegistersConf:
                buildListOfRegistersToBeUpdated()
                writeRegistersToTag()
            }
        } else {
            miOSReaderSession.stopTagReaderSession("Tag has changed, please scan again the Tag ...")
        }

        if self.mTag is ST25TVCTag {
            self.miOSReaderSession.stopTagReaderSession()
        }
        
    }
    
    func handleTagSessionError(didInvalidateWithError error: Error) {
        let errorNFC = error as! NFCReaderError
        if errorNFC.code ==  NFCReaderError.readerSessionInvalidationErrorSessionTimeout {
        }
        else if errorNFC.code ==  NFCReaderError.readerSessionInvalidationErrorUserCanceled {
        }
         miOSReaderSession.stopTagReaderSession(error.localizedDescription)
        
    }
    
    func handleTagST25SdkError(didInvalidateWithError error: NSException) {
        let errorST25SDK = error as! ComStSt25sdkSTException
        if (error.description.contains("ISO15693_BLOCK_NOT_AVAILABLE")) {
            // do nothing Register not available
            UIHelper.UI() {
                self.mRegistersTableView.reloadData()
            }
            
        } else {
            miOSReaderSession.stopTagReaderSession("Command failed: \(error.description)")
            UIHelper.UI() {
                self.mRegistersTableView.reloadData()
            }
        }
    }

    func handleFinallyBlock() {
        //Does nothing in case of ST25TVC Tag. Otherwise, stop session
        if self.mTag is ST25TVCTag {
            UIHelper.UI() {
                self.mRegistersTableView.reloadData()
            }
        }else{
            miOSReaderSession.stopTagReaderSession()
        }
        
    }
    
}

extension ST25RegistersViewController: ST25PasswordViewDelegate {
    func okButtonTapped(pwdValue: Data) {
        if self.mTaskToDo == .writeRegisterValueToTag {
            //print(pwdValue.toHexString())
            self.mST25ConfigurationPwd = pwdValue
            self.mTaskToDo = .writeRegisterValueToTag
            self.miOSReaderSession.startTagReaderSession()
        }
        if self.mTaskToDo == .writeRegistersConf {
            //print(pwdValue.toHexString())
            self.mST25ConfigurationPwd = pwdValue
            self.mTaskToDo = .writeRegistersConf
            self.miOSReaderSession.startTagReaderSession()
        }
        if self.mTaskToDo == .getRegistersConfWithPwd {
            //print(pwdValue.toHexString())
            self.mST25ConfigurationPwd = pwdValue
            self.mTaskToDo = .getRegistersConfWithPwd
            self.miOSReaderSession.startTagReaderSession()
        }
        if self.mTaskToDo == .readRegisterValueFromTagWithPwd {
            //print(pwdValue.toHexString())
            self.mST25ConfigurationPwd = pwdValue
            self.mTaskToDo = .readRegisterValueFromTagWithPwd
            self.miOSReaderSession.startTagReaderSession()
        }

    }
    
    func cancelButtonTapped() {
    }
}


extension ST25RegistersViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.mRegistersList != nil {
            return Int(self.mRegisterLibrary.registers.count)
        }
        return Int(1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print("Register content editor Table index : \(indexPath.row)")
        if self.mRegistersList != nil && indexPath.row < self.mRegisterLibrary.registers.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdCustom, for: indexPath) as! RegisterCell
            cell.mTableView = tableView

            cell.registerInfo = self.mRegisterLibrary.registers[indexPath.row]
            cell.setRegisterValueToTextEditField(value: (self.mRegisterLibrary.registers[indexPath.row]).mValue)
            cell.configureValueField()
            view.endEditing(true)
            return cell

        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
            // No Register - display the information
            cell.imageView?.image = UIImage(named: "right_arrow_light_dark_blue")
            cell.textLabel?.text = "No register"
            cell.detailTextLabel?.text = ""
            return cell
        }

    }
    
    func setCell(action:actionOnRegisterToDo, at indexPath: IndexPath){
        
        let cell = self.mRegistersTableView.cellForRow(at: indexPath ) as! RegisterCell
        //print(action)
        self.mCurrentIndexforRegisterAction = indexPath.row

        if action == .write {
            let value = Int(cell.registerCellValueLabel.text!)
            if value != nil {
                mTaskToDo = .writeRegisterValueToTag
                if (mTag is ST25TNTag){
                    self.miOSReaderSession.startTagReaderSession()
                }else{
                    self.presentPwdController()
                }
            }

        }
       if action == .refresh {
            if (mTag is ST25TVCTag) {
                mTaskToDo = .readRegisterValueFromTagWithPwd
                UIHelper.UI {
                    self.presentPwdController()
                    
                }
            } else {
                mTaskToDo = .readRegisterValueFromTag
                self.miOSReaderSession.startTagReaderSession()
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    //func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if self.mRegistersList != nil {
            let cell = self.mRegistersTableView.cellForRow(at: indexPath ) as! RegisterCell
            let ro = "\(RegisterCell.RO)".elementsEqual((cell.registerCellPermissionLabel.text)!) ||
            "\(RegisterCell.LK)".elementsEqual((cell.registerCellPermissionLabel.text)!)
            if ro {
                // no action
                return nil
            } else {
                let SaveAction = UIContextualAction(style: .normal, title: "Write") { (action, view, actionPerformed) in
                    self.setCell(action: .write, at: indexPath)
                }
                SaveAction.backgroundColor = .stLightBlueColor()
                
                let RefreshAction = UIContextualAction(style: .normal, title: "Refresh") { (action, view, actionPerformed) in
                    self.setCell(action: .refresh, at: indexPath)
                }
                RefreshAction.backgroundColor = .stDarkBlueColor()
                return UISwipeActionsConfiguration(actions: [SaveAction, RefreshAction])
            }

        }
        return nil
    }
    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.mRegistersList != nil {
            return 120
        } else {
            return 40
        }

    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        } else {
            return 40
        }
    }
    

}

