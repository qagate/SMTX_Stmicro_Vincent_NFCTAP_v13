//
//  ST25NDEFWifiRecordViewController.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 06/04/2020.
//  Copyright © 2020 STMicroelectronics. All rights reserved.
//

import UIKit
import SystemConfiguration.CaptiveNetwork
import NetworkExtension


class ST25NDEFWifiRecordViewController: ST25UIViewController ,UIPickerViewDataSource, UIPickerViewDelegate {


    var delegate:NdefRecordReady?
    
    // ST25SDK NDEF Records
    var mComStSt25sdkNdefWifiRecord:ComStSt25sdkNdefWifiRecord!
    var mAction: actionOnRecordToDo = .add

    private var mListSSIDScheme = [
    "MY_SSID",
    ]
    private var mIndexListSSIDScheme:Int!
    
    private var currentNetworkInfos: Array<NetworkInfo>? {
        get {
            return SSID.fetchNetworkInfo()
        }
    }
    
    private var mListAuthenticationTypeScheme = [
    "OPEN",
    "WPAPSK",
    "SHARED",
    "WPA",
    "WPA2",
    "WPA2PSK"
    ]
    private var mIndexListAuthenticationTypeScheme:Int!

    private var mListEncryptionTypeScheme = [
    "NONE",
    "WEP",
    "TKIP",
    "AES"
    ]
    private var mIndexListEncryptionTypeScheme:Int!


    
    
    @IBOutlet weak var mPickerAuthenticationType: UIPickerView!
    @IBOutlet weak var mPickerEncryptionType: UIPickerView!
    @IBOutlet weak var mPickerSSIDType: UIPickerView!
    
    @IBOutlet weak var mEditSSIDField: UITextField!
    @IBOutlet weak var mAddRemoveSSIDButton: UIButton!
    
    @IBOutlet weak var mNetworkKeyField: UITextView!
    
    
    @IBAction func addRemoveSSIDButtonAction(_ sender: Any) {
        if mAddRemoveSSIDButton.titleLabel?.text == "Remove" {
            if mIndexListSSIDScheme > 0 {
                mListSSIDScheme.remove(at: mIndexListSSIDScheme)
                mPickerSSIDType.reloadAllComponents()
            }
        } else {
            // means Add
            if mEditSSIDField.text != "" {
                setSSIDOnPicker(ssidName: mEditSSIDField.text!)
            }
        }
    }
    

    @IBAction func ValidateRecord(_ sender: UIButton) {
        if isNDEFRecordReady() {
            delegate?.onRecordReady(action: mAction, record: updateNDEFRecordMessage())
            self.dismiss(animated: false, completion: nil)
        } else {
            warningAlert(message: "At least Tel field must not be empty ")
        }
        
    }
    
    @IBAction func CancelRecord(_ sender: UIButton) {
        delegate?.onRecordReady(action: .cancelled, record: updateNDEFRecordMessage())
         self.dismiss(animated: false, completion: nil)
         
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if currentNetworkInfos != nil && currentNetworkInfos!.count > 0 {
            //print("WIFI connected : \(currentNetworkInfos)")
            for networkInfo in currentNetworkInfos! { // networkInfo.ssid!
                if networkInfo.ssid != nil {
                    mListSSIDScheme.append(networkInfo.ssid!)
                }
            }
        }
        
        // Do any additional setup after loading the view.
        mEditSSIDField.delegate = self
        mAddRemoveSSIDButton.titleLabel?.text = "Add"
        
        mIndexListSSIDScheme = 1
        mPickerSSIDType.delegate = self
        
        mIndexListAuthenticationTypeScheme = 1
        mIndexListEncryptionTypeScheme = 1
        mPickerAuthenticationType.delegate = self
        mPickerEncryptionType.delegate  = self
        
        if mComStSt25sdkNdefWifiRecord != nil {
            mEditSSIDField.text = mComStSt25sdkNdefWifiRecord.getSSID()
            mNetworkKeyField.text = mComStSt25sdkNdefWifiRecord.getEncrKey()
            setAuthenticationValueOnPicker(value: Int(mComStSt25sdkNdefWifiRecord.getAuthType()))
            setEncryptionValueOnPicker(value: Int(mComStSt25sdkNdefWifiRecord.getEncrType()))
            setSSIDOnPicker(ssidName: mComStSt25sdkNdefWifiRecord.getSSID())
        }
    }
    

    private func updateNDEFRecordMessage() -> ComStSt25sdkNdefWifiRecord {
        
        mComStSt25sdkNdefWifiRecord = ComStSt25sdkNdefWifiRecord()
        if (mEditSSIDField.text == "") {
            mComStSt25sdkNdefWifiRecord.setSSIDWith("NotDefined")
        } else {
            mComStSt25sdkNdefWifiRecord.setSSIDWith(mEditSSIDField.text)
        }
        
        if (mNetworkKeyField.text == "") {
            mComStSt25sdkNdefWifiRecord.setEncrKeyWith("NotDefined")
        } else {
            mComStSt25sdkNdefWifiRecord.setEncrKeyWith(mNetworkKeyField.text)
        }
        mComStSt25sdkNdefWifiRecord.setAuthTypeWith(jint(getAuthenticationValue()))
        mComStSt25sdkNdefWifiRecord.setEncrTypeWith(jint(getEncryptionValue()))

        return mComStSt25sdkNdefWifiRecord
    }
    
    private func setSSIDOnPicker(ssidName : String) {
        var defaultRowIndex = mListSSIDScheme.firstIndex(of: ssidName)
        if(defaultRowIndex == nil) {
            // ssid not exist ....
            mListSSIDScheme.append(ssidName)
            mPickerSSIDType.reloadAllComponents()
            defaultRowIndex = mListSSIDScheme.count - 1
            
        }
        mPickerSSIDType.selectRow(defaultRowIndex!, inComponent: 0, animated: false)

    }
    
    private func getEncryptionValue() -> Int {
        var encryptionType : Int = Int(ComStSt25sdkNdefWifiRecord_WIFI_ENCR_NONE)
        let selectedEncryptionString = mListEncryptionTypeScheme[mIndexListEncryptionTypeScheme]
        switch (selectedEncryptionString) {
        case "NONE":
            encryptionType = Int(ComStSt25sdkNdefWifiRecord_WIFI_ENCR_NONE)
        case "WEP":
            encryptionType = Int(ComStSt25sdkNdefWifiRecord_WIFI_ENCR_WEP)
        case "TKIP":
            encryptionType = Int(ComStSt25sdkNdefWifiRecord_WIFI_ENCR_TKIP)
        case "AES":
            encryptionType = Int(ComStSt25sdkNdefWifiRecord_WIFI_ENCR_AES)
        default:
            encryptionType = Int(ComStSt25sdkNdefWifiRecord_WIFI_ENCR_NONE)
        }
        return encryptionType
    }
    

    private func setEncryptionValueOnPicker(value : Int) {
        var defaultRowIndex : Int = 0
        //var encryptionType : Int = Int(ComStSt25sdkNdefWifiRecord_WIFI_ENCR_NONE)
        //let selectedEncryptionString = mListEncryptionTypeScheme[mIndexListEncryptionTypeScheme]
        if ((value & Int(ComStSt25sdkNdefWifiRecord_WIFI_ENCR_NONE)) == ComStSt25sdkNdefWifiRecord_WIFI_ENCR_NONE) {
            defaultRowIndex = 0
        }
        if ((value & Int(ComStSt25sdkNdefWifiRecord_WIFI_ENCR_WEP)) == ComStSt25sdkNdefWifiRecord_WIFI_ENCR_WEP) {
            defaultRowIndex = 1
        }
        if ((value & Int(ComStSt25sdkNdefWifiRecord_WIFI_ENCR_TKIP)) == ComStSt25sdkNdefWifiRecord_WIFI_ENCR_TKIP) {
            defaultRowIndex = 2
        }
        if ((value & Int(ComStSt25sdkNdefWifiRecord_WIFI_ENCR_AES)) == ComStSt25sdkNdefWifiRecord_WIFI_ENCR_AES) {
            defaultRowIndex = 3
        }
        
        mPickerEncryptionType.selectRow(defaultRowIndex, inComponent: 0, animated: false)
    }
 

    private func getAuthenticationValue() -> Int {
        var authenticationType : Int = Int(ComStSt25sdkNdefWifiRecord_WIFI_AUTH_OPEN)
        let selectedAuthenticationString = mListAuthenticationTypeScheme[mIndexListAuthenticationTypeScheme]
        switch (selectedAuthenticationString) {
        case "OPEN":
            authenticationType = Int(ComStSt25sdkNdefWifiRecord_WIFI_AUTH_OPEN)
        case "WPAPSK":
            authenticationType = Int(ComStSt25sdkNdefWifiRecord_WIFI_AUTH_WPAPSK)
        case "SHARED":
            authenticationType = Int(ComStSt25sdkNdefWifiRecord_WIFI_AUTH_SHARED)
        case "WPA":
            authenticationType = Int(ComStSt25sdkNdefWifiRecord_WIFI_AUTH_WPA)
        case "WPA2":
            authenticationType = Int(ComStSt25sdkNdefWifiRecord_WIFI_AUTH_WPA2)
        case "WPA2PSK":
            authenticationType = Int(ComStSt25sdkNdefWifiRecord_WIFI_AUTH_WPA2PSK)
        default:
            authenticationType = Int(ComStSt25sdkNdefWifiRecord_WIFI_AUTH_OPEN)
        }
        
        return authenticationType

    }

    private func setAuthenticationValueOnPicker(value : Int) {
        var defaultRowIndex : Int = 0
        //var encryptionType : Int = Int(ComStSt25sdkNdefWifiRecord_WIFI_ENCR_NONE)
        //let selectedEncryptionString = mListEncryptionTypeScheme[mIndexListEncryptionTypeScheme]
        if ((value & Int(ComStSt25sdkNdefWifiRecord_WIFI_AUTH_OPEN)) == ComStSt25sdkNdefWifiRecord_WIFI_AUTH_OPEN) {
            defaultRowIndex = 0
        }
        if ((value & Int(ComStSt25sdkNdefWifiRecord_WIFI_AUTH_WPAPSK)) == ComStSt25sdkNdefWifiRecord_WIFI_AUTH_WPAPSK) {
            defaultRowIndex = 1
        }
        if ((value & Int(ComStSt25sdkNdefWifiRecord_WIFI_AUTH_SHARED)) == ComStSt25sdkNdefWifiRecord_WIFI_AUTH_SHARED) {
            defaultRowIndex = 2
        }
        if ((value & Int(ComStSt25sdkNdefWifiRecord_WIFI_AUTH_WPA)) == ComStSt25sdkNdefWifiRecord_WIFI_AUTH_WPA) {
            defaultRowIndex = 3
        }
        if ((value & Int(ComStSt25sdkNdefWifiRecord_WIFI_AUTH_WPA2)) == ComStSt25sdkNdefWifiRecord_WIFI_AUTH_WPA2) {
            defaultRowIndex = 4
        }
        if ((value & Int(ComStSt25sdkNdefWifiRecord_WIFI_AUTH_WPA2PSK)) == ComStSt25sdkNdefWifiRecord_WIFI_AUTH_WPA2PSK) {
            defaultRowIndex = 5
        }

        mPickerAuthenticationType.selectRow(defaultRowIndex, inComponent: 0, animated: false)
    }
    
    private func isNDEFRecordReady() -> Bool {
        if (mEditSSIDField.text != "") {
            return true
        } else {
            return false
        }
    }
    
    private func warningAlert(message : String) {
        UIHelper.warningAlert(viewController: self, title : "Wifi record" , message: message)
    }
    
    /* Picker Delegate */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == mPickerAuthenticationType {
            return mListAuthenticationTypeScheme.count
        }
        if pickerView == mPickerEncryptionType {
            return mListEncryptionTypeScheme.count
        }
        if pickerView == mPickerSSIDType {
            return mListSSIDScheme.count
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == mPickerAuthenticationType {
            return self.mListAuthenticationTypeScheme[row]
        }
        if pickerView == mPickerEncryptionType {
            return self.mListEncryptionTypeScheme[row]
        }
        if pickerView == mPickerSSIDType {
            return mListSSIDScheme[row]
        }
        return "Not define"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == mPickerAuthenticationType {
            return self.mIndexListAuthenticationTypeScheme = row
        }
        if pickerView == mPickerEncryptionType {
            return self.mIndexListEncryptionTypeScheme = row
        }
        if pickerView == mPickerSSIDType {
            return self.mIndexListSSIDScheme = row
        }
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "System", size: 17)
            pickerLabel?.textAlignment = .center
        }
        if pickerView == mPickerAuthenticationType {
            pickerLabel?.text =  self.mListAuthenticationTypeScheme[row]
        }
        if pickerView == mPickerEncryptionType {
            pickerLabel?.text =  self.mListEncryptionTypeScheme[row]
        } 
        if pickerView == mPickerSSIDType {
            pickerLabel?.text =  self.mListSSIDScheme[row]
            mEditSSIDField.text = self.mListSSIDScheme[row]
            mAddRemoveSSIDButton.titleLabel?.text = "Remove"
            
        }
        pickerLabel?.textColor = UIColor.white
        
        return pickerLabel!
    }

        
    override func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == mEditSSIDField {
            mAddRemoveSSIDButton.titleLabel?.text = "Add"
        }
    }
    
    // Wifi specific
    struct NetworkInfo {
        var interface: String
        var success: Bool = false
        var ssid: String?
        var bssid: String?
    }
    public class SSID {
        class func fetchNetworkInfo() -> [NetworkInfo]? {
            if let interfaces: NSArray = CNCopySupportedInterfaces() {
                var networkInfos = [NetworkInfo]()
                for interface in interfaces {
                    let interfaceName = interface as! String
                    var networkInfo = NetworkInfo(interface: interfaceName,
                                                  success: false,
                                                  ssid: nil,
                                                  bssid: nil)
                    if let dict = CNCopyCurrentNetworkInfo(interfaceName as CFString) as NSDictionary? {
                        networkInfo.success = true
                        networkInfo.ssid = dict[kCNNetworkInfoKeySSID as String] as? String
                        networkInfo.bssid = dict[kCNNetworkInfoKeyBSSID as String] as? String
                    }
                    networkInfos.append(networkInfo)
                }
                return networkInfos
            }
            return nil
        }
    }

    // Not used but can be useful in next implementation
    func getAllWiFiNameList() -> String? {
         var ssid: String?
         if let interfaces = CNCopySupportedInterfaces() as NSArray? {
         for interface in interfaces {
         if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                     ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                     break
                 }
             }
         }
         return ssid
     }
 
    
    // Can be used if particular privilege are granted to thec application.
    // -------------------------------------------------------------------
    var hotspots = [Hotspot]()

    fileprivate func handleOnFilterScanList(command: NEHotspotHelperCommand) -> Void {
      print("handleOnFilterScanList")
      
      // create network list for managed network.
      var array = [NEHotspotNetwork]()
      
      for network in command.networkList ?? [] {
        autoreleasepool {
          guard let index = hotspots.firstIndex(of: Hotspot(network: network)) else {
            // unmanaged network.
            return
          }
          
          // managed network.
          print("add networklist [\(network)]")
          
          network.setPassword(hotspots[index].pw)
          network.setConfidence(NEHotspotHelperConfidence.high)
          
          array.append(network)
        }
      }
      
      
      // create response.
      let response = command.createResponse(NEHotspotHelperResult.success)
      
      if array.count > 0 {
        // set network list when only there are managed network.
        response.setNetworkList(array)
      }
      
      response.deliver()
    }
    
    
}

class Hotspot: Equatable {
  // MARK: enum, const
  enum AuthType: UInt {
    case WEP = 0
    case WPA = 1  // WPA/WPA2
  }
  
  
  var bssid: String
  var ssid: String
  var pw: String
  var authType: AuthType
  
  
  init() {
    bssid = ""
    ssid = ""
    pw = ""
    authType = AuthType.WEP
  }
  
  init(network: NEHotspotNetwork) {
    bssid = network.bssid
    ssid = network.ssid
    pw = ""
    authType = AuthType.WEP
  }
  
  
  static func ==(lhs: Hotspot, rhs: Hotspot) -> Bool {
    
    if lhs.bssid.count > 0 && rhs.bssid.count > 0 {
      // BSSID is not empty.
      // -> BSSID.
      return lhs.bssid.caseInsensitiveCompare(rhs.bssid) == .orderedSame
    }
    
    //  SSID.
    return lhs.ssid.caseInsensitiveCompare(rhs.ssid) == .orderedSame
  }
  
  var description: String {
    let res = String(format: "BSSID[%@] SSID[%@",
                     bssid,
                     ssid
    )
    
    return res
  }
}
// -------------------------------------------------------------------

