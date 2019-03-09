struct LoginData {
    let username: String
    let password: String
}

extension LoginData {
    func toJson() -> [String : String] {
        return ["username" : username, "password": password]
    }
}
