//
//  AppDelegate.swift
//  ST25NFCApp
//
//  Created by STMicroelectronics on 13/06/2017.
//  Copyright © 2017 STMicroelectronics. All rights reserved.
//

import UIKit
import CoreNFC

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb else {
            return false
        }
        
        
        // Confirm that the NSUserActivity object contains a valid NDEF message.
        if #available(iOS 12.0, *) {
            let ndefMessage = userActivity.ndefMessagePayload
            guard ndefMessage.records.count > 0,
                ndefMessage.records[0].typeNameFormat != .empty else {
                    return false
            }
            
            // Send the message to `mST25HomeVC` for processing.
            let mST25TabBarVC = window?.rootViewController as! ST25TabBarController
            mST25TabBarVC.viewDidLoad()
            
            let mST25HomeVC = mST25TabBarVC.selectST25HomeVc()
            var ndefMessageList:[NFCNDEFMessage] = []
            ndefMessageList.append(ndefMessage)
            //mST25HomeVC.addMessage(messages: ndefMessageList)
        } else {
            // Fallback on earlier versions
        }
        
        
        return true
    }
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        window?.overrideUserInterfaceStyle = .light
    }
    
    private func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        var navigationBarAppearace = UINavigationBar.appearance()

        //navigationBarAppearace.tintColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
        navigationBarAppearace.barTintColor = UIColor.stDarkBlueColor()
        navigationBarAppearace.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

