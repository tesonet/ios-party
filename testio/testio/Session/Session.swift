
import Foundation


protocol Session {
    
    var token: String? { get }
    var isActive: Bool { get }
    func activate(with token: String)
    func deactivate()
}


extension AppDelegate {
    
    func createSession() -> Session {
        return DefaultSession()
    }
}


class DefaultSession: Session {

    private(set) var token: String? {
        set {
            UserDefaults.standard
                .set(newValue,
                     forKey: "Session.token")
        }
        get {
            return UserDefaults.standard
                .value(forKey: "Session.token") as? String
        }
    }
    
    var isActive: Bool {
        return token != nil
    }
    
    func activate(with token: String) {
        self.token = token
    }
    
    func deactivate() {
        token = nil
    }
}
