//
//  NDEFWifiViewController.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 13/11/2017.
//  Copyright © 2017 STMicroelectronics. All rights reserved.
//

import UIKit
import NetworkExtension

class NDEFWifiViewController: ST25UIViewController {

    @IBAction func disconnectButtonAction(_ sender: UIButton) {
        if (self.mConnectToggle == false){
            self.disConnectWifi()
        }else{
            self.connectWifi()
        }
        self.mConnectToggle = !self.mConnectToggle
    }
    
    @IBOutlet weak var acitvityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var disconnectButton: UIButton!
    @IBOutlet weak var wifiStatusText: UITextView!
    @IBOutlet weak var wifiImage: UIImageView!
    @IBOutlet weak var wirelessImage: UIImageView!
    
    var mSSID:String! = nil
    var mKey:String! = nil
    var mEncryptionType:Int! = nil
    
    var mConnectToggle:Bool = false
    
    let managerWifi = NEHotspotConfigurationManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wifiStatusText.text = ""
        wifiImage.isHidden = true
        wirelessImage.isHidden = true
        disconnectButton.isHidden = true
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        connectWifi()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        acitvityIndicator.stopAnimating()
        wifiStatusText.text = ""
        wifiImage.isHidden = true
        wirelessImage.isHidden = true
        disconnectButton.isHidden = true
    }
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setNDEFWifiRecord(SSID: String, key: String, encryptionType:Int){
        self.mSSID = SSID
        self.mKey  = key
        self.mEncryptionType = encryptionType
    }
    
    private func connectWifi(){
        wifiStatusText.text = ""
        wifiImage.isHidden = true
        wirelessImage.isHidden = true
        disconnectButton.isHidden = true
        acitvityIndicator.startAnimating()
        wifiStatusText.text = NSLocalizedString("Wifi connection on going...\n", comment: "")
        
        // in case of ST25_WIFI_XXXXX, don"t take into account key and encrytion type
        var WiFiConfig:NEHotspotConfiguration!
        
        if (self.mSSID.contains("ST25_WIFI")){
            WiFiConfig = NEHotspotConfiguration(ssid: self.mSSID)
        }else{
            var isWep:Bool = true
            if (mEncryptionType != 0){
                isWep = false
            }
            WiFiConfig = NEHotspotConfiguration(ssid: self.mSSID, passphrase: self.mKey, isWEP: isWep)
        }
        
        WiFiConfig.joinOnce = false
        
        
        managerWifi.apply(WiFiConfig) { error in
            if let error = error {
                if (error.localizedDescription.contains(NSLocalizedString("already associated",comment:""))){
                  self.wifiSuccess()
                }else{
                    self.wifiShowError(errorMsg: error.localizedDescription)
                }
           }
            else {
                //success
                self.managerWifi.getConfiguredSSIDs(completionHandler: { (list) in
                    print(list)
                })
                self.wifiSuccess()
            }
        }
        
    }
    
    private func disConnectWifi(){
        self.managerWifi.removeConfiguration(forSSID: self.mSSID)
        let formatString = NSLocalizedString("Wifi %@ Disconnected",comment: "")
        wifiShowError(errorMsg: String.localizedStringWithFormat(formatString, self.mSSID!))
        self.disconnectButton.setTitle("Connect", for: .normal)
        self.disconnectButton.isHidden = false
    }
    
    private func wifiSuccess(){
        self.acitvityIndicator.stopAnimating()
        
        let formatString = NSLocalizedString("Device %@ connected and ready to use\n",comment: "")
        self.wifiStatusText.text = String.localizedStringWithFormat(formatString, self.mSSID!)
        self.wifiImage.image = UIImage(named: "wifi")
        self.wirelessImage.image = UIImage(named: "wireless_light_blue")
        self.wifiImage.isHidden = false
        self.wirelessImage.isHidden = false
        self.disconnectButton.setTitle(NSLocalizedString("Disconnect",comment: ""), for: .normal)
        self.disconnectButton.isHidden = false
        
        let alert = UIAlertController(title: NSLocalizedString("Wifi join success",comment: ""), message: NSLocalizedString("Device connected and ready to use",comment: ""), preferredStyle: .alert)
        let action = UIAlertAction(title: NSLocalizedString("OK",comment: ""), style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func wifiShowError(errorMsg : String){
        self.acitvityIndicator.stopAnimating()
        
        let formatString = NSLocalizedString("Device %@ not connected.\nCheck NFC Wifi settings\n",comment: "")
        self.wifiStatusText.text = String.localizedStringWithFormat(formatString, self.mSSID!)
    
        self.wifiImage.image = UIImage(named: "wifi_pink")
        self.wirelessImage.image = UIImage(named: "wireless_pink")
        self.wifiImage.isHidden = false
        self.wirelessImage.isHidden = false
        
        let alert = UIAlertController(title: NSLocalizedString("Wifi Status",comment: ""), message: errorMsg, preferredStyle: .alert)
        let action = UIAlertAction(title: NSLocalizedString("OK",comment: ""), style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }

}
