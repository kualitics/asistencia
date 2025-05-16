//
//  BeaconController.swift
//  TraccarClient
//
//  Created by Ussiel on 02/05/25.
//  Copyright © 2025 Traccar. All rights reserved.
//

import Foundation
import kbeaconlib2

class BeaconController: Thread, KBeaconMgrDelegate {
    
    var mBeaconsDictory = [String:KBeacon]()
    var mBeaconsMgr: KBeaconsMgr?
    private var mSelectedBeacon : KBeacon?
    var mBeaconsArray = [KBeacon]()
    
    override init(){
        super.init()
        
        //mBeaconsMgr = KBeaconsMgr?//.sharedBeaconManager()
        mBeaconsMgr!.delegate = self
    }
    
    override func start() {
        let t = Thread(target: self, selector: #selector(run), object: "helloworld")
        t.start()
    }
    
    @objc func run(){
        //mBeaconsMgr?.startScanning()
        let nStartScan = self.mBeaconsMgr?.startScanning()
        if (nStartScan == 0)
        {
            NSLog("start scan success");
            
        }
        else if (nStartScan == SCAN_ERROR_BLE_NOT_ENABLE) {
            NSLog("error: BLE function is not enable")
            
        }
        else if (nStartScan == SCAN_ERROR_NO_PERMISSION) {
            NSLog("error: BLE scanning has no location permission")
        }
        else
        {
            NSLog("error: BLE scanning unknown error")
        }
    }
    
    func stop(){
        mBeaconsMgr?.stopScanning()
    }
    
    func onBeaconDiscovered(_ beacons:[KBeacon])
    {
        NSLog("******** Discover")
        for beacon in beacons
        {
            NSLog(beacon.uuidString)
            if mBeaconsDictory[beacon.uuidString] != nil
            {
                mBeaconsArray.append(beacon)
                
                NSLog(beacon.name)
                //NSLog(beacon.mac)
            }
            mBeaconsDictory[beacon.uuidString] = beacon
            
        }
        mBeaconsMgr?.stopScanning()
    }
    
    func onCentralBleStateChange(_ newState:BLECentralMgrState)
    {
        NSLog("***** central ble")
        if (newState == BLECentralMgrState.statePowerOn)
        {
            //the app can start scan in this case
            NSLog("central ble state power on")
        }
    }
}
