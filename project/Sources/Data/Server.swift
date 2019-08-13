import Foundation

class Server {
	var name: String = ""
	var distance: Int = 0
	
	enum Keys: String {
		case name = "name"
		case distance = "distance"
	}
	
	init(name: String, distance: Int) {
		self.name = name
		self.distance = distance
	}
}
