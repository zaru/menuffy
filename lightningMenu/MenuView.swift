//
//  Menu.swift
//  lightningMenu
//
//  Created by zaru on 2020/03/28.
//  Copyright © 2020年 zaru. All rights reserved.
//

import Cocoa

class MenuView: NSView {
    
    var appMenu: NSMenu = NSMenu()
    
    func makeMenu(_ pid: pid_t) {
        let items = getMenuItems(pid)
        buildAllMenu(items)
        
        appMenu.popUp(positioning: nil, at: NSMakePoint(550, 550), in: self)
    }
    
    func getMenuItems(_ pid: pid_t) -> [AXUIElement] {
        let appRef = AXUIElementCreateApplication(pid)
        var menubar: CFTypeRef?
        let status:AXError = AXUIElementCopyAttributeValue(appRef, kAXMenuBarAttribute as CFString, &menubar)
        if status == AXError.success {
            return getChildren(menubar as! AXUIElement)
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
    
    func buildAllMenu(_ elements: [AXUIElement]) {
        for element in elements {
            var title = getTitle(element)
            if title == "Apple" {
                title = ""
            }
            print("menu item: \(title)")
            
            let item = NSMenuItem(title: title, action: nil, keyEquivalent: "")
            appMenu.addItem(item)
            
            buildSubMenu(mainElement: element, mainMenuItesm: item)
        }
    }
    
    func buildSubMenu(mainElement: AXUIElement, mainMenuItesm: NSMenuItem) {
        let subMenu = NSMenu()
        mainMenuItesm.submenu = subMenu
        
        let subElements = getChildren(mainElement)
        for subElement in subElements {
            let subMenuItems = getChildren(subElement)
            buildSubMenuItems(subMenuItemsElements: subMenuItems, subMenu: subMenu)
        }
    }
    
    func buildSubMenuItems(subMenuItemsElements: [AXUIElement], subMenu: NSMenu) {
        for element in subMenuItemsElements {
            let title = getTitle(element)
            print("submenu item: \(title)")
            if title == "" {
                subMenu.addItem(NSMenuItem.separator())
            } else {
                let showPrefsMenuItem = NSMenuItem(title: title, action: #selector(hogeSelected), keyEquivalent: "")
                subMenu.addItem(showPrefsMenuItem)
            }
        }
    }
    
    func getChildren(_ element: AXUIElement) -> [AXUIElement] {
        var children: CFTypeRef?
        AXUIElementCopyAttributeValue(element, kAXChildrenAttribute as CFString, &children)
        if children == nil {
            return []
        }
        return children as! [AXUIElement]
    }
    
    func getTitle(_ element: AXUIElement) -> String {
        var title: CFTypeRef?
        AXUIElementCopyAttributeValue(element, kAXTitleAttribute as CFString, &title)
        if title == nil {
            return ""
        }
        return title as! String
    }
    
    @objc func hogeSelected(sender: AnyObject) {
        NSLog("hoge")
    }
}
