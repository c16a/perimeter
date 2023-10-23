import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)
    self.titlebarAppearsTransparent = true
    self.isOpaque = false
    self.titleVisibility = TitleVisibility.hidden
    self.styleMask = [.fullSizeContentView, .titled, .resizable]

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
