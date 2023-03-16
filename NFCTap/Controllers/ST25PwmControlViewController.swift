//
//  ST25PwmControlViewController.swift
//  NFCTap 
//
//  Created by STMICROELECTRONICS on 08/06/2020.
//  Copyright © 2020 STMicroelectronics. All rights reserved.
//

import UIKit

class ST25PwmControlViewController: ST25UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ST25PWM control"

        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ST25PwmModeAuto" {
            //print(segue)
            guard let detailsVC = segue.destination as? ST25PwmControlNormalAndAutoViewController else { return }
            
            detailsVC.mAutoModeEnable = true
        }
        if segue.identifier == "ST25PwmModeNormal" {
            //print(segue)
            guard let detailsVC = segue.destination as? ST25PwmControlNormalAndAutoViewController else { return }
            
            detailsVC.mAutoModeEnable = false
        }
    }
    

}
