//
//  ST25Home.swift
//  ST25NFCApp
//
//  Created by STMicroelectronics on 13/06/2017.
//  Copyright © 2017 STMicroelectronics. All rights reserved.
//

import UIKit

class ST25Home: ST25UIViewController {
    
    // Reference the readTagInfo class
    private var mReadTagInfo:readTagInfo!

    @IBAction func tapReadTag(_ sender: Any) {
        mReadTagInfo = readTagInfo(aVc: self.navigationController!)
        mReadTagInfo.startSession()
    }

    ///////////////////////////// OVERRIDE /////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        let tbvc = self.tabBarController as! ST25TabBarController
        tbvc.customizableViewControllers = []
        let tabBar = TagTabBarController()
        if Thread.isMainThread {
            tabBar.setDefautTabBarController(tabBarController: self.tabBarController!)
        } else {
            UIHelper.UI() {
            tabBar.setDefautTabBarController(tabBarController: self.tabBarController!)
            }
        }
        
        if (UserDefaults.standard.bool(forKey: "AutoApp")){
            let storyBoard : UIStoryboard = UIStoryboard(name: "ST25AreaManagement", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ST25NdefRecordsListViewController") as! ST25NdefRecordsListViewController
            self.present(nextViewController, animated:true, completion:nil)

        }
     }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}

extension UITabBarController {
    func orderedTabBarItemViews() -> [UIView] {
        let interactionViews = tabBar.subviews.filter({$0.isUserInteractionEnabled})
    return interactionViews.sorted(by: {$0.frame.minX < $1.frame.minX})
    }
}
