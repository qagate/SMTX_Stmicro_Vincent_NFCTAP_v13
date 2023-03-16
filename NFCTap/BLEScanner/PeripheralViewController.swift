//
//  PeripheralTableViewController.swift
//  ST25NFCApp
//
//  Created by STMicroelectronics on 13/06/2017.
//  Copyright © 2017 STMicroelectronics. All rights reserved.
//

import CoreBluetooth
import UIKit

struct DisplayPeripheral{
	var peripheral: CBPeripheral?
	var lastRSSI: NSNumber?
	var isConnectable: Bool?
}

class PeripheralViewController: ST25UIViewController {
    
    @IBOutlet weak var bluetoothIcon: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
	
	@IBOutlet weak var scanningButton: ScanButton!
	
    var centralManager: CBCentralManager!
    var peripherals: [DisplayPeripheral] = []
	var viewReloadTimer: Timer!
	var selectedPeripheral: CBPeripheral?
    
    // NDEF BTLE Device Name. HID by default
    var ndefBTLEName:String = "HID"
	
	@IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Initialise CoreBluetooth Central Manager
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
        //startScanning()
        viewReloadTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(PeripheralViewController.refreshScanView), userInfo: nil, repeats: true)
    }
    
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		viewReloadTimer?.invalidate()
	}
    
    func setNdefBtleName(name: String){
        ndefBTLEName = name
    }
    
	func updateViewForScanning(){
		statusLabel.text = "Scanning BLE Devices...".localized
		bluetoothIcon.pulseAnimation()
		bluetoothIcon.isHidden = false
		scanningButton.buttonColorScheme(true)
	}
	
	func updateViewForStopScanning(){
		let plural = peripherals.count > 1 ? "Devices".localized : "Device".localized
        statusLabel.text = "\(peripherals.count) \(plural)"+" "+"Found".localized
		bluetoothIcon.layer.removeAllAnimations()
		bluetoothIcon.isHidden = true
		scanningButton.buttonColorScheme(false)
	}
	
	@IBAction func scanningButtonPressed(_ sender: AnyObject){
		if centralManager!.isScanning{
			centralManager?.stopScan()
            if (selectedPeripheral != nil){
                centralManager?.cancelPeripheralConnection(selectedPeripheral!)
            }
			updateViewForStopScanning()
		}else{
			startScanning()
		}
	}
	
	func startScanning(){
		peripherals = []
		self.centralManager?.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
        updateViewForScanning()
		let triggerTime = (Int64(NSEC_PER_SEC) * 30)
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(triggerTime) / Double(NSEC_PER_SEC), execute: { () -> Void in
			if self.centralManager!.isScanning{
				self.centralManager?.stopScan()
				self.updateViewForStopScanning()
			}
		})
	}
	
    @objc func refreshScanView()
	{
		if peripherals.count > 1 && centralManager!.isScanning{
			tableView.reloadData()
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let destinationViewController = segue.destination as? PeripheralConnectedViewController{
			destinationViewController.peripheral = selectedPeripheral
            destinationViewController.centralManager = centralManager
		}
	}
    
}


extension PeripheralViewController: CBCentralManagerDelegate{
     func centralManagerDidUpdateState(_ central: CBCentralManager){
		if (central.state == .poweredOn){
            print ("Start Scanning")
			startScanning()
		}else{
            print ("Stoped Scanning")
			// do something like alert the user that ble is not on
		}
	}
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber){
		//print ("didDiscover peripheral")
		for (index, foundPeripheral) in peripherals.enumerated(){
			if foundPeripheral.peripheral?.identifier == peripheral.identifier{
				peripherals[index].lastRSSI = RSSI
				return
			}
		}
		
		let isConnectable = advertisementData["kCBAdvDataIsConnectable"] as! Bool
		let displayPeripheral = DisplayPeripheral(peripheral: peripheral, lastRSSI: RSSI, isConnectable: isConnectable)
		peripherals.append(displayPeripheral)
		tableView.reloadData()
        
        // Trying connection to device
        if peripheral.name == ndefBTLEName.localized || peripheral.name == "bluenrg"  {
            if peripheral.state != .connected {
                selectedPeripheral = peripheral
                peripheral.delegate = self
                centralManager?.connect(peripheral, options: nil)
            }
        }
	}
}

extension PeripheralViewController: CBPeripheralDelegate {
	func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
		print("Error connecting peripheral: \(error?.localizedDescription)")
	}
	
	func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
		print("Peripheral connected")
		//performSegue(withIdentifier: "PresentPeripheralConnectedViewController", sender: self)
		//peripheral.discoverServices(nil)
        
        //playSound(for: "ST25DVDemo",type: "mp3")
        
        /*
        let scheme : String = "https://www.youtube.com/watch?v=UP5Ng-9pNBo"
        if let url = URL(string: scheme) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:],
                                          completionHandler: {
                                            (success) in
                                            print("Open \(scheme): \(success)")
                })
            } else {
                // Fallback on earlier versions
            }
        }
 */
        
        let mPeripheralConnectedViewController: PeripheralConnectedViewController = UIStoryboard(name: "NDEFRecordsAction", bundle: nil).instantiateViewController(withIdentifier: "PeripheralConnectedViewController") as! PeripheralConnectedViewController
        mPeripheralConnectedViewController.peripheral = peripheral
        mPeripheralConnectedViewController.peripheral?.discoverServices(nil)
        
        self.present(mPeripheralConnectedViewController, animated: true, completion: nil)

        }
}

extension PeripheralViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
		
		let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell")! as! DeviceTableViewCell
		cell.displayPeripheral = peripherals[indexPath.row]
		cell.delegate = self
		return cell
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
		return peripherals.count
	}
}

extension PeripheralViewController: DeviceCellDelegate{
	func connectPressed(_ peripheral: CBPeripheral) {
		if peripheral.state != .connected {
			selectedPeripheral = peripheral
			peripheral.delegate = self
			centralManager?.connect(peripheral, options: nil)
		}
	}
}

