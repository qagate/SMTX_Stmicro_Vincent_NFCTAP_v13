//
//  ST25NDEFVCardRecordViewController.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 16/01/2020.
//  Copyright © 2020 STMicroelectronics. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
import CoreNFC


class ST25NDEFVCardRecordViewController: ST25UIViewController, CNContactPickerDelegate {

     var delegate:NdefRecordReady?

     // ST25SDK NDEF Records
     var mComStSt25sdkNdefVCardRecord:ComStSt25sdkNdefVCardRecord!
     var mAction: actionOnRecordToDo = .add

     var cnPicker:CNContactPickerViewController!
     
     var sliderValue:Int!
     var mContactImageTmp:UIImage!
    
     private var isUpdateMessageValid:Bool? = false
     
     @IBOutlet weak var mSliderResolution: UISlider!
     @IBOutlet weak var mSwitchPhoto: UISwitch!
     
     @IBOutlet weak var mPictureResolutionLabel: UILabel!
     
     @IBOutlet weak var mContactImageView: UIImageView!
     @IBOutlet weak var mNameTextField: UITextField!
     @IBOutlet weak var mNumberTextField: UITextField!
    
     @IBOutlet weak var mEmailTextField: UITextField!
     @IBOutlet weak var mWebSiteTextField: UITextField!
    
    
     @IBOutlet weak var mAddressTextView: UITextField!
    
     @IBOutlet weak var mNdefSizeTextField: UITextField!
     @IBOutlet weak var mPictureSizeTextField: UITextField!
     
     @IBAction func handleSwitchPhoto(_ sender: Any) {
         mSliderResolution.isEnabled = self.mSwitchPhoto.isOn
         updateNdefVcardRecord(imageView: mContactImageView!)

     }
     
     @IBAction func handleGetContact(_ sender: Any) {
         cnPicker = CNContactPickerViewController()
         cnPicker.delegate = self
         self.present(cnPicker, animated: true, completion: nil)
     }
     
     @IBAction func handleSlider(_ sender: UISlider) {
         sliderValue = Int(sender.value)
         mPictureResolutionLabel.text = "Picture Resolution : \(sliderValue ?? 100)"
         
         if (mContactImageTmp != nil) {
             let image = mContactImageTmp
             let imageResized = resizeImageWithAspect(image: image!, ratio: CGFloat(sliderValue))
             
             mContactImageView.image = imageResized
         }
         
         updateNdefVcardRecord(imageView: mContactImageView)
     
     }
     
    @IBAction func ValidateRecord(_ sender: UIButton) {
        if (cnPicker != nil) {
            cnPicker.dismiss(animated: false, completion: nil)
        }
        let mComStSt25sdkNdefVCardRecordTmp = updateNDEFRecordMessage()
        if (isUpdateMessageValid!){
            delegate?.onRecordReady(action: mAction, record: mComStSt25sdkNdefVCardRecordTmp)
            self.dismiss(animated: false, completion: nil)
        }else{
            UIHelper.warningAlert(viewController: self, title: "NDEF VCard", message: "Record not valid. Please, check fields are not empty, or that image is correct")
        }
        
    }
    

    @IBAction func CancelRecord(_ sender: UIButton) {
        if (cnPicker != nil) {
            cnPicker.dismiss(animated: false, completion: nil)
        }
        delegate?.onRecordReady(action: .cancelled, record: updateNDEFRecordMessage())
        self.dismiss(animated: false, completion: nil)
        
    }
    
    override func viewDidLoad() {
         super.viewDidLoad()
         sliderValue = 100
         self.mNameTextField.delegate = self
         self.mNumberTextField.delegate = self
         self.mEmailTextField.delegate = self
         self.mWebSiteTextField.delegate = self
         mContactImageView.image = resizeImageWithAspect(image: mContactImageView.image!, ratio: 25)
         mContactImageTmp = mContactImageView.image
        
        if mComStSt25sdkNdefVCardRecord != nil {
            
            mNameTextField.text = mComStSt25sdkNdefVCardRecord.getName()
            mNumberTextField.text = mComStSt25sdkNdefVCardRecord.getNumber()
            mEmailTextField.text = mComStSt25sdkNdefVCardRecord.getEmail()
            mWebSiteTextField.text = mComStSt25sdkNdefVCardRecord.getWebSiteAddr()
            
            mNameTextField.text = mComStSt25sdkNdefVCardRecord.getName()
            mNameTextField.text = mComStSt25sdkNdefVCardRecord.getName()

            if mComStSt25sdkNdefVCardRecord.getPhoto() != nil {
                let strBase64 = mComStSt25sdkNdefVCardRecord.getPhoto()
                let dataDecoded:NSData = NSData(base64Encoded: strBase64!, options: NSData.Base64DecodingOptions(rawValue: 0))!
                let decodedimage:UIImage = UIImage(data: dataDecoded as Data)!
                //print(decodedimage)
                mContactImageView.image = decodedimage
                mContactImageTmp = decodedimage
            }
        }
     }
     
     
     private func resizeImageWithAspect(image: UIImage,ratio :CGFloat)->UIImage? {
         
         let oldWidth = image.size.width;
         let oldHeight = image.size.height;

         let newHeight = (( oldHeight - 10) * ratio / 100 + 10 )
         let newWidth = (( oldWidth - 10) * ratio / 100 + 10 )
         
         //print(newHeight)
         //print(newWidth)
         
         let newSize = CGSize(width: newWidth, height: newHeight)

         UIGraphicsBeginImageContextWithOptions(newSize,false,UIScreen.main.scale);

         image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height));
         let newImage = UIGraphicsGetImageFromCurrentImageContext();
         UIGraphicsEndImageContext();
         return newImage
     }
     
     private func updateNdefVcardRecord(imageView: UIImageView){
         mComStSt25sdkNdefVCardRecord = ComStSt25sdkNdefVCardRecord()
         mComStSt25sdkNdefVCardRecord.setNameWith(mNameTextField.text)
         mComStSt25sdkNdefVCardRecord.setNickNameWith(mNameTextField.text)
         mComStSt25sdkNdefVCardRecord.setEmailWith(mEmailTextField.text)
         mComStSt25sdkNdefVCardRecord.setNumberWith(mNumberTextField.text)
         mComStSt25sdkNdefVCardRecord.setSPAddrWith(mAddressTextView.text)
         mComStSt25sdkNdefVCardRecord.setWebSiteWith(mWebSiteTextField.text)
         mComStSt25sdkNdefVCardRecord.setFormattedNameWith(mNameTextField.text)
         if (self.mSwitchPhoto.isOn == true){
             if (imageView.image != nil){
                 let imageData = imageView.image!.jpegData(compressionQuality: 0.20)
                 let imageDataString=imageData!.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
                 mComStSt25sdkNdefVCardRecord.setPhotoWith(imageDataString)
                 
                 mPictureSizeTextField.text = "["+"\(Int(imageView.image!.size.width))"+" "+"\(Int(imageView.image!.size.height))"+"]"
             }
         }
         
     }
     
     private func updateNDEFRecordMessage() -> ComStSt25sdkNdefVCardRecord {
        // By default, we assume that message is valid. If not, an exception will occur, and will set value to false.
        self.isUpdateMessageValid = true
        self.updateNdefVcardRecord(imageView: mContactImageView!)
        
        SwiftTryCatch.try({
            self.mNdefSizeTextField.text = "\(self.mComStSt25sdkNdefVCardRecord.getSize())"+" bytes"
        }
        , catch: { (error) in
            self.isUpdateMessageValid = false
        }
        , finallyBlock: {
        })
        
        return mComStSt25sdkNdefVCardRecord
     }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        super.touchesBegan(touches, with: event)
        self.updateNdefVcardRecord(imageView: mContactImageView!)
    }
    
     // CNContactPickerDelegate Method
     func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
         //print("Selected a contact")
         
         if contact.isKeyAvailable(CNContactFamilyNameKey){
             mNameTextField.text = contact.givenName+" "+contact.middleName
        
         } else {
             mNameTextField.text = ""
         }
         
         if contact.isKeyAvailable(CNContactPhoneNumbersKey){
             for phoneNumber:CNLabeledValue in contact.phoneNumbers {
                 let a = phoneNumber.value as! CNPhoneNumber
                 mNumberTextField.text = a.stringValue
             }
         } else {
             mNumberTextField.text = ""
         }
         
         if contact.isKeyAvailable(CNContactEmailAddressesKey){
             for emailAddress:CNLabeledValue in contact.emailAddresses{
                 mEmailTextField.text = emailAddress.value as String
             }
         } else {
             mEmailTextField.text = ""
         }
         
         if contact.isKeyAvailable(CNContactPostalAddressesKey){
             for postalAddress:CNLabeledValue in contact.postalAddresses{
                 mAddressTextView.text = postalAddress.value.street
             }
             
         } else {
             mAddressTextView.text = ""
         }
         
         if contact.isKeyAvailable(CNContactUrlAddressesKey){
             for urlWebSite:CNLabeledValue in contact.urlAddresses{
                 mWebSiteTextField.text = urlWebSite.value as String
             }
             
         } else {
             mWebSiteTextField.text = ""
         }
         
         if contact.imageDataAvailable {
             // there is an image for this contact
             mContactImageView.image = UIImage(data: contact.imageData!)!
             mContactImageTmp = mContactImageView.image
             let image = mContactImageTmp
             let imageResized = resizeImageWithAspect(image: image!, ratio: CGFloat(sliderValue))
                     
             mContactImageView.image = imageResized
        }
         
         updateNdefVcardRecord(imageView: mContactImageView)
     }
     
     
     func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
         //print("Cancel Contact Picker")
     }
     
}
