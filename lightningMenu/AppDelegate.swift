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
class AppDelegate: NSObject, NSApplicationDelegate, NSTextFieldDelegate {

    @IBOutlet weak var window: NSWindow!

    var statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

    var menuWindow: NSWindow!
    var menuView: MenuView!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = statusItem.button {
            button.image = NSImage(named: "StatusImage")
        }

        if let keyCombo = KeyCombo(keyCode: 46, carbonModifiers: 4352) {
            let hotKey = HotKey(identifier: "MainShortkey",
                                keyCombo: keyCombo, target: self, action: #selector(openMenu))
            hotKey.register()
        }

        addStatusIconMenu()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        HotKeyCenter.shared.unregisterAll()
    }

    func controlTextDidChange(_ notification: Notification) {
        let textField = notification.object as? NSTextField
        print(textField?.stringValue ?? "")
        menuView.filterMenuItem(keyword: textField!.stringValue)
    }

    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        print("control")
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

    func addStatusIconMenu() {
        let menu = NSMenu()

        let preferenceMenu = NSMenuItem(title: "Preference", action: #selector(openPreference), keyEquivalent: "")
        menu.addItem(preferenceMenu)

        let quitMenu = NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: "")
        menu.addItem(quitMenu)

        statusItem.menu = menu
    }

    @objc func openMenu() {
        print("key press cmd ctrl m")
        let app = activeApp()
        let pid = app.processIdentifier

        menuWindow = MenuWindow()
        menuView = MenuView()
        menuView.appMenu.delegate = self
        menuWindow.contentView?.addSubview(menuView)
        menuView.makeMenu(pid)
    }

    func activeApp() -> NSRunningApplication {
        let runningApps = NSWorkspace.shared.runningApplications
        let activeApp = runningApps.filter { $0.isActive }[0]
        return activeApp
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
        let preferenceWindow = PreferenceWindowController()
        PreferenceWindowController.sharedController.showWindow(nil)
    }

}

extension AppDelegate: NSMenuDelegate {
    func menuDidClose(_ menu: NSMenu) {
        menuWindow.close()
    }
}
