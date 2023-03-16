//
//  UIHelper.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 22/01/2020.
//  Copyright © 2020 STMicroelectronics. All rights reserved.
//

import Foundation

class UIHelper {

    static func makeImageView(image: UIImage? = nil,
                       contentMode: UIView.ContentMode = .scaleAspectFit) -> UIImageView {
        let iv = UIImageView(image: image)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = contentMode
        iv.clipsToBounds = true
        return iv
    }

    static func makeLabel(text: String? = nil, font: UIFont = .systemFont(ofSize: 15),
                          color: UIColor = .black, numberOfLines: Int = 1,
                          alignment: NSTextAlignment = .left) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = font
        label.textColor = color
        label.text = text
        label.numberOfLines = numberOfLines
        label.textAlignment = alignment
        return label
    }
    static func makeLine(color: UIColor = UIColor.init(red: 242, green: 246, blue: 254, alpha: 1),
                         height: CGFloat = 1) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = color
        view.frame.size.height = height
        //view.heightAnchor(height)
        return view
    }

    static func searchMainTabItemInTabController(viewController: UIViewController, name:String) -> Int {
        var array: [UIViewController] = []
        array = (viewController.tabBarController?.viewControllers)!
        var foundIdx = -1
        var position = 0
        print("parsing of Tab controller views from :" + viewController.description)
        for vc in array {
            print(vc.title)
            if vc.title == name {
                foundIdx = position
            }
            position+=1
        }
        return foundIdx
    }
    static func searchMainTabItemInTabController(tabBarController: UITabBarController, name:String) -> Int {
        var array: [UIViewController] = []
        array = tabBarController.viewControllers!
        var foundIdx = -1
        var position = 0
        //print("parsing of Tab controller views from :" + viewController.description)
        for vc in array {
            print(vc.title)
            if vc.title == name {
                foundIdx = position
            }
            position+=1
        }
        return foundIdx
    }
    
    static func BG(_ block: @escaping ()->Void) {
        DispatchQueue.global(qos: .default).async(execute: block)
    }

    static func UI(_ block: @escaping ()->Void) {
        DispatchQueue.main.async(execute: block)
    }
    
    static func warningAlert(viewController : UIViewController, title : String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }

}
