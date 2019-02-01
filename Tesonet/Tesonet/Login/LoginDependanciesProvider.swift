import Foundation
import RxSwift

final class LoginDependanciesProvider: NSObject {
    let useMock = false
    
    fileprivate var loginRepository: LoginRepository?
    fileprivate var loginService: LoginService?
    fileprivate var loginInteractor: LoginInteractor?
    
    static let shared = LoginDependanciesProvider()

    // Repository
    
    fileprivate func repository() -> LoginRepository {
        return loginRepository ?? setupRepository()
    }
    
    fileprivate func setupRepository() -> LoginRepository {
        loginRepository = LoginRepository(service: service())
        return loginRepository!
    }
    
    // Service
    
    fileprivate func service() -> LoginService {
        return loginService ?? setupService()
    }
    
    fileprivate func setupService() -> LoginService {
        let network = Network()
        loginService = useMock ? LoginServiceMock(network: network) : LoginService(network: network)
        return loginService!
    }
    
    // Interactor
    
    func getLoginInteractor() -> LoginInteractor {
        return loginInteractor ?? setupLoginInteractor()
    }

    fileprivate func setupLoginInteractor() -> LoginInteractor {
        loginInteractor = LoginInteractor(repository: repository())
        return loginInteractor!
    }
}
