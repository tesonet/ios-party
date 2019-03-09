import RxSwift

class LoginRepository {
    let service: LoginService
    
    init(service: LoginService) {
        self.service = service
    }
    
    func retrieveToken(with params: LoginData) -> Single<String> {
        return service.retrieveToken(with: params)
    }
}
