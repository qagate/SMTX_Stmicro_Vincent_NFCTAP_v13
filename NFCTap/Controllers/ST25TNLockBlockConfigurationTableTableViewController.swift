//
//  ST25TNLockBlockConfigurationTableTableViewController.swift
//  NFCTap 
//
//  Created by STMicroelectronics on 18/11/2020.
//  Copyright © 2020 STMicroelectronics. All rights reserved.
//

import UIKit

// lock config structure
struct statusLockBlockConfigStruct {
    var id:ComStSt25sdkType2St25tnST25TNTag_ST25TNLocks         // Lock Block Id
    var name:String!                                            // LockBlock Name
    var statusTag:Bool!                                         // Status from Tag
    var statusUI:Bool!                                          // Status from UI
}

// Register config structure
struct registerLockStruct {
    var section:UInt8
    var name:String
    var val:Int16
}


class ST25TNLockBlockConfigurationTableTableViewController: UITableViewController {
    
    
    @IBOutlet var mTableView: UITableView!
    @IBOutlet weak var StatLock0_b0: UIImageView!
    @IBOutlet weak var Statlock0_b1: UIImageView!
    @IBOutlet weak var Statlock0_b2: UIImageView!
    @IBOutlet weak var Statlock0_b3: UIImageView!
    @IBOutlet weak var Statlock0_b4: UIImageView!
    @IBOutlet weak var Statlock0_b5: UIImageView!
    @IBOutlet weak var Statlock0_b6: UIImageView!
    @IBOutlet weak var Statlock0_b7: UIImageView!
    
    
    @IBOutlet weak var Statlock1_b0: UIImageView!
    @IBOutlet weak var Statlock1_b1: UIImageView!
    @IBOutlet weak var Statlock1_b2: UIImageView!
    @IBOutlet weak var Statlock1_b3: UIImageView!
    @IBOutlet weak var Statlock1_b4: UIImageView!
    @IBOutlet weak var Statlock1_b5: UIImageView!
    @IBOutlet weak var Statlock1_b6: UIImageView!
    @IBOutlet weak var Statlock1_b7: UIImageView!
    
    
    @IBOutlet weak var Dynlock0_b0: UIImageView!
    @IBOutlet weak var Dynlock0_b1: UIImageView!
    @IBOutlet weak var Dynlock0_b2: UIImageView!
    @IBOutlet weak var Dynlock0_b3: UIImageView!
    @IBOutlet weak var Dynlock0_b4: UIImageView!
    @IBOutlet weak var Dynlock0_b5: UIImageView!
    @IBOutlet weak var Dynlock0_b6: UIImageView!
    @IBOutlet weak var Dynlock0_b7: UIImageView!
    
    
    @IBOutlet weak var Dynlock1_b0: UIImageView!
    @IBOutlet weak var Dynlock1_b1: UIImageView!
    @IBOutlet weak var Dynlock1_b2: UIImageView!
    @IBOutlet weak var Dynlock1_b3: UIImageView!
    @IBOutlet weak var Dynlock1_b4: UIImageView!
    @IBOutlet weak var Dynlock1_b5: UIImageView!
    
    @IBOutlet weak var Syslock_b0: UIImageView!
    @IBOutlet weak var Syslock_b1: UIImageView!
    @IBOutlet weak var Syslock_b2: UIImageView!
    @IBOutlet weak var Syslock_b3: UIImageView!
    @IBOutlet weak var Syslock_b4: UIImageView!
    
    
    @IBOutlet weak var Dynlock2_b2: UIImageView!
    @IBOutlet weak var Dynlock2_b3: UIImageView!
    @IBOutlet weak var Dynlock2_b4: UIImageView!
    @IBOutlet weak var Dynlock2_b5: UIImageView!
    @IBOutlet weak var Dynlock2_b6: UIImageView!
    @IBOutlet weak var Dynlock2_b7: UIImageView!
       
    internal var mLockBlockArray:[statusLockBlockConfigStruct] =
    [
        statusLockBlockConfigStruct(id: .BLOCK_02H_EXTENDED_LOCK0, name:"statlock0_b0",statusTag: false, statusUI: false),
        statusLockBlockConfigStruct(id: .BLOCK_02H_EXTENDED_LOCK1, name:"statlock0_b1", statusTag: false, statusUI: false),
        statusLockBlockConfigStruct(id: .BLOCK_02H_EXTENDED_LOCK2, name:"statlock0_b2", statusTag: false, statusUI: false),
        statusLockBlockConfigStruct(id: .BLOCK_03H_CC_FILE, name:"statlock0_b3", statusTag: false, statusUI: false),
        statusLockBlockConfigStruct(id: .BLOCK_04H, name:"statlock0_b4", statusTag: false, statusUI: false),
        statusLockBlockConfigStruct(id: .BLOCK_05H, name:"statlock0_b5", statusTag: false, statusUI: false),
        statusLockBlockConfigStruct(id: .BLOCK_06H, name:"statlock0_b6", statusTag: false, statusUI: false),
        statusLockBlockConfigStruct(id: .BLOCK_07H, name:"statlock0_b7", statusTag: false, statusUI: false),

        statusLockBlockConfigStruct(id: .BLOCK_08H, name:"statlock1_b0", statusTag: false, statusUI: false),
        statusLockBlockConfigStruct(id: .BLOCK_09H, name:"statlock1_b1", statusTag: false, statusUI: false),
        statusLockBlockConfigStruct(id: .BLOCK_0AH, name:"statlock1_b2", statusTag: false, statusUI: false),
        statusLockBlockConfigStruct(id: .BLOCK_0BH, name:"statlock1_b3", statusTag: false, statusUI: false),
        statusLockBlockConfigStruct(id: .BLOCK_0CH, name:"statlock1_b4", statusTag: false, statusUI: false),
        statusLockBlockConfigStruct(id: .BLOCK_0DH, name:"statlock1_b5", statusTag: false, statusUI: false),
        statusLockBlockConfigStruct(id: .BLOCK_0EH, name:"statlock1_b6", statusTag: false, statusUI: false),
        statusLockBlockConfigStruct(id: .BLOCK_0FH, name:"statlock1_b7", statusTag: false, statusUI: false),

        statusLockBlockConfigStruct(id: .BLOCKS_10H_TO_11H, name:"dynlock0_b0", statusTag: false, statusUI: false),
        statusLockBlockConfigStruct(id: .BLOCKS_12H_TO_13H, name:"dynlock0_b1", statusTag: false, statusUI: false),
        statusLockBlockConfigStruct(id: .BLOCKS_14H_TO_15H, name:"dynlock0_b2", statusTag: false, statusUI: false),
        statusLockBlockConfigStruct(id: .BLOCKS_16H_TO_17H, name:"dynlock0_b3", statusTag: false, statusUI: false),
        statusLockBlockConfigStruct(id: .BLOCKS_18H_TO_19H, name:"dynlock0_b4", statusTag: false, statusUI: false),
        statusLockBlockConfigStruct(id: .BLOCKS_1AH_TO_1BH, name:"dynlock0_b5", statusTag: false, statusUI: false),
        statusLockBlockConfigStruct(id: .BLOCKS_1CH_TO_1DH, name:"dynlock0_b6", statusTag: false, statusUI: false),
        statusLockBlockConfigStruct(id: .BLOCKS_1EH_TO_1FH, name:"dynlock0_b7", statusTag: false, statusUI: false),
 
        statusLockBlockConfigStruct(id: .BLOCKS_20H_TO_21H, name:"dynlock1_b0", statusTag: false, statusUI: false),
        statusLockBlockConfigStruct(id: .BLOCKS_22H_TO_23H, name:"dynlock1_b1", statusTag: false, statusUI: false),
        statusLockBlockConfigStruct(id: .BLOCKS_24H_TO_25H, name:"dynlock1_b2", statusTag: false, statusUI: false),
        statusLockBlockConfigStruct(id: .BLOCKS_26H_TO_27H, name:"dynlock1_b3", statusTag: false, statusUI: false),
        statusLockBlockConfigStruct(id: .BLOCKS_28H_TO_29H, name:"dynlock1_b4", statusTag: false, statusUI: false),
        statusLockBlockConfigStruct(id: .BLOCKS_2AH_TO_2BH, name:"dynlock1_b5", statusTag: false, statusUI: false),
 
        statusLockBlockConfigStruct(id: .BLOCK_2CH_DYNLOCK_SYSLOCK, name:"syslock_b0", statusTag: false, statusUI: false),
        statusLockBlockConfigStruct(id: .BLOCK_2DH_PRODUCT_IDENTIFICATION, name:"syslock_b1", statusTag: false, statusUI: false),
        statusLockBlockConfigStruct(id: .BLOCK_2EH_ANDEF_CFG, name:"syslock_b2", statusTag: false, statusUI: false),
        statusLockBlockConfigStruct(id: .BLOCK_2FH_KILL_PASSWORD, name:"syslock_b3", statusTag: false, statusUI: false),
        statusLockBlockConfigStruct(id: .BLOCK_30H_KILL_KEYHOLE, name:"syslock_b4", statusTag: false, statusUI: false),

        statusLockBlockConfigStruct(id: .BLOCKS_34H_TO_35H, name:"dynlock2_b2", statusTag: false, statusUI: false),
        statusLockBlockConfigStruct(id: .BLOCKS_36H_TO_37H, name:"dynlock2_b3", statusTag: false, statusUI: false),
        statusLockBlockConfigStruct(id: .BLOCKS_38H_TO_39H, name:"dynlock2_b4", statusTag: false, statusUI: false),
        statusLockBlockConfigStruct(id: .BLOCKS_3AH_TO_3BH, name:"dynlock2_b5", statusTag: false, statusUI: false),
        statusLockBlockConfigStruct(id: .BLOCKS_3CH_TO_3DH, name:"dynlock2_b6", statusTag: false, statusUI: false),
        statusLockBlockConfigStruct(id: .BLOCKS_3EH_TO_3FH, name:"dynlock2_b7", statusTag: false, statusUI: false),
    ];
    
    internal var mLockRegisterArray:[registerLockStruct] = [
        registerLockStruct(section: 0, name: "STATLOCK_0", val: 0x00),
        registerLockStruct(section: 1, name: "STATLOCK_1", val: 0x00),
        registerLockStruct(section: 2, name: "DYNLOCK_0", val: 0x00),
        registerLockStruct(section: 3, name: "DYNLOCK_1", val: 0x00),
        registerLockStruct(section: 4, name: "SYSLOCK", val: 0x00),
        registerLockStruct(section: 5, name: "DYNLOCK_2", val: 0x00),
    ];

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(MyHeaderView.self, forHeaderFooterViewReuseIdentifier: "header")
    }
   
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }

    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? MyHeaderView
        for lockReg in mLockRegisterArray {
            if (section == Int(lockReg.section)){
                header?.apply(text: lockReg.name+":"+String(format: "0x%02X",lockReg.val))
            }
       }
        return header
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? MyHeaderView
        for lockReg in mLockRegisterArray {
            if (section == Int(lockReg.section)){
                header?.apply(text: lockReg.name+":"+String(format: "0x%02X",lockReg.val))
            }
       }
     }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //no need to keep cell selected
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return
        }
        
        var lockBlockConfig:statusLockBlockConfigStruct? = getLockBlockConfigStruct(lockBlockName: cell.reuseIdentifier!)
        if (lockBlockConfig != nil) {
            if (lockBlockConfig?.statusTag == false){
                lockBlockConfig?.statusUI.toggle()
                updateLockBlockUI(lockBlockConfig: lockBlockConfig!)
                
                // Update extended blocks
                updateExtendedBlocks(lockBlockConfig: lockBlockConfig)
           }
        }
    }
 
    // Update Extended Block
    func updateExtendedBlocks(lockBlockConfig:statusLockBlockConfigStruct?){
        // Update extended blocks
        if (lockBlockConfig?.id == .BLOCK_02H_EXTENDED_LOCK0){
            var lockBlockConfigExtended:statusLockBlockConfigStruct? = getLockBlockConfigStruct(lockBlockId: .BLOCK_03H_CC_FILE)
                lockBlockConfigExtended?.statusUI.toggle()
                lockBlockConfigExtended?.statusTag.toggle()
                updateLockBlockUI(lockBlockConfig: lockBlockConfigExtended!)
        }
        
        if (lockBlockConfig?.id == .BLOCK_02H_EXTENDED_LOCK1){
            for lockBlockId in 4...9 {
                var lockBlockConfigExtended:statusLockBlockConfigStruct? = mLockBlockArray[lockBlockId]
                    lockBlockConfigExtended?.statusUI.toggle()
                    lockBlockConfigExtended?.statusTag.toggle()
                    updateLockBlockUI(lockBlockConfig: lockBlockConfigExtended!)
            }
        }

        if (lockBlockConfig?.id == .BLOCK_02H_EXTENDED_LOCK2){
            for lockBlockId in 10...15 {
                var lockBlockConfigExtended:statusLockBlockConfigStruct? = mLockBlockArray[lockBlockId]
                    lockBlockConfigExtended?.statusUI.toggle()
                    lockBlockConfigExtended?.statusTag.toggle()
                    updateLockBlockUI(lockBlockConfig: lockBlockConfigExtended!)
            }
        }
    }
    
    // Update ONE Section Header
    func updateLockRegisterUI(section:UInt8){
        var i:UInt8 = 0
        for lockReg in mLockRegisterArray {
            if (lockReg.section == section){
                UIHelper.UI { [self] in
                    let section = mTableView.headerView(forSection: Int(lockReg.section)) as? MyHeaderView
                    section?.apply(text: lockReg.name+":"+String(format: "0x%02X",lockReg.val))
                }
                return
            }
            i = i+1
       }
    }
    
    
    // Update ONE row of table
    func updateLockBlockUI(lockBlockConfig : statusLockBlockConfigStruct){
        switch lockBlockConfig.name {
        case "statlock0_b0":
            if (lockBlockConfig.statusUI == true){
                StatLock0_b0.image = UIImage(named:"checked")
                mLockRegisterArray[0].val = mLockRegisterArray[0].val | 0x01
            }else{
                StatLock0_b0.image = UIImage(named:"unchecked")
                mLockRegisterArray[0].val = mLockRegisterArray[0].val  & ~0x01
            }
            updateLockRegisterUI(section: 0)
            break
        case "statlock0_b1":
            if (lockBlockConfig.statusUI == true){
                Statlock0_b1.image = UIImage(named:"checked")
                mLockRegisterArray[0].val = mLockRegisterArray[0].val  | 0x02
            }else{
                Statlock0_b1.image = UIImage(named:"unchecked")
                mLockRegisterArray[0].val = mLockRegisterArray[0].val  & ~0x02
            }
            updateLockRegisterUI(section: 0)
            break
        case "statlock0_b2":
            if (lockBlockConfig.statusUI == true){
                Statlock0_b2.image = UIImage(named:"checked")
                mLockRegisterArray[0].val = mLockRegisterArray[0].val  | 0x04
            }else{
                Statlock0_b2.image = UIImage(named:"unchecked")
                mLockRegisterArray[0].val = mLockRegisterArray[0].val  & ~0x04
            }
            updateLockRegisterUI(section: 0)
            break
        case "statlock0_b3":
            if (lockBlockConfig.statusUI == true || mLockBlockArray[0].statusUI == true){
                Statlock0_b3.image = UIImage(named:"checked")
                mLockRegisterArray[0].val = mLockRegisterArray[0].val | 0x08
            }else{
                Statlock0_b3.image = UIImage(named:"unchecked")
                mLockRegisterArray[0].val = mLockRegisterArray[0].val  & ~0x08
            }
            updateLockRegisterUI(section: 0)
            break
        case "statlock0_b4":
            if (lockBlockConfig.statusUI == true || mLockBlockArray[1].statusUI == true){
                Statlock0_b4.image = UIImage(named:"checked")
                mLockRegisterArray[0].val = mLockRegisterArray[0].val  | 0x10
            }else{
                Statlock0_b4.image = UIImage(named:"unchecked")
                mLockRegisterArray[0].val = mLockRegisterArray[0].val  & ~0x10
            }
            updateLockRegisterUI(section: 0)
            break
        case "statlock0_b5":
            if (lockBlockConfig.statusUI == true || mLockBlockArray[1].statusUI == true){
                Statlock0_b5.image = UIImage(named:"checked")
                mLockRegisterArray[0].val = mLockRegisterArray[0].val  | 0x20
            }else{
                Statlock0_b5.image = UIImage(named:"unchecked")
                mLockRegisterArray[0].val = mLockRegisterArray[0].val & ~0x20
            }
            updateLockRegisterUI(section: 0)
            break
        case "statlock0_b6":
            if (lockBlockConfig.statusUI == true || mLockBlockArray[1].statusUI == true){
                Statlock0_b6.image = UIImage(named:"checked")
                mLockRegisterArray[0].val = mLockRegisterArray[0].val | 0x40
            }else{
                Statlock0_b6.image = UIImage(named:"unchecked")
                mLockRegisterArray[0].val = mLockRegisterArray[0].val & ~0x40
            }
            updateLockRegisterUI(section: 0)
            break
        case "statlock0_b7":
            if (lockBlockConfig.statusUI == true || mLockBlockArray[1].statusUI == true){
                Statlock0_b7.image = UIImage(named:"checked")
               mLockRegisterArray[0].val = mLockRegisterArray[0].val | 0x80
            }else{
                Statlock0_b7.image = UIImage(named:"unchecked")
               mLockRegisterArray[0].val = mLockRegisterArray[0].val & ~0x80
            }
            updateLockRegisterUI(section: 0)
            break
            
        case "statlock1_b0":
            if (lockBlockConfig.statusUI == true || mLockBlockArray[1].statusUI == true){
                Statlock1_b0.image = UIImage(named:"checked")
                mLockRegisterArray[1].val = mLockRegisterArray[1].val | 0x01
            }else{
                Statlock1_b0.image = UIImage(named:"unchecked")
                mLockRegisterArray[1].val = mLockRegisterArray[1].val & ~0x01
            }
            updateLockRegisterUI(section: 1)
            break
        case "statlock1_b1":
            if (lockBlockConfig.statusUI == true || mLockBlockArray[1].statusUI == true){
                Statlock1_b1.image = UIImage(named:"checked")
                mLockRegisterArray[1].val = mLockRegisterArray[1].val | 0x02
            }else{
                Statlock1_b1.image = UIImage(named:"unchecked")
                mLockRegisterArray[1].val = mLockRegisterArray[1].val & ~0x02
            }
            updateLockRegisterUI(section: 1)
            break
        case "statlock1_b2":
            if (lockBlockConfig.statusUI == true || mLockBlockArray[2].statusUI == true){
                Statlock1_b2.image = UIImage(named:"checked")
                mLockRegisterArray[1].val = mLockRegisterArray[1].val | 0x04
            }else{
                Statlock1_b2.image = UIImage(named:"unchecked")
                mLockRegisterArray[1].val = mLockRegisterArray[1].val & ~0x04
            }
            updateLockRegisterUI(section: 1)
            break
        case "statlock1_b3":
            if (lockBlockConfig.statusUI == true || mLockBlockArray[2].statusUI == true){
                Statlock1_b3.image = UIImage(named:"checked")
                mLockRegisterArray[1].val = mLockRegisterArray[1].val | 0x08
            }else{
                Statlock1_b3.image = UIImage(named:"unchecked")
                mLockRegisterArray[1].val = mLockRegisterArray[1].val & ~0x08
            }
            updateLockRegisterUI(section: 1)
            break
        case "statlock1_b4":
            if (lockBlockConfig.statusUI == true || mLockBlockArray[2].statusUI == true){
                Statlock1_b4.image = UIImage(named:"checked")
                mLockRegisterArray[1].val = mLockRegisterArray[1].val | 0x10
            }else{
                Statlock1_b4.image = UIImage(named:"unchecked")
                mLockRegisterArray[1].val = mLockRegisterArray[1].val & ~0x10
            }
            updateLockRegisterUI(section: 1)
            break
        case "statlock1_b5":
            if (lockBlockConfig.statusUI == true || mLockBlockArray[2].statusUI == true){
                Statlock1_b5.image = UIImage(named:"checked")
                mLockRegisterArray[1].val = mLockRegisterArray[1].val | 0x20
            }else{
                Statlock1_b5.image = UIImage(named:"unchecked")
                mLockRegisterArray[1].val = mLockRegisterArray[1].val & ~0x20
            }
            updateLockRegisterUI(section: 1)
            break
        case "statlock1_b6":
            if (lockBlockConfig.statusUI == true || mLockBlockArray[2].statusUI == true){
                Statlock1_b6.image = UIImage(named:"checked")
                mLockRegisterArray[1].val = mLockRegisterArray[1].val | 0x40
            }else{
                Statlock1_b6.image = UIImage(named:"unchecked")
                mLockRegisterArray[1].val = mLockRegisterArray[1].val & ~0x40
            }
            updateLockRegisterUI(section: 1)
            break
        case "statlock1_b7":
            if (lockBlockConfig.statusUI == true || mLockBlockArray[2].statusUI == true){
                Statlock1_b7.image = UIImage(named:"checked")
                mLockRegisterArray[1].val = mLockRegisterArray[1].val | 0x80
            }else{
                Statlock1_b7.image = UIImage(named:"unchecked")
                mLockRegisterArray[1].val = mLockRegisterArray[1].val & ~0x80
            }
            updateLockRegisterUI(section: 1)
            break
            
        case "dynlock0_b0":
            if (lockBlockConfig.statusUI == true){
                Dynlock0_b0.image = UIImage(named:"checked")
                mLockRegisterArray[2].val = mLockRegisterArray[2].val | 0x01
            }else{
                Dynlock0_b0.image = UIImage(named:"unchecked")
                mLockRegisterArray[2].val = mLockRegisterArray[2].val & ~0x01
            }
            updateLockRegisterUI(section: 2)
            break
        case "dynlock0_b1":
            if (lockBlockConfig.statusUI == true){
                Dynlock0_b1.image = UIImage(named:"checked")
                mLockRegisterArray[2].val = mLockRegisterArray[2].val | 0x02
            }else{
                Dynlock0_b1.image = UIImage(named:"unchecked")
                mLockRegisterArray[2].val = mLockRegisterArray[2].val & ~0x02
            }
            updateLockRegisterUI(section: 2)
            break
        case "dynlock0_b2":
            if (lockBlockConfig.statusUI == true){
                Dynlock0_b2.image = UIImage(named:"checked")
                mLockRegisterArray[2].val = mLockRegisterArray[2].val | 0x04
            }else{
                Dynlock0_b2.image = UIImage(named:"unchecked")
                mLockRegisterArray[2].val = mLockRegisterArray[2].val & ~0x04
            }
            updateLockRegisterUI(section: 2)
            break
        case "dynlock0_b3":
            if (lockBlockConfig.statusUI == true){
                Dynlock0_b3.image = UIImage(named:"checked")
                mLockRegisterArray[2].val = mLockRegisterArray[2].val | 0x08
            }else{
                Dynlock0_b3.image = UIImage(named:"unchecked")
                mLockRegisterArray[2].val = mLockRegisterArray[2].val & ~0x08
            }
            updateLockRegisterUI(section: 2)
            break
        case "dynlock0_b4":
            if (lockBlockConfig.statusUI == true){
                Dynlock0_b4.image = UIImage(named:"checked")
                mLockRegisterArray[2].val = mLockRegisterArray[2].val | 0x10
            }else{
                Dynlock0_b4.image = UIImage(named:"unchecked")
                mLockRegisterArray[2].val = mLockRegisterArray[2].val & ~0x10
            }
            updateLockRegisterUI(section: 2)
            break
        case "dynlock0_b5":
            if (lockBlockConfig.statusUI == true){
                Dynlock0_b5.image = UIImage(named:"checked")
                mLockRegisterArray[2].val = mLockRegisterArray[2].val | 0x20
            }else{
                Dynlock0_b5.image = UIImage(named:"unchecked")
                mLockRegisterArray[2].val = mLockRegisterArray[2].val & ~0x20
            }
            updateLockRegisterUI(section: 2)
            break
        case "dynlock0_b6":
            if (lockBlockConfig.statusUI == true){
                Dynlock0_b6.image = UIImage(named:"checked")
                mLockRegisterArray[2].val = mLockRegisterArray[2].val | 0x40
            }else{
                Dynlock0_b6.image = UIImage(named:"unchecked")
                mLockRegisterArray[2].val = mLockRegisterArray[2].val & ~0x40
            }
            updateLockRegisterUI(section: 2)
            break
        case "dynlock0_b7":
            if (lockBlockConfig.statusUI == true){
                Dynlock0_b7.image = UIImage(named:"checked")
                mLockRegisterArray[2].val = mLockRegisterArray[2].val | 0x80
            }else{
                Dynlock0_b7.image = UIImage(named:"unchecked")
                mLockRegisterArray[2].val = mLockRegisterArray[2].val & ~0x80
            }
            updateLockRegisterUI(section: 2)
            break
            
        case "dynlock1_b0":
            if (lockBlockConfig.statusUI == true){
                Dynlock1_b0.image = UIImage(named:"checked")
                mLockRegisterArray[3].val = mLockRegisterArray[3].val | 0x01
            }else{
                Dynlock1_b0.image = UIImage(named:"unchecked")
                mLockRegisterArray[3].val = mLockRegisterArray[3].val & ~0x01
            }
            updateLockRegisterUI(section: 3)
            break
        case "dynlock1_b1":
            if (lockBlockConfig.statusUI == true){
                Dynlock1_b1.image = UIImage(named:"checked")
                mLockRegisterArray[3].val = mLockRegisterArray[3].val | 0x02
            }else{
                Dynlock1_b1.image = UIImage(named:"unchecked")
                mLockRegisterArray[3].val = mLockRegisterArray[3].val & ~0x02
            }
            updateLockRegisterUI(section: 3)
            break
        case "dynlock1_b2":
            if (lockBlockConfig.statusUI == true){
                Dynlock1_b2.image = UIImage(named:"checked")
                mLockRegisterArray[3].val = mLockRegisterArray[3].val | 0x04
            }else{
                Dynlock1_b2.image = UIImage(named:"unchecked")
                mLockRegisterArray[3].val = mLockRegisterArray[3].val & ~0x04
            }
            updateLockRegisterUI(section: 3)
            break
        case "dynlock1_b3":
            if (lockBlockConfig.statusUI == true){
                Dynlock1_b3.image = UIImage(named:"checked")
                mLockRegisterArray[3].val = mLockRegisterArray[3].val | 0x08
            }else{
                Dynlock1_b3.image = UIImage(named:"unchecked")
                mLockRegisterArray[3].val = mLockRegisterArray[3].val & ~0x08
            }
            updateLockRegisterUI(section: 3)
            break
        case "dynlock1_b4":
            if (lockBlockConfig.statusUI == true){
                Dynlock1_b4.image = UIImage(named:"checked")
                mLockRegisterArray[3].val = mLockRegisterArray[3].val | 0x10
            }else{
                Dynlock1_b4.image = UIImage(named:"unchecked")
                mLockRegisterArray[3].val = mLockRegisterArray[3].val & ~0x10
            }
            updateLockRegisterUI(section: 3)
            break
        case "dynlock1_b5":
            if (lockBlockConfig.statusUI == true){
                Dynlock1_b5.image = UIImage(named:"checked")
                mLockRegisterArray[3].val = mLockRegisterArray[3].val | 0x20
            }else{
                Dynlock1_b5.image = UIImage(named:"unchecked")
                mLockRegisterArray[3].val = mLockRegisterArray[3].val & ~0x20
            }
            updateLockRegisterUI(section: 3)
            break
            
            
        case "syslock_b0":
            if (lockBlockConfig.statusUI == true){
                Syslock_b0.image = UIImage(named:"checked")
                mLockRegisterArray[4].val = mLockRegisterArray[4].val | 0x01
            }else{
                Syslock_b0.image = UIImage(named:"unchecked")
                mLockRegisterArray[4].val = mLockRegisterArray[4].val & ~0x01
            }
            updateLockRegisterUI(section: 4)
            break
        case "syslock_b1":
            if (lockBlockConfig.statusUI == true){
                Syslock_b1.image = UIImage(named:"checked")
                mLockRegisterArray[4].val = mLockRegisterArray[4].val | 0x02
            }else{
                Syslock_b1.image = UIImage(named:"unchecked")
                mLockRegisterArray[4].val = mLockRegisterArray[4].val & ~0x02
            }
            updateLockRegisterUI(section: 4)
            break
        case "syslock_b2":
            if (lockBlockConfig.statusUI == true){
                Syslock_b2.image = UIImage(named:"checked")
                mLockRegisterArray[4].val = mLockRegisterArray[4].val | 0x04
            }else{
                Syslock_b2.image = UIImage(named:"unchecked")
                mLockRegisterArray[4].val = mLockRegisterArray[4].val & ~0x04
            }
            updateLockRegisterUI(section: 4)
            break
        case "syslock_b3":
            if (lockBlockConfig.statusUI == true){
                Syslock_b3.image = UIImage(named:"checked")
                mLockRegisterArray[4].val = mLockRegisterArray[4].val | 0x08
            }else{
                Syslock_b3.image = UIImage(named:"unchecked")
                mLockRegisterArray[4].val = mLockRegisterArray[4].val & ~0x08
            }
            updateLockRegisterUI(section: 4)
            break
        case "syslock_b4":
            if (lockBlockConfig.statusUI == true){
                Syslock_b4.image = UIImage(named:"checked")
                mLockRegisterArray[4].val = mLockRegisterArray[4].val | 0x10
            }else{
                Syslock_b4.image = UIImage(named:"unchecked")
                mLockRegisterArray[4].val = mLockRegisterArray[4].val & ~0x10
            }
            updateLockRegisterUI(section: 4)
            break

        case "dynlock2_b2":
            if (lockBlockConfig.statusUI == true){
                Dynlock2_b2.image = UIImage(named:"checked")
                mLockRegisterArray[5].val = mLockRegisterArray[5].val | 0x04
            }else{
                Dynlock2_b2.image = UIImage(named:"unchecked")
                mLockRegisterArray[5].val = mLockRegisterArray[5].val & ~0x04
            }
            updateLockRegisterUI(section: 5)
            break
        case "dynlock2_b3":
            if (lockBlockConfig.statusUI == true){
                Dynlock2_b3.image = UIImage(named:"checked")
                mLockRegisterArray[5].val = mLockRegisterArray[5].val | 0x08
            }else{
                Dynlock2_b3.image = UIImage(named:"unchecked")
                mLockRegisterArray[5].val = mLockRegisterArray[5].val & ~0x08
            }
            updateLockRegisterUI(section: 5)
            break
        case "dynlock2_b4":
            if (lockBlockConfig.statusUI == true){
                Dynlock2_b4.image = UIImage(named:"checked")
                mLockRegisterArray[5].val = mLockRegisterArray[5].val | 0x10
            }else{
                Dynlock2_b4.image = UIImage(named:"unchecked")
                mLockRegisterArray[5].val = mLockRegisterArray[5].val & ~0x10
            }
            updateLockRegisterUI(section: 5)
            break
        case "dynlock2_b5":
            if (lockBlockConfig.statusUI == true){
                Dynlock2_b5.image = UIImage(named:"checked")
                mLockRegisterArray[5].val = mLockRegisterArray[5].val | 0x20
            }else{
                Dynlock2_b5.image = UIImage(named:"unchecked")
                mLockRegisterArray[5].val = mLockRegisterArray[5].val & ~0x20
            }
            updateLockRegisterUI(section: 5)
            break
        case "dynlock2_b6":
            if (lockBlockConfig.statusUI == true){
                Dynlock2_b6.image = UIImage(named:"checked")
                mLockRegisterArray[5].val = mLockRegisterArray[5].val | 0x40
            }else{
                Dynlock2_b6.image = UIImage(named:"unchecked")
                mLockRegisterArray[5].val = mLockRegisterArray[5].val & ~0x40
            }
            updateLockRegisterUI(section: 5)
            break
        case "dynlock2_b7":
            if (lockBlockConfig.statusUI == true){
                Dynlock2_b7.image = UIImage(named:"checked")
                mLockRegisterArray[5].val = mLockRegisterArray[5].val | 0x80
            }else{
                Dynlock2_b7.image = UIImage(named:"unchecked")
                mLockRegisterArray[5].val = mLockRegisterArray[5].val & ~0x80
            }
            updateLockRegisterUI(section: 5)
            break
            
        default:
            break;
        }
        
        // update config array
        setLockBlockConfigStruct(lockBlockConfig: lockBlockConfig)
    }
    
    // Get lockConfig according its name
    private func getLockBlockConfigStruct(lockBlockName:String) -> statusLockBlockConfigStruct? {
        for lockConfig in mLockBlockArray {
            if (lockConfig.name == lockBlockName){
                return lockConfig
            }
       }
        return nil
    }
    
    // Get lockConfig according its id
    private func getLockBlockConfigStruct(lockBlockId:ComStSt25sdkType2St25tnST25TNTag_ST25TNLocks) -> statusLockBlockConfigStruct? {
        for lockConfig in mLockBlockArray {
            if (lockConfig.id == lockBlockId){
                return lockConfig
            }
       }
        return nil
    }

    
    // Set lockConfig
    func setLockBlockConfigStruct(lockBlockConfig:statusLockBlockConfigStruct) {
        var i:UInt8 = 0
        for lockConfig in mLockBlockArray {
            if (lockConfig.name == lockBlockConfig.name){
                mLockBlockArray[Int(i)] = lockBlockConfig
                return
            }
            i = i+1
       }
    }
  
    // returns lock config array to the parent
    func getLockConfigUI() -> [statusLockBlockConfigStruct]{
        return mLockBlockArray;
    }
    
    // Set Lock Registers
    func setLockRegisterStruct(lockRegister:registerLockStruct) {
        var i:UInt8 = 0
        for lockReg in mLockRegisterArray {
            if (lockReg.name == lockRegister.name){
                mLockRegisterArray[Int(i)] = lockRegister
                UIHelper.UI { [self] in
                    let section = mTableView.headerView(forSection: Int(lockRegister.section))
                    section?.textLabel?.text = lockReg.name+":"+String(format: "0x%02X",lockRegister.val)
                }
                return
            }
            i = i+1
       }
    }
    // returns lock register array to the parent
    func getLockRegister() -> [registerLockStruct]{
        return mLockRegisterArray;
    }
}

// Class for section header config
class MyHeaderView: UITableViewHeaderFooterView {

    let label = UILabel(frame: .zero)

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        let customBackgroundView = UIView(frame: .zero)
        customBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        customBackgroundView.backgroundColor = UIColor.stLightBlueColor()
        

        contentView.addSubview(customBackgroundView)
        customBackgroundView.addSubview(label)

        label.textColor = UIColor.stDarkBlueColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: customBackgroundView.leadingAnchor, constant: 16.0),
            label.trailingAnchor.constraint(equalTo: customBackgroundView.trailingAnchor, constant: -16.0),
            label.topAnchor.constraint(equalTo: customBackgroundView.topAnchor),
            label.bottomAnchor.constraint(equalTo: customBackgroundView.bottomAnchor),

            customBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            customBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            customBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor),
            customBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            ])
    }

    func apply(text: String) {
        label.text = text
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

