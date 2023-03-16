//
//  ST25DVAreaConfigurationViewController.swift
//  ST25NFCApp
//
//  Created by Vincent LATORRE on 3/24/20.
//  Copyright © 2020 STMicroelectronics. All rights reserved.
//

import UIKit
import CoreNFC

class ST25DVAreaConfigurationViewController: ST25UIViewController {

    //internal var mST25DVTag:ST25DVTag!
    internal var mTag : ComStSt25sdkNFCTag!

    internal var mST25DVConfigurationPwd:Data!
    internal var miOSReaderSession:iOSReaderSession!
    internal var mST25TagMemorySize:Int!
    internal var mSliderStepValue:UInt = 32*4

    
    enum taskToDo {
          case readAreaConfiguration
          case writeAreaConfiguration
      }
    internal var mTaskToDo:taskToDo = .readAreaConfiguration
 
    // Array index 0 not used. Start at ComStSt25sdkMultiAreaInterface_AREA1 = 1
    internal var mAreaSizeInBytes:[UInt]     = [0,0,0,0,0]
    internal var mAreaOffsetInBytes:[UInt]   = [0,0,0,0,0]
    internal var mArea1ENDARegister:jint = 0
    internal var mArea2ENDARegister:jint = 0
    internal var mArea3ENDARegister:jint = 0

    internal var mAreaLabelConstraints:[[NSLayoutConstraint]] = [[NSLayoutConstraint]]()
    
    @IBOutlet weak var mAreaView: UIView!
    @IBOutlet weak var mArea1Label: UILabel!
    @IBOutlet weak var mArea2Label: UILabel!
    @IBOutlet weak var mArea3Label: UILabel!
    @IBOutlet weak var mArea4Label: UILabel!
    
    @IBOutlet weak var mArea1Slider: UISlider!
    @IBOutlet weak var mArea2Slider: UISlider!
    @IBOutlet weak var mArea3Slider: UISlider!
    @IBOutlet weak var mArea4Slider: UISlider!
 
    @IBOutlet weak var mArea1Start: UILabel!
    @IBOutlet weak var mArea2Start: UILabel!
    @IBOutlet weak var mArea3Start: UILabel!
    @IBOutlet weak var mArea4Start: UILabel!
    @IBOutlet weak var mTotalStart: UILabel!
    
    @IBOutlet weak var mArea1Size: UILabel!
    @IBOutlet weak var mArea2Size: UILabel!
    @IBOutlet weak var mArea3Size: UILabel!
    @IBOutlet weak var mArea4Size: UILabel!
    @IBOutlet weak var mTotalSize: UILabel!
    
    @IBAction func handleResetButton(_ sender: Any) {
        mTaskToDo = .readAreaConfiguration
        miOSReaderSession.startTagReaderSession()
    }
    
    @IBAction func handleWriteButton(_ sender: Any) {
        mTaskToDo = .writeAreaConfiguration
        self.presentPwdController()
    }
    
    @IBAction func area1SliderAction(_ sender: UISlider) {
        
        // Clean lable graphic constraints
        removeConstraints()

        // Force value to be 4bytes aligned
        sender.newValue = sender.value
        
        setAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA1,Int(UInt(mArea1Slider!.value)))
        setAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA2,Int(mST25TagMemorySize) - getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA1) - getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA3) - getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA4))
        
        // Area 3 becomes area 2 and area 4 becomes area 3
        if (getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA2) <= 0){
            setAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA2,Int(getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA3)))
            setAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA3,Int(getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA4)))
            setAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA4,0)
        }
        
        // Update max values for Area2 and Area3 sliders : They can only take more space to their right
        mArea2Slider.maximumValue = Float(mST25TagMemorySize-getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA1))
        mArea3Slider.maximumValue = Float(mST25TagMemorySize-getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA1)-getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA2))

        // update Other sliders to the right
        mArea2Slider.newValue = Float(getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA2))
        mArea3Slider.newValue = Float(getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA3))
        mArea4Slider.newValue = Float(getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA4))
        
        // Compute program Registers
        mArea1ENDARegister = jint(jint(computeEndARegisterValue(value: Int(getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA1)))))
        
        if (getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA2) != 0){
            mArea2ENDARegister = jint(jint(computeEndARegisterValue(value: Int(getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA1))+Int(getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA2)))))
        }else{
            mArea2ENDARegister = jint(jint(computeEndARegisterValue(value: Int(mST25TagMemorySize))))
        }
        
        if (getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA3) != 0){
            mArea3ENDARegister = jint(jint(computeEndARegisterValue(value: Int(getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA1))+Int(getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA2))+Int(getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA3)))))
        }else{
            mArea3ENDARegister = jint(jint(computeEndARegisterValue(value: Int(mST25TagMemorySize))))
        }
        
        // Compute AreaOffset
        computeAreaOffsetInByte()
        
        // update Graphic
        updateGridArray()
        updateAreasLabel()
    }
    
    @IBAction func area2SliderAction(_ sender: UISlider) {
        
        // Clean lable graphic constraints
        removeConstraints()
 
        // Force value to be 4bytes aligned
        sender.newValue = sender.value

        if (UInt(mArea2Slider!.value) <= 0 ){
            // Area3 becomes Area2 and area4 becomes Area3
            setAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA2,Int(mST25TagMemorySize-getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA1)-getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA4)))
            setAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA3,Int(getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA4)))
            setAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA4,0)
            
            mArea2Slider.newValue = Float(getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA2))
            mArea3Slider.newValue = Float(getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA3))
            mArea4Slider.newValue = Float(0)
        }else{
            setAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA2,Int(UInt(mArea2Slider!.value)))
            //When Area2 changes, Area3 is the first area impacted
            setAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA3,Int(mST25TagMemorySize-getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA1)-getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA2)-getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA4)))
        
            
            // Make sure we don't ahve negative values
            if (getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA3) <= 0){
                setAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA3,Int(getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA4)))
                setAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA4,0)
            }
            mArea3Slider.maximumValue = Float(mST25TagMemorySize - getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA1) - getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA2))
            
            // update Other sliders to the right
            mArea3Slider.newValue = Float(getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA3))
            mArea4Slider.newValue = Float(getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA4))
        }

        // Compute program Registers
        if (getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA2) != 0){
            mArea2ENDARegister = jint(jint(computeEndARegisterValue(value: Int(getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA1))+Int(getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA2)))))
        }else{
            mArea2ENDARegister = jint(jint(computeEndARegisterValue(value: Int(mST25TagMemorySize))))
        }

        if (getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA3) != 0){
            mArea3ENDARegister = jint(jint(computeEndARegisterValue(value: Int(getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA1))+Int(getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA2))+Int(getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA3)))))
        }else{
            mArea3ENDARegister = jint(jint(computeEndARegisterValue(value: Int(mST25TagMemorySize))))
        }
        
        // Compute AreaOffset
        computeAreaOffsetInByte()

        // update Graphic
        updateGridArray()
        updateAreasLabel()

    }
    
    @IBAction func area3SliderAction(_ sender: UISlider) {

        // Clean lable graphic constraints
        removeConstraints()
 
        // Force value to be 4bytes aligned
        sender.newValue = sender.value

        if (UInt(mArea3Slider!.value) <= 0 ){
            // Area4 becomes Area3
            setAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA3,Int(mST25TagMemorySize-getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA1)-getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA2)))
            setAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA4,0)
            mArea3Slider.newValue = Float(getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA3))
            mArea4Slider.newValue = Float(0)
        }else{
            setAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA3,Int(UInt(mArea3Slider!.value)))
            //When Area3 changes, Area4 is only impacted
            setAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA4,Int(mST25TagMemorySize-getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA1)-getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA2)-getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA3)))
            
            // Make sure we don't have negative values
            if (getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA4) <= 0){
                setAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA4,0)
            }
    
            // update Other sliders to the right
            mArea4Slider.newValue = Float(getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA4))
        }
        
        // Compute program Registers
        if (getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA3) != 0){
            mArea3ENDARegister = jint(jint(computeEndARegisterValue(value: Int(getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA1))+Int(getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA2))+Int(getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA3)))))
        }else{
            mArea3ENDARegister = jint(jint(computeEndARegisterValue(value: Int(mST25TagMemorySize))))
        }
        
        // Compute AreaOffset
        computeAreaOffsetInByte()

        // update Graphic
        updateGridArray()
        updateAreasLabel()
    }
          
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Areas Management"
        
        // Init with Default values
        mST25TagMemorySize = 512
        setAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA1,Int(mST25TagMemorySize))
        setAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA2,0)
        setAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA3,0)
        setAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA4,0)
        
        // Compute AreaOffset
        computeAreaOffsetInByte()
        
        // Ad ticks sliders
        drawSliderTicks(slider: mArea1Slider, step: 64)
        drawSliderTicks(slider: mArea2Slider, step: 64)
        drawSliderTicks(slider: mArea3Slider, step: 64)
        drawSliderTicks(slider: mArea4Slider, step: 64)
        
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
        updateSlider(slider: mArea3Slider, value: UInt(getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA3)))
        updateSlider(slider: mArea4Slider, value: UInt(getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA4)))
    }
    
    // Init & Update sliders
    private func initSliders() {
        self.mArea1Slider.maximumValue = Float(self.mST25TagMemorySize)
        self.mArea2Slider.maximumValue = Float(self.mST25TagMemorySize)
        self.mArea3Slider.maximumValue = Float(self.mST25TagMemorySize)  
        self.mArea4Slider.maximumValue = Float(self.mST25TagMemorySize)
   }
    
    private func updateSlider(slider:UISlider,value:UInt){
        slider.newValue = Float(value)
        slider.minimumValue = 0
        
        switch slider {
        case mArea1Slider:
            slider.minimumValue = 32
            area1SliderAction(slider)
        case mArea2Slider:
            area2SliderAction(slider)
        case mArea3Slider:
            area3SliderAction(slider)
        case mArea4Slider:
            break
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
        
        size = getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA3)
        if (size == 0){
           mArea3Start.text = "N/A"
        }else{
           mArea3Start.text = "\(getAreaOffsetInBytes(ComStSt25sdkMultiAreaInterface_AREA3))"
        }
        mArea3Size.text  = "\(size)"

        size = getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA4)
        if (size == 0){
           mArea4Start.text = "N/A"
        }else{
           mArea4Start.text = "\(getAreaOffsetInBytes(ComStSt25sdkMultiAreaInterface_AREA4))"
        }
        mArea4Size.text  = "\(size)"
    
        mTotalSize.text  = "\(getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA1)+getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA2)+getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA3)+getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA4))"
    }
    
    // graphical functions for drawing Labels
    private func updateAreasLabel(){
        removeConstraints()
        updateAreaLabel(areaNbr: ComStSt25sdkMultiAreaInterface_AREA1)
        updateAreaLabel(areaNbr: ComStSt25sdkMultiAreaInterface_AREA2)
        updateAreaLabel(areaNbr: ComStSt25sdkMultiAreaInterface_AREA3)
        updateAreaLabel(areaNbr: ComStSt25sdkMultiAreaInterface_AREA4)
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
        case ComStSt25sdkMultiAreaInterface_AREA3:
            item = mArea3Label
            toItem = mArea2Label
            item.backgroundColor = UIColor.stLightGreenColor()
            item.text = "Area3"
        case ComStSt25sdkMultiAreaInterface_AREA4:
            item = mArea4Label
            toItem = mArea3Label
            item.backgroundColor = UIColor.stVioletColor()
            item.text = "Area4"
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
        setAreaOffsetInBytes(ComStSt25sdkMultiAreaInterface_AREA3, getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA1)+getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA2))
        setAreaOffsetInBytes(ComStSt25sdkMultiAreaInterface_AREA4, getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA1)+getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA2)+getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA3))
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
        if self.mTag is ST25DVTag {
            return ((value/Int((mTag as! ST25DVTag).getBlockSizeInBytes())/8)-1)
        } else if self.mTag is ST25DVCTag {
            return ((value/Int((mTag as! ST25DVCTag).getBlockSizeInBytes())/8)-1)
        } else if self.mTag is ST25TV16KTag {
            return ((value/Int((mTag as! ST25TV16KTag).getBlockSizeInBytes())/8)-1)
        } else if self.mTag is ST25TV64KTag {
            return ((value/Int((mTag as! ST25TV64KTag).getBlockSizeInBytes())/8)-1)
        } else {
            return ((value/Int((mTag as! ST25DVTag).getBlockSizeInBytes())/8)-1)
        }
    }
    

    private func readAreaConfiguration() {
            self.readAreaSizes()
            self.readAreaOffset()
     }
    
    private func readENDARegister(){
        if self.mTag is ST25DVTag {
            readENDARegister(tag: mTag as! ST25DVTag)
        } else if self.mTag is ST25DVCTag {
            readENDARegister(tag: mTag as! ST25DVCTag)
        } else if self.mTag is ST25TV16KTag {
            readENDARegister(tag: mTag as! ST25TV16KTag)
        } else if self.mTag is ST25TV64KTag {
            readENDARegister(tag: mTag as! ST25TV64KTag)
        } else{
            UIHelper.warningAlert(viewController: self, title: "ST25 areas configuration ", message: "Tag does not support this feature")
        }
    }
    private func readENDARegister(tag : ST25DVTag){
        mST25TagMemorySize = Int(tag.getMemSizeInBytes())
        mArea1ENDARegister = jint(tag.getRegisterEndArea(with: ComStSt25sdkMultiAreaInterface_AREA1).getEndArea())
        mArea2ENDARegister = jint(tag.getRegisterEndArea(with: ComStSt25sdkMultiAreaInterface_AREA2).getEndArea())
        mArea3ENDARegister = jint(tag.getRegisterEndArea(with: ComStSt25sdkMultiAreaInterface_AREA3).getEndArea())
    }
    
    private func readENDARegister(tag : ST25DVCTag){
        mST25TagMemorySize = Int(tag.getMemSizeInBytes())
        mArea1ENDARegister = jint(tag.getRegisterEndArea(with: ComStSt25sdkMultiAreaInterface_AREA1).getEndArea())
        mArea2ENDARegister = jint(tag.getRegisterEndArea(with: ComStSt25sdkMultiAreaInterface_AREA2).getEndArea())
        mArea3ENDARegister = jint(tag.getRegisterEndArea(with: ComStSt25sdkMultiAreaInterface_AREA3).getEndArea())
    }
    
    private func readENDARegister(tag : ST25TV16KTag){
        mST25TagMemorySize = Int(tag.getMemSizeInBytes())
        mArea1ENDARegister = jint(tag.getRegisterEndArea(with: ComStSt25sdkMultiAreaInterface_AREA1).getEndArea())
        mArea2ENDARegister = jint(tag.getRegisterEndArea(with: ComStSt25sdkMultiAreaInterface_AREA2).getEndArea())
        mArea3ENDARegister = jint(tag.getRegisterEndArea(with: ComStSt25sdkMultiAreaInterface_AREA3).getEndArea())
    }
    private func readENDARegister(tag : ST25TV64KTag){
        mST25TagMemorySize = Int(tag.getMemSizeInBytes())
        mArea1ENDARegister = jint(tag.getRegisterEndArea(with: ComStSt25sdkMultiAreaInterface_AREA1).getEndArea())
        mArea2ENDARegister = jint(tag.getRegisterEndArea(with: ComStSt25sdkMultiAreaInterface_AREA2).getEndArea())
        mArea3ENDARegister = jint(tag.getRegisterEndArea(with: ComStSt25sdkMultiAreaInterface_AREA3).getEndArea())
    }
    
    private func readAreaSizes() {
        if self.mTag is ST25DVTag {
            readAreaSizes(tag: mTag as! ST25DVTag)
        } else if self.mTag is ST25DVCTag {
            readAreaSizes(tag: mTag as! ST25DVCTag)
        } else if self.mTag is ST25TV16KTag {
            readAreaSizes(tag: mTag as! ST25TV16KTag)
        } else if self.mTag is ST25TV64KTag {
            readAreaSizes(tag: mTag as! ST25TV64KTag)
        } else{
            UIHelper.warningAlert(viewController: self, title: "ST25 areas configuration ", message: "Tag does not support this feature")
        }

    }
    
    private func readAreaSizes(tag : ST25DVTag) {
        for index in ComStSt25sdkMultiAreaInterface_AREA1...ComStSt25sdkMultiAreaInterface_AREA4 {                  setAreaSizeInBytes(index,Int(tag.getAreaSizeInBytes(with: index)))
        }
    }
    
    private func readAreaSizes(tag : ST25DVCTag) {
        for index in ComStSt25sdkMultiAreaInterface_AREA1...ComStSt25sdkMultiAreaInterface_AREA4 {                  setAreaSizeInBytes(index,Int(tag.getAreaSizeInBytes(with: index)))
        }
    }
    
    private func readAreaSizes(tag : ST25TV64KTag) {
        for index in ComStSt25sdkMultiAreaInterface_AREA1...ComStSt25sdkMultiAreaInterface_AREA4 {                  setAreaSizeInBytes(index,Int(tag.getAreaSizeInBytes(with: index)))
        }
    }
    private func readAreaSizes(tag : ST25TV16KTag) {
        for index in ComStSt25sdkMultiAreaInterface_AREA1...ComStSt25sdkMultiAreaInterface_AREA4 {                  setAreaSizeInBytes(index,Int(tag.getAreaSizeInBytes(with: index)))
        }
    }
    
    // For Offset, we have to check if an areaSize exist for specified Area. If not, the Offset function will throw an error BAD PARAMETER
    private func readAreaOffset() {
        let mArea2Size = getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA2)
        let mArea3Size = getAreaSizeInBytes(ComStSt25sdkMultiAreaInterface_AREA3)
        
        var maxNbrOfAreaOffset = ComStSt25sdkMultiAreaInterface_AREA3
        if (mArea3Size <= 0){
            maxNbrOfAreaOffset = ComStSt25sdkMultiAreaInterface_AREA2
            setAreaOffsetInBytes(ComStSt25sdkMultiAreaInterface_AREA3,0)
        }
        if (mArea2Size <= 0){
            maxNbrOfAreaOffset = ComStSt25sdkMultiAreaInterface_AREA1
            setAreaOffsetInBytes(ComStSt25sdkMultiAreaInterface_AREA2,0)
        }
        for index in ComStSt25sdkMultiAreaInterface_AREA1...maxNbrOfAreaOffset {
            if self.mTag is ST25DVTag {
                setAreaOffsetInBytes(index,Int((mTag as! ST25DVTag).getAreaOffsetInBytes(with: index)))
            } else if self.mTag is ST25DVCTag {
                setAreaOffsetInBytes(index,Int((mTag as! ST25DVCTag).getAreaOffsetInBytes(with: index)))
            } else if self.mTag is ST25TV16KTag {
                setAreaOffsetInBytes(index,Int((mTag as! ST25TV16KTag).getAreaOffsetInBytes(with: index)))
            } else if self.mTag is ST25TV64KTag {
                setAreaOffsetInBytes(index,Int((mTag as! ST25TV64KTag).getAreaOffsetInBytes(with: index)))
            }
        }
    }
    
    private func writeAreaConfiguration() {
        if self.mTag is ST25DVTag {
            writeAreaConfiguration(tag: self.mTag as! ST25DVTag)
        } else if self.mTag is ST25DVCTag {
            writeAreaConfiguration(tag: self.mTag as! ST25DVCTag)
        } else if self.mTag is ST25TV16KTag {
            writeAreaConfiguration(tag: self.mTag as! ST25TV16KTag)
        } else if self.mTag is ST25TV64KTag {
            writeAreaConfiguration(tag: self.mTag as! ST25TV64KTag)
        } else{
            UIHelper.warningAlert(viewController: self, title: "ST25 areas configuration ", message: "Tag does not support this feature")
        }
   }
    
    private func writeAreaConfiguration(tag : ST25DVTag) {
        tag.presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25dvST25DVTag_ST25DV_CONFIGURATION_PASSWORD_ID), password: mST25DVConfigurationPwd)
        if tag.getMemSizeInBytes() > 512 {
            // custom method need to be used for jbyte capacity and values
            do  {
                try tag.setAreaEndValuesForHighDensityTags(endOfArea1: UInt8(mArea1ENDARegister), endOfArea2: UInt8(mArea2ENDARegister), endOfArea3: UInt8(mArea3ENDARegister))
            } catch {
                // Show alert
                UIHelper.warningAlert(viewController: self, title: "ST25 areas configuration ", message: "Wrong parameters")

            }
        } else {
            tag.setAreaEndValuesWithByte(Int8(mArea1ENDARegister), withByte: Int8(mArea2ENDARegister), withByte: Int8(mArea3ENDARegister))
        }
    }
    
    private func writeAreaConfiguration(tag : ST25DVCTag) {
        tag.presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25dvST25DVTag_ST25DV_CONFIGURATION_PASSWORD_ID), password: mST25DVConfigurationPwd)
        if tag.getMemSizeInBytes() > 512 {
            // custom method need to be used for jbyte capacity and values
            do  {
                try tag.setAreaEndValuesForHighDensityTags(endOfArea1: UInt8(mArea1ENDARegister), endOfArea2: UInt8(mArea2ENDARegister), endOfArea3: UInt8(mArea3ENDARegister))
            } catch {
                // Show alert
                UIHelper.warningAlert(viewController: self, title: "ST25 areas configuration ", message: "Wrong parameters")

            }
        } else {
            tag.setAreaEndValuesWithByte(Int8(mArea1ENDARegister), withByte: Int8(mArea2ENDARegister), withByte: Int8(mArea3ENDARegister))
        }
    }
    
    private func writeAreaConfiguration(tag : ST25TV16KTag) {
        tag.presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25dvST25TV16KTag.ST25TVHighDensity_CONFIGURATION_PASSWORD_ID), password: mST25DVConfigurationPwd)

        // custom method need to be used for jbyte capacity and values
        do  {
            try tag.setAreaEndValuesForHighDensityTags(endOfArea1: UInt8(mArea1ENDARegister), endOfArea2: UInt8(mArea2ENDARegister), endOfArea3: UInt8(mArea3ENDARegister))
        } catch {
            // Show alert
            UIHelper.warningAlert(viewController: self, title: "ST25 areas configuration ", message: "Wrong parameters")

        }
    }
    
    private func writeAreaConfiguration(tag : ST25TV64KTag) {
        tag.presentPassword(passwordNumber: UInt8(ComStSt25sdkType5St25dvST25TV16KTag.ST25TVHighDensity_CONFIGURATION_PASSWORD_ID), password: mST25DVConfigurationPwd)
        // custom method need to be used for jbyte capacity and values
        do  {
            try tag.setAreaEndValuesForHighDensityTags(endOfArea1: UInt8(mArea1ENDARegister), endOfArea2: UInt8(mArea2ENDARegister), endOfArea3: UInt8(mArea3ENDARegister))
        } catch {
            // Show alert
            UIHelper.warningAlert(viewController: self, title: "ST25 areas configuration ", message: "Wrong parameters")

        }
    }
    
    private func presentPwdController() {
       let mST25PasswordVC:ST25PasswordViewController = UIStoryboard(name: "ST25Password", bundle: nil).instantiateViewController(withIdentifier: "ST25PasswordID") as! ST25PasswordViewController
       mST25PasswordVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
       mST25PasswordVC.setTitle("Enter configuration password")
       mST25PasswordVC.setMessage("(64 bits hexadecimal format)")
       mST25PasswordVC.numberOfBytes = 8
       mST25PasswordVC.delegate = self
       self.present(mST25PasswordVC, animated: false, completion: nil)
   }

}

extension ST25DVAreaConfigurationViewController: tagReaderSessionViewControllerDelegate {

    func handleTag(st25SDKTag: ComStSt25sdkNFCTag, uid: Data!) throws {
        //mST25DVTag = st25SDKTag as? ST25DVTag
        mTag = st25SDKTag

        // Check if tag has changed
        if (!isSameTag(uid: uid)) {
            miOSReaderSession.stopTagReaderSession("Tag has changed, please scan again the Tag ...")
            return
        }
        
        
        switch mTaskToDo {
        case .readAreaConfiguration:
            //mST25TagMemorySize = Int(mST25DVTag.getMemSizeInBytes())
            readENDARegister()
            readAreaConfiguration()
            UIHelper.UI{
                self.initSliders()
                self.updateGraphic()
            }
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

extension ST25DVAreaConfigurationViewController: ST25PasswordViewDelegate {
    func okButtonTapped(pwdValue: Data) {
        self.mST25DVConfigurationPwd = pwdValue
        self.miOSReaderSession.startTagReaderSession()
    }

    func cancelButtonTapped() {
    }
}

extension UIView{
    func constraintWith(identifier: String) -> NSLayoutConstraint?{
        return self.constraints.first(where: {$0.identifier == identifier})
    }
}

extension UISlider{
    var newValue : Float {
        get { // get is needed
            return value
        }
        set(val) { // set is not needed, using only get gives you a read only property
            value=((Float(val) / Float(32)).rounded() * Float(32))
        }
    }
 }
