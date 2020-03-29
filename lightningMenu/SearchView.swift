//
//  SearchView.swift
//  lightningMenu
//
//  Created by zaru on 2020/03/29.
//  Copyright © 2020年 zaru. All rights reserved.
//

import Cocoa

class SearchView: NSView {
    
    init() {
        super.init(frame: NSMakeRect(0, 0, 200, 50))

        self.wantsLayer = true
        self.layer?.backgroundColor = .black
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
