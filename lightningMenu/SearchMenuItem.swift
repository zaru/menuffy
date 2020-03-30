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

        searchField = NSTextField(frame: NSMakeRect(0, 0, 150, 20))
        
        let appDelegate = NSApplication.shared.delegate as! AppDelegate
        searchField.delegate = appDelegate
        
        self.view = searchField
    }
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    func setNextKeyView(view: NSView) {
        searchField.nextKeyView = view
    }
}
