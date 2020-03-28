//
//  AppDelegate.swift
//  lightningMenu
//
//  Created by zaru on 2020/03/28.
//  Copyright © 2020年 zaru. All rights reserved.
//

import Cocoa
import Magnet

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    
    var statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

    var menuWindow: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = statusItem.button {
            button.image = NSImage(named: "StatusImage")
        }

        if let keyCombo = KeyCombo(keyCode: 46, carbonModifiers: 4352) {
            let hotKey = HotKey(identifier: "CommandControlM", keyCombo: keyCombo, target: self, action: #selector(openMenu))
            hotKey.register()
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        HotKeyCenter.shared.unregisterAll()
    }
    
    @objc func openMenu() {
        print("key press cmd ctrl m")
        
        menuWindow = MenuWindow()
        let menuView = MenuView()
        menuWindow.contentView?.addSubview(menuView)
        menuView.makeMenu()

    }

    // TODO: なぜかここにセレクタのメソッドがないとメニューが有効にならない、あとで調べる
    @objc func hogeSelected(sender: AnyObject) {
        NSLog("hoge")
    }

}

