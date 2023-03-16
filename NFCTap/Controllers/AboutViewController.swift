//
//  AboutViewController.swift
//  ST25NFCApp
//
//  Created by STMicroelectronics on 20/07/2017.
//  Copyright © 2017 STMicroelectronics. All rights reserved.
//
/*
 
 
 
 */

import UIKit

class AboutViewController: UITableViewController {

    @IBOutlet weak var actionTextView: UITextView!
    @IBOutlet weak var aboutTextView: UITextView!
    @IBOutlet weak var featureTextView: UITextView!
    
    @IBAction func tapGestureSTImage(_ sender: Any) {
        let urlString = "http://www.st.com/st25"
        open(scheme: urlString)
    }
    let aboutTextString:String = "aboutTextView".localized
    
    
    let featureTextString = "featureTextView".localized
    
    
    let actionTextString = "actionTextView".localized

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.stDarkBlueColor()
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().isTranslucent = false

        //  Convert textString to NSString because attrText.addAttribute takes an NSRange.
        let textFont = UIFont(name: "Helvetica", size: 14.0)!
        var attrText:NSMutableAttributedString!
        var textRange:NSRange!
        
        attrText = NSMutableAttributedString(string: aboutTextString)
        textRange = (aboutTextString as NSString).range(of: aboutTextString)
        attrText.addAttribute(NSAttributedString.Key.font, value: textFont, range: textRange)
        aboutTextView.attributedText = attrText
        
        attrText = NSMutableAttributedString(string: featureTextString)
        textRange = (featureTextString as NSString).range(of: featureTextString)
        attrText.addAttribute(NSAttributedString.Key.font, value: textFont, range: textRange)
        featureTextView.attributedText = attrText
        
        
        attrText = NSMutableAttributedString(string: actionTextString)
        textRange = (actionTextString as NSString).range(of: actionTextString)
        attrText.addAttribute(NSAttributedString.Key.font, value: textFont, range: textRange)
        actionTextView.attributedText = attrText
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Run application with URL
    func open(scheme: String) {
        if let url = URL(string: scheme) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:],
                                          completionHandler: {
                                            (success) in
                                            print("Open \(scheme): \(success)")
                })
            } else {
                let success = UIApplication.shared.openURL(url)
                print("Open \(scheme): \(success)")
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
