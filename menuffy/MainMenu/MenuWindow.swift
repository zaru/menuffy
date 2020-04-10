//
//  MenuWindow.swift
//  lightningMenu
//
//  Created by zaru on 2020/03/28.
//  Copyright © 2020年 zaru. All rights reserved.
//

import Cocoa

// NSWindow だと NSTextField が active にならないので NSPanel にする
class MenuWindow: NSPanel {

    init(locationX: CGFloat, locationY: CGFloat) {
        super.init(contentRect: NSRect(x: locationX, y: locationY, width: 200, height: 50),
                   styleMask: [.nonactivatingPanel],
                   backing: .buffered,
                   defer: false)

        self.isOpaque = false
        self.hasShadow = false
        self.backgroundColor = NSColor.clear
        self.makeKeyAndOrderFront(nil)
        self.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        self.level = NSWindow.Level.floating
    }

    override var canBecomeKey: Bool {
        return true
    }
}
