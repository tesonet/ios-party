import Foundation
import UIKit

enum TSURL {
	static let loginUrl = "http://playground.tesonet.lt/v1/tokens"
	static let listUrl = "http://playground.tesonet.lt/v1/servers"
}

enum Key {
	static let username = "username"
	static let password = "password"
	static let token = "token"
}

enum Color {
	static let tableViewBackground: UIColor = UIColor(white: 248.0/255.0, alpha: 1.0)
}
