//
//  Menu.swift
//  lightningMenu
//
//  Created by zaru on 2020/03/28.
//  Copyright © 2020年 zaru. All rights reserved.
//

import Cocoa

class MenuView: NSView {
    func makeMenu() {
        let appMenu = NSMenu()
        let showPrefsMenuItem = NSMenuItem(title: "File", action: #selector(hogeSelected), keyEquivalent: "")
        let showPrefsMenuItem2 = NSMenuItem(title: "Edit", action: #selector(hogeSelected), keyEquivalent: "")
        let showPrefsMenuItem3 = NSMenuItem(title: "View", action: #selector(hogeSelected), keyEquivalent: "")
        let showPrefsMenuItem4 = NSMenuItem(title: "Find", action: #selector(hogeSelected), keyEquivalent: "")
        let showPrefsMenuItem5 = NSMenuItem(title: "Navigate", action: #selector(hogeSelected), keyEquivalent: "")
        let showPrefsMenuItem6 = NSMenuItem(title: "Editor", action: #selector(hogeSelected), keyEquivalent: "")
        appMenu.addItem(showPrefsMenuItem)
        appMenu.addItem(showPrefsMenuItem2)
        appMenu.addItem(showPrefsMenuItem3)
        appMenu.addItem(showPrefsMenuItem4)
        appMenu.addItem(showPrefsMenuItem5)
        appMenu.addItem(showPrefsMenuItem6)
        
        appMenu.popUp(positioning: nil, at: NSMakePoint(550, 550), in: self)
    }
    
    
    @objc func hogeSelected(sender: AnyObject) {
        NSLog("hoge")
    }
}
