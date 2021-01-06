
import UIKit
import CoreData


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let sessionContext = createSessionContext()
        let sessionController = SessionViewController()
        sessionController.sessionContext = sessionContext
        
        window!.rootViewController = sessionController
        window!.makeKeyAndVisible()
        
        return true
    }
}

