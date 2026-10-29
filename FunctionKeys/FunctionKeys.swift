import Cocoa

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var item: NSStatusItem!
    private var toggleItem: NSMenuItem!
    private var timer: Timer?
    private let key = "com.apple.keyboard.fnState" as CFString
    private func mode() -> Bool {
        CFPreferencesSynchronize(kCFPreferencesAnyApplication, kCFPreferencesCurrentUser, kCFPreferencesAnyHost)
        return (CFPreferencesCopyValue(key, kCFPreferencesAnyApplication, kCFPreferencesCurrentUser, kCFPreferencesAnyHost) as? NSNumber)?.boolValue ?? false
    }
    func applicationDidFinishLaunching(_ notification: Notification) {
        item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        let menu = NSMenu()
        toggleItem = NSMenuItem(title: "", action: #selector(toggle), keyEquivalent: "")
        toggleItem.target = self
        menu.addItem(toggleItem)
        menu.addItem(NSMenuItem.separator())
        let hint = NSMenuItem(title: "Hold Fn to use the other mode", action: nil, keyEquivalent: "")
        menu.addItem(hint)
        menu.addItem(NSMenuItem.separator())
        let quit = NSMenuItem(title: "Quit Function Keys", action: #selector(quitApp), keyEquivalent: "q")
        quit.target = self
        menu.addItem(quit)
        item.menu = menu
        refresh()
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { [weak self] _ in self?.refresh() }
    }
    private func refresh() {
        let standard = mode()
        item.button?.title = standard ? "F1" : "Fn"
        item.button?.toolTip = standard ? "F1–F12 mode" : "Brightness and volume mode"
        toggleItem.title = standard ? "Switch to brightness / volume keys" : "Switch to F1–F12 keys"
    }
    @objc private func toggle() {
        let oldMode = mode()
        CFPreferencesSetValue(key, NSNumber(value: !oldMode), kCFPreferencesAnyApplication, kCFPreferencesCurrentUser, kCFPreferencesAnyHost)
        guard CFPreferencesSynchronize(kCFPreferencesAnyApplication, kCFPreferencesCurrentUser, kCFPreferencesAnyHost) else {
            showError("macOS could not save the keyboard setting.")
            return
        }
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings")
        process.arguments = ["-u"]
        process.standardOutput = FileHandle.nullDevice
        process.standardError = FileHandle.nullDevice
        do {
            try process.run()
            process.waitUntilExit()
            if process.terminationStatus != 0 { showError("macOS saved the setting but could not apply it immediately. Check System Settings → Keyboard → Keyboard Shortcuts → Function Keys.") }
        } catch { showError(error.localizedDescription) }
        refresh()
    }
    private func showError(_ message: String) {
        let alert = NSAlert()
        alert.messageText = "Function Keys"
        alert.informativeText = message
        NSApp.activate(ignoringOtherApps: true)
        alert.runModal()
    }
    @objc private func quitApp() { NSApp.terminate(nil) }
}
let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.setActivationPolicy(.accessory)
app.run()
