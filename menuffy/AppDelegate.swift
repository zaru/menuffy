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

    var menuWindow: NSWindow!
    var menuView: MenuView!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        LoginServiceManager().loadConfig()

        let shortkeyManager = ShortkeyManager()
        shortkeyManager.saveDefaultMainShortkey()
        shortkeyManager.loadMainShortkey()

        if let button = statusItem.button {
            button.image = NSImage(named: "StatusImage")
        }

        addStatusIconMenu()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        ShortkeyManager().unregisterAll()
    }

    func controlTextDidChange(_ notification: Notification) {
        let textField = notification.object as? NSTextField
        menuView.filterMenuItem(keyword: textField!.stringValue)
    }

    func addStatusIconMenu() {
        let menu = NSMenu()

        let preferenceMenu = NSMenuItem(title: NSLocalizedString("Preference", comment: ""),
                                        action: #selector(openPreference), keyEquivalent: "")
        menu.addItem(preferenceMenu)

        let quitMenu = NSMenuItem(title: NSLocalizedString("Quit", comment: ""),
                                  action: #selector(quit), keyEquivalent: "")
        menu.addItem(quitMenu)

        statusItem.menu = menu
    }

    @objc func openMenu() {
        if !isEnableAccesibility() {
            showAccesibilityModal()
            return
        }

        let app = activeApp()
        let pid = app.processIdentifier

        let location = NSEvent.mouseLocation
        menuWindow = MenuWindow(locationX: location.x, locationY: location.y)

        menuView = MenuView()
        menuView.appMenu.delegate = self
        menuWindow.contentView?.addSubview(menuView)
        menuView.makeMenu(pid)
    }

    func showAccesibilityModal() {
        let options = NSDictionary(
            object: kCFBooleanTrue ?? true,
            forKey: kAXTrustedCheckOptionPrompt.takeUnretainedValue() as NSString
            ) as CFDictionary

        AXIsProcessTrustedWithOptions(options)
    }

    func activeApp() -> NSRunningApplication {
        let runningApps = NSWorkspace.shared.runningApplications
        let activeApp = runningApps.filter { $0.isActive }[0]
        return activeApp
    }

    func isEnableAccesibility() -> Bool {
        if AXIsProcessTrusted() {
            return true
        }
        return false
    }

    // TODO: なぜかここにセレクタのメソッドがないとメニューが有効にならない、あとで調べる
    @objc func pressMenu(sender: NSMenuItem) {
        AXUIElementPerformAction(menuView.allElements[sender.tag], kAXPressAction as CFString)
    }

    @objc func quit(sender: NSButton) {
        NSApplication.shared.terminate(self)
    }

    @objc func openPreference(sender: NSButton) {
        NSApp.activate(ignoringOtherApps: true)
        PreferenceWindowController.sharedController.showWindow(nil)
    }

}

// MARK: NSMenuDelegate
extension AppDelegate: NSMenuDelegate {
    func menuDidClose(_ menu: NSMenu) {
        menuWindow.close()
    }
}

// MARK: NSTextFieldDelegate
extension AppDelegate: NSTextFieldDelegate {
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        // TODO: ここで↓キーが押されたら、強制的にフォーカスして、Tab ↓ ↓ と入力されるように調整している
        // これによって検索時に↓を押せばメニューにフォーカスできるようになるが、実装が不恰好なので直す
        if commandSelector == #selector(NSResponder.moveDown(_:)) {
            menuWindow.makeFirstResponder(menuView)
            let source = CGEventSource(stateID: CGEventSourceStateID.hidSystemState)
            let tabEvent = CGEvent(keyboardEventSource: source, virtualKey: 0x30, keyDown: true)
            tabEvent?.post(tap: CGEventTapLocation.cghidEventTap)
            let source2 = CGEventSource(stateID: CGEventSourceStateID.hidSystemState)
            let downArrowEvent = CGEvent(keyboardEventSource: source2, virtualKey: 0x7d, keyDown: true)
            downArrowEvent?.post(tap: CGEventTapLocation.cghidEventTap)
        }
        return false
    }
}
