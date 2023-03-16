//
//  ST25TabBarController.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 28/09/2017.
//  Copyright © 2017 STMicroelectronics. All rights reserved.
//

import UIKit

class TabBarControllerWithoutEdit: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.stDarkBlueColor()
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().isTranslucent = false

        customizableViewControllers = []
        self.delegate = self
        selectedIndex = 0
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController == moreNavigationController {
            moreNavigationController.popViewController(animated: true)
            moreNavigationController.navigationBar.didMoveToSuperview()
            tabBarController.moreNavigationController.popToRootViewController(animated: false)
            self.navigationController?.navigationBar.barTintColor = UIColor.stDarkBlueColor()

            return
        }
        
    }
}


class ST25TabBarController: TabBarControllerWithoutEdit {
    var centerButton : UIButton!
    let centerButtonWidth:CGFloat = 64
    let centerButtonHeight:CGFloat = 64
    
    
    @IBOutlet weak var mTabBar: UITabBar!
    
    // Reference to other Controller Screen
    var mSettingVC : SettingTableViewController!
    var mAboutVC : UIViewController!
    var mHomeVC : ST25Home!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizableViewControllers = []

        setCenterButton()
        
        // Init default values if never done
        if (UserDefaults.standard.object(forKey: "AutoApp") == nil){
            UserDefaults.standard.set(false, forKey: "AutoApp")
        }
        
        var nc = self.viewControllers![3] as! UINavigationController
        if nc.topViewController is SettingTableViewController {
            mSettingVC = nc.topViewController as! SettingTableViewController
            mSettingVC.title = "Settings"
        }
        
        nc = self.viewControllers![4] as! UINavigationController
        if nc.topViewController is AboutViewController {
            mAboutVC = nc.topViewController as! AboutViewController
            mAboutVC.title = "About"

        }
        
        nc = self.viewControllers![2] as! UINavigationController
        if nc.topViewController is ST25Home {
            mHomeVC = nc.topViewController as! ST25Home
            mHomeVC.title = "Scan"

        }
        self.selectedIndex = 2;

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        self.selectedIndex = item.tag
    }

    private func setCenterButton(){
        let image = UIImage(named : "touch_screen_white.png")
        let highlightImage = UIImage(named : "touch_screen_white.png")
        addCenterButton(withImage: image!, highlightImage: highlightImage!)
        view.layoutIfNeeded()
        
    }

    func setupTabBarMenu(tabBarController: UITabBarController) {

        let tabBar = TagTabBarController()
        
        if Thread.isMainThread {
            tabBar.setDefautTabBarController(tabBarController: tabBarController)
        } else {
            //DispatchQueue.main.async {
            UIHelper.UI() {
                tabBar.setDefautTabBarController(tabBarController: tabBarController)
                
            }
        }
    }
    
    
    func addCenterButton(withImage buttonImage : UIImage, highlightImage: UIImage) {

        self.centerButton = UIButton(type: .custom)
        self.centerButton?.autoresizingMask = [.flexibleRightMargin, .flexibleTopMargin, .flexibleLeftMargin, .flexibleBottomMargin]
        self.centerButton?.frame = CGRect(x: 0.0, y: 0.0, width: centerButtonWidth, height: centerButtonHeight)
        //self.centerButton?.frame = CGRect(x: 0.0, y: 0.0, width: buttonImage.size.width, height: buttonImage.size.height)
        self.centerButton.backgroundColor = UIColor(displayP3Red: 57/255, green: 169/255, blue: 220/255, alpha: 1.0)
        self.centerButton.layer.cornerRadius = centerButtonHeight/2

        self.centerButton?.setBackgroundImage(buttonImage, for: .normal)
         self.centerButton?.setBackgroundImage(highlightImage, for: .highlighted)
        self.centerButton?.isUserInteractionEnabled = true

        //let heightdif: CGFloat = buttonImage.size.height - (self.tabBar.frame.size.height);
        let heightdif: CGFloat = 64 - (self.tabBar.frame.size.height);

        if (heightdif < 0){
            self.centerButton?.center = (self.tabBar.center)
        }
        else{
            var center: CGPoint = (self.tabBar.center)
            center.y = center.y - 24
            self.centerButton?.center = center
        }

        self.view.addSubview(self.centerButton!)
        self.tabBar.bringSubviewToFront(self.centerButton!)

        self.centerButton?.addTarget(self, action: #selector(centerButtonAction(sender:)), for: .touchUpInside)

        if let count = self.tabBar.items?.count
        {
            let i = floor(Double(count / 2))
            let item = self.tabBar.items![Int(i)]
            item.title = ""
        }
    }
    
    @objc private func centerButtonAction(sender : UIButton){
        let topController = UIApplication.topViewController()
        if topController != nil {
            let foundIdx = UIHelper.searchMainTabItemInTabController(viewController: topController!, name: "Scan")
            if foundIdx != -1 {
                self.selectedIndex = foundIdx
            } else {
                // default value
                self.selectedIndex = 2
            }
        } else {
            self.selectedIndex = 2
        }
        mHomeVC.viewWillAppear(true)
        mHomeVC.navigationController?.popToRootViewController(animated: true)
      }
    
    // Fucntion to select ST25Home View Controller. Called from AppDelegate when NAtive URL found
    func selectST25HomeVc() -> ST25Home {
        let topController = UIApplication.topViewController()
        if topController != nil {
            let foundIdx = UIHelper.searchMainTabItemInTabController(viewController: topController!, name: "Scan")
            if foundIdx != -1 {
                self.selectedIndex = foundIdx
            } else {
                // default value
                self.selectedIndex = 2
            }
        } else {
            self.selectedIndex = 2
        }
        mHomeVC.viewWillAppear(true)
        mHomeVC.navigationController?.popToRootViewController(animated: true)
        return mHomeVC
    }
    
}
