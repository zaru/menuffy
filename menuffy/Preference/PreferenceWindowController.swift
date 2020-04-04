import Cocoa

class PreferenceWindowController: NSWindowController {

    static let sharedController = PreferenceWindowController(windowNibName: NSNib.Name("PreferenceWindow"))

    @IBOutlet weak var toolbar: NSToolbar!
    var tabs: [NSViewController] = []

    override func windowDidLoad() {
        super.windowDidLoad()

        tabs = [
            SettingsViewController(nibName: NSNib.Name("Settings"), bundle: nil),
            ShortkeyViewController(nibName: NSNib.Name("Shortkey"), bundle: nil)
        ]

        switchTab(0)
    }

    @IBAction func selectMenu(_ sender: NSToolbarItem) {
        switchTab(sender.tag)
    }

    func switchTab(_ index: Int) {
        removeViews()
        let viewController = tabs[index]
        window?.contentView?.addSubview(viewController.view)
    }

    func removeViews() {
        window?.contentView?.subviews.forEach { view in
            view.removeFromSuperview()
        }
    }
}
