//
//  SettingTableViewController.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 10/10/2017.
//  Copyright © 2017 STMicroelectronics. All rights reserved.
//

import UIKit
import CoreLocation
import StoreKit

protocol SettingTableViewControllerDelegate {
    func switchAutoAction(data: Bool)
    func switchMultiTagAction(data: Bool)
}

class SettingTableViewController: UITableViewController,UITextFieldDelegate {

    
  ////////////////////////////////////////////////////////
    public var delegate: SettingTableViewControllerDelegate?
    
    var switchAutoAppSavedValue : Bool!
    var switchMultiTagSavedValue : Bool!
    
    
    @IBOutlet weak var switchAutoApp: UISwitch!
    
    @IBAction func switchAutoAction(_ sender: UISwitch) {
        switchAutoAppSavedValue = sender.isOn
    }
    
    @IBAction func showReview(_ sender: Any) {
        
        let alert = UIAlertController(title: NSLocalizedString("App Rating and Review", comment: ""),
                                      message: NSLocalizedString("The system will only show up to a maximum of 3 prompts to the same user in a 365-day period\nIf Rate app popup is not showing, please use App Store URL link here below\n", comment: ""),
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { (action: UIAlertAction!) in
            SKStoreReviewController.requestReview()
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("App Store Link", comment: ""), style: .default, handler: { (action: UIAlertAction!) in
            let url = NSURL(string : "https://itunes.apple.com/us/app/nfc-tap/id1278913597?action=write-review")
            UIApplication.shared.open(url! as URL, options: [:],
                                      completionHandler: {
                                        (success) in
                                        print("Open \(url): \(success)")
            })
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
   }
    
    // Controller Loader
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.stDarkBlueColor()
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().isTranslucent = false

        initSettings()
        
    }
    
    // Controller will disappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        terminateSettings()
    }
    
    
    // Loading parameters
    func initSettings(){
        // Get Values saved
        var value:Bool
        
        value = UserDefaults.standard.bool(forKey: "AutoApp")
        switchAutoApp.setOn(value, animated: false)
        switchAutoAppSavedValue = value
        
    }
    
    // Saving parameters
    func terminateSettings(){
        
        UserDefaults.standard.set(switchAutoApp.isOn, forKey: "AutoApp")
        self.delegate?.switchAutoAction(data: self.switchAutoApp.isOn)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    }
}
