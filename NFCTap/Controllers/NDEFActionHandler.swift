//
//  NDEFActionHandler.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 17/10/2017.
//  Copyright © 2017 STMicroelectronics. All rights reserved.
//

import UIKit

class NDEFActionHandler: NSObject {
    
    var mUIViewController:ST25UIViewController!
    var mNDEFRecords:NDEFRecords!
    
    override init() {
        super.init()
    }
    
    
    // designated initializer
    init(vc:ST25UIViewController,ndefRecord:NDEFRecords){
        super.init()
        self.mUIViewController = vc
        self.mNDEFRecords = ndefRecord
    }
    
    func runNDEF(){
        // Run URI NDEF
        if (mNDEFRecords is NDEFUriRecords){
            let ndefRecordTmp = mNDEFRecords as! NDEFUriRecords
            
            if let url = NSURL(string: ndefRecordTmp.mRecordValue.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!) {
                openApplicationWithURI(url: url as URL)
            }
            
        }
        
        // Run Text NDEF
        else if (mNDEFRecords is NDEFTextRecords){
            let ndefRecordTmp = mNDEFRecords as! NDEFTextRecords
            openNDEFTextView(data: ndefRecordTmp.mRecordValue)
        }
        
        // Run SMS NDEF
        else if (mNDEFRecords is NDEFSmsRecords){
            let ndefRecordTmp = mNDEFRecords as! NDEFSmsRecords
            
            if let url = NSURL(string: ndefRecordTmp.mRecordValue.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!) {
                openApplicationWithURI(url: url as URL)
                
            }
        }
        
        // Run Mail NDEF
        else if (mNDEFRecords is NDEFEmailRecords){
            let ndefRecordTmp = mNDEFRecords as! NDEFEmailRecords
            
            if let url = NSURL(string: ndefRecordTmp.mRecordValue.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!) {
                openApplicationWithURI(url: url as URL)
                
            }
        }
        
        // Run BTLE NDEF
        else if (mNDEFRecords is NDEFBtleRecords){
            let ndefRecordTmp = mNDEFRecords as! NDEFBtleRecords
            if let myBTName = ndefRecordTmp.mComStSt25sdkNdefNDEFBtLe.getBTDeviceName() {
                openBtleView(btleName: myBTName)
            } else {
                UIHelper.warningAlert(viewController: self.mUIViewController, title: "BT record", message: "Device name not defined")
            }
        }
        
        // Run BT NDEF
        else if (mNDEFRecords is NDEFBtRecords){
            let ndefRecordTmp = mNDEFRecords as! NDEFBtRecords
            if let myBTName = ndefRecordTmp.mComStSt25sdkNdefNDEFBt.getBTDeviceName() {
                openBtleView(btleName: myBTName)
            } else {
                UIHelper.warningAlert(viewController: self.mUIViewController, title: "BTLe record", message: "Device name not defined")
            }
         }
        
        // Run VCard NDEF
        else if (mNDEFRecords is NDEFVcardRecords){
            let ndefRecordTmp = mNDEFRecords as! NDEFVcardRecords
            openVCardView(ndefVcardRecord : ndefRecordTmp)
        }
        
        // Run Mime NDEF
        else if (mNDEFRecords is NDEFMimeRecords){
            let ndefRecordTmp = mNDEFRecords as! NDEFMimeRecords
            openMimeView(mimeId: ndefRecordTmp.mMimeId, data: ndefRecordTmp.mMimeContent)
        }
            
        // Run External Record NDEF
        else if (mNDEFRecords is NDEFExternalRecords){
            let ndefRecordTmp = mNDEFRecords as! NDEFExternalRecords
            openExternalView(externalId: ndefRecordTmp.mDomainId+"/"+ndefRecordTmp.mTypeId, data: ndefRecordTmp.mContent)
        }
            
        // Run Wifi Record NDEF
        else if (mNDEFRecords is NDEFWifiRecords){
            let ndefRecordTmp = mNDEFRecords as! NDEFWifiRecords
            openNDEFWifiView(SSID: ndefRecordTmp.mComStSt25sdkNdefNDEFWifi.getSSID(), key: ndefRecordTmp.mComStSt25sdkNdefNDEFWifi.getEncrKey(), encryptionType: Int(ndefRecordTmp.mComStSt25sdkNdefNDEFWifi.getEncrType()))
        }
        
        // Run NDEF Not handled yet
        else {
            alertNDEFNotHandled()
        }
     }
    
    // Run application with URL
    private func openApplicationWithURI(url : URL){
        if (UIApplication.shared.canOpenURL(url)){
            UIApplication.shared.open(url, options: [:],
                                      completionHandler: {
                                        (success) in
                                        print("Open \(url): \(success)")
            })
            
        }
        else{
            // Display content of Record into Alert Controller
            let alert = UIAlertController(title: nil,
                                          message: NSLocalizedString("URI not supported.",comment: ""),
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK",
                                                                   comment: ""), style: .default, handler: nil))
            
            self.mUIViewController.present(alert, animated: true, completion: nil)
        }
    }
    
    // Run webView in case of URL
    private func openWebView(url : URL, data: String){
        let storyBoard : UIStoryboard = UIStoryboard(name: "NDEFRecordsAction", bundle:nil)
        let mWebViewVC = storyBoard.instantiateViewController(withIdentifier: "NDEFWebViewController") as! NDEFWebViewController
        mWebViewVC.setURL(url: url,data: data)
        self.mUIViewController.present(mWebViewVC, animated: true, completion:nil)
        
    }
    
    // Run Text View
    private func openNDEFTextView(data: String){
        let storyBoard : UIStoryboard = UIStoryboard(name: "NDEFRecordsAction", bundle:nil)
        let mNDEFTextVC = storyBoard.instantiateViewController(withIdentifier: "NDEFTextViewController") as! NDEFTextViewController
        mNDEFTextVC.setText(data: data)
        self.mUIViewController.present(mNDEFTextVC, animated: true, completion:nil)
   }
    
    // Run BTLE View
    private func openBtleView(btleName: String){
        let mPeripheralViewController:PeripheralViewController = UIStoryboard(name: "NDEFRecordsAction", bundle: nil).instantiateViewController(withIdentifier: "PeripheralViewController") as! PeripheralViewController
        mPeripheralViewController.setNdefBtleName(name: btleName)
        self.mUIViewController.present(mPeripheralViewController, animated: true)
    }
    
    // Run VCard View
    private func openVCardView(ndefVcardRecord : NDEFVcardRecords){
        let mNDEFVCardVC = NDEFVCardViewController.init(vc: self.mUIViewController, ndefVcardRecord: ndefVcardRecord)
        mNDEFVCardVC.showVcardContact()
    }
    
    // Run Mime View
    private func openMimeView(mimeId : String, data: String){
        let mMimeViewVC = UIStoryboard(name: "NDEFRecordsAction", bundle:nil).instantiateViewController(withIdentifier: "NDEFMimeViewController") as! NDEFMimeViewController
        mMimeViewVC.setMime(mimeId: mimeId, data: data)
        self.mUIViewController.present(mMimeViewVC, animated: true)
    }
    
    // Run External NDEF View
    private func openExternalView(externalId : String, data: String){
        let mExternalViewVC = UIStoryboard(name: "NDEFRecordsAction", bundle:nil).instantiateViewController(withIdentifier: "NDEFExternalViewController") as! NDEFExternalViewController
        mExternalViewVC.setExternal(externalId: externalId, data: data)
        self.mUIViewController.present(mExternalViewVC, animated: true)
    }
    
    // Run Wifi View
    private func openNDEFWifiView(SSID: String, key: String, encryptionType:Int){
        let mNDEFWifiVC = UIStoryboard(name: "NDEFRecordsAction", bundle:nil).instantiateViewController(withIdentifier: "NDEFWifiViewController") as! NDEFWifiViewController
        mNDEFWifiVC.setNDEFWifiRecord(SSID: SSID, key: key, encryptionType: encryptionType)
        self.mUIViewController.present(mNDEFWifiVC, animated: true)
    }
    
    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    // Handle NDEF Application
    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    private func alertNDEFNotHandled() {
        // Display content of Record into Alert Controller
        let alert = UIAlertController(
            title: NSLocalizedString("NDEF Native Application unhandled",comment: ""),
            message: NSLocalizedString("You can show or share NDEF.\n",comment: ""),
            preferredStyle: .alert)
        
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK",comment: ""), style: .default, handler: nil))
        
        self.mUIViewController.present(alert, animated: true, completion: nil)
    }
    
}
