import Foundation

fileprivate let tokenKey: String = "token"

class StorageHelper {
	class func getSavedToken() -> String? {
		return UserDefaults.standard.string(forKey: tokenKey)
	}
	
	class func saveToken(_ token: String?) {
		if let token = token {
			UserDefaults.standard.set(token, forKey: tokenKey)
		}
		else {
			UserDefaults.standard.removeObject(forKey: tokenKey)
		}
	}
}
