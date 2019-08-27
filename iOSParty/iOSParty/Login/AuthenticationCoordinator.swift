import UIKit
import UserInterface
import Authentication
import User

protocol AuthenticationCoordinatorDelegate: class {
    func auhtenticationCompleted()
}

final class AuthenticationCoordinator: NSObject {
    
    weak var delegate: AuthenticationCoordinatorDelegate?
    
    private lazy var loginVC: UIViewController = {
        let vc = UserInterface().loginVC(actionResponder: self)
        vc.view.translatesAutoresizingMaskIntoConstraints = true
        return vc
    }()
}

extension AuthenticationCoordinator {
    
    var viewController: UIViewController {
        return loginVC
    }
}

extension AuthenticationCoordinator: LoginVCActionResponder {
    
    func loginVCDidSelectLogin(with loginData: LoginData) {
        Authentication().getAuthenticationToken(with: loginData.userName, password: loginData.password) { error, data in
            DispatchQueue.main.async {
                if let error = error {
                    self.showAlert(error)
                    return
                }
                guard
                    let data = data,
                    let tokenData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
                    let token = tokenData["token"] as? String
                    else {
                        self.showAlert(AuthenticationError.dataError)
                        return
                }
                User().setUser(username: loginData.userName, token: token)
                self.delegate?.auhtenticationCompleted()
            }
        }
    }
}

extension AuthenticationCoordinator {
    
    private func showAlert(_ error: Error) {
        if let error = error as? AuthenticationError {
            
            let alertInfo: (title: String, message: String) = {
                switch error {
                case .serverError: return (title: "That's embarasing", message: "Our fort has fallen down. Please try again later")
                case .unauthorised: return (title: "Wrong login details", message: "We can not verify your credentials. Please check your username and password are correct and try again later")
                case .dataError, .badResponse: return (title: "Whoops!", message: "Something went terribly wrong. Please try again later")
                }
            }()
            
            let alert = UIAlertController(title: alertInfo.title, message: alertInfo.message, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            viewController.present(alert, animated: true, completion: nil)
        }
    }
}
