//
//  LoginViewController.swift
//  Tesonet
//

import UIKit
import Alamofire

class LoginViewController: UIKeyboardViewController {

    @IBOutlet weak var loginView: LoginView!
    @IBOutlet weak var loadingView: LoadingView!

    private var user: UserModel?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadingView.prepareView()
        loginView.prepareView { [weak self] in
            self?.logIn()
        }
        loadingView.isHidden = true
        loadingView.alpha = 0
        loginView.isHidden = false
        loginView.alpha = 1
    }

    // MARK: Actions

    func logIn() {
        guard let loginInfo = loginView.getLoginInfo() else {
            loginView.showError("LoginInfoError".localized)
            return
        }
        loginView.hideError()
        startLoading()
        view.endEditing(true)
        APIManager.sendRequest(RequestsManager.login(userName: loginInfo.userName, password: loginInfo.password), onSuccess: { [weak self] (response) in
            self?.user = UserModel(with: response.dictionaryObject)
            self?.fetchServers()
        }) { [weak self] (errorCode) in
            self?.showAlert(with: errorCode)
        }
    }

    private func fetchServers() {
        guard let user = user else {
            return
        }
        APIManager.sendRequest(RequestsManager.serversList(token: user.token), onSuccess: { [weak self] (response) in
            if let list = response.arrayObject as? [[String: Any]] {
                let servers = list.compactMap({ return ServerModel(with: $0) })
                self?.user = nil
                self?.loginView.clearLoginInfo()
                self?.navigationController?.pushViewController(ServerListViewController.instantiate(with: servers), animated: true)
            }
        }) { [weak self] (errorCode) in
            self?.showAlert(with: errorCode)
        }
    }

    private func startLoading() {
        loadingView.startLoading()
        loadingView.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            self.loginView.alpha = 0
            self.loadingView.alpha = 1
        }) { (_) in
            self.loginView.isHidden = true
        }
    }

    private func cancelLoading() {
        loadingView.stopLoading()
        UIView.animate(withDuration: 0.3, animations: {
            self.loginView.alpha = 1
            self.loadingView.alpha = 0
        }) { (_) in
            self.loginView.isHidden = false
            self.loadingView.isHidden = true
        }
    }

    private func showAlert(with errorCode: Int?) {
        let errorMessage: String
        if errorCode == 401 {
            errorMessage = "401".localized
        } else {
            errorMessage = "UnknownError".localized
        }
        let alertController: UIAlertController = UIAlertController(title: "", message: errorMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] (_) in
            self?.loginView.showError(errorMessage)
        }))
        cancelLoading()
        present(alertController, animated: true)
    }
}
