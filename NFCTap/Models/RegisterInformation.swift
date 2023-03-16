//
//  RegisterInformation.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 05/02/2020.
//  Copyright © 2020 STMicroelectronics. All rights reserved.
//

import Foundation


class RegisterInformation : NSObject {
    var mRegister : ComStSt25sdkSTRegister
    var isValueUpdated :Bool
    var mValue : Int
    var mRegisterValue : Int
    var islocked = false;

    init(register : ComStSt25sdkSTRegister) {
        self.mRegister = register
        self.isValueUpdated = false
        self.mRegisterValue = Int(register.getValue())
        self.mValue = mRegisterValue
    }
    init(register : ComStSt25sdkSTRegister, locked : Bool) {
        self.mRegister = register
        self.isValueUpdated = false
        self.mRegisterValue = Int(register.getValue())
        self.mValue = mRegisterValue
        self.islocked = locked
    }
    init(register : ComStSt25sdkSTRegister, newValue: Int) {
        self.mRegister = register
        self.mValue = newValue
        self.mRegisterValue = Int(register.getValue())
        if mValue == mRegisterValue {
            self.isValueUpdated = false
        } else {
            self.isValueUpdated = true
        }
    }
    func alignRegisterInformationValues () {
        mRegisterValue = mValue
        isValueUpdated = false
    }
}

class RegisterLibrary: NSObject {
    
    static let shared = RegisterLibrary()
    
    private(set) var registers: [RegisterInformation] = []
    
    func add(_ register: RegisterInformation) {
        registers.append(register)
        //print(register.description)
    }
    func update(_ register: RegisterInformation, index : Int) {
        registers[index] = register
        //print(register.description)
    }
    func clear() {
        registers.removeAll()
    }

}
