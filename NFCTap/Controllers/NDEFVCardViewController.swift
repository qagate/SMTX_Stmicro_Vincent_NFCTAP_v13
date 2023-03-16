//
//  NDEFVCardViewController.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 16/10/2017.
//  Copyright © 2017 STMicroelectronics. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class NDEFVCardViewController: NSObject, CNContactPickerDelegate,CNContactViewControllerDelegate{

    var mNDEFVcardRecords:NDEFVcardRecords!
    var mUIViewController:UIViewController!
    
    override init() {
        super.init()
    }
    
    // designated initializer
    init(vc:UIViewController,ndefVcardRecord:NDEFVcardRecords){
        super.init()
        self.mUIViewController = vc
        self.mNDEFVcardRecords = ndefVcardRecord
    }
    
    func showVcardContact() {
        
        self.requestForAccess { (accessGranted) -> Void in
            if !accessGranted {
                let message = NSLocalizedString("Please allow the app to access your contacts through the Settings.",
                                                comment: "")
                self.showVcardAlertMessage(message:message)
                return
            }
        }
        
        let store = CNContactStore()
        var contactData = [CNContact()]
        
        var vcardData = mNDEFVcardRecords.mVcardInfo
        
        // Workaround : replace \r by ""
        vcardData = vcardData?.replacingOccurrences(of: "\r", with: "")
        let vcardDataNew = vcardData?.data(using: .utf8)
        
        do{
            try contactData = CNContactVCardSerialization.contacts(with: vcardDataNew!)
        } catch let err{
            let formatString = NSLocalizedString("Failed to convert the Vcard contact ",comment: "")
            let message = NSLocalizedString("Failed to convert the Vcard contact ",comment: "")+err.localizedDescription
            print(message)
            self.showVcardAlertMessage(message:message)
        }
        
        let contact : CNMutableContact = contactData[0].mutableCopy() as! CNMutableContact
        print(contact.givenName)
        
        var fetchContactName = contact.givenName
        if (contact.givenName.isEmpty && contact.familyName.isEmpty){
             self.showVcardAlertMessage(message:"Unable to fetch contacts.")
            return
        }else if (contact.givenName.isEmpty){
            fetchContactName = contact.familyName
        }
        
        let predicate = CNContact.predicateForContacts(matchingName: fetchContactName)
        
        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey, CNContactBirthdayKey, CNContactImageDataKey]
        var message : String!
        do {
            let contactTmp = try store.unifiedContacts(matching: predicate, keysToFetch: keys as [CNKeyDescriptor])
            if contactTmp.count == 0 {
                message = "No contacts were found matching the given name."
                print(message)
                
                let request = CNSaveRequest()
                request.add(contact, toContainerWithIdentifier: nil)
                do{
                    try store.execute(request)
                    //let formatString = NSLocalizedString("Successfully added the contact %@",comment: "")
                    //message = String.localizedStringWithFormat(formatString,contact.givenName)
                    //print(message)
                    //self.showVcardAlertMessage(message:message)
                } catch let err{
                    message = NSLocalizedString("Failed to save the contact ",comment: "")+err.localizedDescription
                    //print(message)
                    self.showVcardAlertMessage(message:message)
                }
            }
        }
        catch {
            message = "Unable to fetch contacts."
            self.showVcardAlertMessage(message:message)
        }
         
        //let contactViewController = CNContactViewController(for: contact)
        let contactViewController = CNContactViewController(forUnknownContact: contact)
        contactViewController.contactStore = store
        contactViewController.delegate = self
        contactViewController.allowsActions = true
        let STColor = UIColor(red: 0, green: 32/255, blue: 82/255, alpha: 1)
        self.mUIViewController.navigationController?.navigationBar.isTranslucent = false
        self.mUIViewController.navigationController?.navigationBar.barTintColor = STColor
        self.mUIViewController.navigationController?.navigationBar.backgroundColor = STColor
        //let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        //statusBar.backgroundColor = STColor
        self.mUIViewController.navigationController?.pushViewController(contactViewController, animated: true)
    }
    
    func requestForAccess(completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        let store = CNContactStore()
        
        switch authorizationStatus {
        case .authorized:
            completionHandler(true)
            
        case .denied, .notDetermined:
            store.requestAccess(for: CNEntityType.contacts, completionHandler: { (access, accessError) -> Void in
                if access {
                    completionHandler(access)
                }
                else {
                    if authorizationStatus == CNAuthorizationStatus.denied {
                        completionHandler(false)
                    }
                }
            })
            
        default:
            completionHandler(false)
        }
    }
    
    private func showVcardAlertMessage(message : String){
        let alert = UIAlertController(title: nil,
                                      message: message,
                                      preferredStyle: .alert)
        
        let okActionBtn = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okActionBtn)
        self.mUIViewController.present(alert, animated: true, completion: nil)
    }
}

