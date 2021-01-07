
import Foundation


class DefaultSession: Session {

    private let sessionTokenKey = "Session.token"
    
    private(set) var token: String? {
        set {
            UserDefaults.standard.set(newValue,
                                      forKey: sessionTokenKey)
        }
        get {
            return UserDefaults.standard.value(forKey: sessionTokenKey) as? String
        }
    }
    
    
    // MARK: - Public
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


// MARK: - AppDelegate + createSession
extension AppDelegate {
    
    func createSession() -> Session {
        return DefaultSession()
    }
}
