//
//  MenuWindow.swift
//  lightningMenu
//
//  Created by zaru on 2020/03/28.
//  Copyright © 2020年 zaru. All rights reserved.
//

import Cocoa

class MenuWindow : NSWindow {
    
    override init(contentRect: NSRect,
                  styleMask style: NSWindow.StyleMask,
                  backing backingStoreType: NSWindow.BackingStoreType,
                  defer flag: Bool) {

        let screenFrame = NSScreen.main!.frame
        let x = screenFrame.width / 2 - 100
        let y = screenFrame.height / 2 + 100

        super.init(contentRect: NSMakeRect(x, y, 200, 50),
                   styleMask: [.borderless],
                   backing: .buffered,
                   defer: false)

        self.isOpaque = false
        self.hasShadow = false
        self.backgroundColor = NSColor.clear
        self.makeKeyAndOrderFront(nil)
        self.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        self.level = NSWindow.Level.floating
        self.isMovableByWindowBackground = true
        
    }
}
