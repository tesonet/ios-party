import Foundation

private let TokenDefaultsKey = "TokenDefaultsKey"

struct TokenService {
    static func token() -> String? {
        return UserDefaults.standard.object(forKey: TokenDefaultsKey) as? String
    }
    
    static func saveToken(token: String) {
        UserDefaults.standard.set(token, forKey: TokenDefaultsKey)
    }
    
    static func removeToken() {
        UserDefaults.standard.removeObject(forKey: TokenDefaultsKey)
    }
}
