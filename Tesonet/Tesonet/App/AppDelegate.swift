import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Just for demo purposes since no initial data loaded so loading screen time is too short
        Thread.sleep(forTimeInterval: 1.0)

        // Realm
        Realm.Configuration.defaultConfiguration = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 1) {
                    //write the migration logic here
                }
        })
        print("Realm location: ", Realm.Configuration.defaultConfiguration.fileURL!)

        return true
    }
}

