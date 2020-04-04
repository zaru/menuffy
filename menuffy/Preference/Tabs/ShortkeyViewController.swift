//
//  SettingsViewController.swift
//  lightningMenu
//
//  Created by zaru on 2020/04/03.
//  Copyright © 2020 zaru. All rights reserved.
//

import Cocoa
import KeyHolder
import Magnet

class ShortkeyViewController: NSViewController {
    @IBOutlet weak var mainShortkeyRecordView: RecordView!

    override func loadView() {
        super.loadView()
        mainShortkeyRecordView.delegate = self
        let keyCombo = KeyCombo(keyCode: 46, carbonModifiers: 4352)
        mainShortkeyRecordView.keyCombo = keyCombo
    }
}

extension ShortkeyViewController: RecordViewDelegate {
    func recordViewShouldBeginRecording(_ recordView: RecordView) -> Bool {
        return true
    }

    func recordView(_ recordView: RecordView, canRecordKeyCombo keyCombo: KeyCombo) -> Bool {
        return true
    }

    func recordViewDidClearShortcut(_ recordView: RecordView) {
        if let keyCombo = KeyCombo(keyCode: 46, carbonModifiers: 4352) {
            ShortkeyManager().setMainShortkey(keyCombo: keyCombo)
        }
    }

    func recordView(_ recordView: RecordView, didChangeKeyCombo keyCombo: KeyCombo) {
        UserDefaults.standard.set(keyCombo.keyCode, forKey: "keyCode")
        UserDefaults.standard.set(keyCombo.modifiers, forKey: "modifiers")
        ShortkeyManager().setMainShortkey(keyCombo: keyCombo)
    }

    func recordViewDidEndRecording(_ recordView: RecordView) {
    }

}
