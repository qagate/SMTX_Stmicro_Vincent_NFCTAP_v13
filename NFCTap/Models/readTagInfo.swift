//
//  readTagInfo.swift
//  ST25NFCAppClip
//
//  Created by STMICROELECTRONICS on 23/09/2020.
//  Copyright © 2020 STMicroelectronics. All rights reserved.
//

import Foundation
import UIKit
import StoreKit
import CoreNFC


class readTagInfo: NSObject {
    private var mVC:UINavigationController
    
    // Reference the NFC session
    private var tagSession: NFCTagReaderSession!
    
    internal var miOSReaderSession:iOSReaderSession!

    
    // Reference to TagInfoTypes
    private var tagInfoTypeX: TagInfoTypeX?
    private var tagInfoType5:TagInfoType5?
    private var tagInfoType2:TagInfoType2?
    private var tagInfoType4:TagInfoType4?
    private var isValidCCFile:Bool? = false

    init(aVc:UINavigationController) {
        mVC = aVc
    }
    
    func startSession() {
        miOSReaderSession = iOSReaderSession(atagReaderSessionViewControllerDelegate: self)
        miOSReaderSession.startTagReaderSession(aResetTagInfo: true)
    }
    
   private func warningAlert(message : String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Read Tag Info", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.mVC.present(alert, animated: true, completion: nil)
        }
    }
    
    func setupTagTabBarMenuForTag(pdt : ComStSt25sdkTagHelper_ProductID,tagPropertiesInformationTableModel:TagInfoGenericModel,tagSystemInfo:TagInfo?) {
        
        // No customizable Menu in AppClip
        #if !APPCLIP
        let tabBar = TagTabBarController()
        let myTagMenu = tabBar.performTagMenuDiscovery(productId: (self.tagInfoTypeX!.mTagSystemInfo.getProductID()))
        self.mVC.tabBarController!.customizableViewControllers = []
        tabBar.performTagTabBarMenu(menu: myTagMenu, tabBarController: self.mVC.tabBarController!)
        #endif

        let sections = [Category(name:TagInfoGenericModel.infoFileSectionName, items: tagPropertiesInformationTableModel.tagInfo), Category(name:TagInfoGenericModel.systemFileSectionName, items: tagPropertiesInformationTableModel.systemFileInfo), Category(name:TagInfoGenericModel.ccFileSectionName, items: tagPropertiesInformationTableModel.ccFileInfo)]
    
        // No TabBarController in AppClip
        #if !APPCLIP
        let tabBarController : UITabBarController =  self.mVC.tabBarController!
        tabBarController.selectedIndex = 0

        let navigationController  = tabBarController.selectedViewController as! UINavigationController
        let controllers = navigationController.viewControllers // will give array
        let tagInfoController:ST25TagInformationViewController = (controllers[0] as? ST25TagInformationViewController)!
        #else
        let tagInfoController:ST25TagInformationViewController = UIStoryboard(name: "ST25TagInformation", bundle: nil).instantiateViewController(withIdentifier: "ST25TagInformationViewController") as! ST25TagInformationViewController
               
        #endif
        
        tagInfoController.sections = sections
        tagInfoController.productId = tagSystemInfo!.getProductID()
        tagInfoController.uid = tagSystemInfo?.uid
        tagInfoController.mTagSystemInfo = tagSystemInfo

        #if APPCLIP
        self.mVC.present(tagInfoController, animated: true, completion: nil)
        #endif

        #if !APPCLIP
        if (tagInfoController.productId == ComStSt25sdkTagHelper_ProductID.PRODUCT_UNKNOWN && self.isValidCCFile == true){
            let alert = UIAlertController(title: "Tag Info", message: "Unknown Product", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            tagInfoController.present(alert, animated: true, completion: nil)
        }
        // Reactivate this in case of request to choose action when CC file not present on Tag
        // ====================================================================================
//        else if (self.isValidCCFile == false){
//            let alert = UIAlertController(title: "CC File", message: "Invalid CC File. Please, Enter valid values before continuing...", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Edit CC File", style: .default, handler: { action in
//                
//                if (self.tagInfoTypeX is TagInfoType5){
//                    let ccFileTypeController:Type5CCFileViewController = UIStoryboard(name: "Type5CCFile", bundle: nil).instantiateViewController(withIdentifier: "Type5CCFileViewController") as! Type5CCFileViewController
//                    self.mVC.present(ccFileTypeController, animated: true, completion: nil)
//                }
//                
//                else if (self.tagInfoTypeX is TagInfoType2){
//                    let ccFileTypeController:Type2CCFileViewController = UIStoryboard(name: "Type2CCFile", bundle: nil).instantiateViewController(withIdentifier: "Type2CCFileViewController") as! Type2CCFileViewController
//                    self.mVC.present(ccFileTypeController, animated: true, completion: nil)
//                }
//                
//                else if (self.tagInfoTypeX is TagInfoType4){
//                }
//            })
//            )
//            tagInfoController.present(alert, animated: true, completion: nil)
//        }

        #endif
    }
}

extension readTagInfo:tagReaderSessionViewControllerDelegateWithFinallyBlock {
    
    func handleTag(st25SDKTag: ComStSt25sdkNFCTag, uid: Data!) throws {
        
        if (miOSReaderSession.mComStSt25sdkRFReaderInterface.mIso15693Tag != nil){
            self.tagInfoType5 = TagInfoType5(aNFCTag:miOSReaderSession.mComStSt25sdkRFReaderInterface.mNFCTag, aNFCISO15693Tag: miOSReaderSession.mComStSt25sdkRFReaderInterface.mIso15693Tag, aiOSReaderInterface: miOSReaderSession.mComStSt25sdkRFReaderInterface)
            self.tagInfoTypeX = self.tagInfoType5
            
        }else if (miOSReaderSession.mComStSt25sdkRFReaderInterface.mMiFareTag != nil){
            self.tagInfoType2 = TagInfoType2(aNFCTag:miOSReaderSession.mComStSt25sdkRFReaderInterface.mNFCTag, aNFCMiFareTag: miOSReaderSession.mComStSt25sdkRFReaderInterface.mMiFareTag, aiOSReaderInterface: miOSReaderSession.mComStSt25sdkRFReaderInterface)
            self.tagInfoTypeX = self.tagInfoType2
            
        }else if (miOSReaderSession.mComStSt25sdkRFReaderInterface.mIso7816Tag != nil){
            self.tagInfoType4 = TagInfoType4(aiOSReaderInterface: miOSReaderSession.mComStSt25sdkRFReaderInterface)
            self.tagInfoTypeX = self.tagInfoType4
            
        }else{
            miOSReaderSession.stopTagReaderSession("Invalid TAG or Tag not handled")
            return
        }
        
        UIHelper.UI() { [self] in
            // Try/Catch for Exceptions from OBJC calls
            self.isValidCCFile = self.tagInfoTypeX?.tagInformationProcess()
            
            // Code you want to be delayed
             self.setupTagTabBarMenuForTag(
                 pdt:  self.tagInfoTypeX!.mProductId,
                 tagPropertiesInformationTableModel: self.tagInfoTypeX!.mTagPropertiesInformationTableModel,
                 tagSystemInfo: self.tagInfoTypeX!.mTagSystemInfo)
            // ==========================
            if (self.isValidCCFile == true){
                miOSReaderSession.stopTagReaderSession()
            }else{
                miOSReaderSession.stopTagReaderSession("Error while processig CCFile")
            }
            #if !APPCLIP
            self.tagInfoTypeX?.processReadNdef()
            #endif

            
           }
    }
    
    func handleTagSessionError(didInvalidateWithError error: Error) {
        // Code you want to be delayed
        if (self.tagInfoTypeX?.mUID == nil){
            miOSReaderSession.stopTagReaderSession("Command failed: \(error.localizedDescription)")
        }
        if (self.tagInfoTypeX?.mUID == mUIDUnTraceable){
            self.setupTagTabBarMenuForTag(
             pdt: self.tagInfoTypeX!.mProductId,
             tagPropertiesInformationTableModel: self.tagInfoTypeX!.mTagPropertiesInformationTableModel,
             tagSystemInfo: self.tagInfoTypeX!.mTagSystemInfo)
        
            miOSReaderSession.stopTagReaderSession()
        }else{
            miOSReaderSession.stopTagReaderSession("Command failed: \(error.localizedDescription)")
        }
    }
    
    func handleTagST25SdkError(didInvalidateWithError error: NSException) {
        miOSReaderSession.stopTagReaderSession("Command failed: \(error.description)")
    }
    
    func handleFinallyBlock() {
    }
}
