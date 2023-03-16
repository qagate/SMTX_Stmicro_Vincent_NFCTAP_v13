//
//  ST25AreaViewController.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 06/01/2020.
//  Copyright © 2020 STMicroelectronics. All rights reserved.
//

import UIKit
import CoreNFC

class ST25AreaViewController: ST25UIViewController {
    

    internal var miOSReaderSession:iOSReaderSession!
    internal var mTag : ComStSt25sdkNFCTag!

    var mNumberOfAreas: Int8 = 1
    let mAreaLibrary = AreaLibrary.shared

    var mCurrentArea: Int8 = 1
    var mCurrentAreaSize: Int = 0
    var mCCFileLength = 4

    enum taskToDo {
        case getAreaMemoryConf
        case getAreaNdefConf
    }
    
    internal var mTaskToDo:taskToDo = .getAreaMemoryConf
    
    @IBOutlet weak var mAreaTableView: UITableView!
   
    @IBAction func refreshContentStatus(_ sender: Any) {
        mTaskToDo = .getAreaMemoryConf
        mAreaLibrary.clear()
        mCurrentArea = Int8(ComStSt25sdkMultiAreaInterface_AREA1)
        miOSReaderSession.startTagReaderSession()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Areas content editor"
        mAreaLibrary.clear()
        self.miOSReaderSession = iOSReaderSession(atagReaderSessionViewControllerDelegate: self)
        mAreaTableView.dataSource = self
        mAreaTableView.delegate = self
        
        mTaskToDo = .getAreaMemoryConf
        mCurrentArea = Int8(ComStSt25sdkMultiAreaInterface_AREA1)
        miOSReaderSession.startTagReaderSession()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.mAreaTableView.reloadData()
    }
    //MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            //print(segue)
            guard let detailsVC = segue.destination as? ST25NdefRecordsListViewController else { return }
            
            guard let cell = sender as? UITableViewCell,
                let indexPath = mAreaTableView.indexPath(for: cell) else { return }
            
            self.mCurrentArea = Int8(indexPath.row)
            detailsVC.mCoreNFCSessionType = .tagSession
            detailsVC.mAera = indexPath.row
            detailsVC.mNumberOfAreas = self.mNumberOfAreas
            detailsVC.mSize = mAreaLibrary.areas[indexPath.row].mSize
            detailsVC.mCCFileLength = mCCFileLength
            if mAreaLibrary.areas[indexPath.row].style == .PWD_NEEDED {
                detailsVC.mAreaReadProtected = true
            }
            detailsVC.delegate = self
            
            if mAreaLibrary.areas[indexPath.row].mNdefMsg != nil {
                let editionNdefMessage = mAreaLibrary.areas[indexPath.row].mNdefMsg.copy__()
                detailsVC.mNdefMsg = editionNdefMessage
            } else {
                detailsVC.mNdefMsg = mAreaLibrary.areas[indexPath.row].mNdefMsg
            }
        }
    }
    
    private func getAreasStatus() {
        //print("getAreasStatus")
        if mTag is ST25TVTag {
            areaStatus(mTag: mTag as! ST25TVTag)
        } else if mTag is ST25TVCTag {
            areaStatus(mTag: mTag as! ST25TVCTag)
        } else if mTag is ST25DVTag {
            areaStatus(mTag: mTag as! ST25DVTag)
        } else if mTag is ST25DVCTag {
            areaStatus(mTag: mTag as! ST25DVCTag)
        } else if self.mTag is ST25DVPwmTag {
            areaStatus(mTag: mTag as! ST25DVPwmTag)
        } else if self.mTag is ST25TV16KTag {
            areaStatus(mTag: mTag as! ST25TV16KTag)
        }  else if self.mTag is ST25TV64KTag {
            areaStatus(mTag: mTag as! ST25TV64KTag)
        } else {
            warningAlert(message: "Tag doesn't support this feature")
        }
    }

    private func areaStatus ( mTag : ST25DVTag) {
        mCCFileLength = Int(mTag.getExpectedCCFileLength())
        mNumberOfAreas = Int8(mTag.getNumberOfAreas())
        //print(mNumberOfAreas)
        if mNumberOfAreas == 1 {
            mTaskToDo = .getAreaMemoryConf
            mCurrentAreaSize = Int(mTag.getMemSizeInBytes())
            mTaskToDo = .getAreaNdefConf
            let ndefMsg : ComStSt25sdkNdefNDEFMsg! = mTag.readNdefMessage()
            if ndefMsg != nil {
                let area = TagArea(area: Int(mNumberOfAreas), style: .NDEF, size: Int(mCurrentAreaSize), ndefMessage: ndefMsg)
                self.mAreaLibrary.add(area)
            } else {
                let area = TagArea(area: Int(mNumberOfAreas), style: .UNKNOWN_DATA, size: Int(mCurrentAreaSize))
                self.mAreaLibrary.add(area)
            }

        } else {
            for nbArea in mCurrentArea...mNumberOfAreas {
                mCurrentArea = nbArea
                mTaskToDo = .getAreaMemoryConf
                mCurrentAreaSize = Int(mTag.getAreaSizeInBytes(with: jint(nbArea)))
                mTaskToDo = .getAreaNdefConf
                let ndefMsg : ComStSt25sdkNdefNDEFMsg! = mTag.readNdefMessage(with: jint(nbArea))
                if ndefMsg != nil {
                    let area = TagArea(area: Int(nbArea), style: .NDEF, size: Int(mCurrentAreaSize), ndefMessage: ndefMsg!)
                    self.mAreaLibrary.add(area)

                } else {
                    let area = TagArea(area: Int(nbArea), style: .UNKNOWN_DATA, size: Int(mCurrentAreaSize))
                    self.mAreaLibrary.add(area)
                }
            }
        }
    }
    
    private func areaStatus ( mTag : ST25DVCTag) {
        mCCFileLength = Int(mTag.getExpectedCCFileLength())
        mNumberOfAreas = Int8(mTag.getNumberOfAreas())
        //print(mNumberOfAreas)
        if mNumberOfAreas == 1 {
            mTaskToDo = .getAreaMemoryConf
            mCurrentAreaSize = Int(mTag.getMemSizeInBytes())
            mTaskToDo = .getAreaNdefConf
            let ndefMsg : ComStSt25sdkNdefNDEFMsg! = mTag.readNdefMessage()
            if ndefMsg != nil {
                let area = TagArea(area: Int(mNumberOfAreas), style: .NDEF, size: Int(mCurrentAreaSize), ndefMessage: ndefMsg)
                self.mAreaLibrary.add(area)
            } else {
                let area = TagArea(area: Int(mNumberOfAreas), style: .UNKNOWN_DATA, size: Int(mCurrentAreaSize))
                self.mAreaLibrary.add(area)
            }

        } else {
            for nbArea in mCurrentArea...mNumberOfAreas {
                mCurrentArea = nbArea
                mTaskToDo = .getAreaMemoryConf
                mCurrentAreaSize = Int(mTag.getAreaSizeInBytes(with: jint(nbArea)))
                mTaskToDo = .getAreaNdefConf
                let ndefMsg : ComStSt25sdkNdefNDEFMsg! = mTag.readNdefMessage(with: jint(nbArea))
                if ndefMsg != nil {
                    let area = TagArea(area: Int(nbArea), style: .NDEF, size: Int(mCurrentAreaSize), ndefMessage: ndefMsg!)
                    self.mAreaLibrary.add(area)

                } else {
                    let area = TagArea(area: Int(nbArea), style: .UNKNOWN_DATA, size: Int(mCurrentAreaSize))
                    self.mAreaLibrary.add(area)
                }
            }
        }
    }
    
    private func areaStatus ( mTag : ST25TVTag) {
        mCCFileLength = Int(mTag.getExpectedCCFileLength())
        mNumberOfAreas = Int8(mTag.getNumberOfAreas())
        //print(mNumberOfAreas)
        if mNumberOfAreas == 1 {
            mTaskToDo = .getAreaMemoryConf
            mCurrentAreaSize = Int(mTag.getMemSizeInBytes())
            mTaskToDo = .getAreaNdefConf
            let ndefMsg : ComStSt25sdkNdefNDEFMsg! = mTag.readNdefMessage()
            if ndefMsg != nil {
                let area = TagArea(area: Int(mNumberOfAreas), style: .NDEF, size: Int(mCurrentAreaSize), ndefMessage: ndefMsg)
                self.mAreaLibrary.add(area)
            } else {
                let area = TagArea(area: Int(mNumberOfAreas), style: .UNKNOWN_DATA, size: Int(mCurrentAreaSize))
                self.mAreaLibrary.add(area)
            }

        } else {
            for nbArea in mCurrentArea...mNumberOfAreas {
                mCurrentArea = nbArea
                mTaskToDo = .getAreaMemoryConf
                mCurrentAreaSize = Int(mTag.getAreaSizeInBytes(with: jint(nbArea)))
                mTaskToDo = .getAreaNdefConf
                let ndefMsg : ComStSt25sdkNdefNDEFMsg! = mTag.readNdefMessage(with: jint(nbArea))
                if ndefMsg != nil {
                    let area = TagArea(area: Int(nbArea), style: .NDEF, size: Int(mCurrentAreaSize), ndefMessage: ndefMsg!)
                    self.mAreaLibrary.add(area)

                } else {
                    let area = TagArea(area: Int(nbArea), style: .UNKNOWN_DATA, size: Int(mCurrentAreaSize))
                    self.mAreaLibrary.add(area)
                }
            }
        }
    }
    
    private func areaStatus ( mTag : ST25TVCTag) {
        mCCFileLength = Int(mTag.getExpectedCCFileLength())
        mNumberOfAreas = Int8(mTag.getNumberOfAreas())
        //print(mNumberOfAreas)
        if mNumberOfAreas == 1 {
            mTaskToDo = .getAreaMemoryConf
            mCurrentAreaSize = Int(mTag.getMemSizeInBytes())
            mTaskToDo = .getAreaNdefConf
            let ndefMsg : ComStSt25sdkNdefNDEFMsg! = mTag.readNdefMessage()
            if ndefMsg != nil {
                let area = TagArea(area: Int(mNumberOfAreas), style: .NDEF, size: Int(mCurrentAreaSize), ndefMessage: ndefMsg)
                self.mAreaLibrary.add(area)
            } else {
                let area = TagArea(area: Int(mNumberOfAreas), style: .UNKNOWN_DATA, size: Int(mCurrentAreaSize))
                self.mAreaLibrary.add(area)
            }

        } else {
            for nbArea in mCurrentArea...mNumberOfAreas {
                mCurrentArea = nbArea
                mTaskToDo = .getAreaMemoryConf
                mCurrentAreaSize = Int(mTag.getAreaSizeInBytes(with: jint(nbArea)))
                mTaskToDo = .getAreaNdefConf
                let ndefMsg : ComStSt25sdkNdefNDEFMsg! = mTag.readNdefMessage(with: jint(nbArea))
                if ndefMsg != nil {
                    let area = TagArea(area: Int(nbArea), style: .NDEF, size: Int(mCurrentAreaSize), ndefMessage: ndefMsg!)
                    self.mAreaLibrary.add(area)

                } else {
                    let area = TagArea(area: Int(nbArea), style: .UNKNOWN_DATA, size: Int(mCurrentAreaSize))
                    self.mAreaLibrary.add(area)
                }
            }
        }
    }

    
    private func areaStatus ( mTag : ST25DVPwmTag) {
        mCCFileLength = Int(mTag.getExpectedCCFileLength())
        mNumberOfAreas = Int8(mTag.getNumberOfAreas())
        //print(mNumberOfAreas)
        if mNumberOfAreas == 1 {
            mTaskToDo = .getAreaMemoryConf
            mCurrentAreaSize = Int(mTag.getMemSizeInBytes())
            mTaskToDo = .getAreaNdefConf
            let ndefMsg : ComStSt25sdkNdefNDEFMsg! = mTag.readNdefMessage()
            if ndefMsg != nil {
                let area = TagArea(area: Int(mNumberOfAreas), style: .NDEF, size: Int(mCurrentAreaSize), ndefMessage: ndefMsg)
                self.mAreaLibrary.add(area)
            } else {
                let area = TagArea(area: Int(mNumberOfAreas), style: .UNKNOWN_DATA, size: Int(mCurrentAreaSize))
                self.mAreaLibrary.add(area)
            }

        } else {
            for nbArea in mCurrentArea...mNumberOfAreas {
                mCurrentArea = nbArea
                mTaskToDo = .getAreaMemoryConf
                mCurrentAreaSize = Int(mTag.getAreaSizeInBytes(with: jint(nbArea)))
                mTaskToDo = .getAreaNdefConf
                let ndefMsg : ComStSt25sdkNdefNDEFMsg! = mTag.readNdefMessage(with: jint(nbArea))
                if ndefMsg != nil {
                    let area = TagArea(area: Int(nbArea), style: .NDEF, size: Int(mCurrentAreaSize), ndefMessage: ndefMsg!)
                    self.mAreaLibrary.add(area)

                } else {
                    let area = TagArea(area: Int(nbArea), style: .UNKNOWN_DATA, size: Int(mCurrentAreaSize))
                    self.mAreaLibrary.add(area)
                }
            }
        }
    }
    
    private func areaStatus ( mTag : ST25TV16KTag) {
        mCCFileLength = Int(mTag.getExpectedCCFileLength())
        mNumberOfAreas = Int8(mTag.getNumberOfAreas())
        //print(mNumberOfAreas)
        if mNumberOfAreas == 1 {
            mTaskToDo = .getAreaMemoryConf
            mCurrentAreaSize = Int(mTag.getMemSizeInBytes())
            mTaskToDo = .getAreaNdefConf
            let ndefMsg : ComStSt25sdkNdefNDEFMsg! = mTag.readNdefMessage()
            if ndefMsg != nil {
                let area = TagArea(area: Int(mNumberOfAreas), style: .NDEF, size: Int(mCurrentAreaSize), ndefMessage: ndefMsg)
                self.mAreaLibrary.add(area)
            } else {
                let area = TagArea(area: Int(mNumberOfAreas), style: .UNKNOWN_DATA, size: Int(mCurrentAreaSize))
                self.mAreaLibrary.add(area)
            }

        } else {
            for nbArea in mCurrentArea...mNumberOfAreas {
                mCurrentArea = nbArea
                mTaskToDo = .getAreaMemoryConf
                mCurrentAreaSize = Int(mTag.getAreaSizeInBytes(with: jint(nbArea)))
                mTaskToDo = .getAreaNdefConf
                let ndefMsg : ComStSt25sdkNdefNDEFMsg! = mTag.readNdefMessage(with: jint(nbArea))
                if ndefMsg != nil {
                    let area = TagArea(area: Int(nbArea), style: .NDEF, size: Int(mCurrentAreaSize), ndefMessage: ndefMsg!)
                    self.mAreaLibrary.add(area)

                } else {
                    let area = TagArea(area: Int(nbArea), style: .UNKNOWN_DATA, size: Int(mCurrentAreaSize))
                    self.mAreaLibrary.add(area)
                }
            }
        }
    }
    
    private func areaStatus ( mTag : ST25TV64KTag) {
        mCCFileLength = Int(mTag.getExpectedCCFileLength())
        mNumberOfAreas = Int8(mTag.getNumberOfAreas())
        //print(mNumberOfAreas)
        if mNumberOfAreas == 1 {
            mTaskToDo = .getAreaMemoryConf
            mCurrentAreaSize = Int(mTag.getMemSizeInBytes())
            mTaskToDo = .getAreaNdefConf
            let ndefMsg : ComStSt25sdkNdefNDEFMsg! = mTag.readNdefMessage()
            if ndefMsg != nil {
                let area = TagArea(area: Int(mNumberOfAreas), style: .NDEF, size: Int(mCurrentAreaSize), ndefMessage: ndefMsg)
                self.mAreaLibrary.add(area)
            } else {
                let area = TagArea(area: Int(mNumberOfAreas), style: .UNKNOWN_DATA, size: Int(mCurrentAreaSize))
                self.mAreaLibrary.add(area)
            }

        } else {
            for nbArea in mCurrentArea...mNumberOfAreas {
                mCurrentArea = nbArea
                mTaskToDo = .getAreaMemoryConf
                mCurrentAreaSize = Int(mTag.getAreaSizeInBytes(with: jint(nbArea)))
                mTaskToDo = .getAreaNdefConf
                let ndefMsg : ComStSt25sdkNdefNDEFMsg! = mTag.readNdefMessage(with: jint(nbArea))
                if ndefMsg != nil {
                    let area = TagArea(area: Int(nbArea), style: .NDEF, size: Int(mCurrentAreaSize), ndefMessage: ndefMsg!)
                    self.mAreaLibrary.add(area)

                } else {
                    let area = TagArea(area: Int(nbArea), style: .UNKNOWN_DATA, size: Int(mCurrentAreaSize))
                    self.mAreaLibrary.add(area)
                }
            }
        }
    }
    private func setMemoryConfigurationNotInitialised() {
        mNumberOfAreas = 1
    }
    
    private func warningAlert(message : String) {
        UIHelper.warningAlert(viewController: self, title : "Area content management" , message: message)
    }
}

extension ST25AreaViewController: AreaEditionReady {
    func onAreaReady(action: actionOnArea, ndef: ComStSt25sdkNdefNDEFMsg) {
        if action == .modified {
            self.mAreaLibrary.updateNdefInArea(area: Int(mCurrentArea), ndef: ndef)
            DispatchQueue.main.async { self.mAreaTableView.reloadData() }
        } else {
            
        }
    }
}

extension ST25AreaViewController: UITableViewDataSource, UITableViewDelegate {
       
       func numberOfSections(in tableView: UITableView) -> Int {
           return 1
       }
       
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return Int(mNumberOfAreas)
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "areaCell", for: indexPath)
           //print("Area content editor Table index : \(indexPath.row)")
           //print("Area content editor Area lib index : \(self.library.areas.count)")

           if self.mAreaLibrary.areas.count != 0 && indexPath.row < self.mAreaLibrary.areas.count {
               let currentArea = self.mAreaLibrary.areas[indexPath.row]
               cell.textLabel?.text = currentArea.description
               cell.detailTextLabel?.text = currentArea.content
           }

           return cell

       }
       
    }

extension ST25AreaViewController: tagReaderSessionViewControllerDelegate {
    
    func handleTag(st25SDKTag: ComStSt25sdkNFCTag, uid: Data!) throws {
        mTag = st25SDKTag
        if self.isSameTag(uid: uid)  {
            switch mTaskToDo {
            case .getAreaMemoryConf, .getAreaNdefConf:
                getAreasStatus()
            }
        } else {
            //print((TabItem.TagInfo.mainVC as! ST25TagInformationViewController).productId?.description)
            //print(uid.toHexString())
            UIHelper.UI() {
                self.warningAlert(message: "Tag has changed, please scan again the Tag ...")
            }
        }
        
    }
    
    private func nop() {
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
            
        } else  {
            UIHelper.UI() {
                self.warningAlert(message: error.localizedDescription)
            }
        }
        DispatchQueue.main.async { self.mAreaTableView.reloadData() }
        print(error.localizedDescription)

    }
    
    func handleTagST25SdkError(didInvalidateWithError error: NSException) {
//        print("ST25SDK Error description: \(error.description)")
//        print("ST25SDK Error name: \(error.name)")
//        print("ST25SDK Error user info: \(error.userInfo)")
//        print("ST25SDK Error reason: \(error.reason)")
        let errorST25SDK = error as! ComStSt25sdkSTException

//        print("Error SDK \(errorST25SDK)")
//        print("Error SDK \(errorST25SDK.getError())")
//        print("Error SDK \(errorST25SDK.getMessage())")
        

        if self.mTaskToDo == .getAreaNdefConf {
            // according to error code define information to be displayed
            var contentStatus :TagArea.AreaStyle = .UNKNOWN_DATA
            //print("error raw \(error.name.rawValue.description)")
            //print("Exception raw \(ComStSt25sdkSTException_STExceptionCode.INVALID_CCFILE.name())")

            
            if ((errorST25SDK.getMessage()?.contains(ComStSt25sdkSTException_STExceptionCode.PASSWORD_NEEDED.description()))! ||
                (errorST25SDK.getMessage()?.contains(ComStSt25sdkSTException_STExceptionCode.ISO15693_BLOCK_PROTECTED.description()))!
                ){
                contentStatus = .PWD_NEEDED
            }
            
            if ((errorST25SDK.getMessage()?.contains(ComStSt25sdkSTException_STExceptionCode.ISO15693_BLOCK_IS_LOCKED.description()))!
                ){
                contentStatus = .BLOCK_LOCKED
            }

            let area = TagArea(area: Int(self.mCurrentArea), style: contentStatus, size: Int(self.mCurrentAreaSize))
            self.mAreaLibrary.add(area)
            //print("handleTagST25SdkError area added ..")

            DispatchQueue.main.async { self.mAreaTableView.reloadData() }

            if self.mCurrentArea <= self.mNumberOfAreas {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4.0,execute: { () -> Void in
                    self.mCurrentArea = self.mCurrentArea + 1
                    //print("handleTagST25SdkError area incremented ..")
                    self.mTaskToDo = .getAreaMemoryConf
                    //print("handleTagST25SdkError restart session ..")
                        if self.mCurrentArea <= self.mNumberOfAreas {
                            self.miOSReaderSession = iOSReaderSession(atagReaderSessionViewControllerDelegate: self)
                            self.miOSReaderSession.startTagReaderSession()
                        } else {
                            // we got the last one with Error and current is over the max - put it on the last one
                            self.mCurrentArea = self.mNumberOfAreas
                        }

                })
            }
        }
    }
}
