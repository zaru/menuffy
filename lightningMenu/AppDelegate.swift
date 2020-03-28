//
//  AppDelegate.swift
//  lightningMenu
//
//  Created by zaru on 2020/03/28.
//  Copyright © 2020年 zaru. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    
    var statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = statusItem.button {
            button.image = NSImage(named: "StatusImage")
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

