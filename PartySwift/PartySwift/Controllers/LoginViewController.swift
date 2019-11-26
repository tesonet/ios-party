//
//  ViewController.swift
//  PartySwift
//
//  Created by Arturas Kuciauskas on 22.11.2019.
//  Copyright © 2019 Party. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class LoginViewController: UIViewController, UIViewControllerTransitioningDelegate
{
    let backgroundImageView: UIImageView =
    {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "backgroundImage")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let logoImageView: UIImageView =
    {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "logo-white")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let usernameTextField: UITextField =
    {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 5.0
        textField.backgroundColor = UIColor.white
        textField.placeholder = "Username"
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        let iconImageView = UIImageView(frame: CGRect(x: 10.0, y: 0.0, width: 35.0, height: 40.0))
        iconImageView.image = UIImage(named: "ico-username")
        iconImageView.contentMode = .center
        paddingView.addSubview(iconImageView)
        textField.leftView = paddingView
        textField.leftViewMode = .always
    
        return textField
    }()
    
    let passwordTextField: UITextField =
    {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 5.0
        textField.backgroundColor = UIColor.white
        textField.placeholder = "Password"
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        let iconImageView = UIImageView(frame: CGRect(x: 10.0, y: 0.0, width: 35.0, height: 40.0))
        iconImageView.image = UIImage(named: "ico-lock")
        iconImageView.contentMode = .center
        paddingView.addSubview(iconImageView)
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.isSecureTextEntry = true
    
        return textField
    }()
    
    let logInButton: UIButton =
    {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(red: 159.0/255.0, green: 213.0/255.0, blue: 51.0/255.0, alpha: 1.0)
        button.addTarget(self, action: #selector(didTapLoginIn(sender:)), for: .touchUpInside)
        
        button.layer.cornerRadius = 5.0
        button.setTitle("Log In", for: .normal)

        return button
    }()
    
    let fetchingProgressLabel: UILabel =
    {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.clear
        label.text = "Fetching the list..."
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.isHidden = true
    
        return label
    }()
    
    let transition = BubbleTransition()
    
    
  //MARK: - View
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
      // Do any additional setup after loading the view.

        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.view.addSubview(self.backgroundImageView)
        self.view.addSubview(self.passwordTextField)
        self.view.addSubview(self.usernameTextField)
        self.view.addSubview(self.logInButton)
        self.view.addSubview(self.logoImageView)
        self.view.addSubview(self.fetchingProgressLabel)
        
        self.view.addGestureRecognizer(
          UITapGestureRecognizer(
            target: self,
            action: #selector(handleTap(_:))
          )
        )
        
        self.configConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.fetchingProgressLabel.alpha = 0
        self.passwordTextField.alpha = 1
        self.usernameTextField.alpha = 1
        self.logInButton.alpha = 1
        self.logoImageView.alpha = 1
        self.fetchingProgressLabel.isHidden = true
        self.passwordTextField.isHidden = false
        self.usernameTextField.isHidden = false
        self.logInButton.isHidden = false
        self.logoImageView.isHidden = false
    }
    
    func configConstraints()
    {
        NSLayoutConstraint.activate([
          
            self.backgroundImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0.0),
            self.backgroundImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0),
            self.backgroundImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0.0),
            self.backgroundImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0.0),
            
            self.logoImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0),
            self.logoImageView.centerYAnchor.constraint(equalTo: self.passwordTextField.centerYAnchor, constant: -183.0),
            self.logoImageView.widthAnchor.constraint(equalToConstant: 123.0),
            self.logoImageView.heightAnchor.constraint(equalToConstant: 32.0),
            
            self.passwordTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0),
            self.passwordTextField.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0.0),
            self.passwordTextField.widthAnchor.constraint(equalToConstant: 210.0),
            self.passwordTextField.heightAnchor.constraint(equalToConstant: 40.0),
            
            self.usernameTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0),
            self.usernameTextField.centerYAnchor.constraint(equalTo: self.passwordTextField.centerYAnchor, constant: -49.0),
            self.usernameTextField.widthAnchor.constraint(equalToConstant: 210.0),
            self.usernameTextField.heightAnchor.constraint(equalToConstant: 40.0),
            
            self.logInButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0),
            self.logInButton.centerYAnchor.constraint(equalTo: self.passwordTextField.centerYAnchor, constant: 49.0),
            self.logInButton.widthAnchor.constraint(equalToConstant: 210.0),
            self.logInButton.heightAnchor.constraint(equalToConstant: 40.0),
            
            self.fetchingProgressLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0),
            self.fetchingProgressLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 180.0),
            self.fetchingProgressLabel.widthAnchor.constraint(equalToConstant: 210.0),
            self.fetchingProgressLabel.heightAnchor.constraint(equalToConstant: 20.0),
        
        ])
    }
    
    func updateView()
    {
        UIView.animate(withDuration: 0.2, animations: {
            self.fetchingProgressLabel.alpha = 1
            self.passwordTextField.alpha = 0
            self.usernameTextField.alpha = 0
            self.logInButton.alpha = 0
            self.logoImageView.alpha = 0
        }) { (_) in
            self.fetchingProgressLabel.isHidden = false
            self.passwordTextField.isHidden = true
            self.usernameTextField.isHidden = true
            self.logInButton.isHidden = true
            self.logoImageView.isHidden = true
        }
    }
    
    // MARK: - Actions
     
    @objc private func handleTap(_ gesture: UITapGestureRecognizer)
    {
        view.endEditing(true)
    }
    
    @objc func didTapLoginIn(sender:UIButton)
    {
        UIView.animate(withDuration: 0.1, animations: {
            self.logInButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { (_) in
            UIView.animate(withDuration: 0.1, animations: {
                self.logInButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }) { (_) in
                self.startLogin()
            }
        }
        
    }
    
    func startLogin()
    {
        self.view.endEditing(true)
        
        guard let loginUsername = self.usernameTextField.text, loginUsername.count > 0 else
        {
            self.showAlertWithMessage(title: "Login Error!", message:"Empty username or password")
            return
        }

        guard let loginPassword = self.passwordTextField.text, loginPassword.count > 0 else
        {
            self.showAlertWithMessage(title: "Login Error!", message:"Empty username or password")
            return
        }
        
                     
        TesonetAPIManager.shared.loginWithCredentials(username: loginUsername, password: loginPassword) { [weak self] (response) in
            
            let statusCode = response.response?.statusCode
            
            if statusCode == 401
            {
                self?.showAlertWithMessage(title: "Login Error!", message: "Unauthorized login. Check username or password!")
            }
            else
            {
                  switch response.result
                  {
                    case .success(let JSON):
                        let response = JSON as! NSDictionary
                        if let token = response.value(forKey: "token") as? String
                        {
                            TesonetAPIManager.shared.token = token
                            
                            self?.updateView()
                            self?.showActivityIndicator()
                            self?.saveCredentialsToKeychain(username: loginUsername, password: loginPassword)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                                self?.fetchServersList()
                            })
                        }
                        else
                        {
                            self?.showAlertWithMessage(title: "Error!", message: "Missing token")
                        }
                    
                    case .failure(let error):
                        self?.showAlertWithMessage(title: "Error!",message: error.localizedDescription)
                  }
            }
        }
    }
    
    func fetchServersList()
    {
        TesonetAPIManager.shared.fetchServersList { [weak self] (result) in
            
            SVProgressHUD.dismiss()
      
            switch result
            {
                case .success(let servers):
                    self?.serversListDidFetched(servers: servers)
                case .failure(let error):
                    self?.showAlertWithMessage(title: "Error!", message: error.localizedDescription)
            }
        }
    }
    
    func serversListDidFetched(servers: [Server])
    {
        let slvc = ServersListViewController()
        slvc.modalPresentationStyle = .custom
        slvc.transitioningDelegate = self
        slvc.servers = servers
        
        self.navigationController?.present(slvc, animated: true, completion: nil)
    }
    
    func showAlertWithMessage(title: String, message: String)
    {
        let actionSheetController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        actionSheetController.addAction(cancelAction)
        actionSheetController.popoverPresentationController?.sourceView = self.view

        present(actionSheetController, animated: true) {
        }
    }
    
    func saveCredentialsToKeychain(username: String, password: String)
    {
        do
        {
            try KeychainManager.saveCredentialsToKeychain(username, password: password)
        }
        catch
        {
            self.showAlertWithMessage(title: "Error!", message: error.localizedDescription)
        }
    }
    
    func showActivityIndicator()
    {
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setForegroundColor(UIColor.white)
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.setRingNoTextRadius(73.0)
        SVProgressHUD.setRingThickness(4.0)
        SVProgressHUD.setImageViewSize(CGSize(width: 200.0, height: 200.0))
        SVProgressHUD.show()
    }
    
     // MARK: - Transition Delegate

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2)
        transition.bubbleColor = UIColor.white
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
      transition.transitionMode = .dismiss
      transition.startingPoint = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2)
      transition.bubbleColor = UIColor.white
      return transition
    }


}

