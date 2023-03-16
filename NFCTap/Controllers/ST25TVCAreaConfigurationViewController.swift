//
//  ST25TVCAreaConfigurationViewController.swift
//  NFCTap 
//
//  Created by STMICROELECTRONICS on 19/03/2021.
//  Copyright © 2021 STMicroelectronics. All rights reserved.
//

import UIKit
import CoreNFC

class ST25TVCAreaConfigurationViewController: ST25UIViewController {

    //internal var mST25DVTag:ST25DVTag!
    internal var mTag : ComStSt25sdkNFCTag!

    internal var mST25ConfigurationPwd:Data!
    internal var miOSReaderSession:iOSReaderSession!
    internal var mST25TagMemorySize:Int!
    internal var mSliderStepValue:UInt = 32*4
    internal var mST25TagBlockSizeInBytes:Int!
    
    enum taskToDo {
          case readAreaConfiguration
          case writeAreaConfiguration
      }
    internal var mTaskToDo:taskToDo = .readAreaConfiguration
 
    // Array index 0 not used. Start at ComStSt25sdkMultiAreaInterface_AREA1 = 1 Max 2 Areas
    internal var mAreaSizeInBytes:[UInt]     = [0,0,0]
    internal var mAreaOffsetInBytes:[UInt]   = [0,0,0]
    internal var mArea1ENDARegister:jint = 0
    // used and keep for next update if any - Not necessary
    internal var mArea2ENDARegister:jint = 0
    
    internal var mIsArea1Locked:Bool = false
    internal var mIsArea2Locked:Bool = false


    internal var mAreaLabelConstraints:[[NSLayoutConstraint]] = [[NSLayoutConstraint]]()
    
    @IBOutlet weak var mAreaView: UIView!
    @IBOutlet weak var mArea1Label: UILabel!
    @IBOutlet weak var mArea2Label: UILabel!

    
    @IBOutlet weak var mArea1Slider: UISlider!
    @IBOutlet weak var mArea2Slider: UISlider!

 
    @IBOutlet weak var mArea1Start: UILabel!
    @IBOutlet weak var mArea2Start: UILabel!

    @IBOutlet weak var mTotalStart: UILabel!
    
    @IBOutlet weak var mArea1Size: UILabel!
    @IBOutlet weak var mArea2Size: UILabel!

    @IBOutlet weak var mTotalSize: UILabel!
    
    @IBAction func handleResetButton(_ sender: Any) {
        mTaskToDo = .readAreaConfiguration
        miOSReaderSession.startTagReaderSession()
    }
    
    @IBAction func handleWriteButton(_ sender: Any) {
        if (mIsArea1Locked || mIsArea2Locked) {
            UIHelper.warningAlert(viewController: self, title: "ST25 areas configuration ", message: "Tag Areas configuration locked !!")

        } else {
            mTaskToDo = .writeAreaConfiguration
            self.presentPwdController()
        }

    }
    
    @IBAction func area1SliderAction(_ sender: UISlider) {
        
        // Clean lable graphic constraints
        removeConstraints()

        // Force value to be 4bytes aligned
        sender.newValue = sender.value
        //print("Slider action value : \(sender.value)")
        //print("Slider action value : \(sender.newValue)")

        setAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA1,Int(sender.value))
        setAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA2,Int(mST25TagMemorySize) - getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA1))
        
        
        // Update max values for Area2 and Area3 sliders : They can only take more space to their right
        mArea2Slider.maximumValue = Float(mST25TagMemorySize-getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA1))

        // update Other sliders to the right
        mArea2Slider.newValue = Float(getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA2))
        
        // Compute program Registers
        mArea1ENDARegister = jint( Int(getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA1)) / mST25TagBlockSizeInBytes)
        //print("Slider mArea1ENDARegister value : \(mArea1ENDARegister)")
        
        if (getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA2) != 0){
            mArea2ENDARegister = jint( Int(getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA1))+Int(getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA2)))
        }else{
            mArea2ENDARegister = jint(Int(mST25TagMemorySize) / mST25TagBlockSizeInBytes)
        }
                
        // Compute AreaOffset
        computeAreaOffsetInByte()
        
        // update Graphic
        updateGridArray()
        updateAreasLabel()
    }
    
    @IBAction func area2SliderAction(_ sender: UISlider) {
        // Nothing to do - Handled by Slider1
    }
    
          
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Areas Management"
        
        // Init with Default values
        mST25TagMemorySize = 512
        setAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA1,Int(mST25TagMemorySize))
        setAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA2,0)
        
        // Compute AreaOffset
        computeAreaOffsetInByte()
        
        // Ad ticks sliders
        drawSliderTicks(slider: mArea1Slider, step: 64)
        drawSliderTicks(slider: mArea2Slider, step: 64)
        
        // disable mArea2Slider interactions
        mArea2Slider.isEnabled = false
        
        // Read Configuration in first
        mTaskToDo = .readAreaConfiguration
        
        // run NFC to read NFC Tag Configuration
        self.miOSReaderSession = iOSReaderSession(atagReaderSessionViewControllerDelegate: self)
        self.miOSReaderSession.startTagReaderSession()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // draw tick sliders
    private func drawSliderTicks(slider:UISlider, step:Int){
       for i in stride(from: 0, to: Int(slider.frame.size.width), by: 32) {
           let tick = UIView(frame: CGRect(x: i, y: (Int(slider.frame.size.height) - 10) / 2, width: 2, height: 10))
           tick.backgroundColor = UIColor.init(white: 0.7, alpha: 1)
           tick.layer.shadowColor = UIColor.white.cgColor
           tick.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
           tick.layer.shadowOpacity = 1.0
           tick.layer.shadowRadius = 0.0
           slider.insertSubview(tick, belowSubview: mArea1Slider)
           }
    }
    
    // Update graphical view
    private func updateGraphic(){
        // update GridArray
        updateGridArray()
        
        // update Graphic
        updateAreasLabel()
        
        // updateSlider
        updateSlider(slider: mArea1Slider, value: UInt(getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA1)))
        updateSlider(slider: mArea2Slider, value: UInt(getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA2)))
    }
    
    // Init & Update sliders
    private func initSliders() {
        self.mArea1Slider.maximumValue = Float(self.mST25TagMemorySize)
        self.mArea2Slider.maximumValue = Float(self.mST25TagMemorySize)
   }
    
    private func updateSlider(slider:UISlider,value:UInt){
        slider.value = Float(value)
        slider.minimumValue = 0

        switch slider {
        case mArea1Slider:
            slider.minimumValue = 32
            mArea1Slider.value = Float(value)
            mArea1Slider.newValue = Float(value)
        case mArea2Slider:
            mArea2Slider.value = Float(value)
            mArea2Slider.newValue = Float(value)
        default:
            break
        }
        
    }
    
    // Uodate Grid array label values
    private func updateGridArray(){
        mArea1Start.text = "\(getAreaOffsetInBytes(ComStSt25sdkMultiAreaInterface_AREA1))"
        mArea1Size.text  = "\(getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA1))"
        
        var size = getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA2)
        if (size == 0){
            mArea2Start.text = "N/A"
        }else{
            mArea2Start.text = "\(getAreaOffsetInBytes(ComStSt25sdkMultiAreaInterface_AREA2))"
        }
        mArea2Size.text  = "\(size)"
        
    
        mTotalSize.text  = "\(getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA1)+getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA2))"
    }
    
    // graphical functions for drawing Labels
    private func updateAreasLabel(){
        removeConstraints()
        updateAreaLabel(areaNbr: ComStSt25sdkMultiAreaInterface_AREA1)
        updateAreaLabel(areaNbr: ComStSt25sdkMultiAreaInterface_AREA2)

    }
    
    private func updateAreaLabel(areaNbr:jint){
        let size:CGFloat = CGFloat(getAreaSizeInBytes(areaNbr))
        let val:CGFloat = size/CGFloat(mST25TagMemorySize)
        
        var item:UILabel!
        var toItem:Any!
        var attribute:NSLayoutConstraint.Attribute = .trailing
        
        switch areaNbr {
        case ComStSt25sdkMultiAreaInterface_AREA1:
            item = mArea1Label
            toItem = mAreaView
            item.backgroundColor = UIColor.stLightBlueColor()
            item.text = "Area1"
            attribute = .leading
        case ComStSt25sdkMultiAreaInterface_AREA2:
            item = mArea2Label
            toItem = mArea1Label
            item.backgroundColor = UIColor.stLightYellowColor()
            item.text = "Area2"
        default:
            break
        }
        item.translatesAutoresizingMaskIntoConstraints = false
        item.textColor = .white
        item.textAlignment = .center
        self.view.addSubview(item)
        
        let horConstraint:NSLayoutConstraint = NSLayoutConstraint(item: item as Any, attribute: .leading, relatedBy: .equal,
                                      toItem: toItem, attribute: attribute,
                                      multiplier: 1.0, constant: 0.0)
        let verConstraint:NSLayoutConstraint = NSLayoutConstraint(item: item as Any, attribute: .top, relatedBy: .equal,
                                      toItem: mAreaView, attribute: .top,
                                      multiplier: 1.0, constant: 0.0)
        let widConstraint:NSLayoutConstraint = NSLayoutConstraint(item: item as Any, attribute: .width, relatedBy: .equal,
                                      toItem: mAreaView, attribute: .width,
                                      multiplier: val, constant: 0.0)
        let heiConstraint:NSLayoutConstraint = NSLayoutConstraint(item: item as Any, attribute: .height, relatedBy: .equal,
                                      toItem: mAreaView, attribute: .height,
                                      multiplier: 1.0, constant: 0.0)
        let constraint:[NSLayoutConstraint] = ([horConstraint,verConstraint,widConstraint,heiConstraint])
        mAreaLabelConstraints.append(constraint)
        view.addConstraints(constraint)
    }
 
    private func removeConstraints(){
        if (mAreaLabelConstraints.count != 0){
            for i in 0...mAreaLabelConstraints.count-1 {
                let constraint:[NSLayoutConstraint] = mAreaLabelConstraints[i]
                for j in 0...constraint.count-1{
                    view.removeConstraint(constraint[j])
                }
            }
        }
    }
    
    
    // Setter/Getter of Area Sizes
    private func setAreaSizeInBytes(_ areaNb:jint, _ sizeInBytes:Int){
        if (sizeInBytes >= 0){
            mAreaSizeInBytes[Int(areaNb)] = UInt(sizeInBytes)
        }else{
            mAreaSizeInBytes[Int(areaNb)] = 0
        }
    }
    private func getAreaSizeInBytes(_ areaNb:jint) -> Int{
        return Int(mAreaSizeInBytes[Int(areaNb)])
    }
 
    // Setter/Getter of Offset
    private func computeAreaOffsetInByte(){
        setAreaOffsetInBytes(ComStSt25sdkMultiAreaInterface_AREA1, 0)
        setAreaOffsetInBytes(ComStSt25sdkMultiAreaInterface_AREA2, getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA1))
    }
    
    private func setAreaOffsetInBytes(_ areaNb:jint, _ offsetInBytes:Int){
        if (offsetInBytes <= mST25TagMemorySize){
           mAreaOffsetInBytes[Int(areaNb)] = UInt(offsetInBytes)
        }else{
           mAreaOffsetInBytes[Int(areaNb)] = 0
        }
        
    }
    private func getAreaOffsetInBytes(_ areaNb:jint) -> UInt{
        return mAreaOffsetInBytes[Int(areaNb)]
    }
    
    // NFC ST25 TAG Functions
    private func computeEndARegisterValue(value:Int) -> Int{

        if self.mTag is ST25TVCTag {
            return ((value/Int(mST25TagBlockSizeInBytes)/8)-1)
        } else {
            return 0
        }
    }
    

    private func readAreaConfiguration() {
        self.readLockedFlags()
        self.readAreaSizes()
        
        // Compute AreaOffset
        computeAreaOffsetInByte()
        
        UIHelper.UI{
            self.initSliders()
            self.updateGraphic()
        }
        
        if (mIsArea1Locked || mIsArea1Locked) {
            UIHelper.warningAlert(viewController: self, title: "ST25 areas configuration ", message: "Tag Areas configuration locked !!")

        }


     }
        
    private func readAreaSizes() {
        if self.mTag is ST25TVCTag {
            readAreaSizes(tag: mTag as! ST25TVCTag)
        } else{
            UIHelper.warningAlert(viewController: self, title: "ST25 areas configuration ", message: "Tag does not support this feature")
        }

    }
    
    private func getTotalMemorySize(tag : ST25TVCTag) -> Int {
        let totalMemorySize = Int(tag.getNumberOfBlocks()) + getAndefTrust25Size()
        return totalMemorySize * mST25TagBlockSizeInBytes
    }
    // not used now, but can be used to avoid Trust25/ANDEF memory space handling in memory configuration
    // if requiered later
    private func getAndefTrust25Size() -> Int {
        let val = 0
        return val
    }
    
    private func readLockedFlags() {
        if self.mTag is ST25TVCTag {
            readLockedFlags(tag: mTag as! ST25TVCTag)
        } else{
            UIHelper.warningAlert(viewController: self, title: "ST25 areas configuration ", message: "Tag does not support this feature")
        }

    }
    private func readLockedFlags(tag : ST25TVCTag) {
        mIsArea1Locked = tag.isArea1ConfigurationLocked()
        mIsArea2Locked = tag.isArea2ConfigurationLocked()
    }
    
    private func readAreaSizes(tag : ST25TVCTag) {
        mST25TagBlockSizeInBytes = Int(tag.getBlockSizeInBytes())
        mST25TagMemorySize = getTotalMemorySize(tag: tag)
        mArea1ENDARegister = jint(tag.getClampedArea1EndValue())

        setAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA1,Int(Int(mArea1ENDARegister+1) * mST25TagBlockSizeInBytes))
        
        if (Int(mArea1ENDARegister+1) * mST25TagBlockSizeInBytes < mST25TagMemorySize) {
            // a second area exist
            var mST25TagMemorySizeInBlocks = (Int)(mST25TagMemorySize/mST25TagBlockSizeInBytes)
            setAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA2, (Int)( mST25TagMemorySize - Int(mArea1ENDARegister+1) * mST25TagBlockSizeInBytes))
            
        } else {
            setAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA2, (Int)(0))

        }

        
    }
    

    
    private func writeAreaConfiguration() {
        if self.mTag is ST25TVCTag {
            writeAreaConfiguration(tag: self.mTag as! ST25TVCTag)
        }  else{
            UIHelper.warningAlert(viewController: self, title: "ST25 areas configuration ", message: "Tag does not support this feature")
        }
   }
    
    private func writeAreaConfiguration(tag : ST25TVCTag) {
        tag.presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25tvcST25TVCTag_ST25TVC_CONFIGURATION_PASSWORD_ID), password: mST25ConfigurationPwd)
        tag.setArea1EndValueWithByte(jbyte(mArea1ENDARegister-1))
        
   }
    

    
    private func presentPwdController() {
       let mST25PasswordVC:ST25PasswordViewController = UIStoryboard(name: "ST25Password", bundle: nil).instantiateViewController(withIdentifier: "ST25PasswordID") as! ST25PasswordViewController
       mST25PasswordVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
       mST25PasswordVC.setTitle("Enter configuration password")
       mST25PasswordVC.setMessage("(32 bits hexadecimal format)")
       mST25PasswordVC.numberOfBytes = 4
       mST25PasswordVC.delegate = self
       self.present(mST25PasswordVC, animated: false, completion: nil)
   }

}

extension ST25TVCAreaConfigurationViewController: tagReaderSessionViewControllerDelegate {

    func handleTag(st25SDKTag: ComStSt25sdkNFCTag, uid: Data!) throws {
        mTag = st25SDKTag

        // Check if tag has changed
        if (!isSameTag(uid: uid)) {
            miOSReaderSession.stopTagReaderSession("Tag has changed, please scan again the Tag ...")
            return
        }
        
        
        switch mTaskToDo {
        case .readAreaConfiguration:
            readAreaConfiguration()
        case .writeAreaConfiguration:
            writeAreaConfiguration()
            
        }
        
    }

    func handleTagSessionError(didInvalidateWithError error: Error) {
        let errorNFC = error as! NFCReaderError
        if errorNFC.code ==  NFCReaderError.readerSessionInvalidationErrorSessionTimeout {
        }
        else if errorNFC.code ==  NFCReaderError.readerSessionInvalidationErrorUserCanceled {
        }
    }

    func handleTagST25SdkError(didInvalidateWithError error: NSException) {
        miOSReaderSession.stopTagReaderSession("Command failed: \(error.description)")
    }
}

extension ST25TVCAreaConfigurationViewController: ST25PasswordViewDelegate {
    func okButtonTapped(pwdValue: Data) {
        self.mST25ConfigurationPwd = pwdValue
        self.miOSReaderSession.startTagReaderSession()
    }

    func cancelButtonTapped() {
    }
}

