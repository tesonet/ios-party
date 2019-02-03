import UIKit
import RxSwift
import RxKeyboard

class LoginViewController: UIViewController {
    @IBOutlet fileprivate weak var usernameTextField: UITextField!
    @IBOutlet fileprivate weak var passwordTextField: UITextField!
    @IBOutlet fileprivate weak var scrollView: UIScrollView!
    
    fileprivate var loginViewModel =
        LoginViewModel(loginInteractor: LoginDependanciesProvider.shared.getLoginInteractor())
    fileprivate let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginViewModel.delegate = self
        setupKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLogin()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dch_checkDeallocation()
        usernameTextField.text = nil
        passwordTextField.text = nil
    }
}

// MARK: - Navigation

extension LoginViewController {
    @IBAction fileprivate func loginPressed() {
        loginViewModel.retrieveToken(with: createLoginData())
    }
}

// MARK: - LoginViewControllerDelegate

extension LoginViewController: LoginViewControllerDelegate {
    func moveToServersList() {
        self.performSegue(withIdentifier: "SegueToServers", sender: self)
    }
}

// MARK: - Privates

extension LoginViewController {
    fileprivate func setupLogin() {
        if UserSession.shared.isCrudentialsSaved {
            usernameTextField.text = UserSession.shared.signInDetails?.username
            passwordTextField.text = UserSession.shared.signInDetails?.password
        }
    }
    
    fileprivate func setupKeyboard() {
        hideKeyboardWhenTappedAround()
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [scrollView] keyboardVisibleHeight in
                scrollView?.contentInset.bottom = keyboardVisibleHeight
            })
            .disposed(by: disposeBag)
    }
    
    fileprivate func createLoginData() -> LoginData {
        #if DEBUG
        let username = "tesonet"
        let password = "partyanimal"
        #else
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        #endif
        
        return LoginData(username: username, password: password)
    }
}
