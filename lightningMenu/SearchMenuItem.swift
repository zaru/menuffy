//
//  SearchMenuItem.swift
//  lightningMenu
//
//  Created by zaru on 2020/03/30.
//  Copyright © 2020年 zaru. All rights reserved.
//

import Cocoa

class SearchMenuItem: NSMenuItem {

    var searchField: NSTextField!

    override init(title string: String, action selector: Selector?, keyEquivalent charCode: String) {
        super.init(title: string, action: selector, keyEquivalent: charCode)

        let view = NSView(frame: NSRect(x: 0, y: 0, width: 160, height: 30))

        searchField = NSTextField(frame: NSRect(x: 20, y: 8, width: 140, height: 20))
        searchField.wantsLayer = true
        let border = CALayer()
        border.frame = CGRect(x: 0, y: 19, width: 140, height: 1)
        border.backgroundColor = NSColor(red: 220/255, green: 220/255, blue: 225/255, alpha: 0.8).cgColor
        searchField.layer?.addSublayer(border)

        searchField.isBezeled = false
        searchField.drawsBackground = false
        searchField.focusRingType = .none
        searchField.placeholderString = "search menu"

        let appDelegate = NSApplication.shared.delegate as! AppDelegate
        searchField.delegate = appDelegate

        view.addSubview(searchField)
        self.view = view
    }

    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }

    func setNextKeyView(view: NSView) {
        searchField.nextKeyView = view
    }
}
