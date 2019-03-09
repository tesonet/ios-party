import RxSwift

class LoginInteractor {
    let repository: LoginRepository
    
    init(repository: LoginRepository) {
        self.repository = repository
    }

    func request(with params: LoginData) -> Single<String> {
        return repository.retrieveToken(with: params)
    }
}
