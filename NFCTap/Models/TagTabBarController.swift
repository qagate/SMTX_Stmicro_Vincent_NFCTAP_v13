//
//  TagTabBarController.swift
//  NFCTap
//
//  Created by STMicroelectronics on 17/10/2019.
//  Copyright © 2019 STMicroelectronics. All rights reserved.
//

import Foundation
import UIKit


#if APPCLIP
struct TabItem {
    let storyboardName: String
    let controllerName: String
    let tabName: String
    let image: String
    let selectedImage: String
    let order: Int
    var withNC : Bool
    var mainVC : UIViewController?

    static var TagInfo = TabItem(
        storyboardName: "ST25TagInformation",
        controllerName: "ST25TagInformationViewController",
        tabName: "Tag info",
        image: "tagEdit_dark_blue.png",
        selectedImage: "tagEdit_dark_blue.png",
        order: 0,
        withNC: true
    )
}

#else
struct TabItem {
  let storyboardName: String
  let controllerName: String
  let tabName: String
  let image: String
  let selectedImage: String
  let order: Int
  var withNC : Bool
  var mainVC : ST25UIViewController?
 
    static var TagInfo = TabItem(
    storyboardName: "ST25TagInformation",
    controllerName: "ST25TagInformationViewController",
    tabName: "Tag info",
    image: "tagEdit_dark_blue.png",
    selectedImage: "tagEdit_dark_blue.png",
    order: 0,
    withNC: true
  )
    static var TagMemory = TabItem(
      storyboardName: "Main",
      controllerName: "TagMemoryViewController",
      tabName: "Tag Memory specific",
      image: "eeprom_dark_blue.png",
      selectedImage: "eeprom_dark_blue.png",
      order: 0,
      withNC: true
    )
  
    static var TagST25Home = TabItem(
      storyboardName: "ST25Home",
      controllerName: "ST25Home",
      tabName: "Scan",
      image: "RS221_touch_screen_light_blue_30x30.png",
      selectedImage: "RS221_touch_screen_light_blue_30x30.png",
      order: 0,
      withNC: true
    )
    static var TagNDEFRecord = TabItem(
      storyboardName: "ST25AreaManagement",
      controllerName: "ST25NdefRecordsListViewController",
      tabName: "NDEF records List",
      image: "ndef_editor_dark_blue.png",
      selectedImage: "ndef_editor_dark_blue.png",
      order: 0,
      withNC: true
    )
    
    static var TagST25DVI2CDemos = TabItem(
       storyboardName: "Main",
       controllerName: "ST25DVI2CDemosViewController",
       tabName: "ST25DV Fast Transfer Mode",
       image: "fw_upgrade_dark_blue.png",
       selectedImage: "fw_upgrade_dark_blue.png",
       order: 0,
       withNC: true
     )
    static var TagCoreNFC = TabItem(
       storyboardName: "Main",
       controllerName: "testCoreNfcViewController",
       tabName: "CoreNFC",
       image: "NFC_white.png",
       selectedImage: "NFC_white.png",
       order: 0,
       withNC: true
     )

    static var TagSettings = TabItem(
       storyboardName: "Main",
       controllerName: "SettingTableViewController",
       tabName: "Settings",
       image: "RS780_Gear_dark_blue",
       selectedImage: "RS780_Gear_dark_blue",
       order: 0,
       withNC: true
     )
    static var TagAbout = TabItem(
       storyboardName: "Main",
       controllerName: "AboutViewController",
       tabName: "About",
       image: "RS2211_call_center_white_30x30.png",
       selectedImage: "RS2211_call_center_white_30x30.png",
       order: 0,
       withNC: true
     )
    static var TagST25PWMControl = TabItem(
      storyboardName: "ST25PwmDemosStoryboard",
      controllerName: "ST25PwmControlViewController",
      tabName: "ST25PWM control",
      image: "right_arrow_light_dark_blue",
      selectedImage: "right_arrow_light_dark_blue",
      order: 0,
      withNC: true
    )
    static var ST25TVCounter = TabItem(
      storyboardName: "ST25TVCounter",
      controllerName: "ST25TVCounterViewController",
      tabName: "ST25TV Counter",
      image: "metering_light_blue.png",
      selectedImage: "metering_light_blue.png",
      order: 0,
      withNC: true
        )
    static var TagST25DVI2CFWUpdateDemos = TabItem(
        storyboardName: "ST25DVFirmwareUpdate",
        controllerName: "ST25DVFirmwareUpdateViewController",
        tabName: "Firmware update",
        image: "fw_upgrade_dark_blue.png",
        selectedImage: "fw_upgrade_dark_blue.png",
        order: 0,
        withNC: true
    )
    static var TagST25DVI2CStopwatchTransfer = TabItem(
        storyboardName: "ST25DVFirmwareUpdate",
        controllerName: "ST25DVStopwatchViewController",
        tabName: "Stopwatch",
        image: "fw_upgrade_dark_blue.png",
        selectedImage: "fw_upgrade_dark_blue.png",
        order: 0,
        withNC: true
    )
    
    static var ST25TVTamper = TabItem(
      storyboardName: "ST25TVTamper",
      controllerName: "ST25TVTamperViewController",
      tabName: "ST25TV Tamper",
      image: "tamper_detect_dark_blue.png",
      selectedImage: "tamper_detect_dark_blue.png",
      order: 0,
      withNC: true
    )
    static var ST25TVSignature = TabItem(
      storyboardName: "ST25TVSignature",
      controllerName: "ST25TVSignatureViewController",
      tabName: "ST25 Signature",
      image: "ST10230_protection_information_3_dark_blue.png",
      selectedImage: "ST10230_protection_information_3_dark_blue.png",
      order: 0,
      withNC: true
    )

    static var TagST25DVI2CMailboxManagement = TabItem(
        storyboardName: "ST25DVFirmwareUpdate",
        controllerName: "ST25DVMailboxManagementViewController",
        tabName: "Firmware update",
        image: "fw_upgrade_dark_blue.png",
        selectedImage: "fw_upgrade_dark_blue.png",
        order: 0,
        withNC: true
    )
    static var TagST25DVI2CPictureTransfer = TabItem(
        storyboardName: "ST25DVFirmwareUpdate",
        controllerName: "ST25DVPictureTransferViewController",
        tabName: "Firmware update",
        image: "fw_upgrade_dark_blue.png",
        selectedImage: "fw_upgrade_dark_blue.png",
        order: 0,
        withNC: true
    )
    
    static var TagST25TVAreaSecurityStatus = TabItem(
        storyboardName: "ST25AreasSecurityStatusStoryboard",
        controllerName: "ST25AreaSecurityStatusViewController",
        tabName: "Area security status",
        image: "ST10230_protection_information_3_dark_blue",
        selectedImage: "ST10230_protection_information_3_dark_blue",
        order: 0,
        withNC: true
    )
    static var TagST25TVConfigurationPasswordManagement = TabItem(
        storyboardName: "ST25ConfigurationPassword",
        controllerName: "ST25ConfigurationPasswordViewController",
        tabName: "Configuration pwd management",
        image: "ST10230_protection_information_3_dark_blue",
        selectedImage: "ST10230_protection_information_3_dark_blue",
        order: 0,
        withNC: true
    )
    
    static var TagST25TVAreaManagementViewController = TabItem(
        storyboardName: "ST25AreasSecurityStatusStoryboard",
        controllerName: "ST25TVAreaManagementViewController",
        tabName: "Areas management",
        image: "multi_area",
        selectedImage: "multi_area",
        order: 0,
        withNC: true
    )
    static var TagST25AreaViewController = TabItem(
        storyboardName: "ST25AreaManagement",
        controllerName: "ST25AreaViewController",
        tabName: "Areas content editor",
        image: "multi_area",
        selectedImage: "multi_area",
        order: 0,
        withNC: true
    )
    
    static var TagST25RegistersViewController = TabItem(
        storyboardName: "ST25Registers",
        controllerName: "ST25RegistersViewController",
        tabName: "Registers management",
        image: "RS8684_settings_dark_blue",
        selectedImage: "RS8684_settings_dark_blue",
        order: 0,
        withNC: true
    )
  
    static var TagST25DVDynRegistersViewController = TabItem(
        storyboardName: "ST25Registers",
        controllerName: "ST25RegistersViewController",
        tabName: "Dynamic registers management",
        image: "RS8684_settings_dark_blue",
        selectedImage: "RS8684_settings_dark_blue",
        order: 0,
        withNC: true
    )

    
    
    static var TagST25TVKillFeaturesViewController = TabItem(
        storyboardName: "ST25TVKillFeatures",
        controllerName: "ST25TVKillFeaturesViewController",
        tabName: "Kill management",
        image: "ST10230_protection_information_3_dark_blue",
        selectedImage: "ST10230_protection_information_3_dark_blue",
        order: 0,
        withNC: true
    )
 
    static var TagST25LockBlockFeaturesViewController = TabItem(
        storyboardName: "ST25LockBlock",
        controllerName: "ST25LockBlockViewController",
        tabName: "Lock block features",
        image: "ST10230_protection_information_3_dark_blue",
        selectedImage: "ST10230_protection_information_3_dark_blue",
        order: 0,
        withNC: true
    )
    
    static var TagST25TVUntraceableModeViewController = TabItem(
        storyboardName: "ST25TVUntraceableMode",
        controllerName: "ST25TVUntraceableModeViewController",
        tabName: "ST25TV Untraceable Mode",
        image: "ST13348_Search_dark_blue",
        selectedImage: "ST13348_Search_dark_blue",
        order: 0,
        withNC: true
    )
    static var TagST25TVEasViewController = TabItem(
        storyboardName: "ST25TVEas",
        controllerName: "ST25TVEasViewController",
        tabName: "ELectronic Article Surveillance",
        image: "RS1074_security_camera_dark_blue",
        selectedImage: "RS1074_security_camera_dark_blue",
        order: 0,
        withNC: true
        )

    static var TagST25DVConfigurationPasswordManagement = TabItem(
        storyboardName: "ST25ConfigurationPassword",
        controllerName: "ST25ConfigurationPasswordViewController",
        tabName: "Configuration pwd management",
        image: "ST10230_protection_information_3_dark_blue",
        selectedImage: "ST10230_protection_information_3_dark_blue",
        order: 0,
        withNC: true
    )
   
     static var TagST25DVAreaConfiguration = TabItem(
         storyboardName: "ST25DVAreaConfiguration",
         controllerName: "ST25DVAreaConfigurationViewController",
         tabName: "Area management",
         image: "multi_area",
         selectedImage: "multi_area",
         order: 0,
         withNC: true
     )

    static var TagST25PWMDemos = TabItem(
        storyboardName: "ST25PwmDemosStoryboard",
        controllerName: "ST25PwmDemosViewController",
        tabName: "ST25PWM demos",
        image: "right_arrow_light_dark_blue",
        selectedImage: "right_arrow_light_dark_blue",
        order: 0,
        withNC: true
    )

    static var TagST25PWMConfiguration = TabItem(
        storyboardName: "ST25PwmDemosStoryboard",
        controllerName: "ST25PwmConfigurationViewController",
        tabName: "ST25PWM configuration",
        image: "right_arrow_light_dark_blue",
        selectedImage: "right_arrow_light_dark_blue",
        order: 0,
        withNC: true
    )
    
    static var ST25TVCUniqueTapCode = TabItem(
      storyboardName: "ST25TVCUniqueTapCode",
      controllerName: "ST25TVCUniqueTapCodeViewController",
      tabName: "ST25TVC Unique Tap Code",
      image: "metering_light_blue.png",
      selectedImage: "metering_light_blue.png",
      order: 0,
      withNC: true
        )
 
    static var ST25TVCANDEFUrlRecordViewController = TabItem(
      storyboardName: "ST25TVCANDEFUriConfiguration",
      controllerName: "ST25TVCANDEFUrlRecordViewController",
      tabName: "ST25TVC ANDEF Url",
      image: "metering_light_blue.png",
      selectedImage: "metering_light_blue.png",
      order: 0,
      withNC: true
        )
    
    static var ST25TVCTamper = TabItem(
      storyboardName: "ST25TVCTamper",
      controllerName: "ST25TVCTamperViewController",
      tabName: "ST25TVC Tamper",
      image: "tamper_detect_dark_blue.png",
      selectedImage: "tamper_detect_dark_blue.png",
      order: 0,
      withNC: true
        )

    static var ST25TVCLockConfiguration = TabItem(
      storyboardName: "ST25TVCLockConfiguration",
      controllerName: "ST25TVCLockConfigurationViewController",
      tabName: "ST25TVC Lock Configuration",
      image: "ST10230_protection_information_3_dark_blue",
      selectedImage: "ST10230_protection_information_3_dark_blue",
      order: 0,
      withNC: true
        )
  
    static var ST25TVCAfiDsFid = TabItem(
      storyboardName: "ST25TVCAfiDsFid",
      controllerName: "ST25TVCAfiDsFidViewController",
      tabName: "ST25TVC Afi/DsFid",
      image: "metering_light_blue.png",
      selectedImage: "metering_light_blue.png",
      order: 0,
      withNC: true
        )

    static var TagST25TVCPasswordProtection = TabItem(
        storyboardName: "ST25TVCPasswordProtection",
        controllerName: "ST25TVCPasswordProtectionViewController",
        tabName: "Password Protection",
        image: "ST10230_protection_information_3_dark_blue",
        selectedImage: "ST10230_protection_information_3_dark_blue",
        order: 0,
        withNC: true
    )

    static var TagST25TVCAreaConfiguration = TabItem(
        storyboardName: "ST25TVCAreaConfiguration",
        controllerName: "ST25TVCAreaConfigurationViewController",
        tabName: "Area management",
        image: "multi_area",
        selectedImage: "multi_area",
        order: 0,
        withNC: true
    )

    static var ST25EnergyHarvesting = TabItem(
        storyboardName: "energyHarvesting",
        controllerName: "ST25EnergyHarverstingViewController",
        tabName: "Energy Harvesting",
        image: "RS1421_mobile_nfc_light_blue_30x30",
        selectedImage: "RS1421_mobile_nfc_light_blue_30x30",
        order: 0,
        withNC: true
    )

    static var Type5CCFileEditor = TabItem(
        storyboardName: "Type5CCFile",
        controllerName: "Type5CCFileViewController",
        tabName: "CC File Editor",
        image: "ndef_editor_dark_blue.png",
        selectedImage: "ndef_editor_dark_blue.png",
        order: 0,
        withNC: true
    )
    
    static var ST25TNANDEFUrlRecordViewController = TabItem(
      storyboardName: "ST25TNANDEFUriConfiguration",
      controllerName: "ST25TNANDEFUrlRecordViewController",
      tabName: "ST25TN ANDEF Url",
      image: "metering_light_blue.png",
      selectedImage: "metering_light_blue.png",
      order: 0,
      withNC: true
        )

    static var ST25TNLockBlockConfiguration = TabItem(
      storyboardName: "ST25TNLockBlockConfiguration",
      controllerName: "ST25TNLockBlockConfigurationViewController",
      tabName: "ST25TN Lock Block Configuration",
      image: "ST10230_protection_information_3_dark_blue",
      selectedImage: "ST10230_protection_information_3_dark_blue",
      order: 0,
      withNC: true
        )
 
    static var ST25TNCCFileEditor = TabItem(
      storyboardName: "Type2CCFile",
      controllerName: "Type2CCFileViewController",
      tabName: "ST25TN CC File Editor",
      image: "ndef_editor_dark_blue.png",
      selectedImage: "ndef_editor_dark_blue.png",
      order: 0,
      withNC: true
        )
    
    static var ST25TNMemoryConfiguration = TabItem(
      storyboardName: "ST25TNMemoryConfiguration",
      controllerName: "ST25TNMemoryConfigurationViewController",
      tabName: "ST25TN Memory Configuration",
      image: "multi_area",
      selectedImage: "multi_area",
      order: 0,
      withNC: true
        )

    static var ST25AppLauncher = TabItem(
        storyboardName: "ST25AppLauncher",
        controllerName: "ST25AppLauncherViewController",
        tabName: "ST25 App Launcher",
        image: "ndef_editor_dark_blue.png",
        selectedImage: "ndef_editor_dark_blue.png",
        order: 0,
        withNC: true
    )
  
    static var Type4CCFileEditor = TabItem(
        storyboardName: "ST25TACCFileEditor",
        controllerName: "ST25TACCFileEditorViewController",
        tabName: "Type4a CC File",
        image: "ndef_editor_dark_blue.png",
        selectedImage: "ndef_editor_dark_blue.png",
        order: 0,
        withNC: true
    )
    
    static var Type4aSystemFileEditor = TabItem(
        storyboardName: "ST25Type4aSystemFileEditor",
        controllerName: "ST25Type4aSystemFileEditorViewController",
        tabName: "Type4a System File",
        image: "ndef_editor_dark_blue.png",
        selectedImage: "ndef_editor_dark_blue.png",
        order: 0,
        withNC: true
    )
    
    static var Type4aAccessRights = TabItem(
        storyboardName: "ST25Type4AccessRights",
        controllerName: "ST25Type4AccessRightsViewController",
        tabName: "Type4a Access Rights",
        image: "ST10230_protection_information_3_dark_blue",
        selectedImage: "ST10230_protection_information_3_dark_blue",
        order: 0,
        withNC: true
    )

    static var ST25Type4aGpoManagement = TabItem(
        storyboardName: "ST25Type4aGpoManagement",
        controllerName: "ST25Type4aGpoManagement",
        tabName: "ST25 Type4a Gpo Management",
        image: "RS8684_settings_dark_blue",
        selectedImage: "RS8684_settings_dark_blue",
        order: 0,
        withNC: true
    )
    static var ST25Type4APassword = TabItem(
        storyboardName: "ST25Type4Password",
        controllerName: "ST25Type4APasswordViewController",
        tabName: "Type4a Password",
        image: "ST10230_protection_information_3_dark_blue",
        selectedImage: "ST10230_protection_information_3_dark_blue",
        order: 0,
        withNC: true
    )

    static var ST25TagMemoryReadWriteDump = TabItem(
        storyboardName: "ST25GenericTagMemoryDumpStoryboard",
        controllerName: "TagMemoryGenViewController",
        tabName: "Tag Memory",
        image: "eeprom_dark_blue.png",
        selectedImage: "eeprom_dark_blue.png",
        order: 0,
        withNC: true
    )
    private func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {

         let scale = newWidth / image.size.width
         let newHeight = image.size.height * scale
         UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
         image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))

         let newImage = UIGraphicsGetImageFromCurrentImageContext()
         UIGraphicsEndImageContext()

         return newImage
     }
    
    
    mutating func toViewController() -> UIViewController {
        //let nc : UINavigationController?
        if self.mainVC != nil && (controllerName == "ST25Home" || controllerName == "NDEFRecordTableViewController") {
            // ST25Home handle NDEF history messages  - Need to avoid new creation
            return (self.mainVC?.navigationController)!
        } else {
            let tabBarItem = UITabBarItem(
                title: tabName,
                image: resizeImage(image: UIImage(named: image)!, newWidth: 30),
                selectedImage: resizeImage(image: UIImage(named: selectedImage)!, newWidth: 30)
            )
            tabBarItem.tag = order
            
            let viewController = UIStoryboard(name: self.storyboardName, bundle: nil).instantiateViewController(withIdentifier: controllerName)
            viewController.tabBarItem = tabBarItem

            mainVC = viewController as? ST25UIViewController
            
            if withNC {
                let nc = ST25NavigationController.init(rootViewController: viewController)
                nc.title = tabName
                return nc
            }
            return viewController as! ST25UIViewController
        }
    }
    
    class ST25NavigationController: UINavigationController {
        override func viewDidAppear(_ animated: Bool) {
            self.navigationBar.backgroundColor = UIColor.stDarkBlueColor()
            self.navigationBar.tintColor = .white
            
            UINavigationBar.appearance().scrollEdgeAppearance?.backgroundColor = UIColor.stDarkBlueColor()
            UINavigationBar.appearance().backgroundColor = UIColor.stDarkBlueColor()
       }
        
        override func viewDidLoad() {
            super.viewDidLoad()
        }
    }
}
#endif



#if !APPCLIP
class TagTabBarController {
    let mIndexScanVC = 2
    //raw value
    enum MenuType: String, CustomStringConvertible, CaseIterable, Codable {
        case DEFAULT
        case ST25DV
        case ST25TV
        case ST25TVC
        case ST25TV512C
        case ST25DVPWM
        case ST25TV64
        case ST25TN
        case ST25TA
        case M24SR
        case STUNTRACEABLE
        
        var description: String {
            return self.rawValue
        }
    }

    public func performTagMenuDiscovery(productId : ComStSt25sdkTagHelper_ProductID) -> MenuType {
        var menu = MenuType.DEFAULT
        switch (productId) {
        case .PRODUCT_ST_ST25DV64K_I:
            menu = MenuType.ST25DV
        case .PRODUCT_ST_ST25DV64K_J:
            menu = MenuType.ST25DV
        case .PRODUCT_ST_ST25DV16K_I:
            menu = MenuType.ST25DV
        case .PRODUCT_ST_ST25DV16K_J:
            menu = MenuType.ST25DV
        case .PRODUCT_ST_ST25DV04K_I:
            menu = MenuType.ST25DV
        case .PRODUCT_ST_ST25DV04K_J:
            menu = MenuType.ST25DV
        case .PRODUCT_ST_ST25DV64KC_I, .PRODUCT_ST_ST25DV64KC_J:
            menu = MenuType.ST25DV
        case .PRODUCT_ST_ST25DV16KC_I, .PRODUCT_ST_ST25DV16KC_J:
            menu = MenuType.ST25DV
        case .PRODUCT_ST_ST25DV04KC_I, .PRODUCT_ST_ST25DV04KC_J:
            menu = MenuType.ST25DV

        case .PRODUCT_ST_LRi512:
            break;
        case .PRODUCT_ST_LRi1K:
            break;
        case .PRODUCT_ST_LRi2K:
            break;
        case .PRODUCT_ST_LRiS2K:
            break;
        case .PRODUCT_ST_LRiS64K:
            break;
        case .PRODUCT_ST_ST25TV512:
            menu = MenuType.ST25TV
            break;
        case .PRODUCT_ST_ST25TV02K:
            menu = MenuType.ST25TV
            break;
        case .PRODUCT_ST_ST25TV02KC:
            menu = MenuType.ST25TVC
            break;
        case .PRODUCT_ST_ST25TV512C:
            menu = MenuType.ST25TV512C
            break;
        case .PRODUCT_ST_ST25TV16K:
            menu = MenuType.ST25TV64
            break;
        case .PRODUCT_ST_ST25TV64K:
            menu = MenuType.ST25TV64
            break;
        case .PRODUCT_ST_ST25TV04K_P:
            menu = MenuType.ST25TV64
            break;
        case .PRODUCT_ST_ST25DV02K_W1:
            menu = MenuType.ST25DVPWM
            break;
        case .PRODUCT_ST_ST25DV02K_W2:
            menu = MenuType.ST25DVPWM
            break;
            
        case .PRODUCT_ST_M24LR04E_R,
             .PRODUCT_ST_M24LR16E_R,
             .PRODUCT_ST_M24LR64E_R,
             .PRODUCT_ST_M24LR64_R:
            break;

        // Type4
        case    .PRODUCT_ST_ST25TA02K,
                .PRODUCT_ST_ST25TA02KB,
                .PRODUCT_ST_ST25TA02K_P,
                .PRODUCT_ST_ST25TA02KB_P,
                .PRODUCT_ST_ST25TA02K_D,
                .PRODUCT_ST_ST25TA02KB_D,
                .PRODUCT_ST_ST25TA16K,
                .PRODUCT_ST_ST25TA512_K,
                .PRODUCT_ST_ST25TA512,
                .PRODUCT_ST_ST25TA512B,
                .PRODUCT_ST_ST25TA64K,
                .PRODUCT_GENERIC_TYPE4,
                .PRODUCT_GENERIC_TYPE4A:
            menu = MenuType.ST25TA
            break;

        case .PRODUCT_ST_M24SR02_Y,
             .PRODUCT_ST_M24SR04_Y,
             .PRODUCT_ST_M24SR04_G,
             .PRODUCT_ST_M24SR16_Y,
             .PRODUCT_ST_M24SR64_Y:
            menu = MenuType.M24SR
            break;

        case .PRODUCT_GENERIC_TYPE4B:
            break;
        case .PRODUCT_GENERIC_ISO14443B:
            break;
            
        case .PRODUCT_GENERIC_TYPE5_AND_ISO15693:
            break;
        case .PRODUCT_GENERIC_TYPE5:
            break;
        case .PRODUCT_GENERIC_TYPE2:
            break;
            
        case .PRODUCT_ST_ST25TN01K:
            menu = MenuType.ST25TN
            break;
/*
        case .PRODUCT_ST_STM_UNTRACEABLE:
            menu = MenuType.STUNTRACEABLE
            break;
 */
        default: break
            
        }
        return menu
    }
    
    public func performTagTabBarMenu(menu : MenuType, tabBarController: UITabBarController) -> UITabBarController  {
        var tbc = tabBarController
        switch (menu) {
        case .DEFAULT:
            tbc.selectedIndex = mIndexScanVC
            tbc = setDefautTabBarController(tabBarController: tabBarController)
            disableCustumizableProperty (tabBarController: tabBarController)

        case .ST25DV:
            tbc.selectedIndex = mIndexScanVC
            tbc = setDefautTabBarControllerForST25DV(tabBarController: tabBarController as! ST25TabBarController)
            disableCustumizableProperty (tabBarController: tabBarController)

            break
        case .ST25TV:
            tbc.selectedIndex = mIndexScanVC
            tbc = setDefautTabBarControllerForST25TV(tabBarController: tabBarController)
            disableCustumizableProperty (tabBarController: tabBarController)

        case .ST25TVC:
            tbc.selectedIndex = mIndexScanVC
            tbc = setDefautTabBarControllerForST25TVC(tabBarController: tabBarController)
            disableCustumizableProperty (tabBarController: tabBarController)
            break
        case .ST25TV512C:
            tbc.selectedIndex = mIndexScanVC
            tbc = setDefautTabBarControllerForST25TV512C(tabBarController: tabBarController)
            disableCustumizableProperty (tabBarController: tabBarController)
            break
        case .ST25DVPWM:
            tbc.selectedIndex = mIndexScanVC
            tbc = setDefautTabBarControllerForST25DVPWM(tabBarController: tabBarController)
            disableCustumizableProperty (tabBarController: tabBarController)

            break
        case .ST25TV64: // TV64 is a DV without I2C - same for TV16k
            tbc.selectedIndex = mIndexScanVC
            tbc = setDefautTabBarControllerForST25TV16_64(tabBarController: tabBarController as! ST25TabBarController)
            disableCustumizableProperty (tabBarController: tabBarController)
            break
            
        case .STUNTRACEABLE:
            tbc.selectedIndex = mIndexScanVC
            tbc = setUntraceableTabBarController(tabBarController: tabBarController)
            disableCustumizableProperty (tabBarController: tabBarController)
            break
            
        case .ST25TN:
            tbc.selectedIndex = mIndexScanVC
            tbc = setDefautTabBarControllerForST25TN(tabBarController: tabBarController)
            disableCustumizableProperty (tabBarController: tabBarController)
            break
            
        case .ST25TA:
            tbc.selectedIndex = mIndexScanVC
            tbc = setDefautTabBarControllerForST25TA(tabBarController: tabBarController)
            disableCustumizableProperty (tabBarController: tabBarController)
            break
            
        case .M24SR:
            tbc.selectedIndex = mIndexScanVC
            tbc = setDefautTabBarControllerForM24SR(tabBarController: tabBarController)
            disableCustumizableProperty (tabBarController: tabBarController)
            break

       }
        return tbc
    }
    
    private func disableCustumizableProperty (tabBarController: UITabBarController) {
        tabBarController.customizableViewControllers = []
    }
    
    private func removeMoreTabBarControllerContent(tabBarController: UITabBarController) {
        let more: UINavigationController! = tabBarController.moreNavigationController
        more.popViewController(animated: false)
    }
    
    private func genericMenusTabBarController(array: inout [UIViewController]){
        array.append(TabItem.TagInfo.toViewController())
        array.append(TabItem.ST25TagMemoryReadWriteDump.toViewController())
        array.append(TabItem.TagST25Home.toViewController())
        array.append(TabItem.TagNDEFRecord.toViewController())
    }
    
    
    private func miscellaneousMenusTabBarController(array: inout [UIViewController]){
        array.append(TabItem.TagCoreNFC.toViewController())
       array.append(TabItem.ST25EnergyHarvesting.toViewController())
       array.append(TabItem.ST25AppLauncher.toViewController()) 
       array.append(TabItem.TagSettings.toViewController())
       array.append(TabItem.TagAbout.toViewController())
    }
    
    private func miscellaneousMenusType4TabBarController(array: inout [UIViewController]){
       array.append(TabItem.ST25EnergyHarvesting.toViewController())
       array.append(TabItem.ST25AppLauncher.toViewController())
       array.append(TabItem.TagSettings.toViewController())
       array.append(TabItem.TagAbout.toViewController())
    }

    
    func setDefautTabBarController(tabBarController: UITabBarController) -> UITabBarController {
        var array: [UIViewController] = []
        removeMoreTabBarControllerContent(tabBarController: tabBarController)
        tabBarController.selectedIndex = 0

        array = tabBarController.viewControllers!
        array.removeAll()
        
        // Generic Menus
        genericMenusTabBarController(array: &array)
      
        // Menus specific to tag
        // none

        // Miscellaneous
        miscellaneousMenusTabBarController(array: &array)
        
        tabBarController.setViewControllers(array, animated: false)
        tabBarController.selectedIndex = 2
        return tabBarController

    }
    
    func setUntraceableTabBarController(tabBarController: UITabBarController) -> UITabBarController {
        var array: [UIViewController] = []
        removeMoreTabBarControllerContent(tabBarController: tabBarController)
        tabBarController.selectedIndex = 0

        array = tabBarController.viewControllers!
        array.removeAll()
        
        // Generic Menus
        genericMenusTabBarController(array: &array)
      
        // Menus specific to tag
        // Not supported yet in iOS13. Will be uncommented once fixed
        array.append(TabItem.TagST25TVUntraceableModeViewController.toViewController())


        // Miscellaneous
        miscellaneousMenusTabBarController(array: &array)
        
        tabBarController.setViewControllers(array, animated: false)
        tabBarController.selectedIndex = 2
        return tabBarController

    }
    
    func setDefautTabBarControllerForST25DV(tabBarController: ST25TabBarController) -> UITabBarController {
        var array: [UIViewController] = []
        removeMoreTabBarControllerContent(tabBarController: tabBarController)
        tabBarController.selectedIndex = 0

        array = tabBarController.viewControllers!
        array.removeAll()
        
        // Generic Menus
        genericMenusTabBarController(array: &array)

        // Menus specific to tag
        array.append(TabItem.Type5CCFileEditor.toViewController())
        array.append(TabItem.TagST25DVI2CDemos.toViewController())
        array.append(TabItem.TagST25DVConfigurationPasswordManagement.toViewController())
        array.append(TabItem.TagST25DVAreaConfiguration.toViewController())
        array.append(TabItem.TagST25AreaViewController.toViewController())
        array.append(TabItem.TagST25TVAreaSecurityStatus.toViewController())
        array.append(TabItem.TagST25RegistersViewController.toViewController())
        array.append(TabItem.TagST25DVDynRegistersViewController.toViewController())
        
        array.append(TabItem.TagST25LockBlockFeaturesViewController.toViewController())
        array.append(TabItem.TagMemory.toViewController())

        // Miscellaneous
        miscellaneousMenusTabBarController(array: &array)
        
        tabBarController.setViewControllers(array, animated: false)
        tabBarController.selectedIndex = 0
        return tabBarController

    }
    
    // DV without I2C
    func setDefautTabBarControllerForST25TV16_64(tabBarController: ST25TabBarController) -> UITabBarController {
        var array: [UIViewController] = []
        removeMoreTabBarControllerContent(tabBarController: tabBarController)
        tabBarController.selectedIndex = 0

        array = tabBarController.viewControllers!
        array.removeAll()
        
        // Generic Menus
        genericMenusTabBarController(array: &array)

        // Menus specific to tag
        array.append(TabItem.Type5CCFileEditor.toViewController())
        array.append(TabItem.TagST25DVConfigurationPasswordManagement.toViewController())
        array.append(TabItem.TagST25DVAreaConfiguration.toViewController())
        array.append(TabItem.TagST25AreaViewController.toViewController())
        array.append(TabItem.TagST25TVAreaSecurityStatus.toViewController())
        array.append(TabItem.TagST25RegistersViewController.toViewController())
        
        array.append(TabItem.TagST25LockBlockFeaturesViewController.toViewController())

        array.append(TabItem.TagMemory.toViewController())
        // Miscellaneous
        miscellaneousMenusTabBarController(array: &array)

        tabBarController.setViewControllers(array, animated: false)
        tabBarController.selectedIndex = 0
        return tabBarController

    }
    
    func setDefautTabBarControllerForST25TV(tabBarController: UITabBarController) -> UITabBarController {
        var array: [UIViewController] = []
        
        removeMoreTabBarControllerContent(tabBarController: tabBarController)
        tabBarController.selectedIndex = 0

        array = tabBarController.viewControllers!
        array.removeAll()
        
        // Generic Menus
        genericMenusTabBarController(array: &array)

        // Menus specific to tag
        array.append(TabItem.Type5CCFileEditor.toViewController())
        

        array.append(TabItem.ST25TVCounter.toViewController())
        array.append(TabItem.ST25TVTamper.toViewController())
        array.append(TabItem.TagST25LockBlockFeaturesViewController.toViewController())

        // Not supported yet in iOS13. Will be uncommented once fixed
        //array.append(TabItem.TagST25TVUntraceableModeViewController.toViewController())
        
        array.append(TabItem.ST25TVSignature.toViewController())
        
        array.append(TabItem.TagST25TVAreaManagementViewController.toViewController())
        array.append(TabItem.TagST25AreaViewController.toViewController())

        array.append(TabItem.TagST25TVAreaSecurityStatus.toViewController())
        array.append(TabItem.TagST25TVConfigurationPasswordManagement.toViewController())
        
        array.append(TabItem.TagST25RegistersViewController.toViewController())

        array.append(TabItem.TagST25TVKillFeaturesViewController.toViewController())
        array.append(TabItem.TagST25TVEasViewController.toViewController())
        
        array.append(TabItem.TagMemory.toViewController())
        // Miscellaneous
        miscellaneousMenusTabBarController(array: &array)
        
        tabBarController.setViewControllers(array, animated: false)
        tabBarController.selectedIndex = 0
        return tabBarController

    }
    
    func setDefautTabBarControllerForST25TVC(tabBarController: UITabBarController) -> UITabBarController {
        var array: [UIViewController] = []
        
        removeMoreTabBarControllerContent(tabBarController: tabBarController)
        tabBarController.selectedIndex = 0

        array = tabBarController.viewControllers!
        array.removeAll()
        
        // Generic Menus
        genericMenusTabBarController(array: &array)

        // Menus specific to tag
        array.append(TabItem.Type5CCFileEditor.toViewController())

        array.append(TabItem.ST25TVCUniqueTapCode.toViewController())
        array.append(TabItem.ST25TVCTamper.toViewController())
        array.append(TabItem.ST25TVCANDEFUrlRecordViewController.toViewController())
        array.append(TabItem.ST25TVCLockConfiguration.toViewController())
        array.append(TabItem.ST25TVCAfiDsFid.toViewController())
        array.append(TabItem.TagST25TVCAreaConfiguration.toViewController())
        array.append(TabItem.TagST25AreaViewController.toViewController())

        array.append(TabItem.TagST25TVConfigurationPasswordManagement.toViewController())
        array.append(TabItem.TagST25TVAreaSecurityStatus.toViewController())
        array.append(TabItem.TagST25LockBlockFeaturesViewController.toViewController())

        array.append(TabItem.TagST25RegistersViewController.toViewController())
        
        #if SLA
        array.append(TabItem.TagST25TVCPasswordProtection.toViewController())
        #endif
 
        array.append(TabItem.ST25TVSignature.toViewController())

        array.append(TabItem.TagST25TVKillFeaturesViewController.toViewController())

        // Not supported yet in iOS13. Will be uncommented once fixed
        //array.append(TabItem.TagST25TVUntraceableModeViewController.toViewController())
        array.append(TabItem.TagMemory.toViewController())

        // Miscellaneous
        miscellaneousMenusTabBarController(array: &array)
        
        tabBarController.setViewControllers(array, animated: false)
        tabBarController.selectedIndex = 0
        return tabBarController

    }
    func setDefautTabBarControllerForST25TV512C(tabBarController: UITabBarController) -> UITabBarController {
        var array: [UIViewController] = []
        
        removeMoreTabBarControllerContent(tabBarController: tabBarController)
        tabBarController.selectedIndex = 0

        array = tabBarController.viewControllers!
        array.removeAll()
        
        // Generic Menus
        genericMenusTabBarController(array: &array)

        // Menus specific to tag
        array.append(TabItem.Type5CCFileEditor.toViewController())

        array.append(TabItem.ST25TVCUniqueTapCode.toViewController())
        // No tamper for 512C
        //array.append(TabItem.ST25TVCTamper.toViewController())
        array.append(TabItem.ST25TVCANDEFUrlRecordViewController.toViewController())
        array.append(TabItem.ST25TVCLockConfiguration.toViewController())
        array.append(TabItem.ST25TVCAfiDsFid.toViewController())
 
        array.append(TabItem.TagST25TVCAreaConfiguration.toViewController())
        array.append(TabItem.TagST25AreaViewController.toViewController())

        array.append(TabItem.TagST25TVAreaSecurityStatus.toViewController())
        array.append(TabItem.TagST25LockBlockFeaturesViewController.toViewController())

       array.append(TabItem.TagST25RegistersViewController.toViewController())
        
        #if SLA
        array.append(TabItem.TagST25TVCPasswordProtection.toViewController())
        #endif
 
        array.append(TabItem.ST25TVSignature.toViewController())

        array.append(TabItem.TagST25TVKillFeaturesViewController.toViewController())

        // Not supported yet in iOS13. Will be uncommented once fixed
        //array.append(TabItem.TagST25TVUntraceableModeViewController.toViewController())

        array.append(TabItem.TagMemory.toViewController())

        // Miscellaneous
        miscellaneousMenusTabBarController(array: &array)
        
        tabBarController.setViewControllers(array, animated: false)
        tabBarController.selectedIndex = 0
        return tabBarController

    }

    
        func setDefautTabBarControllerForST25DVPWM(tabBarController: UITabBarController) -> UITabBarController {
            var array: [UIViewController] = []
            
            removeMoreTabBarControllerContent(tabBarController: tabBarController)
            tabBarController.selectedIndex = 0

            array = tabBarController.viewControllers!
            array.removeAll()
            
            // Generic Menus
            genericMenusTabBarController(array: &array)

            // Menus specific to tag
            array.append(TabItem.Type5CCFileEditor.toViewController())

            array.append(TabItem.ST25TVSignature.toViewController())

            array.append(TabItem.TagST25TVAreaManagementViewController.toViewController())
            array.append(TabItem.TagST25TVAreaSecurityStatus.toViewController())
            array.append(TabItem.TagST25TVConfigurationPasswordManagement.toViewController())
            
            array.append(TabItem.TagST25AreaViewController.toViewController())
            array.append(TabItem.TagST25RegistersViewController.toViewController())

            
            array.append(TabItem.TagST25PWMControl.toViewController())
            array.append(TabItem.TagST25PWMConfiguration.toViewController())
            array.append(TabItem.TagST25PWMDemos.toViewController())

            array.append(TabItem.TagST25LockBlockFeaturesViewController.toViewController())

            array.append(TabItem.TagMemory.toViewController())

            // Miscellaneous
            miscellaneousMenusTabBarController(array: &array)

            tabBarController.setViewControllers(array, animated: true)
            tabBarController.selectedIndex = 0

            return tabBarController
        }
    
    func setDefautTabBarControllerForST25TN(tabBarController: UITabBarController) -> UITabBarController {
        var array: [UIViewController] = []
        
        removeMoreTabBarControllerContent(tabBarController: tabBarController)
        tabBarController.selectedIndex = 0

        array = tabBarController.viewControllers!
        array.removeAll()
        
        // Generic Menus
        genericMenusTabBarController(array: &array)

        // Menus specific to tag
        array.append(TabItem.ST25TNANDEFUrlRecordViewController.toViewController())
        array.append(TabItem.ST25TVSignature.toViewController())
        array.append(TabItem.ST25TNLockBlockConfiguration.toViewController())
        array.append(TabItem.ST25TNCCFileEditor.toViewController())
        array.append(TabItem.TagST25RegistersViewController.toViewController())
        array.append(TabItem.ST25TNMemoryConfiguration.toViewController())

        // Miscellaneous
        miscellaneousMenusTabBarController(array: &array)
        
        tabBarController.setViewControllers(array, animated: false)
        tabBarController.selectedIndex = 0
        return tabBarController
    }
    
    func setDefautTabBarControllerForST25TA(tabBarController: UITabBarController) -> UITabBarController {
        var array: [UIViewController] = []
        
        removeMoreTabBarControllerContent(tabBarController: tabBarController)
        tabBarController.selectedIndex = 0

        array = tabBarController.viewControllers!
        array.removeAll()
        
        // Generic Menus
        genericMenusTabBarController(array: &array)

        // Menus specific to tag
        array.append(TabItem.Type4CCFileEditor.toViewController())
        array.append(TabItem.Type4aSystemFileEditor.toViewController())
        array.append(TabItem.Type4aAccessRights.toViewController())
        array.append(TabItem.ST25Type4APassword.toViewController())
        array.append(TabItem.ST25Type4aGpoManagement.toViewController())
        array.append(TabItem.ST25TVSignature.toViewController())

        // Miscellaneous
        miscellaneousMenusType4TabBarController(array: &array)
        
        tabBarController.setViewControllers(array, animated: false)
        tabBarController.selectedIndex = 0
        return tabBarController

    }
    func setDefautTabBarControllerForM24SR(tabBarController: UITabBarController) -> UITabBarController {
        var array: [UIViewController] = []
        
        removeMoreTabBarControllerContent(tabBarController: tabBarController)
        tabBarController.selectedIndex = 0

        array = tabBarController.viewControllers!
        array.removeAll()
        
        // Generic Menus
        genericMenusTabBarController(array: &array)

        // Menus specific to tag
        array.append(TabItem.Type4CCFileEditor.toViewController())
        array.append(TabItem.Type4aSystemFileEditor.toViewController())
        array.append(TabItem.Type4aAccessRights.toViewController())
        array.append(TabItem.ST25Type4APassword.toViewController())
        array.append(TabItem.ST25Type4aGpoManagement.toViewController())

        // Miscellaneous
        miscellaneousMenusType4TabBarController(array: &array)
        
        tabBarController.setViewControllers(array, animated: false)
        tabBarController.selectedIndex = 0
        return tabBarController

    }


}
#endif
