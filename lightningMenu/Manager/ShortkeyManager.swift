//
//  ShortkeyManager.swift
//  lightningMenu
//
//  Created by zaru on 2020/04/04.
//  Copyright © 2020 zaru. All rights reserved.
//

import Foundation
import Magnet

class ShortkeyManager: NSObject {

    let mainIdentifier = "MainShortkey"

    func setMainShortkey(keyCombo: KeyCombo) {
        if let appDelegate = NSApplication.shared.delegate as? AppDelegate {
            HotKeyCenter.shared.unregisterHotKey(with: mainIdentifier)
            let hotKey = HotKey(identifier: mainIdentifier,
                                keyCombo: keyCombo,
                                target: appDelegate,
                                action: #selector(appDelegate.openMenu))
            hotKey.register()
        }
    }

    func saveDefaultMainShortkey() {
        UserDefaults.standard.register(defaults: ["keyCode": 46, "modifiers": 4352, "LoginService": 1])
    }

    func loadMainShortkey() {

        let keyCode = UserDefaults.standard.integer(forKey: "keyCode")
        let modifiers = UserDefaults.standard.integer(forKey: "modifiers")
        if let keyCombo = KeyCombo(keyCode: keyCode, carbonModifiers: modifiers) {
            ShortkeyManager().setMainShortkey(keyCombo: keyCombo)
        }

    }

    func unregisterAll() {
        HotKeyCenter.shared.unregisterAll()
    }

}
