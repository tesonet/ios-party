extension Server: Decodable {
    private enum CodingKeys: String, CodingKey {
        case distance
        case name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        distance = try container.decodeIfPresent(Int.self, forKey: .distance)
        name = try container.decodeIfPresent(String.self, forKey: .name)
    }
}
