//
//  LoginServiceManager.swift
//  lightningMenu
//
//  Created by zaru on 2020/04/04.
//  Copyright © 2020 zaru. All rights reserved.
//

import Foundation
import LoginServiceKit

class LoginServiceManager: NSObject {

    func saveConfig(_ state: Int) {
        UserDefaults.standard.set(state, forKey: "LoginService")
    }

    func getConfig() -> Int {
        return UserDefaults.standard.integer(forKey: "LoginService")
    }

    func loadConfig() {
        let config = UserDefaults.standard.integer(forKey: "LoginService")
        if config == 0 {
            LoginServiceKit.removeLoginItems()
        } else {
            LoginServiceKit.addLoginItems()
        }
    }

}
