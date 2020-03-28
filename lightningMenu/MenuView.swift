//
//  Menu.swift
//  lightningMenu
//
//  Created by zaru on 2020/03/28.
//  Copyright © 2020年 zaru. All rights reserved.
//

import Cocoa

class MenuView: NSView {
    func makeMenu(_ pid: pid_t) {
        let appMenu = NSMenu()

        let items = getMenuItems(pid)
        for item in items {
            var menuLabel: CFTypeRef?
            AXUIElementCopyAttributeValue(item as! AXUIElement, kAXTitleAttribute as CFString, &menuLabel)
            var title = menuLabel as! String
            if title == "Apple" {
                title = ""
            }
            print("menu item: \(title)")
            let showPrefsMenuItem = NSMenuItem(title: title, action: #selector(hogeSelected), keyEquivalent: "")
            appMenu.addItem(showPrefsMenuItem)

            let subMenu = NSMenu()
            showPrefsMenuItem.submenu = subMenu
            
            var subMenuRef: CFTypeRef?
            AXUIElementCopyAttributeValue(item as! AXUIElement, kAXChildrenAttribute as CFString, &subMenuRef)
            let subitems = subMenuRef as! NSArray
            for subitem in subitems {
                var subMenuItemsRef: CFTypeRef?
                AXUIElementCopyAttributeValue(subitem as! AXUIElement, kAXChildrenAttribute as CFString, &subMenuItemsRef)
                let subMenuItems = subMenuItemsRef as? NSArray
                for item in subMenuItems! {
                    var menuLabel: CFTypeRef?
                    AXUIElementCopyAttributeValue(item as! AXUIElement, kAXTitleAttribute as CFString, &menuLabel)
                    if menuLabel != nil {
                        var title = menuLabel as! String
                        print("submenu item: \(title)")
                        if title == "" {
                            subMenu.addItem(NSMenuItem.separator())
                        } else {
                            
                            let showPrefsMenuItem = NSMenuItem(title: title, action: #selector(hogeSelected), keyEquivalent: "")
                            subMenu.addItem(showPrefsMenuItem)
                        }
                    }
                }
            }
        }
        
        appMenu.popUp(positioning: nil, at: NSMakePoint(550, 550), in: self)
    }
    
    
    @objc func hogeSelected(sender: AnyObject) {
        NSLog("hoge")
    }
    
    func getMenuItems(_ pid: pid_t) -> NSArray {
        let appRef = AXUIElementCreateApplication(pid)
        var menubar: CFTypeRef?
        let status:AXError = AXUIElementCopyAttributeValue(appRef, kAXMenuBarAttribute as CFString, &menubar)
        if status == AXError.success {
            var children: CFTypeRef?
            AXUIElementCopyAttributeValue(menubar as! AXUIElement, kAXChildrenAttribute as CFString, &children)
            let items = children as! NSArray
            return items
        } else {
            print("open accesibility permission dialog")
            let options = NSDictionary(
                object: kCFBooleanTrue,
                forKey: kAXTrustedCheckOptionPrompt.takeUnretainedValue() as NSString
                ) as CFDictionary
            
            AXIsProcessTrustedWithOptions(options)
        }
        return []
    }
}
