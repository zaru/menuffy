import Cocoa

class PreferenceWindowController: NSWindowController {

    static let sharedController = PreferenceWindowController(windowNibName: NSNib.Name("PreferenceWindow"))

    override func windowDidLoad() {
        super.windowDidLoad()
    }
}
