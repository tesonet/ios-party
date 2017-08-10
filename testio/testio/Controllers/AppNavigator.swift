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
        startupVC.onServersLoaded = { [weak self] servers in
            self?.switchToServerList(with: servers)
        }
        window.rootViewController = startupVC
        window.makeKeyAndVisible()
    }
    
    // MARK: Navigation
    
    func switchToServerList(with servers: Servers) {
        let serversVC = ServerListViewController.initWithNib()
        serversVC.servers = servers
        serversVC.onLogOut = { [weak self] in
            self?.switchToLogin()
        }
        transition(from: window.rootViewController!, to: serversVC)
    }
    
    func switchToLogin() {
        let startupVC = StartupViewController.initWithNib()
        startupVC.onServersLoaded = { [weak self] servers in
            self?.switchToServerList(with: servers)
        }
        transition(from: window.rootViewController!, to: startupVC)
    }
    
    private func transition(from fromVC: UIViewController, to toVC: UIViewController) {
        toVC.view.frame = fromVC.view.frame
        toVC.view.layoutIfNeeded()
        UIView.transition(
            from: fromVC.view,
            to: toVC.view,
            duration: 0.3,
            options: [.transitionCrossDissolve], completion: { _ in
                self.window.rootViewController = toVC
        })
    }
}
