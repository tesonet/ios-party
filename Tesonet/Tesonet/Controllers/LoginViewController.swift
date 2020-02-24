//
//  LoginViewController.swift
//  Tesonet
//

import UIKit

class LoginViewController: UIKeyboardViewController {

    @IBOutlet weak var loginView: LoginView!
    @IBOutlet weak var loadingView: LoadingView!

    override func viewDidLoad() {
        super.viewDidLoad()
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
        view.endEditing(true)
        navigationController?.pushViewController(ServerListViewController.instantiate(with: [
            ServerModel(serverName: "Test1", distanceToServer: "1100km"),
            ServerModel(serverName: "Test2", distanceToServer: "500km"),
            ServerModel(serverName: "Test3", distanceToServer: "9900km"),
            ServerModel(serverName: "Test4", distanceToServer: "12300km"),
            ServerModel(serverName: "Test5", distanceToServer: "140km"),
            ServerModel(serverName: "Test6", distanceToServer: "100km"),
            ServerModel(serverName: "Test7", distanceToServer: "1100km"),
            ServerModel(serverName: "Test8", distanceToServer: "13500km"),
            ServerModel(serverName: "Test9", distanceToServer: "120km"),
            ServerModel(serverName: "Test10", distanceToServer: "140km")]), animated: true)
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
}
