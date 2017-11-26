import UIKit
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let window = UIWindow.init(frame: UIScreen.main.bounds)
    let authController = AuthViewController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        window.rootViewController = authController
        window.makeKeyAndVisible()
        return true
    }
}

