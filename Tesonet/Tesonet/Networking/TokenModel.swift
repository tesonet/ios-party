import Foundation

struct Token: Codable {
    var token: String
    
    enum CodingKeys: String, CodingKey {
        case token
    }
}
