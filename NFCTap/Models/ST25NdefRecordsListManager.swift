//
//  ST25NdefRecordsListManager.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 10/01/2020.
//  Copyright © 2020 STMicroelectronics. All rights reserved.
//

import UIKit
import CoreNFC

enum actionOnRecordToDo {
    case exec
    case insert
    case edit
    case add
    case remove
    case cancelled
}


class ST25NdefRecordsListManager: NSObject {
    var mParentVC:ST25NdefRecordsListViewController!
    
    //private var mCurrentIndexforRecordEdition = 0
    private var mCurrentActionOnRecordToDo :actionOnRecordToDo = .add
    
    enum recordType: String, CaseIterable {
        case NdefUriRecord
        case NdefTextRecord
        case NdefBtRecord
        case NdefBtLeRecord
        case NdefEmailRecord
        case NdefSmsRecord
        case NdefVCardRecord
        case NdefWifiRecord
        case NdefMimeRecord
        case NdefExternalRecord
        case NdefCallRecord
        case NdefGeolocalisationRecord
        case NdefAarRecord
        
        var description: String {
            return self.rawValue
        }
    }
    
    init(vc:ST25UIViewController) {
        super.init()
        mParentVC = vc as! ST25NdefRecordsListViewController
        mParentVC.mRecordsTableView.dataSource = self
        mParentVC.mRecordsTableView.delegate = self
    }
    
    
    private func warningAlert(message : String) {
        UIHelper.warningAlert(viewController: self.mParentVC, title : "NDEF record management" , message: message)
    }
    
    // Records edition functions
    func addRecord(at indexPath: Int) {
        if indexPath >= 0  {

            let otherAlert = UIAlertController(title: "Record selection", message: "Which record do you want to use?", preferredStyle: .alert)

            for type in recordType.allCases {
                let actionTitle = type.rawValue.description

                switch type {
                case .NdefUriRecord :
                    var image = UIImage(named: "Safari.png")
                    image = image?.resizeImage(30.0, opaque: false)
                    let action = UIAlertAction(title: actionTitle, style: .default) { action in
                        // completion handler
                        self.prepareNdefUriRecord()
                    }
                    action.setValue(image, forKey: "image")
                    action.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
                    otherAlert.addAction(action)

                case .NdefTextRecord :
                    var image = UIImage(named: "text.png")
                    image = image?.resizeImage(30.0, opaque: false)
                    let action = UIAlertAction(title: actionTitle, style: .default) { action in
                        // completion handler
                        self.prepareNdefTextRecord()
                    }
                    action.setValue(image, forKey: "image")
                    action.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
                    otherAlert.addAction(action)
                case .NdefVCardRecord :
                    var image = UIImage(named: "vcard.png")
                    image = image?.resizeImage(30.0, opaque: false)
                    let action = UIAlertAction(title: actionTitle, style: .default) { action in
                        // completion handler
                        self.prepareNdefVCardRecord()
                    }
                    action.setValue(image, forKey: "image")
                    action.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
                    otherAlert.addAction(action)
                    
                case .NdefBtRecord :
                    var image = UIImage(named: "bluetooth")
                    image = image?.resizeImage(30.0, opaque: false)
                    let action = UIAlertAction(title: actionTitle, style: .default) { action in
                        // completion handler
                        self.prepareNdefBTRecord(isBTLe: false)
                    }
                    action.setValue(image, forKey: "image")
                    action.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
                    otherAlert.addAction(action)

                case .NdefBtLeRecord :
                    var image = UIImage(named: "bluetooth")
                    image = image?.resizeImage(30.0, opaque: false)
                    let action = UIAlertAction(title: actionTitle, style: .default) { action in
                        // completion handler
                        self.prepareNdefBTRecord(isBTLe: true)
                    }
                    action.setValue(image, forKey: "image")
                    action.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
                    otherAlert.addAction(action)
                    
                case .NdefEmailRecord :
                    var image = UIImage(named: "mail")
                    image = image?.resizeImage(30.0, opaque: false)
                    let action = UIAlertAction(title: actionTitle, style: .default) { action in
                        // completion handler
                        self.prepareNdefMailRecord()
                    }
                    action.setValue(image, forKey: "image")
                    action.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
                    otherAlert.addAction(action)
                    
                case .NdefSmsRecord :
                    var image = UIImage(named: "sms")
                    image = image?.resizeImage(30.0, opaque: false)
                    let action = UIAlertAction(title: actionTitle, style: .default) { action in
                        // completion handler
                        self.prepareNdefSmsRecord()
                    }
                    action.setValue(image, forKey: "image")
                    action.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
                    otherAlert.addAction(action)
                    
                case .NdefWifiRecord :
                    var image = UIImage(named: "wifi")
                    image = image?.resizeImage(30.0, opaque: false)
                    let action = UIAlertAction(title: actionTitle, style: .default) { action in
                        self.prepareNdefWifiRecord()
                    }
                    action.setValue(image, forKey: "image")
                    action.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
                    otherAlert.addAction(action)
                    
                case .NdefMimeRecord :
                    var image = UIImage(named: "mime")
                    image = image?.resizeImage(30.0, opaque: false)
                    let action = UIAlertAction(title: actionTitle, style: .default) { action in
                        self.prepareNdefMimeRecord()
                    }
                    action.setValue(image, forKey: "image")
                    action.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
                    otherAlert.addAction(action)
                    
                case .NdefExternalRecord :
                    let ndefExternalRecord = NDEFExternalRecords()
                    var image = ndefExternalRecord.mImage
                    image = image?.resizeImage(30.0, opaque: false)
                    let action = UIAlertAction(title: actionTitle, style: .default) { action in
                        self.prepareNdefExternalRecord()
                    }
                    action.setValue(image, forKey: "image")
                    action.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
                    otherAlert.addAction(action)
                    
                case .NdefCallRecord:
                    var image = UIImage(named: "call")
                    image = image?.resizeImage(30.0, opaque: false)
                    let action = UIAlertAction(title: actionTitle, style: .default) { action in
                       // completion handler
                       self.prepareNdefCallRecord()
                    }
                    action.setValue(image, forKey: "image")
                    action.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
                    otherAlert.addAction(action)
                    
                case .NdefGeolocalisationRecord :
                    var image = UIImage(named: "GeoIoT")
                    image = image?.resizeImage(30.0, opaque: false)
                    let action = UIAlertAction(title: actionTitle, style: .default) { action in
                        // completion handler
                        self.prepareNdefGeolocalisationRecord()
                    }
                    action.setValue(image, forKey: "image")
                    action.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
                    otherAlert.addAction(action)
                
                case .NdefAarRecord :
                    let ndefAarRecord = NDEFAarRecord()
                    var image = ndefAarRecord.mImage
                    image = image?.resizeImage(30.0, opaque: false)
                    let action = UIAlertAction(title: actionTitle, style: .default) { action in
                        self.prepareNdefAarRecord()
                    }
                    action.setValue(image, forKey: "image")
                    action.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
                    otherAlert.addAction(action)
  
                }
            }
            
            let dismiss = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
            
            // relate actions to controllers
            otherAlert.addAction(dismiss)
            //otherAlert.show(self, sender: self.mRecordsTableView)
            self.mParentVC.present(otherAlert, animated: true, completion: nil)
        } else {
            warningAlert(message: "Invalid index for edition in record list")
            
        }
    }
    
    
    private func editRecord (at indexPath: IndexPath) {
        if jint(indexPath.row) >= 0  &&  self.mParentVC.mNdefMsg != nil && jint(indexPath.row) < self.mParentVC.mNdefMsg.getNbrOfRecords() {
            mCurrentActionOnRecordToDo = .edit
            self.mParentVC.mCurrentIndexforRecordEdition = indexPath.row
            let rcd = self.mParentVC.mNdefMsg.getNDEFRecord(with: jint(indexPath.row))
            // Check record type
            switch (rcd)
            {
            case  is ComStSt25sdkNdefUriRecord :
                // Check URI type and call dedicated function
                let ndefUriRecord = NDEFUriRecords(ndefRecord: (rcd as! ComStSt25sdkNdefUriRecord))
                switch ndefUriRecord.NDEFUriRecordsType {
                case .kUrl :
                    prepareNdefUriRecord()
                case .kTel :
                    prepareNdefCallRecord()
                case .kMap :
                    prepareNdefGeolocalisationRecord()
                default:
                    warningAlert(message: "URI Record type controller not yet implemented")
                }
                break
                
            case  is  ComStSt25sdkNdefTextRecord :
                prepareNdefTextRecord()
                break
                
            case  is  ComStSt25sdkNdefVCardRecord :
                prepareNdefVCardRecord()
                break
                
            case  is  ComStSt25sdkNdefBtRecord :
                prepareNdefBTRecord(isBTLe: false)

                break
            case  is  ComStSt25sdkNdefBtLeRecord :
                prepareNdefBTRecord(isBTLe: true)
                break
                
            case  is  ComStSt25sdkNdefEmailRecord :
                prepareNdefMailRecord()
                break
                
            case  is  ComStSt25sdkNdefSmsRecord :
                prepareNdefSmsRecord()
                break
                
            case  is  ComStSt25sdkNdefWifiRecord :
                prepareNdefWifiRecord()
                break
                
            case  is  ComStSt25sdkNdefMimeRecord :
                prepareNdefMimeRecord()
                break
                
            case  is  ComStSt25sdkNdefExternalRecord :
                prepareNdefExternalRecord()
                break
                
            case  is  ComStSt25sdkNdefAarRecord :
                prepareNdefAarRecord()
                break

            default:
                break
            }
        } else {
            warningAlert(message: "Select a valid record first for edition in record list")
        }
    }
    
    private func removeRecord( at indexPath: IndexPath) {
        if jint(indexPath.row) >= 0  &&  self.mParentVC.mNdefMsg != nil && jint(indexPath.row) < self.mParentVC.mNdefMsg.getLength() {
            // Declare Alert
            let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete record?", preferredStyle: .alert)
            
            // Create OK button with action handler
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                print("Ok button click...")
                if self.mParentVC.mNdefMsg != nil {
                    self.mParentVC.mNdefMsg.deleteRecord(with: jint(indexPath.row))
                    self.mParentVC.tagNeedUpdate = true
                    self.mParentVC.updateWriteToTagButtonMessage(forUpdate: true)
                    self.mParentVC.mRecordsTableView.reloadData()
                } else {
                    self.warningAlert(message: "No available record for removal")
                }
            })
            
            // Create Cancel button with action handlder
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                print("Cancel button click...")
            }
            
            //Add OK and Cancel button to dialog message
            dialogMessage.addAction(ok)
            dialogMessage.addAction(cancel)
            
            // Present dialog message to user
            self.mParentVC.present(dialogMessage, animated: true, completion: nil)
            
        } else {
            warningAlert(message: "Select a record first for deletion in record list")
        }
    }
    
    // Record Edition  method
    private func  prepareNdefUriRecord() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "ST25AreaManagement", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ST25NDEFUrlRecordViewController") as! ST25NDEFUrlRecordViewController
        nextViewController.delegate = self.mParentVC
        nextViewController.mAction = mCurrentActionOnRecordToDo
        if mCurrentActionOnRecordToDo == .edit {
            // add the record to view controller
            nextViewController.mComStSt25sdkNdefUriRecord = (self.mParentVC.mNdefMsg.getNDEFRecord(with: jint(self.mParentVC.mCurrentIndexforRecordEdition)) as! ComStSt25sdkNdefUriRecord)
        }
        self.mParentVC.present(nextViewController, animated:true, completion:nil)
    }
    
    private func  prepareNdefTextRecord() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "ST25AreaManagement", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ST25NDEFTextRecordViewController") as! ST25NDEFTextRecordViewController
        nextViewController.delegate = self.mParentVC
        nextViewController.mAction = mCurrentActionOnRecordToDo
        if mCurrentActionOnRecordToDo == .edit {
            // add the record to view controller
            nextViewController.mComStSt25sdkNdefTextRecord = (self.mParentVC.mNdefMsg.getNDEFRecord(with: jint(self.mParentVC.mCurrentIndexforRecordEdition)) as! ComStSt25sdkNdefTextRecord)
        }
        self.mParentVC.present(nextViewController, animated:true, completion:nil)
    }
    private func  prepareNdefVCardRecord() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "ST25AreaManagement", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ST25NDEFVCardRecordViewController") as! ST25NDEFVCardRecordViewController
        nextViewController.delegate = self.mParentVC
        nextViewController.mAction = mCurrentActionOnRecordToDo
        if mCurrentActionOnRecordToDo == .edit {
            // add the record to view controller
            nextViewController.mComStSt25sdkNdefVCardRecord = (self.mParentVC.mNdefMsg.getNDEFRecord(with: jint(self.mParentVC.mCurrentIndexforRecordEdition)) as! ComStSt25sdkNdefVCardRecord)
        }
        self.mParentVC.present(nextViewController, animated:true, completion:nil)
    }

    private func  prepareNdefMailRecord() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "ST25NDEFRecordsStoryboard", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ST25NDEFMailRecordViewController") as! ST25NDEFMailRecordViewController
        nextViewController.delegate = self.mParentVC
        nextViewController.mAction = mCurrentActionOnRecordToDo
        if mCurrentActionOnRecordToDo == .edit {
            // add the record to view controller
            nextViewController.mComStSt25sdkNdefMailRecord = (self.mParentVC.mNdefMsg.getNDEFRecord(with: jint(self.mParentVC.mCurrentIndexforRecordEdition)) as! ComStSt25sdkNdefEmailRecord)
        }
        self.mParentVC.present(nextViewController, animated:true, completion:nil)
    }
    
    private func  prepareNdefSmsRecord() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "ST25NDEFRecordsStoryboard", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ST25NDEFSmsRecordViewController") as! ST25NDEFSmsRecordViewController
        nextViewController.delegate = self.mParentVC
        nextViewController.mAction = mCurrentActionOnRecordToDo
        if mCurrentActionOnRecordToDo == .edit {
            // add the record to view controller
            nextViewController.mComStSt25sdkNdefSmsRecord = (self.mParentVC.mNdefMsg.getNDEFRecord(with: jint(self.mParentVC.mCurrentIndexforRecordEdition)) as! ComStSt25sdkNdefSmsRecord)
        }
        self.mParentVC.present(nextViewController, animated:true, completion:nil)
    }
    
    private func  prepareNdefWifiRecord() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "ST25NDEFRecordsStoryboard", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ST25NDEFWifiRecordViewController") as! ST25NDEFWifiRecordViewController
        nextViewController.delegate = self.mParentVC
        nextViewController.mAction = mCurrentActionOnRecordToDo
        if mCurrentActionOnRecordToDo == .edit {
            // add the record to view controller
            nextViewController.mComStSt25sdkNdefWifiRecord = (self.mParentVC.mNdefMsg.getNDEFRecord(with: jint(self.mParentVC.mCurrentIndexforRecordEdition)) as! ComStSt25sdkNdefWifiRecord)
        }
        self.mParentVC.present(nextViewController, animated:true, completion:nil)
    }
    
    private func  prepareNdefCallRecord() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "ST25NDEFRecordsStoryboard", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ST25NDEFCallRecordViewController") as! ST25NDEFCallRecordViewController
        nextViewController.delegate = self.mParentVC
        nextViewController.mAction = mCurrentActionOnRecordToDo
        if mCurrentActionOnRecordToDo == .edit {
            // add the record to view controller
            nextViewController.mComStSt25sdkNdefUriRecord = (self.mParentVC.mNdefMsg.getNDEFRecord(with: jint(self.mParentVC.mCurrentIndexforRecordEdition)) as! ComStSt25sdkNdefUriRecord)
        }
        self.mParentVC.present(nextViewController, animated:true, completion:nil)
    }
    
    private func  prepareNdefGeolocalisationRecord() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "ST25NDEFRecordsStoryboard", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ST25NDEFGeolocalisationRecordViewController") as! ST25NDEFGeolocalisationRecordViewController
        nextViewController.delegate = self.mParentVC
        nextViewController.mAction = mCurrentActionOnRecordToDo
        if mCurrentActionOnRecordToDo == .edit {
            // add the record to view controller
            nextViewController.mComStSt25sdkNdefGeolocalisationRecord = (self.mParentVC.mNdefMsg.getNDEFRecord(with: jint(self.mParentVC.mCurrentIndexforRecordEdition)) as! ComStSt25sdkNdefUriRecord)
        }
        self.mParentVC.present(nextViewController, animated:true, completion:nil)
    }


    private func  prepareNdefMimeRecord() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "ST25NDEFRecordsStoryboard", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ST25NDEFMimeRecordViewController") as! ST25NDEFMimeRecordViewController
        
        nextViewController.delegate = self.mParentVC
        nextViewController.mAction = mCurrentActionOnRecordToDo
        if mCurrentActionOnRecordToDo == .edit {
            // add the record to view controller
            nextViewController.mComStSt25sdkNdefMimeRecord = (self.mParentVC.mNdefMsg.getNDEFRecord(with: jint(self.mParentVC.mCurrentIndexforRecordEdition)) as! ComStSt25sdkNdefMimeRecord)
        }
    
        self.mParentVC.present(nextViewController, animated:true, completion:nil)
    }
    
    private func  prepareNdefExternalRecord() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "ST25NDEFRecordsStoryboard", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ST25NDEFExternalRecordViewController") as! ST25NDEFExternalRecordViewController
        
        nextViewController.delegate = self.mParentVC
        nextViewController.mAction = mCurrentActionOnRecordToDo
        if mCurrentActionOnRecordToDo == .edit {
            // add the record to view controller
            nextViewController.mComStSt25sdkNdefExternalRecord = (self.mParentVC.mNdefMsg.getNDEFRecord(with: jint(self.mParentVC.mCurrentIndexforRecordEdition)) as! ComStSt25sdkNdefExternalRecord)
        }
    
        self.mParentVC.present(nextViewController, animated:true, completion:nil)
    }
    
    private func  prepareNdefAarRecord() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "ST25NDEFRecordsStoryboard", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ST25NDEFAarRecordViewController") as! ST25NDEFAarRecordViewController
        
        nextViewController.delegate = self.mParentVC
        nextViewController.mAction = mCurrentActionOnRecordToDo
        if mCurrentActionOnRecordToDo == .edit {
            // add the record to view controller
            nextViewController.mComStSt25sdkNdefAarRecord = (self.mParentVC.mNdefMsg.getNDEFRecord(with: jint(self.mParentVC.mCurrentIndexforRecordEdition)) as! ComStSt25sdkNdefAarRecord)
        }
    
        self.mParentVC.present(nextViewController, animated:true, completion:nil)
    }

    private func execRecord (at indexPath: IndexPath) {
        if jint(indexPath.row) >= 0  &&  self.mParentVC.mNdefMsg != nil && jint(indexPath.row) < self.mParentVC.mNdefMsg.getNbrOfRecords() {
            let rcd = self.mParentVC.mNdefMsg.getNDEFRecord(with: jint(indexPath.row))
            var ndefRecord:NDEFRecords?
            
            // Check record type
            switch (rcd)
            {
            case  is ComStSt25sdkNdefUriRecord :
                ndefRecord = NDEFUriRecords(ndefRecord: rcd!)
            break
                
            case  is ComStSt25sdkNdefTextRecord :
                ndefRecord = NDEFTextRecords(ndefRecord: rcd!)
            break

            case  is ComStSt25sdkNdefEmailRecord :
                ndefRecord = NDEFEmailRecords(ndefRecord: rcd!)
            break
            
            case  is  ComStSt25sdkNdefVCardRecord :
                ndefRecord = NDEFVcardRecords(ndefRecord: rcd!)
            break
                
            case  is  ComStSt25sdkNdefBtRecord :
                ndefRecord = NDEFBtRecords(ndefRecord: rcd!)
            break
                
            case  is  ComStSt25sdkNdefBtLeRecord :
                ndefRecord = NDEFBtleRecords(ndefRecord: rcd!)
            break
                                
            case  is  ComStSt25sdkNdefSmsRecord :
                ndefRecord = NDEFSmsRecords(ndefRecord: rcd!)
            break
                
            case  is  ComStSt25sdkNdefWifiRecord :
                ndefRecord = NDEFWifiRecords(ndefRecord: rcd!)
            break
                
            case  is  ComStSt25sdkNdefMimeRecord :
                ndefRecord = NDEFMimeRecords(ndefRecord: rcd!)
                // Due to too many data types to handle, only video/mpeg type is handled
                if ((ndefRecord as! NDEFMimeRecords).mMimeId.contains("video/mpeg") ||
                    (ndefRecord as! NDEFMimeRecords).mMimeId.contains("video/mpeg")
                ){
                    warningAlert(message: "Only video/mpeg data type is handled")
                }
            break
                
            case  is  ComStSt25sdkNdefExternalRecord :
                warningAlert(message: "No action handled for NDEF external records")
            break
                
            case  is  ComStSt25sdkNdefAarRecord :
                warningAlert(message: "No action handled for NDEF AAR records")
            break
                
            default:
                break
            }
            if (ndefRecord != nil){
                let ndefActionHandler:NDEFActionHandler = NDEFActionHandler(vc: self.mParentVC, ndefRecord: ndefRecord!)
                ndefActionHandler.runNDEF()
            }

        } else {
            warningAlert(message: "Select a valid record first for edition in record list")
        }
    }

    private func  prepareNdefBTRecord(isBTLe : Bool) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "ST25NDEFRecordsStoryboard", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ST25NDEFBTRecordViewController") as! ST25NDEFBTRecordViewController
        nextViewController.delegate = self.mParentVC
        nextViewController.mAction = mCurrentActionOnRecordToDo
        nextViewController.isBTLe = isBTLe
        if mCurrentActionOnRecordToDo == .edit {
            // add the record to view controller
            if isBTLe {
            nextViewController.mComStSt25sdkNdefBTLeRecord = (self.mParentVC.mNdefMsg.getNDEFRecord(with: jint(self.mParentVC.mCurrentIndexforRecordEdition)) as! ComStSt25sdkNdefBtLeRecord)
                
            }else {
            nextViewController.mComStSt25sdkNdefBTRecord = (self.mParentVC.mNdefMsg.getNDEFRecord(with: jint(self.mParentVC.mCurrentIndexforRecordEdition)) as! ComStSt25sdkNdefBtRecord)
               
            }

        }
        self.mParentVC.present(nextViewController, animated:true, completion:nil)
    }
}



extension ST25NdefRecordsListManager: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.mParentVC.mNdefMsg != nil && self.mParentVC.mNdefMsg.getNbrOfRecords() > 0 {
            return Int(self.mParentVC.mNdefMsg.getNbrOfRecords())
        }
        return Int(1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recordCell", for: indexPath)
        
        if self.mParentVC.mNdefMsg != nil && indexPath.row < self.mParentVC.mNdefMsg.getNbrOfRecords() {

            let rcd = self.mParentVC.mNdefMsg.getNDEFRecord(with: jint(indexPath.row))
            // Check record type
            switch (rcd)
            {
            case is ComStSt25sdkNdefEmptyRecord :
                cell.imageView?.image = UIImage(named: "empty")
                cell.textLabel?.text = "Empty record"
                cell.detailTextLabel?.text = ""
                break
                
            case  is ComStSt25sdkNdefUriRecord :
                let ndefUriRecordTmp:NDEFUriRecords = NDEFUriRecords(ndefRecord: rcd!)
                cell.imageView?.image = ndefUriRecordTmp.mImage
                cell.textLabel?.text = ndefUriRecordTmp.mRecordTypeString
                cell.detailTextLabel?.text = ndefUriRecordTmp.mRecordValue
                break
                
            case  is  ComStSt25sdkNdefTextRecord :
                cell.imageView?.image = UIImage(named: "text")
                cell.textLabel?.text = "Text record"
                cell.detailTextLabel?.text = (rcd as! ComStSt25sdkNdefTextRecord).getText()
                break
                
            case  is  ComStSt25sdkNdefBtRecord :
                cell.imageView?.image = UIImage(named: "bluetooth")
                cell.textLabel?.text = "Bluetooth record"
                cell.detailTextLabel?.text = (rcd as! ComStSt25sdkNdefBtRecord).getBTDeviceName()
                break
                
            case  is  ComStSt25sdkNdefBtLeRecord :
                cell.imageView?.image = UIImage(named: "bluetooth")
                cell.textLabel?.text = "Bluetooth Low Energy record"
                cell.detailTextLabel?.text = (rcd as! ComStSt25sdkNdefBtLeRecord).getBTDeviceName()
                break
                
            case  is  ComStSt25sdkNdefEmailRecord :
                cell.imageView?.image = UIImage(named: "mail")
                cell.textLabel?.text = "Mail record"
                cell.detailTextLabel?.text = (rcd as! ComStSt25sdkNdefEmailRecord).getSubject()
                break
                
            case  is  ComStSt25sdkNdefSmsRecord :
                cell.imageView?.image = UIImage(named: "sms")
                cell.textLabel?.text = "Sms record"
                cell.detailTextLabel?.text = (rcd as! ComStSt25sdkNdefSmsRecord).getContact()
                break
                
            case  is  ComStSt25sdkNdefVCardRecord :
                cell.imageView?.image = UIImage(named: "vcard")
                cell.textLabel?.text = "Vcard record"
                cell.detailTextLabel?.text = (rcd as! ComStSt25sdkNdefVCardRecord).getName()
                break
                
            case  is  ComStSt25sdkNdefWifiRecord :
                cell.imageView?.image = UIImage(named: "wifi")
                cell.textLabel?.text = "Wifi record"
                cell.detailTextLabel?.text = (rcd as! ComStSt25sdkNdefWifiRecord).getSSID()
                break
                
            case  is  ComStSt25sdkNdefMimeRecord :
                let ndefMimeRecord:NDEFMimeRecords = NDEFMimeRecords.init(ndefRecord: rcd!)
                cell.imageView?.image = ndefMimeRecord.mImage
                cell.textLabel?.text = ndefMimeRecord.mRecordTypeString
                cell.detailTextLabel?.text = ndefMimeRecord.mMimeId
                break
                
            case  is  ComStSt25sdkNdefExternalRecord :
                let ndefExternalRecord:NDEFExternalRecords = NDEFExternalRecords.init(ndefRecord: rcd!)
                cell.imageView?.image = ndefExternalRecord.mImage
                cell.textLabel?.text = ndefExternalRecord.mRecordTypeString
                cell.detailTextLabel?.text = ndefExternalRecord.mRecordValue
                break

            case  is  ComStSt25sdkNdefAarRecord:
                let ndefAarRecord:NDEFAarRecord = NDEFAarRecord.init(ndefRecord: rcd!)
                cell.imageView?.image = ndefAarRecord.mImage
                cell.textLabel?.text = ndefAarRecord.mRecordTypeString
                cell.detailTextLabel?.text = ndefAarRecord.mRecordValue
                break

            default:
                break
            }
            
        } else {
            // No NDEF message - display the information
            cell.imageView?.image = UIImage(named: "right_arrow_light_dark_blue")
            cell.textLabel?.text = "No Ndef record"
            cell.detailTextLabel?.text = ""
            
        }
        
        return cell
        
    }
    
    //A simple example of what you can do in the cell
    func setCell(action:actionOnRecordToDo, at indexPath: IndexPath){
        
        // Or more likely change something related to this cell specifically.
        //let cell = self.mRecordsTableView.cellForRow(at: indexPath )
        //print(action)
        self.mParentVC.mCurrentIndexforRecordEdition = indexPath.row

        if action == .edit {
            mCurrentActionOnRecordToDo = .edit
            editRecord(at: indexPath)
        }
        if action == .add  {
            mCurrentActionOnRecordToDo = .add
            addRecord(at: indexPath.row)
        }
        if action == .insert  {
            mCurrentActionOnRecordToDo = .insert
            addRecord(at: indexPath.row)
        }
        
        if action == .remove {
            //self.mRecordsTableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            removeRecord(at: indexPath)
        }
        
        if action == .exec {
            execRecord(at: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let ExecAction = UIContextualAction(style: .normal, title: "Exec") { (action, view, actionPerformed) in
            self.setCell(action: .exec, at: indexPath)
        }
        ExecAction.backgroundColor = .stLightBlueColor()
        
        let InsertAction = UIContextualAction(style: .normal, title: "Insert") { (action, view, actionPerformed) in
            self.setCell(action: .insert, at: indexPath)
        }
        InsertAction.backgroundColor = .stDarkBlueColor()
        
        let EditAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, actionPerformed) in
            self.setCell(action: .edit, at: indexPath)
        }
        EditAction.backgroundColor = .stLightBlueColor()
        
        let AddAction = UIContextualAction(style: .normal, title: "Add") { (action, view, actionPerformed) in
            self.setCell(action: .add, at: indexPath)
        }
        AddAction.backgroundColor = .stDarkBlueColor()
               
        return UISwipeActionsConfiguration(actions: [ExecAction,InsertAction,EditAction,AddAction])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let RemoveAction = UIContextualAction(style: .destructive, title: "Remove") { (action, view, actionPerformed) in
            self.setCell(action: .remove, at: indexPath)
        }
        RemoveAction.backgroundColor = .stLightYellowColor()
        
        return UISwipeActionsConfiguration(actions: [RemoveAction])
    }
}







