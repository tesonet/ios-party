import UIKit

class AppNavigator {
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        setupWindow()
    }
    
    // MARK: Setup
    
    func setupWindow() {
        let startupVC = StartupViewController.initWithNib()
        startupVC.onServersLoaded = { [weak self] servers in }
        window.rootViewController = startupVC
        window.makeKeyAndVisible()
    }
}
