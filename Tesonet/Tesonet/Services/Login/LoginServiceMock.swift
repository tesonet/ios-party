import RxSwift

class LoginServiceMock: LoginService {
    override func retrieveToken(with params: LoginData) -> Single<String> {
        let json = """
    {
        "token": "f9731b590611a5a9377fbd02f247fcdf"
    }
"""
        
        guard let data = json.data(using: .utf8) else {
            return Single.just("")
        }
        
        let decoder = JSONDecoder()
        do {
            let token = try decoder.decode(Token.self, from: data)
            return  Single.just(token.token)
        } catch {
            return Single.just("")
        }
    }
}
