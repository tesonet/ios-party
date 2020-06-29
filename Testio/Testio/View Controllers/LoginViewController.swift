//
//  LoginViewController.swift
//
//
//  Created by Ernestas Šeputis on 6/26/20.
//

import UIKit

class LoginViewController: UIViewController
{
    fileprivate let sideConstraintConstant:CGFloat = 50
    fileprivate let cellsHeightConstraintConstant:CGFloat = 60
    fileprivate let cellsGapConstraint:CGFloat = 20
    fileprivate var passwordCell:UITextField!
    fileprivate var usernameCell:UITextField!
    fileprivate let tesioImage:UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode =  UIView.ContentMode.scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.image = UIImage(named: "LogoLight")
       return imgView
    }()
    fileprivate let loginButton:UIButton = {
        let loginButton = UIButton()
        loginButton.backgroundColor = UIColor.init(red: 160/255, green: 211/255, blue: 66/255, alpha: 1.0)
        loginButton.layer.cornerRadius = 5.0
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle("Log In", for: .normal)
        loginButton.addTarget(self, action: #selector(loginAction), for:.touchDown)
        return loginButton
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let savedUsername = KeychainManager.getCredentialsForKey(CredentialsKey.username)
        {
            usernameCell.text = savedUsername
        }
        else
        {
            usernameCell.text = ""
        }
        
        if let savedPassword = KeychainManager.getCredentialsForKey(CredentialsKey.password)
        {
            passwordCell.text = savedPassword
        }
        else
        {
            passwordCell.text = ""
        }
    }
    
    fileprivate func setupUI()
    {
        assignbackground()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        setupImage()
        setupCells()
        setupButton()
    }
    
    @objc func loginAction()
    {
        if usernameCell.text!.isEmpty
        {
            print("no username entered")
            return;
        }
        if passwordCell.text!.isEmpty
        {
            print("no password entered")
            return;
        }
        
        /*check if token exists in keychain and if internet is available
            - if not available load "offline mode" with current servers in database*/
        
        if let token = KeychainManager.getCredentialsForKey(CredentialsKey.token)
        {
            if !APIManager.shared.isConnectedToInternet()
            {
                let loadingViewController = LoadingViewController.init(token: token)
                self.navigationController?.pushViewController(loadingViewController, animated: true)
                return
            }
        }
        
        APIManager.shared.getToken(userName: usernameCell.text!, password: passwordCell.text!) { [weak self] (success, response, responseCode) in
            guard let self = self else {
                return
            }
            if !success
            {
                let alert = UIAlertController(title:"Error", message: "Something Went Wrong", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            if responseCode == 401
            {
                let alert = UIAlertController(title:"401 Error", message: response, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else
            {
                guard let token = KeychainManager.getCredentialsForKey(CredentialsKey.token) else {
                    KeychainManager.writeCredentialsForKey(CredentialsKey.password, value: self.passwordCell.text!)
                    KeychainManager.writeCredentialsForKey(CredentialsKey.username, value: self.usernameCell.text!)
                    KeychainManager.writeCredentialsForKey(CredentialsKey.token, value: response)
                    let loadingViewController = LoadingViewController.init(token: response)
                    self.navigationController?.pushViewController(loadingViewController, animated: true)
                    return
                }
                let loadingViewController = LoadingViewController.init(token: token)
                self.navigationController?.pushViewController(loadingViewController, animated: true)
                
            }
        }
    }
    
    fileprivate func setupImage()
    {
        view.addSubview(tesioImage)
        tesioImage.topAnchor.constraint(equalTo:view.topAnchor, constant: 130).isActive = true
        tesioImage.trailingAnchor.constraint(equalTo:view.trailingAnchor, constant: -120).isActive = true
        tesioImage.leadingAnchor.constraint(equalTo:view.leadingAnchor, constant: 120).isActive = true
        tesioImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    fileprivate func setupCells()
    {
        usernameCell = imageWithText(text: "Username", image:UIImage(named:"Username"))
        view.addSubview(usernameCell)
        usernameCell.topAnchor.constraint(equalTo:tesioImage.bottomAnchor, constant: 150).isActive = true
        usernameCell.trailingAnchor.constraint(equalTo:view.trailingAnchor, constant: -sideConstraintConstant).isActive = true
        usernameCell.leadingAnchor.constraint(equalTo:view.leadingAnchor, constant: sideConstraintConstant).isActive = true
        usernameCell.heightAnchor.constraint(equalToConstant: cellsHeightConstraintConstant).isActive = true
        
        passwordCell = imageWithText(text: "Password", image:UIImage(named:"Lock"))
        passwordCell.isSecureTextEntry = true
        view.addSubview(passwordCell)
        passwordCell.topAnchor.constraint(equalTo:usernameCell.bottomAnchor, constant: cellsGapConstraint).isActive = true
        passwordCell.trailingAnchor.constraint(equalTo:view.trailingAnchor, constant: -sideConstraintConstant).isActive = true
        passwordCell.leadingAnchor.constraint(equalTo:view.leadingAnchor, constant: sideConstraintConstant).isActive = true
        passwordCell.heightAnchor.constraint(equalToConstant: cellsHeightConstraintConstant).isActive = true
    }
    fileprivate func setupButton()
    {
        view.addSubview(loginButton)
        loginButton.topAnchor.constraint(equalTo:passwordCell.bottomAnchor, constant: cellsGapConstraint).isActive = true
        loginButton.trailingAnchor.constraint(equalTo:view.trailingAnchor, constant: -sideConstraintConstant).isActive = true
        loginButton.leadingAnchor.constraint(equalTo:view.leadingAnchor, constant: sideConstraintConstant).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: cellsHeightConstraintConstant).isActive = true
    }
    
    fileprivate func assignbackground()
    {
        let background = UIImage(named: "Background")

        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
    
    fileprivate func imageWithText(text: String!, image: UIImage!) -> LoginViewTextField
    {
        let textField = LoginViewTextField()
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        let imageView = UIImageView()
        imageView.image = image
        textField.leftView = imageView
        textField.autocorrectionType = .no
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 5.0
        textField.placeholder = text
        return textField
    }
}
