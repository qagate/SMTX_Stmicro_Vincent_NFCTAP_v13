//
//  ST25TVCLockConfigurationTableTableViewController.swift
//  NFCTap 
//
//  Created by STMicroelectronics on 18/11/2020.
//  Copyright © 2020 STMicroelectronics. All rights reserved.
//

import UIKit

// lock configuration IDs for Array Index
enum lockConfigurationId: Int {
        case lckAfi = 0, lckPriv, lckAndef, lckTd, lckUtc, LckA2r,LckA1r
}

// lock config structure
struct statusLockConfigStruct {
    var id:lockConfigurationId!
    var statusRead:Bool!    // Status from Tag
    var statusSwitch:Bool!  // Status from Switch
}
   
class ST25TVCLockConfigurationTableTableViewController: UITableViewController {

    @IBOutlet weak var statusLockAFI: UILabel!
    @IBOutlet weak var switchLockAfi: UISwitch!
    @IBAction func lockAFISwitchAction(_ sender: Any) {
        mLockarray[lockConfigurationId.lckAfi.rawValue].statusSwitch = switchLockAfi.isOn
        updateLockUI(lockStatus: switchLockAfi.isOn,labelId: statusLockAFI, switchId: switchLockAfi)
    }
        
   
    @IBOutlet weak var statusLockPRIV: UILabel!
    @IBOutlet weak var lockPRIVSwitch: UISwitch!
    @IBAction func lockPRIVSwitchAction(_ sender: Any) {
        mLockarray[lockConfigurationId.lckPriv.rawValue].statusSwitch = lockPRIVSwitch.isOn
        updateLockUI(lockStatus: lockPRIVSwitch.isOn,labelId: statusLockPRIV, switchId: lockPRIVSwitch)
    }
    
    
    @IBOutlet weak var statusLockANDEF: UILabel!
    @IBOutlet weak var switchLockANDEF: UISwitch!
    @IBAction func lockANDEFSwitchAction(_ sender: Any) {
        mLockarray[lockConfigurationId.lckAndef.rawValue].statusSwitch = switchLockANDEF.isOn
        updateLockUI(lockStatus: switchLockANDEF.isOn,labelId: statusLockANDEF, switchId: switchLockANDEF)
    }
    
    
    @IBOutlet weak var statusLockTD: UILabel!
    @IBOutlet weak var switchLockTD: UISwitch!
    @IBAction func LockTDSwitchAction(_ sender: Any) {
        mLockarray[lockConfigurationId.lckTd.rawValue].statusSwitch = switchLockTD.isOn
        updateLockUI(lockStatus: switchLockTD.isOn,labelId: statusLockTD, switchId: switchLockTD)
    }
    
    @IBOutlet weak var statusLockUTC: UILabel!
    @IBOutlet weak var switchLockUTC: UISwitch!
    @IBAction func lockUTCSwitchAction(_ sender: Any) {
        mLockarray[lockConfigurationId.lckUtc.rawValue].statusSwitch = switchLockUTC.isOn
        updateLockUI(lockStatus: switchLockUTC.isOn,labelId: statusLockUTC, switchId: switchLockUTC)
    }
    
    
    @IBOutlet weak var statusLockA2R: UILabel!
    @IBOutlet weak var switchLockA2R: UISwitch!
    @IBAction func lockA2RSwitchAction(_ sender: Any) {
        mLockarray[lockConfigurationId.LckA2r.rawValue].statusSwitch = switchLockA2R.isOn
        updateLockUI(lockStatus: switchLockA2R.isOn,labelId: statusLockA2R, switchId: switchLockA2R)
    }
    
    @IBOutlet weak var statusLockA1R: UILabel!
    @IBOutlet weak var switchLockA1R: UISwitch!
    @IBAction func lockA1RSwitchAction(_ sender: Any) {
        mLockarray[lockConfigurationId.LckA1r.rawValue].statusSwitch = switchLockA1R.isOn
        updateLockUI(lockStatus: switchLockA1R.isOn,labelId: statusLockA1R, switchId: switchLockA1R)
    }
    
    // Default values at Init
    static let mTextLocked:String = "LOCKED"
    static let mTextNotLocked:String = "NOT LOCKED"
    static let mColorLocked:UIColor = UIColor.stLightRedColor()
    static let mColorNotLocked:UIColor = UIColor.stLightGreenColor()
    
    internal var mLockarray:[statusLockConfigStruct] = [
        statusLockConfigStruct(id:.lckAfi,statusRead: false, statusSwitch: false),
        statusLockConfigStruct(id:.lckPriv,statusRead: false, statusSwitch: false),
        statusLockConfigStruct(id:.lckAndef,statusRead: false, statusSwitch: false),
        statusLockConfigStruct(id:.lckTd,statusRead: false, statusSwitch: false),
        statusLockConfigStruct(id:.lckUtc,statusRead: false, statusSwitch: false),
        statusLockConfigStruct(id:.LckA2r,statusRead: false, statusSwitch: false),
        statusLockConfigStruct(id:.LckA1r,statusRead: false, statusSwitch: false),
    ]
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: -20, right: 0);
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.stDarkBlueColor()
    }
    
 
   // Update Whole UI : function called from Parent
    func updateUI(lockArray:[statusLockConfigStruct]){
        mLockarray = lockArray
        for lockConfig in mLockarray {
            let status:Bool = lockConfig.statusRead
            switch lockConfig.id {
                case .lckAfi:
                    updateLockUI(lockStatus: status,labelId: statusLockAFI, switchId: switchLockAfi)
                    switchLockAfi.isEnabled = !status
                case .lckPriv:
                    updateLockUI(lockStatus: status,labelId: statusLockPRIV, switchId: lockPRIVSwitch)
                    lockPRIVSwitch.isEnabled = !status
                case .lckAndef:
                    updateLockUI(lockStatus: status,labelId: statusLockANDEF, switchId: switchLockANDEF)
                    switchLockANDEF.isEnabled = !status
                case .lckTd:
                    updateLockUI(lockStatus: status,labelId: statusLockTD, switchId: switchLockTD)
                    switchLockTD.isEnabled = !status
                case .lckUtc:
                    updateLockUI(lockStatus: status,labelId: statusLockUTC, switchId: switchLockUTC)
                    switchLockUTC.isEnabled = !status
                case .LckA2r:
                    updateLockUI(lockStatus: status,labelId: statusLockA2R, switchId: switchLockA2R)
                    switchLockA2R.isEnabled = !status
                case .LckA1r:
                    updateLockUI(lockStatus: status,labelId: statusLockA1R, switchId: switchLockA1R)
                    switchLockA1R.isEnabled = !status
                case .none:
                    print("")
            }
        }
    }
    
    // Update ONE row of table
    private func updateLockUI(lockStatus:Bool,labelId:UILabel,switchId:UISwitch){
        if (lockStatus == true){
            labelId.text = ST25TVCLockConfigurationTableTableViewController.mTextLocked
            labelId.backgroundColor = ST25TVCLockConfigurationTableTableViewController.mColorLocked
        }else{
            labelId.text = ST25TVCLockConfigurationTableTableViewController.mTextNotLocked
            labelId.backgroundColor = ST25TVCLockConfigurationTableTableViewController.mColorNotLocked
        }
        switchId.isOn = lockStatus
    }
    
    // returns lock config array to the parent 
    func getLockConfigUI() -> [statusLockConfigStruct]{
        return mLockarray
    }

}
