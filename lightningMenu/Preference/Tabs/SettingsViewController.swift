//
//  SettingsViewController.swift
//  lightningMenu
//
//  Created by zaru on 2020/04/03.
//  Copyright © 2020 zaru. All rights reserved.
//

import Cocoa
import LoginServiceKit

class SettingsViewController: NSViewController {

    let loginServiceManager = LoginServiceManager()
    @IBOutlet weak var loginServiceButton: NSButton!

    override func loadView() {
        super.loadView()

        let config = loginServiceManager.getConfig()
        loginServiceButton.state = NSControl.StateValue(rawValue: config)
    }

    @IBAction func toggleLoginService(_ sender: NSButton) {
        loginServiceManager.saveConfig(sender.state.rawValue)
        loginServiceManager.loadConfig()
    }
}
