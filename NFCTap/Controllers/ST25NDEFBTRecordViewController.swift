//
//  ST25NDEFBTRecordViewController.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 15/04/2020.
//  Copyright © 2020 STMicroelectronics. All rights reserved.
//

import UIKit
import CoreBluetooth

class ST25NDEFBTRecordViewController: ST25UIViewController {
    
    var delegate:NdefRecordReady?
    
    // ST25SDK NDEF Records
    var mComStSt25sdkNdefBTRecord:ComStSt25sdkNdefBtRecord!
    var mComStSt25sdkNdefBTLeRecord:ComStSt25sdkNdefBtLeRecord!
    var mAction: actionOnRecordToDo = .add
    var isBTLe = false
    

    
    // Properties
    private var centralManager: CBCentralManager!
    var peripherals:[CBPeripheral] = []
    private var peripheral: CBPeripheral!
    
    private let DEFAULT_MAC = "00:11:22:33:44:55"
    private let DEFAULT_MAC_NB_ADDRESS_LENGTH = 17
    
    private var mListNameScheme = [
        "MyBTDevice"
    ]
    private var mIndexListNameScheme:Int!
    
    private var mListMACScheme = [
        "11:22:33:44:55:66"
    ]
    private var mIndexListMACScheme:Int!
    
    
    private var mBckName:String?
    private var mBckMac : String?
    private var updateEditionFieldWithPicker = true
    
    // For animation
    private var mDisplaylink: CADisplayLink?
    private var mStartAnimTime:Double = 0.0
    private var mCurrentLoopAnimTime:Double = 0.0
    private let mAnimTime:Double = 10.0
    var mTextLabelForBlinkingPosition = 0
    let mTextLabelForBlinking = ["Nearby devices list","Scanning BT Devices","Searching for BT devices","Scanning ongoing"]

    
    
    @IBOutlet weak var mEditDeviceNameField: UITextView!
    @IBOutlet weak var mEditMACAddressField: UITextView!
    
    @IBOutlet weak var mAvailableDevicePickerView: UIPickerView!
    
    @IBOutlet weak var mDevicesListLabel: UILabel!
    
    @IBAction func ValidateRecord(_ sender: Any) {
        if isNDEFRecordReady() {
            if isBTLe {
                delegate?.onRecordReady(action: mAction, record: updateNDEFRecordBTLeMessage())
            } else {
                delegate?.onRecordReady(action: mAction, record: updateNDEFRecordBTMessage())
            }
            self.dismiss(animated: false, completion: nil)
        } else {
            warningAlert(message: "Check that device name is not empty and/or MAC @ format  ")
        }
        
    }
    
    @IBAction func CancelRecord(_ sender: Any) {
        if isBTLe {
            delegate?.onRecordReady(action: .cancelled, record: updateNDEFRecordBTLeMessage())
        } else {
            delegate?.onRecordReady(action: .cancelled, record: updateNDEFRecordBTMessage())
        }
        self.dismiss(animated: false, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        mEditDeviceNameField.delegate = self
        mEditMACAddressField.delegate = self
        
        mEditDeviceNameField.textContainer.maximumNumberOfLines = 1
        mEditMACAddressField.textContainer.maximumNumberOfLines = 1
        
        centralManager = CBCentralManager(delegate: self, queue: .main)
        
        
        mIndexListNameScheme = 1
        mAvailableDevicePickerView.delegate = self
        if isBTLe {
            if mComStSt25sdkNdefBTLeRecord != nil {
                mEditDeviceNameField.text = mComStSt25sdkNdefBTLeRecord.getBTDeviceName()
                mEditMACAddressField.text = ComStSt25sdkHelper.convertHexByteArrayToString(with: mComStSt25sdkNdefBTLeRecord.getBTDeviceMacAddr())
                mEditMACAddressField.text = mEditMACAddressField.text.replacingOccurrences(of: " ", with: ":")
                mEditMACAddressField.text = mEditMACAddressField.text.uppercased()
                updateOnPicker(name: mEditDeviceNameField.text, mac: mEditMACAddressField.text)
            }
        } else {
            if mComStSt25sdkNdefBTRecord != nil {
                mEditDeviceNameField.text = mComStSt25sdkNdefBTRecord.getBTDeviceName()
                mEditMACAddressField.text = ComStSt25sdkHelper.convertHexByteArrayToString(with: mComStSt25sdkNdefBTRecord.getBTDeviceMacAddr())
                mEditMACAddressField.text = mEditMACAddressField.text.replacingOccurrences(of: " ", with: ":")
                mEditMACAddressField.text = mEditMACAddressField.text.uppercased()
                updateOnPicker(name: mEditDeviceNameField.text, mac: mEditMACAddressField.text)
                
            }
        }
        
        // For label animation
        self.mDevicesListLabel.text = "Scan for nearby devices started"
        self.mTextLabelForBlinkingPosition = 0
        mStartAnimTime = CACurrentMediaTime()
        mCurrentLoopAnimTime = mStartAnimTime
        let mDisplaylink = CADisplayLink(target: self, selector: #selector(handleUpdate))
        mDisplaylink.add(to: .main, forMode: .default)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //scanBLEDevice()
        //centralManagerDidUpdateState(centralManager)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        centralManager?.stopScan()
    }
    
    private func updateNDEFRecordBTMessage() -> ComStSt25sdkNdefBtRecord {
        
        mComStSt25sdkNdefBTRecord = ComStSt25sdkNdefBtRecord()
        mComStSt25sdkNdefBTRecord.setBTDeviceNameWith(mEditDeviceNameField.text)
        let macAddr = ComStSt25sdkHelper.convertHexStringToByteArray(with: mEditMACAddressField.text.replacingOccurrences(of: ":", with: ""))
        mComStSt25sdkNdefBTRecord.setBTDeviceMacAddrWith(macAddr)
        
        return mComStSt25sdkNdefBTRecord
    }
    private func updateNDEFRecordBTLeMessage() -> ComStSt25sdkNdefBtLeRecord {
        
        mComStSt25sdkNdefBTLeRecord = ComStSt25sdkNdefBtLeRecord()
        mComStSt25sdkNdefBTLeRecord.setBTDeviceNameWith(mEditDeviceNameField.text)
        let macAddr = ComStSt25sdkHelper.convertHexStringToByteArray(with: mEditMACAddressField.text.replacingOccurrences(of: ":", with: ""))
        mComStSt25sdkNdefBTLeRecord.setBTDeviceMacAddrWith(macAddr)
        
        return mComStSt25sdkNdefBTLeRecord
    }
    
    private func isNDEFRecordReady() -> Bool {
        if (mEditDeviceNameField.text != "") && (mEditMACAddressField.text == "") {
            return true
        }
        if (mEditDeviceNameField.text != "" && mEditMACAddressField.text != "" &&  mEditMACAddressField.text.count == DEFAULT_MAC_NB_ADDRESS_LENGTH) {
            return true
        } else if (mEditDeviceNameField.text == "" && mEditMACAddressField.text != "" &&  mEditMACAddressField.text.count == DEFAULT_MAC_NB_ADDRESS_LENGTH) {
            return true
        } else {
            return false
        }
    }
    
    private func warningAlert(message : String) {
        UIHelper.warningAlert(viewController: self, title : "BT record" , message: message)
    }

    
    private func updateOnPicker(name : String, mac: String) {
        var defaultRowIndex = mListNameScheme.firstIndex(of: name)
        if(defaultRowIndex == nil) {
            // ssid not exist ....
            mListNameScheme.append(name)
            mListMACScheme.append(mac)
            mAvailableDevicePickerView.reloadAllComponents()
            defaultRowIndex = mListNameScheme.count - 1
        }
        mIndexListNameScheme = defaultRowIndex
        
        mAvailableDevicePickerView.selectRow(defaultRowIndex!, inComponent: 0, animated: false)
        
    }
    
    private func addBTDeviceOnPicker(name : String, mac: String) {
        
        self.updateEditionFieldWithPicker = false
        mListNameScheme.append(name)
        mListMACScheme.append(mac)
        mAvailableDevicePickerView.reloadAllComponents()
        self.updateEditionFieldWithPicker = true
    }
    
    private func backupCurrentEdition() {
        self.mBckName = self.mEditDeviceNameField.text
        self.mBckMac = self.mEditMACAddressField.text
    }
    
    private func restaureCurrentEdition(withAlertInfo : Bool) {
        //self.mEditDeviceNameField.becomeFirstResponder()
        if withAlertInfo {
            alertWithTitleOnUpdateListWithResponder(title: "BT Devices list", message: "The list of nearby devices has been updated", ViewController: self, toFocus: self.mEditDeviceNameField)
        }

    }
    

    func stopScanForBTDevice(){
        var pickerUpdated = false
        centralManager?.stopScan()
        print("scan stopped")
        if peripherals.count > 0 {
            self.backupCurrentEdition()
            
            for device in self.peripherals {
                if device.name != nil {
                    var defaultRowIndex = mListNameScheme.firstIndex(of: device.name!)
                    if(defaultRowIndex == nil) {
                        self.addBTDeviceOnPicker(name: device.name!, mac: self.DEFAULT_MAC)
                        pickerUpdated = true
                    }
                }
            }
            self.mDevicesListLabel.stopBlink()
            
            self.mDisplaylink?.isPaused = true
            self.mDisplaylink?.invalidate()
            self.mDisplaylink = nil
            
            self.mDevicesListLabel.text = mTextLabelForBlinking[0]

            self.restaureCurrentEdition(withAlertInfo: pickerUpdated)
        }
    }
    
    private func alertWithTitleOnUpdateListWithResponder(title: String!, message: String, ViewController: UIViewController, toFocus:UITextView) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel,handler: {_ in
            //toFocus.becomeFirstResponder()
            self.mEditDeviceNameField.text = self.mBckName
            self.mEditMACAddressField.text = self.mBckMac
        });
        alert.addAction(action)
        self.view.endEditing(true)
        ViewController.present(alert, animated: true, completion:nil)
    }
    

    @objc func handleUpdate() {
        let elapsed = CACurrentMediaTime() - self.mCurrentLoopAnimTime
        var ping = elapsed
        if ping > 1.0 {
            // Update every second
            self.mCurrentLoopAnimTime = CACurrentMediaTime()
            if (CACurrentMediaTime() - self.mStartAnimTime) > self.mAnimTime {
                // do nothing
            } else {
                if self.mTextLabelForBlinkingPosition < self.mTextLabelForBlinking.count {
                    self.mDevicesListLabel.text = self.mTextLabelForBlinking[self.mTextLabelForBlinkingPosition]
                    self.mTextLabelForBlinkingPosition = self.mTextLabelForBlinkingPosition+1
                }else{
                    self.mTextLabelForBlinkingPosition = 0
                }
            }
        }
    }
}


extension ST25NDEFBTRecordViewController: UITextViewDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var result = true
        
        if  textField == mEditMACAddressField {
            // get the current text, or use an empty string if that failed
            let currentText = textField.text ?? ""
            
            // attempt to read the range they are trying to change, or exit if we can't
            guard let stringRange = Range(range, in: currentText) else { return false }
            
            // add their new text to the existing text
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            // make sure the result is under 18 characters
            return updatedText.count <= DEFAULT_MAC_NB_ADDRESS_LENGTH
            
        }
        return result
        
    }

}

extension ST25NDEFBTRecordViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    /* Picker Delegate */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == mAvailableDevicePickerView {
            return mListNameScheme.count
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == mAvailableDevicePickerView {
            return self.mListNameScheme[row]
        }
        
        return "Not define"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == mAvailableDevicePickerView {
            return self.mIndexListNameScheme = row
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "System", size: 17)
            pickerLabel?.textAlignment = .center
        }
        if pickerView == mAvailableDevicePickerView {
            pickerLabel?.text =  self.mListNameScheme[row]
            if self.updateEditionFieldWithPicker {
                mEditDeviceNameField.text = self.mListNameScheme[row]
                mEditMACAddressField.text = self.mListMACScheme[row]
            }
            
            
        }
        pickerLabel?.textColor = UIColor.white
        
        return pickerLabel!
    }
    
}

// This part handle the discovery of BT devices
// No way to go more in depth at this stage
extension ST25NDEFBTRecordViewController: CBPeripheralDelegate, CBCentralManagerDelegate {
    // BT
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("Central state update")
        switch central.state {
        case .unknown:
            print("central.state is .unknown")
        case .resetting:
            print("central.state is .resetting")
        case .unsupported:
            print("central.state is .unsupported")
        case .unauthorized:
            print("central.state is .unauthorized")
        case .poweredOff:
            print("central.state is .poweredOff")
        case .poweredOn:
            print("central.state is .poweredOn")
            centralManager.scanForPeripherals(withServices: nil, options: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                self.stopScanForBTDevice()
            }
        @unknown default:
            print("central.state is unknown value!")
            
        }
    }
    
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("peripheral: \(peripheral)")
        peripherals.append(peripheral)
        centralManager.connect(peripheral, options: nil)
        peripheral.delegate = self
    }
    
    // Called when it succeeded
    func centralManager(central: CBCentralManager,
                        didConnectPeripheral peripheral: CBPeripheral)
    {
        print("connected!")
        peripheral.discoverServices(nil)
    }
    // Called when it failed
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("failed…")
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?)
    {
        if let error = error {
            print("error: \(error)")
            return
        }
        let services = peripheral.services
        print("Found \(services!.count) services! :\(services)")
        for service in services! {
            peripheral.discoverCharacteristics(nil, for: service)
        }
        //peripheral.discoverCharacteristics(nil, forService: service)
        
    }
    
    func peripheral(peripheral: CBPeripheral,
                    didDiscoverCharacteristicsForService service: CBService,
                    error: NSError?)
    {
        if let error = error {
            print("error: \(error)")
            return
        }
        
        let characteristics = service.characteristics
        print("Found \(characteristics!.count) characteristics!")
    }
    
    
    
    
    // MARK: CBPeripheralDelegate
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let theError = error {
            print("\(#function): error = \(theError.localizedDescription)")
            return
        }
        let services = peripheral.services! as [CBService]
        for service in services {
            print("\(#function): service = \(services)")
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let theError = error {
            print("\(#function): error = \(theError.localizedDescription)")
            return
        }
        let charcteristics = service.characteristics! as [CBCharacteristic]
        for characteristic in charcteristics {
            print("characteristic = \(characteristic) value = \(String(describing: characteristic.value)) UUID = \(characteristic.uuid) isNotifying = \(characteristic.isNotifying) isBroadcasted = \(characteristic.isBroadcasted)")
            // get descriptors for this characteristic
            peripheral.discoverDescriptors(for: characteristic)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        if let theError = error {
            print("\(#function): error = \(theError.localizedDescription)")
            return
        }
        let descriptors = characteristic.descriptors! as [CBDescriptor]
        for descriptor in descriptors {
            print("\(#function): descriptor = \(descriptor) UUID = \(descriptor.uuid) value = \(descriptor.value)")
        }
    }
    
    
}

// Not USED at this stage - Not working - keep for an other update if any
extension UILabel {
    func startBlink() {
        UIView.animate(withDuration: 0.8,//Time duration
            delay:0.2,
            options:[.allowUserInteraction, .curveEaseInOut, .autoreverse, .repeat],
            animations: { self.alpha = 0 },
            completion: nil)
    }
    
    func stopBlink() {
        layer.removeAllAnimations()
        alpha = 1
    }
}

// Not USED at this stage - keep for an other update if any
extension UIView {
    func blink() {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.isRemovedOnCompletion = false
        animation.fromValue           = 1
        animation.toValue             = 0
        animation.duration            = 0.8
        animation.autoreverses        = true
        animation.repeatCount         = 10
        animation.beginTime           = CACurrentMediaTime() + 0.5
        self.layer.add(animation, forKey: nil)
    }
}
