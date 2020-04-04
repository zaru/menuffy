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
    private (set) public var allElements: [AXUIElement] = []
    var allMenuItems: [NSMenuItem] = []
    var menuIndex: Int = 0
    var topLevelMenuNum: Int = 0

    // 検索用フィールドからフォーカスを移すために必要なフラグ
    override var acceptsFirstResponder: Bool {
        return true
    }

    func increment(element: AXUIElement, menuItem: NSMenuItem) {
        allElements.append(element)
        allMenuItems.append(menuItem)
        menuIndex += 1
    }

    func filterMenuItem(keyword: String) {
        // 検索時は既存のトップレベルメニューを隠す、空なら表示する
        let hidden = keyword == "" ? false : true
        for index in 1...topLevelMenuNum {
            let item = appMenu.items[index]
            item.isHidden = hidden
        }

        let startHitIndex = topLevelMenuNum + 1

        for _ in startHitIndex..<appMenu.items.count {
            // remove した時に index が上に詰まっていくので削除対象のインデックスは常に同じ
            if appMenu.items.indices.contains(startHitIndex) {
                appMenu.removeItem(at: startHitIndex)
            }
        }

        for item in allMenuItems {
            if item.title.localizedCaseInsensitiveContains(keyword) {
                guard let copyItem = item.copy() as? NSMenuItem else { continue }
                appMenu.addItem(copyItem)
            }
        }
    }

    func reset() {
        allElements = []
        allMenuItems = []
        menuIndex = 0
        topLevelMenuNum = 0
    }

    func makeMenu(_ pid: pid_t) {
        reset()

        let searchItem = SearchMenuItem()
        searchItem.setNextKeyView(view: self)
        appMenu.addItem(searchItem)

        let items = getMenuItems(pid)
        topLevelMenuNum = items.count
        buildAllMenu(items)

        appMenu.popUp(positioning: nil, at: NSPoint.zero, in: self)
    }

    func getMenuItems(_ pid: pid_t) -> [AXUIElement] {
        let appRef = AXUIElementCreateApplication(pid)
        var menubar: CFTypeRef?
        let status: AXError = AXUIElementCopyAttributeValue(appRef, kAXMenuBarAttribute as CFString, &menubar)
        if status == AXError.success && menubar != nil {
            // TODO: ここで強制キャストをせずに渡す方法が見つからなかった、もしあれば直したい
            // swiftlint:disable:next force_cast
            return getChildren(menubar as! AXUIElement)
        } else {
            let options = NSDictionary(
                object: kCFBooleanTrue ?? true,
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
            let position = getAttribute(element: element, name: kAXPositionAttribute)
            let title = getTitle(element)

            if position == nil {
                continue
            }

            if title == "" {
                subMenu.addItem(NSMenuItem.separator())
            } else {
                let subMenuItem = NSMenuItem(title: title, action: #selector(AppDelegate.pressMenu), keyEquivalent: "")
                subMenuItem.tag = menuIndex
                increment(element: element, menuItem: subMenuItem)
                subMenu.addItem(subMenuItem)

                let lastMenuItems = getChildren(element)
                if lastMenuItems.count > 0 {
                    buildLastMenu(subElement: lastMenuItems[0], subMenuItesm: subMenuItem)
                }
            }

        }
    }

    func buildLastMenu(subElement: AXUIElement, subMenuItesm: NSMenuItem) {
        let lastMenu = NSMenu()
        subMenuItesm.submenu = lastMenu

        let lastElements = getChildren(subElement)
        for element in lastElements {
            let position = getAttribute(element: element, name: kAXPositionAttribute)
            let enabled = getEnabled(element)
            let title = getTitle(element)

            if position == nil {
                continue
            }

            if title == "" {
                lastMenu.addItem(NSMenuItem.separator())
            } else if enabled {
                let lastMenuItem = NSMenuItem(title: title, action: #selector(AppDelegate.pressMenu), keyEquivalent: "")
                lastMenuItem.tag = menuIndex
                increment(element: element, menuItem: lastMenuItem)
                lastMenu.addItem(lastMenuItem)
            } else {
                let lastMenuItem = NSMenuItem(title: title, action: nil, keyEquivalent: "")
                lastMenu.addItem(lastMenuItem)
            }
        }
    }

    func getChildren(_ element: AXUIElement) -> [AXUIElement] {
        let children = getAttribute(element: element, name: kAXChildrenAttribute)
        if children == nil {
            return []
        }
        if let childrenElements = children as? [AXUIElement] {
            return childrenElements
        }
        return []
    }

    func getTitle(_ element: AXUIElement) -> String {
        let title = getAttribute(element: element, name: kAXTitleAttribute)
        if title != nil, let titleString = title as? String {
            return titleString
        }
        return ""
    }

    func getEnabled(_ element: AXUIElement) -> Bool {
        let enabled = getAttribute(element: element, name: kAXEnabledAttribute)
        if enabled != nil, let enabledBool = enabled as? Bool {
            return enabledBool
        }
        return false
    }

    func getAttribute(element: AXUIElement, name: String) -> CFTypeRef? {
        var value: CFTypeRef?
        AXUIElementCopyAttributeValue(element, name as CFString, &value)
        return value
    }
}
