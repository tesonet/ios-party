import Foundation

struct Server: Codable {
    var distance: Int
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case distance
        case name
    }
}
