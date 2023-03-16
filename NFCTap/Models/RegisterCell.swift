//
//  RegisterCell.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 12/02/2020.
//  Copyright © 2020 STMicroelectronics. All rights reserved.
//

import UIKit

class RegisterCell : UITableViewCell{
    //var delegate : RegisterCellDelegate?
    static let CharacterLimit = 2
    static let CharacterLimit16Bits = 4
    static let CharacterLimit24Bits = 6
    static let CharacterLimit32Bits = 8
    static let RO = "RO"
    static let RW = "RW"
    static let LK = "Lck"

    var mTableView: UITableView!
    var factor = 0.6
    var isPositionned = false
    
    //var register : ComStSt25sdkSTRegister! {
        var registerInfo : RegisterInformation! {
        didSet {
            //productImage.image = UIImage(named: "wrench.fill")
            if (registerInfo.mRegister.isExtendedRegisterAddressingModeUsed()) {
                let myAddress = String(format:"%02X", (registerInfo.mRegister.getAddress()))
                let myParameterAddress = String(format:"%02X", (registerInfo.mRegister.getParameterAddress()))
                registerCellNameLabel.text = "\(myAddress) - \(myParameterAddress) \(registerInfo.mRegister.getName())"
            } else {
                registerCellNameLabel.text = registerInfo.mRegister.getName()
            }
            registerCellDescriptionLabel.text = registerInfo.mRegister.getContentDescription()
            var access = registerInfo.mRegister.getAccessRights() == ComStSt25sdkSTRegister_RegisterAccessRights.REGISTER_READ_ONLY ? "\(RegisterCell.RO)" : "\(RegisterCell.RW)"
            if (registerInfo.islocked) {
                access = RegisterCell.LK
            }
            registerCellPermissionLabel.text = access
            setRegisterValueToTextEditField()

            if (!isPositionned) {
                initCellPositionning()
                repositionningOfItems(factor: adjustPositionningFactor())
                isPositionned = true
            }
        }
    }

    private func adjustPositionningFactor() -> Float{
        var factor:Float = 0.6
        if registerCellValueLabel.text?.count == 4 {
            factor = 0.60
        } else if registerCellValueLabel.text?.count == 6 {
            factor = 0.65
        } else if registerCellValueLabel.text?.count == 8 {
            factor = 0.75
        }
        return factor
    }
    
    func setRegisterValueToTextEditField () {
        //registerInfo.mRegisterValue = Int(registerInfo.mRegister.getValue())
        if registerInfo.mRegister.getDataSize() == ComStSt25sdkSTRegister_RegisterDataSize.REGISTER_DATA_ON_16_BITS {
            registerCellValueLabel.text =  String(format:"%04X", (registerInfo.mRegisterValue))
        } else if registerInfo.mRegister.getDataSize() == ComStSt25sdkSTRegister_RegisterDataSize.REGISTER_DATA_ON_24_BITS {
            registerCellValueLabel.text =  String(format:"%06X", (registerInfo.mRegisterValue))
        } else if registerInfo.mRegister.getDataSize() == ComStSt25sdkSTRegister_RegisterDataSize.REGISTER_DATA_ON_32_BITS {
            registerCellValueLabel.text =  String(format:"%08X", (registerInfo.mRegisterValue))
        } else {
            registerCellValueLabel.text =  String(format:"%02X", (registerInfo.mRegisterValue))
        }
        

        
    }
    func setRegisterValueToTextEditField (value : Int) {
        registerInfo.mValue = value
        if registerInfo.mRegister.getDataSize() == ComStSt25sdkSTRegister_RegisterDataSize.REGISTER_DATA_ON_16_BITS {
            registerCellValueLabel.text =  String(format:"%04X", value)
        } else if registerInfo.mRegister.getDataSize() == ComStSt25sdkSTRegister_RegisterDataSize.REGISTER_DATA_ON_24_BITS {
            registerCellValueLabel.text =  String(format:"%06X", value)
        } else if registerInfo.mRegister.getDataSize() == ComStSt25sdkSTRegister_RegisterDataSize.REGISTER_DATA_ON_32_BITS {
            registerCellValueLabel.text =  String(format:"%08X", value)
        } else {
            registerCellValueLabel.text =  String(format:"%02X", value)
        }
        if (getRegisterUpdatedValue(registerInfo: registerInfo) != getRegisterLegacyValue(registerInfo: registerInfo)) {
            registerCellValueLabel.backgroundColor = .stLightGreenColor()
            //registerInfo.isValueUpdated = true
            //registerCellValueLabel.reloadInputViews()

        }
    }
    
    func getRegisterUpdatedValue (registerInfo : RegisterInformation) -> String {
        let value = registerInfo.mValue
        var item : String = ""
        if registerInfo.mRegister.getDataSize() == ComStSt25sdkSTRegister_RegisterDataSize.REGISTER_DATA_ON_16_BITS {
            item =  String(format:"%04X", value)
        } else if registerInfo.mRegister.getDataSize() == ComStSt25sdkSTRegister_RegisterDataSize.REGISTER_DATA_ON_24_BITS {
            item =  String(format:"%06X", value)
        } else if registerInfo.mRegister.getDataSize() == ComStSt25sdkSTRegister_RegisterDataSize.REGISTER_DATA_ON_32_BITS {
            item =  String(format:"%08X", value)
        } else {
            item =  String(format:"%02X", value)
        }
        return item
    }
 
    func getRegisterLegacyValue (registerInfo : RegisterInformation) -> String {
        let value = registerInfo.mRegisterValue
        var item : String = ""
        if registerInfo.mRegister.getDataSize() == ComStSt25sdkSTRegister_RegisterDataSize.REGISTER_DATA_ON_16_BITS {
            item =  String(format:"%04X", value)
        } else if registerInfo.mRegister.getDataSize() == ComStSt25sdkSTRegister_RegisterDataSize.REGISTER_DATA_ON_24_BITS {
            item =  String(format:"%06X", value)
        } else if registerInfo.mRegister.getDataSize() == ComStSt25sdkSTRegister_RegisterDataSize.REGISTER_DATA_ON_32_BITS {
            item =  String(format:"%08X", value)
        } else {
            item =  String(format:"%02X", value)
        }
        return item
    }

    private let productImage : UIImageView = {
        let imgView = UIImageView(image: UIImage(named: "wrench.fill"))
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        return imgView
    }()
    
    private let registerCellNameLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0

        return lbl
    }()
    
    
    let registerCellDescriptionLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 10)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    let registerCellValueLabel : UITextField = {
        let tfl = UITextField()
        tfl.textColor = .black
        tfl.font = UIFont.boldSystemFont(ofSize: 24)
        tfl.textAlignment = .right
        tfl.keyboardType = UIKeyboardType.asciiCapable
        
        return tfl
    }()
    
    let registerCellPermissionLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 10)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
    

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //addSubview(productImage)
        self.contentView.addSubview(registerCellNameLabel)
        self.contentView.addSubview(registerCellDescriptionLabel)
        self.contentView.addSubview(registerCellPermissionLabel)
        self.contentView.addSubview(registerCellValueLabel)
        registerCellValueLabel.delegate = self
        
//        if (!isPositionned) {
//            initCellPositionning()
//            repositionningOfItems(factor: adjustPositionningFactor())
//            isPositionned = true
//        }
        // productImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 20, height: 0, enableInsets: false)

        registerCellValueLabel.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        registerCellValueLabel.delegate = self

    }
    
    private func initCellPositionning() {
        //registerCellPermissionLabel.anchor(top: topAnchor, left: registerCellNameLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 20 , height: 0, enableInsets: false)
        //registerCellValueLabel.anchor(top: registerCellPermissionLabel.bottomAnchor, left: registerCellNameLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0 , height: 0, enableInsets: false)

        registerCellPermissionLabel.anchor(top: topAnchor, left: nil, bottom: nil, right: self.contentView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 20 , height: 0, enableInsets: false)
        registerCellValueLabel.anchor(top: registerCellPermissionLabel.bottomAnchor, left: nil, bottom: nil, right: self.contentView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0 , height: 0, enableInsets: false)

        //registerCellValueLabel.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        //registerCellValueLabel.delegate = self

    }
    private func repositionningOfItems(factor : Float) {
        registerCellNameLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: frame.size.width * CGFloat(factor) , height: 0, enableInsets: false)

        registerCellDescriptionLabel.anchor(top: registerCellNameLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: frame.size.width * CGFloat(factor) , height: 0, enableInsets: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    @objc func handleTextChange(_ textChange: UITextField) {
        if (registerInfo.mRegister.getAccessRights() == ComStSt25sdkSTRegister_RegisterAccessRights.REGISTER_READ_ONLY  ||
            registerInfo.islocked) {
            textChange.textColor = .black
            registerInfo.isValueUpdated = false
        } else {
            if textChange.text!.count < getNumberOfCharacters() {
                textChange.textColor = .stRedColor()
                registerInfo.isValueUpdated = false
            } else {
                let newVal = Int(textChange.text!)
                if newVal != nil {
                    // string contains a number
                    registerInfo.mValue = Int(newVal!)
                    let val : Int = registerInfo.mRegisterValue
                    //print ("\(newVal) - \(val)")
                    
                    if val != newVal! {
                        registerInfo.isValueUpdated = true
                        textChange.textColor = .black
                        textChange.backgroundColor = .stLightGreenColor()
                    } else {
                        textChange.textColor = .black
                        registerInfo.isValueUpdated = false
                    }
                } else {
                    // string do not contains number
                    // test if changes
                    let val = getRegisterUpdatedValue(registerInfo: registerInfo)
                    if (val != "" && val != textChange.text!) {
                        textChange.textColor = .black
                        textChange.backgroundColor = .stLightGreenColor()
                        let scanner = Scanner(string: textChange.text!)
                        var value: UInt64 = 0

                        if scanner.scanHexInt64(&value) {
                            //print("Decimal: \(value)")
                            //print("Hex: 0x\(String(value, radix: 16))")
                        }
                        registerInfo.mValue = Int(value)
                        registerInfo.isValueUpdated = true

                    } else {
                        textChange.textColor = .black
                        registerInfo.isValueUpdated = false
                    }

                }
            }

        }
        textChange.reloadInputViews()
    }
    



    private func getNumberOfCharacters() -> Int {
        var nbCharacters = RegisterCell.CharacterLimit
        if registerInfo.mRegister.getDataSize() == ComStSt25sdkSTRegister_RegisterDataSize.REGISTER_DATA_ON_16_BITS {
            nbCharacters = RegisterCell.CharacterLimit16Bits
        }
        if registerInfo.mRegister.getDataSize() == ComStSt25sdkSTRegister_RegisterDataSize.REGISTER_DATA_ON_32_BITS {
            nbCharacters = RegisterCell.CharacterLimit32Bits
        }
        if registerInfo.mRegister.getDataSize() == ComStSt25sdkSTRegister_RegisterDataSize.REGISTER_DATA_ON_24_BITS {
            nbCharacters = RegisterCell.CharacterLimit24Bits
        }
        return nbCharacters
    }
    
    func configureValueField() {
        let ro = "\(RegisterCell.RO)".elementsEqual((registerCellPermissionLabel.text)!) ||
            "\(RegisterCell.LK)".elementsEqual((registerCellPermissionLabel.text)!)
        //print(ro)
        if ro  {
            // no action
            registerCellValueLabel.isEnabled = false
            registerCellValueLabel.isUserInteractionEnabled = false
            registerCellValueLabel.backgroundColor = .stLightGreyColor()

        } else {
            if registerInfo.isValueUpdated {
                registerCellValueLabel.isEnabled = true
                registerCellValueLabel.isUserInteractionEnabled = true
                registerCellValueLabel.backgroundColor = .stLightGreenColor()
            } else {
                registerCellValueLabel.isEnabled = true
                registerCellValueLabel.isUserInteractionEnabled = true
                registerCellValueLabel.backgroundColor = .stLightBlueColor()
            }

        }
        registerCellValueLabel.layer.cornerRadius = 10.0
        
    }
}


extension RegisterCell: UITextFieldDelegate {
    // UITextFieldDelegate method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
     {
        textField .resignFirstResponder()
        return true;
     }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        //self.view.endEditing(true)
        self.registerCellValueLabel.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // get the current text, or use an empty string if that failed
        let currentText = textField.text ?? ""

        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }

        // add their new text to the existing text

        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)

        // make sure the result is under getNumberOfCharacters characters
        // Regx For XXX textField : only accept Hex Values
        let range = NSRange(location: 0, length: string.utf8.count)
        let regex = try! NSRegularExpression(pattern: "[A-Fa-f0-9]")
        
        return prospectiveText.count <= getNumberOfCharacters() && (regex.firstMatch(in: string, options: [], range: range) != nil || string.utf8.count == 0)

    }
}

extension UIView {
    
    func anchor (top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat, enableInsets: Bool) {
        var topInset = CGFloat(0)
        var bottomInset = CGFloat(0)
        
        if #available(iOS 11, *), enableInsets {
            let insets = self.safeAreaInsets
            topInset = insets.top
            bottomInset = insets.bottom
            
            //print("Anchor top: \(topInset)")
            //print("Anchor bottom: \(bottomInset)")
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop+topInset).isActive = true
        }
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom-bottomInset).isActive = true
        }
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
    }
}

