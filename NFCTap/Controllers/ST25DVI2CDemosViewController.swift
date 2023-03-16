//
//  ST25DVI2CDemosViewController.swift
//  NFCTap
//
//  Created by STMicroelectronics on 18/10/2019.
//  Copyright © 2019 STMicroelectronics. All rights reserved.
//

import UIKit

class ST25DVI2CDemosViewController: ST25UIViewController {

    @IBAction func startFirmwareUpdateViewController(_ sender: Any) {
                // No need to add Navigation Controller to the View Controller as we start the view from a button of a view with have already a NC
        TabItem.TagST25DVI2CFWUpdateDemos.withNC = false
        let vc = TabItem.TagST25DVI2CFWUpdateDemos.toViewController()
        if let navigator = navigationController {
            navigator.pushViewController(vc, animated: false)
        }

    }
    @IBAction func startMailboxManagementViewController(_ sender: Any) {
                // No need to add Navigation Controller to the View Controller as we start the view from a button of a view with have already a NC
        TabItem.TagST25DVI2CMailboxManagement.withNC = false

        let vc = TabItem.TagST25DVI2CMailboxManagement.toViewController()
        if let navigator = navigationController {
            navigator.pushViewController(vc, animated: false)
        }
        
    }
    
    @IBAction func startPictureTransfer(_ sender: Any) {
                // No need to add Navigation Controller to the View Controller as we start the view from a button of a view with have already a NC
        TabItem.TagST25DVI2CPictureTransfer.withNC = false

        let vc = TabItem.TagST25DVI2CPictureTransfer.toViewController()
        if let navigator = navigationController {
            navigator.pushViewController(vc, animated: false)
        }
    }
    
    @IBAction func startStopwatch(_ sender: Any) {
                // No need to add Navigation Controller to the View Controller as we start the view from a button of a view with have already a NC
        TabItem.TagST25DVI2CStopwatchTransfer.withNC = false

        let vc = TabItem.TagST25DVI2CStopwatchTransfer.toViewController()
        if let navigator = navigationController {
            navigator.pushViewController(vc, animated: false)
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
