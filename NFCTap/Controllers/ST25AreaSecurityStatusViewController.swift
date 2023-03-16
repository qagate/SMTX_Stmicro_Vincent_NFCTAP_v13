//
//  ST25AreaSecurityStatusViewController.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 09/12/2019.
//  Copyright © 2019 STMicroelectronics. All rights reserved.
//

import UIKit
import CoreNFC

class ST25AreaSecurityStatusViewController: ST25UIViewController {
    
    internal var mTag : ComStSt25sdkNFCTag!
    internal var miOSReaderSession:iOSReaderSession!
    internal var mST25TVConfigurationPwd:Data!
    
    var mNumberOfAreas: Int8 = 1
    var mAreaRWProtection = [ComStSt25sdkTagHelper_ReadWriteProtection]()
    var mAreaPasswordProtection = [Int]()

    
    let NAString = "N/A"
    
    
    enum taskToDo {
        case initPermissionStatus
    }
    internal var mTaskToDo:taskToDo = .initPermissionStatus
    

    @IBOutlet weak var mCurrentMemoryConfLabel: UILabel!
    @IBOutlet weak var mArea1CurrentReadPermissionLabel: UILabel!
    @IBOutlet weak var mArea1CurrentWritePermissionLabel: UILabel!
    @IBOutlet weak var mArea2CurrentReadPermissionLabel: UILabel!
    @IBOutlet weak var mArea2CurrentWritePermissionLabel: UILabel!
    @IBOutlet weak var mGridPermissionStatus: UIView!
    
    
    @IBOutlet weak var mArea3CurrentReadPermissionLabel: UILabel!
    @IBOutlet weak var mArea3CurrentWritePermissionLabel: UILabel!

    
    @IBOutlet weak var mArea4CurrentReadPermissionLabel: UILabel!
    @IBOutlet weak var mArea4CurrentWritePermissionLabel: UILabel!
    
    
    @IBOutlet weak var mArea2HeaderLabel: UILabel!
    @IBOutlet weak var mArea3HeaderLabel: UILabel!
    @IBOutlet weak var mArea4HeaderLabel: UILabel!
    
    
    @IBAction func dynamicButtonAction(_ sender: Any) {
        if mTag is ST25TVTag || mTag is ST25TVCTag {
            // Refresh
            mTaskToDo = .initPermissionStatus
            miOSReaderSession.startTagReaderSession()
        } else if mTag is ST25DVTag || self.mTag is ST25DVCTag || self.mTag is ST25TV16KTag || self.mTag is ST25TV64KTag {
            // Start Area password change controller
            let modalVC = self.storyboard?.instantiateViewController(identifier: "ST25DVAreaPasswordViewController") as! ST25DVAreaPasswordViewController
            modalVC.mAreaPasswordProtection = self.mAreaPasswordProtection
            modalVC.mNumberOfAreas = self.mNumberOfAreas
            modalVC.mTag = self.mTag
            modalVC.delegate = self
            self.present(modalVC, animated: true, completion: nil)
        } else if self.mTag is ST25DVPwmTag {
            // Refresh
            mTaskToDo = .initPermissionStatus
            miOSReaderSession.startTagReaderSession()
        } else {
            UIHelper.UI() {
                self.warningAlert(message: "Feature not supported ...")
            }

        }

    }
    
    @IBOutlet weak var mDynamicButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Area security status"
         self.miOSReaderSession = iOSReaderSession(atagReaderSessionViewControllerDelegate: self)
         mTaskToDo = .initPermissionStatus
         miOSReaderSession.startTagReaderSession()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.mAreaRWProtection.count > 0 {
            updateCurrentMemoryConfiguration(numberOfAreas: self.mNumberOfAreas)
        }
        if self.mTag is ST25DVTag {
            updateDynamicButtonTitle()
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seguePresentRWPermission" {
            //print(segue)
            guard let detailsVC = segue.destination as? ST25PermissionsViewController else { return }
            //guard let cell = sender as? UITableViewCell,
            //let indexPath = tableView.indexPath(for: cell) else { return }
            //let information = library.restaurants[indexPath.row]
            detailsVC.mNumberOfAreas = mNumberOfAreas
            detailsVC.mAreaRWProtection = self.mAreaRWProtection
            detailsVC.mTag = self.mTag
            detailsVC.delegate = self

        }
        if segue.identifier == "segueAreaChangePwd" {
            //print(segue)
            guard let detailsVC = segue.destination as? ST25TVPasswordViewController else { return }
            //guard let cell = sender as? UITableViewCell,
            //let indexPath = tableView.indexPath(for: cell) else { return }
            //let information = library.restaurants[indexPath.row]
            detailsVC.mNumberOfAreas = mNumberOfAreas
            detailsVC.mTag = self.mTag

        }
    }


    
    private func initPermissionsStatus() {
        if mTag is ST25TVTag {
            mNumberOfAreas = Int8((mTag as! ST25TVTag).getNumberOfAreas())
            mAreaRWProtection.removeAll()

            //print(mNumberOfAreas)
            for index in 0 ..< mNumberOfAreas {
                mAreaRWProtection.append((mTag as! ST25TVTag).getReadWriteProtection(with: jint(index+1)))
            }
            
            updateCurrentMemoryConfiguration(numberOfAreas: mNumberOfAreas)

        } else if mTag is ST25TVCTag {
            mNumberOfAreas = Int8((mTag as! ST25TVCTag).getNumberOfAreas())
            mAreaRWProtection.removeAll()

            //print(mNumberOfAreas)
            for index in 0 ..< mNumberOfAreas {
                mAreaRWProtection.append((mTag as! ST25TVCTag).getReadWriteProtection(with: jint(index+1)))
            }
            
            updateCurrentMemoryConfiguration(numberOfAreas: mNumberOfAreas)

        } else if mTag is ST25DVTag {
            mNumberOfAreas = Int8((mTag as! ST25DVTag).getNumberOfAreas())
            mAreaRWProtection.removeAll()
            mAreaPasswordProtection.removeAll()
            //print(mNumberOfAreas)
            for index in 0 ..< mNumberOfAreas {
                mAreaRWProtection.append((mTag as! ST25DVTag).getReadWriteProtection(with: jint(index+1)))
                mAreaPasswordProtection.append(Int((mTag as! ST25DVTag).getPasswordNumber(with: jint(index+1))))
            }
            
            updateCurrentMemoryConfiguration(numberOfAreas: mNumberOfAreas)
            updateDynamicButtonTitle()

        } else if mTag is ST25DVCTag {
            mNumberOfAreas = Int8((mTag as! ST25DVCTag).getNumberOfAreas())
            mAreaRWProtection.removeAll()
            mAreaPasswordProtection.removeAll()
            //print(mNumberOfAreas)
            for index in 0 ..< mNumberOfAreas {
                mAreaRWProtection.append((mTag as! ST25DVCTag).getReadWriteProtection(with: jint(index+1)))
                mAreaPasswordProtection.append(Int((mTag as! ST25DVCTag).getPasswordNumber(with: jint(index+1))))
            }
            
            updateCurrentMemoryConfiguration(numberOfAreas: mNumberOfAreas)
            updateDynamicButtonTitle()

        } else if self.mTag is ST25DVPwmTag {
            mNumberOfAreas = Int8((mTag as! ST25DVPwmTag).getNumberOfAreas())
            mAreaRWProtection.removeAll()

            //print(mNumberOfAreas)
            for index in 0 ..< mNumberOfAreas {
                mAreaRWProtection.append((mTag as! ST25DVPwmTag).getReadWriteProtection(with: jint(index+1)))
            }
            
            updateCurrentMemoryConfiguration(numberOfAreas: mNumberOfAreas)

        } else if mTag is ST25TV16KTag {
            mNumberOfAreas = Int8((mTag as! ST25TV16KTag).getNumberOfAreas())
            mAreaRWProtection.removeAll()
            mAreaPasswordProtection.removeAll()
            //print(mNumberOfAreas)
            for index in 0 ..< mNumberOfAreas {
                mAreaRWProtection.append((mTag as! ST25TV16KTag).getReadWriteProtection(with: jint(index+1)))
                mAreaPasswordProtection.append(Int((mTag as! ST25TV16KTag).getPasswordNumber(with: jint(index+1))))
            }
            
            updateCurrentMemoryConfiguration(numberOfAreas: mNumberOfAreas)
            updateDynamicButtonTitle()

        } else if mTag is ST25TV64KTag {
            mNumberOfAreas = Int8((mTag as! ST25TV64KTag).getNumberOfAreas())
            mAreaRWProtection.removeAll()
            mAreaPasswordProtection.removeAll()
            //print(mNumberOfAreas)
            for index in 0 ..< mNumberOfAreas {
                mAreaRWProtection.append((mTag as! ST25TV64KTag).getReadWriteProtection(with: jint(index+1)))
                mAreaPasswordProtection.append(Int((mTag as! ST25TV64KTag).getPasswordNumber(with: jint(index+1))))
            }
            
            updateCurrentMemoryConfiguration(numberOfAreas: mNumberOfAreas)
            updateDynamicButtonTitle()

        } else {
            UIHelper.UI() {
                self.warningAlert(message: "Feature not supported ...")
            }

        }
    }
    
    private func updateDynamicButtonTitle() {
        if Thread.isMainThread {
            self.mDynamicButton.setTitle("Change area password",for: .normal)
        } else {
            UIHelper.UI() {
                self.mDynamicButton.setTitle("Change area password",for: .normal)
            }
        }
    }
    
    private func updateCurrentMemoryConfiguration(numberOfAreas : Int8) {
        if Thread.isMainThread {
            mCurrentMemoryConfLabel.text = String(numberOfAreas) + " Area(s)"
            refreshGridArrayDisplay(numberOfArea: numberOfAreas, areaRWProtection: self.mAreaRWProtection)
            
        } else {
            UIHelper.UI() {
                self.mCurrentMemoryConfLabel.text = String(numberOfAreas) + " Area(s)"
                self.refreshGridArrayDisplay(numberOfArea: numberOfAreas, areaRWProtection: self.mAreaRWProtection)
                
            }
        }
    }
    
    private func refreshGridArrayDisplay(numberOfArea : Int8, areaRWProtection : [ComStSt25sdkTagHelper_ReadWriteProtection]) {
        for index in 0..<numberOfArea {
            if index == 0 {

                refreshAreaGridDescriptionString(uiReadLabel: mArea1CurrentReadPermissionLabel, uiWriteLabel: mArea1CurrentWritePermissionLabel, permission: self.mAreaRWProtection[0])
            }
            if index == 1 {
                mArea2HeaderLabel.isHidden = false
                mArea2CurrentReadPermissionLabel.isHidden = false
                mArea2CurrentWritePermissionLabel.isHidden = false
                refreshAreaGridDescriptionString(uiReadLabel: mArea2CurrentReadPermissionLabel, uiWriteLabel: mArea2CurrentWritePermissionLabel, permission: self.mAreaRWProtection[1])
            }
            if index == 2 {
                mArea3HeaderLabel.isHidden = false
                mArea3CurrentReadPermissionLabel.isHidden = false
                mArea3CurrentWritePermissionLabel.isHidden = false
                refreshAreaGridDescriptionString(uiReadLabel: mArea3CurrentReadPermissionLabel, uiWriteLabel: mArea3CurrentWritePermissionLabel, permission: self.mAreaRWProtection[2])
            }
            if index == 3 {
                mArea4HeaderLabel.isHidden = false
                mArea4CurrentReadPermissionLabel.isHidden = false
                mArea4CurrentWritePermissionLabel.isHidden = false
                refreshAreaGridDescriptionString(uiReadLabel: mArea4CurrentReadPermissionLabel, uiWriteLabel: mArea4CurrentWritePermissionLabel, permission: self.mAreaRWProtection[3])
            }
        }

        for index in numberOfArea..<4 {
            setAreaGridDescriptionStringNotApplicable(index: Int(index))
        }

    }
    
    private func setAreaGridDescriptionStringNotApplicable(index: Int) {
        if index == 1 {
            mArea2HeaderLabel.isHidden = true
            mArea2CurrentReadPermissionLabel.isHidden = true
            mArea2CurrentWritePermissionLabel.isHidden = true
            mArea2CurrentReadPermissionLabel.text = NAString
            mArea2CurrentWritePermissionLabel.text = NAString
        }
        if index == 2 {
            mArea3HeaderLabel.isHidden = true
            mArea3CurrentReadPermissionLabel.isHidden = true
            mArea3CurrentWritePermissionLabel.isHidden = true
            mArea3CurrentReadPermissionLabel.text = NAString
            mArea3CurrentWritePermissionLabel.text = NAString
        }
        if index == 3 {
            mArea4HeaderLabel.isHidden = true
            mArea4CurrentReadPermissionLabel.isHidden = true
            mArea4CurrentWritePermissionLabel.isHidden = true
            mArea4CurrentReadPermissionLabel.text = NAString
            mArea4CurrentWritePermissionLabel.text = NAString
        }
    }
    
    private func refreshAreaGridDescriptionString(uiReadLabel: UILabel, uiWriteLabel: UILabel, permission: ComStSt25sdkTagHelper_ReadWriteProtection)  {
        if permission != nil {
            switch permission {
            case .READABLE_AND_WRITABLE:
                uiReadLabel.text = "Not protected"
                uiWriteLabel.text = "Not protected"
                
            case .READABLE_AND_WRITE_PROTECTED_BY_PWD:
                uiReadLabel.text = "Not protected"
                uiWriteLabel.text = "Pwd protected"
                
            case .READ_AND_WRITE_PROTECTED_BY_PWD:
                uiReadLabel.text = "Pwd protected"
                uiWriteLabel.text = "Pwd protected"
                
            case .READ_PROTECTED_BY_PWD_AND_WRITE_IMPOSSIBLE:
                uiReadLabel.text = "Pwd protected"
                uiWriteLabel.text = "Permanently protected"
                
            default:
                print("Permission not handled")
            }
        }
    }
    
    
    private func invalidateGridStatus() {
        if mTaskToDo == .initPermissionStatus {
             UIHelper.UI() {
                 //self.mGridPermissionStatus.alpha = 0.66
                 //self.mGridPermissionStatus.visibility = .invisible
                self.mGridPermissionStatus.isHidden = true
                self.mGridPermissionStatus.setNeedsLayout()
                self.mGridPermissionStatus.setNeedsUpdateConstraints()
             }
         }
    }
    private func validateGridStatus() {
        if mTaskToDo == .initPermissionStatus {
             UIHelper.UI() {
                 //self.mGridPermissionStatus.alpha = 0.66
                 //self.mGridPermissionStatus.visibility = .visible
                self.mGridPermissionStatus.isHidden = false
                self.mGridPermissionStatus.setNeedsLayout()
                self.mGridPermissionStatus.setNeedsUpdateConstraints()
             }
         }
    }

    
    private func warningAlert(message : String) {
        UIHelper.warningAlert(viewController: self, title : "Permissions status" , message: message)
    }
    
}

extension ST25AreaSecurityStatusViewController: AreaSecurityPermissionEditionReady {
    func onSecurityPermissionAreaReady(permissions: [ComStSt25sdkTagHelper_ReadWriteProtection]) {
        self.mAreaRWProtection = permissions
        DispatchQueue.main.async { self.refreshGridArrayDisplay(numberOfArea: self.mNumberOfAreas, areaRWProtection: self.mAreaRWProtection) }

    }
}

extension ST25AreaSecurityStatusViewController: AreaSecurityPasswordEditionReady {
    func onSecurityPasswordAreaReady(passwords: [Int]) {
        self.mAreaPasswordProtection = passwords
    }
}

extension ST25AreaSecurityStatusViewController: tagReaderSessionViewControllerDelegate {

    func handleTag(st25SDKTag: ComStSt25sdkNFCTag, uid: Data!) throws {
        mTag = st25SDKTag
        if self.isSameTag(uid: uid) {
            switch mTaskToDo {
            case .initPermissionStatus:
                initPermissionsStatus()
            }
        }else {
            //print((TabItem.TagInfo.mainVC as! ST25TagInformationViewController).productId?.description)
            //print(uid.toHexString())
            UIHelper.UI() {
                self.warningAlert(message: "Tag has changed, please scan again the Tag ...")
            }
        }
    }
    
    func handleTagSessionError(didInvalidateWithError error: Error) {
        //print(" ==== entry > handleTagSessionEnd in controller : \(self.mTaskToDo)")
        let errorNFC = error as! NFCReaderError
        if errorNFC.code ==  NFCReaderError.readerSessionInvalidationErrorSessionTimeout {
            // session Timeout detected
            // restart a session to continu
            //invalidateGridStatus()
        }
        else if errorNFC.code ==  NFCReaderError.readerSessionInvalidationErrorUserCanceled {
            //invalidateGridStatus()
        }
    }
    
    func handleTagST25SdkError(didInvalidateWithError error: NSException) {
        invalidateGridStatus()
    }
    

}

