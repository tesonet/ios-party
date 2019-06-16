struct AuthorizationResponse: Decodable {
    
    let message: String?
    let token: String
}

struct ServicesResponse: Decodable {
    
    let servers: [[String: String]]
}
