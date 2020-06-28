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
        }else{usernameCell.text = ""}
        
        if let savedPassword = KeychainManager.getCredentialsForKey(CredentialsKey.password)
        {
            passwordCell.text = savedPassword
        }else{passwordCell.text = ""}
    }
    
    fileprivate func setupUI()
    {
        //add image to background
        assignbackground()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        //add light logo
        let imgView = UIImageView()
        imgView.contentMode =  UIView.ContentMode.scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.image = UIImage(named: "LogoLight")
        view.addSubview(imgView)
        imgView.topAnchor.constraint(equalTo:view.topAnchor, constant: 150).isActive = true
        imgView.trailingAnchor.constraint(equalTo:view.trailingAnchor, constant: -120).isActive = true
        imgView.leadingAnchor.constraint(equalTo:view.leadingAnchor, constant: 120).isActive = true
        imgView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //add login/password cells
        
        usernameCell = imageWithText(text: "Username", image:UIImage(named:"Username"))
        if let savedUsername = KeychainManager.getCredentialsForKey(CredentialsKey.password)
        {
            usernameCell.text = savedUsername
        }
        view.addSubview(usernameCell)
        usernameCell.topAnchor.constraint(equalTo:imgView.bottomAnchor, constant: 100).isActive = true
        usernameCell.trailingAnchor.constraint(equalTo:view.trailingAnchor, constant: -sideConstraintConstant).isActive = true
        usernameCell.leadingAnchor.constraint(equalTo:view.leadingAnchor, constant: sideConstraintConstant).isActive = true
        usernameCell.heightAnchor.constraint(equalToConstant: cellsHeightConstraintConstant).isActive = true
        
        passwordCell = imageWithText(text: "Password", image:UIImage(named:"Lock"))
        if let savedPassword = KeychainManager.getCredentialsForKey(CredentialsKey.username)
        {
            passwordCell.text = savedPassword
        }
        passwordCell.isSecureTextEntry = true
        view.addSubview(passwordCell)
        passwordCell.topAnchor.constraint(equalTo:usernameCell.bottomAnchor, constant: cellsGapConstraint).isActive = true
        passwordCell.trailingAnchor.constraint(equalTo:view.trailingAnchor, constant: -sideConstraintConstant).isActive = true
        passwordCell.leadingAnchor.constraint(equalTo:view.leadingAnchor, constant: sideConstraintConstant).isActive = true
        passwordCell.heightAnchor.constraint(equalToConstant: cellsHeightConstraintConstant).isActive = true
        
        //add loginButton
        let loginButton = UIButton()
        loginButton.backgroundColor = UIColor.init(red: 160/255, green: 211/255, blue: 66/255, alpha: 1.0)
        loginButton.layer.cornerRadius = 5.0
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle("Log In", for: .normal)
        loginButton.addTarget(self, action: #selector(loginAction), for:.touchDown)
        view.addSubview(loginButton)
        loginButton.topAnchor.constraint(equalTo:passwordCell.bottomAnchor, constant: cellsGapConstraint).isActive = true
        loginButton.trailingAnchor.constraint(equalTo:view.trailingAnchor, constant: -sideConstraintConstant).isActive = true
        loginButton.leadingAnchor.constraint(equalTo:view.leadingAnchor, constant: sideConstraintConstant).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: cellsHeightConstraintConstant).isActive = true
        
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
            if responseCode == 401
            {
                let alert = UIAlertController(title:"401 Error", message: response, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            if (success)
            {
                KeychainManager.writeCredentialsForKey(CredentialsKey.password, value: self.passwordCell.text!)
                KeychainManager.writeCredentialsForKey(CredentialsKey.username, value: self.usernameCell.text!)
                KeychainManager.writeCredentialsForKey(CredentialsKey.token, value: response)
                let loadingViewController = LoadingViewController.init(token: response)
                self.navigationController?.pushViewController(loadingViewController, animated: true)
            }
            else
            {
                print(response)
            }
        }
    }
    
    fileprivate func assignbackground()
    {
        let background = UIImage(named: "Background")

        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
    
    fileprivate func imageWithText(text: String!, image: UIImage!) -> UITextField
    {
        let textField = UITextField()
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
