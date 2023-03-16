//
//  ST25TagInformationViewController.swift
//  NFCTap
//
//  Created by STMICROELECTRONICS on 30/09/2019.
//  Copyright © 2019 STMicroelectronics. All rights reserved.
//

import UIKit
import CoreNFC


class ST25TagInformationViewController: ST25UIViewController {

    
    @IBOutlet weak var tagNameAndTypeLabel: UILabel!
    @IBOutlet weak var tagInformationTableView: UITableView!
    

    
    // Set done in the UI table view cell setting
    let tableViewGenricRowIdentifier = "TagInformationCell"
    let vcStoryBoardID = "ST25TagInformationViewControllerID"

    
    var tagDescription:String?
    var productId : ComStSt25sdkTagHelper_ProductID?
    var sections: [Category]?
    
    var uid : Data?
    var mTagSystemInfo: TagInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Tag Information"
        // Do any additional setup after loading the view.
        tagNameAndTypeLabel.text = productId?.description
        tagInformationTableView.dataSource = self
        tagInformationTableView.delegate = self
        
        tagInformationTableView.backgroundColor = UIColor.white
        
    }


//    @IBAction func ftmscreen(_ sender: UIButton) {
//        let tagInfoController:ST25DVI2CDemosViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ST25DVI2CDemosViewController") as! ST25DVI2CDemosViewController
//               
//
//        self.present(tagInfoController, animated: true, completion: nil)
//    }
}
    // Table view
    // MARK: - UITableViewDataSource
extension ST25TagInformationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell = tableView.dequeueReusableCell(withIdentifier: tableViewGenricRowIdentifier)!
        let items = self.sections?[indexPath.section].items
        guard let item = items?[indexPath.row] else {
            return cell
        }
        //print(item["ItemId"] as? String)
        for raw in item {
            for (key, value) in raw {
                    if (key.description == "Item") {
                        cell.textLabel?.text = value as? String
                    } else if (key.description == "ItemId") {
                        cell.detailTextLabel?.text = value as? String
                    }
            }
        }
        cell.backgroundColor = UIColor.stLightGreyColor()
        return cell
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //print("Number of section", self.sections?.count as Any)
        guard let numberOfSections = self.sections?.count else {
            return 1
        }
        return numberOfSections
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //print("Name of section [", section, "] ", self.sections?[section].name as Any)
        guard let titleForHeaderInSection = self.sections?[section].name else {
            return nil
        }
        return titleForHeaderInSection
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let items = self.sections?[section].items else {
            return 0
        }
        //print("Section : ", section)
        return items.count

    }

    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view:UIView, forSection: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = UIColor.red
            let sectionName = self.sections?[forSection].name

            if sectionName == TagInfoGenericModel.infoFileSectionName {
                headerView.textLabel?.textColor = UIColor.stDarkBlueColor()
            } else if sectionName == TagInfoGenericModel.ccFileSectionName {
                    headerView.textLabel?.textColor = UIColor.stDarkBlueColor()
            } else if sectionName == TagInfoGenericModel.systemFileSectionName {
                    headerView.textLabel?.textColor = UIColor.stDarkBlueColor()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.stLightBlueColor()
        // view.backgroundColor = UIColor.red
         let myCustomView: UIImageView = UIImageView()

        let sectionName = self.sections?[section].name
        var myImage: UIImage = UIImage(named: "eeprom_dark_blue")!

        if sectionName == TagInfoGenericModel.infoFileSectionName {
                myImage = UIImage(named: "eeprom_dark_blue")!
        } else if sectionName == TagInfoGenericModel.ccFileSectionName {
                myImage = UIImage(named: "eeprom_dark_blue")!
        } else if sectionName == TagInfoGenericModel.systemFileSectionName {
                myImage = UIImage(named: "eeprom_dark_blue")!
        }

         myCustomView.image = myImage
         myCustomView.frame = CGRect(x: 5, y: 5, width: 50, height: 50)
         view.addSubview(myCustomView)

         let label:UILabel = UILabel()
         label.text = self.sections?[section].name
         label.frame = CGRect(x: 70, y: 5, width: 100, height: 35)
         view.addSubview(label)
         
         return view

    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //heightForHeaderInSection See previous for image size and offset 55+5 + margin = 60
        return 60
    }
    

}
    
