//
//  ST25NDEFGeolocalisationRecordViewController.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 23/04/2020.
//  Copyright © 2020 STMicroelectronics. All rights reserved.
//

import UIKit
import MapKit

protocol LocationSelectionReady
{
    func onLocationSelectionReady(location : CLLocationCoordinate2D)
}

class ST25NDEFGeolocalisationRecordViewController: ST25UIViewController, LocationSelectionReady {
    
    func onLocationSelectionReady(location: CLLocationCoordinate2D) {
        mSelectedLocation = location
        mLatitudeLabel.text = String("\(location.latitude)")
        mLongitudeLabel.text = String("\(location.longitude)")
    }
    

    // ST25SDK NDEF Records
    var mComStSt25sdkNdefGeolocalisationRecord:ComStSt25sdkNdefUriRecord!
    var mAction: actionOnRecordToDo = .add
    var delegate:NdefRecordReady?

    private  var mSelectedLocation : CLLocationCoordinate2D!
    
    @IBOutlet weak var mLatitudeLabel: UITextField!
    @IBOutlet weak var mLongitudeLabel: UITextField!
    

    @IBAction func ValidateRecord(_ sender: UIButton) {
        if isNDEFRecordReady() {
             delegate?.onRecordReady(action: mAction, record: updateNDEFRecordMessage())
             self.dismiss(animated: false, completion: nil)
         } else {
             warningAlert(message: "Latitude and Longitude must not be empty ")
         }
    }
    
    @IBAction func CancelRecord(_ sender: UIButton) {
        delegate?.onRecordReady(action: .cancelled, record: updateNDEFRecordMessage())
        self.dismiss(animated: false, completion: nil)

    }

    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "getLocationOnMap" {
            //print(segue)
            guard let mapViewController = segue.destination as? MapViewController else { return }
            mapViewController.delegate = self
            var validLocation = true
            var lat = Double(mLatitudeLabel.text!)
            if lat == nil {
                print("Not a valid latitude number: \(mLatitudeLabel.text!)")
                validLocation = false
            }
            var long = Double(mLongitudeLabel.text!)
            if long == nil {
                print("Not a valid longitude number: \(mLongitudeLabel.text!)")
                validLocation = false
            }
            if !validLocation {
                //warningAlert(message: "Coordinates not conform, default used")
                // Paris TE
                lat = 48.858370
                long = 2.294481
            }

            let myloc = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
            mapViewController.mEditLocation = myloc
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if mComStSt25sdkNdefGeolocalisationRecord != nil {
            if (mComStSt25sdkNdefGeolocalisationRecord.getContent() != nil) {
                //print(mComStSt25sdkNdefGeolocalisationRecord.getContent())
                let content = mComStSt25sdkNdefGeolocalisationRecord.getContent()
                let fullItemsArr = content?.components(separatedBy: ":")
                if fullItemsArr?.count == 3 {
                    if fullItemsArr![0] == "geo" {
                        mLatitudeLabel.text = fullItemsArr![1]
                        mLongitudeLabel.text = fullItemsArr![2]
                    }
                } else if fullItemsArr?.count == 2 {
                    mLatitudeLabel.text = fullItemsArr![0]
                    mLongitudeLabel.text = fullItemsArr![1]
                    warningAlert(message: "Decoded coordinates not in format geo:latitude:longitude")

                } else {
                    warningAlert(message: "Coordinates not decoded")
                }
            }
        }

    }
    

    private func updateNDEFRecordMessage() -> ComStSt25sdkNdefUriRecord {
        
        // Create ST25SDK NDEF record
        mComStSt25sdkNdefGeolocalisationRecord = ComStSt25sdkNdefUriRecord()
        let uriCode = ComStSt25sdkNdefUriRecord_NdefUriIdCode_valueOfWithNSString_("NDEF_RTD_URI_ID_IMAP")

        mComStSt25sdkNdefGeolocalisationRecord.setUriIDWith(uriCode)
        let content = String("geo:\(mLatitudeLabel.text!):\(mLongitudeLabel.text!)")
        mComStSt25sdkNdefGeolocalisationRecord.setContentWith(content)
        return mComStSt25sdkNdefGeolocalisationRecord
    }

    private func isNDEFRecordReady() -> Bool {
        if (mLatitudeLabel.text != "" && mLongitudeLabel.text != "")  {
            return true
        } else {
            return false
        }
    }
    
    private func warningAlert(message : String) {
        UIHelper.warningAlert(viewController: self, title : "MAP record" , message: message)
    }
    
}
