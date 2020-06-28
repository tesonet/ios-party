//
//  LoginViewController.swift
//
//
//  Created by Ernestas Šeputis on 6/26/20.
//

import UIKit

class LoginViewController: UIViewController
{
    //
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
        view.addSubview(usernameCell)
        usernameCell.topAnchor.constraint(equalTo:imgView.bottomAnchor, constant: 100).isActive = true
        usernameCell.trailingAnchor.constraint(equalTo:view.trailingAnchor, constant: -sideConstraintConstant).isActive = true
        usernameCell.leadingAnchor.constraint(equalTo:view.leadingAnchor, constant: sideConstraintConstant).isActive = true
        usernameCell.heightAnchor.constraint(equalToConstant: cellsHeightConstraintConstant).isActive = true
        
        passwordCell = imageWithText(text: "Password", image:UIImage(named:"Lock"))
        view.addSubview(passwordCell)
        passwordCell.topAnchor.constraint(equalTo:usernameCell.bottomAnchor, constant: cellsGapConstraint).isActive = true
        passwordCell.trailingAnchor.constraint(equalTo:view.trailingAnchor, constant: -sideConstraintConstant).isActive = true
        passwordCell.leadingAnchor.constraint(equalTo:view.leadingAnchor, constant: sideConstraintConstant).isActive = true
        passwordCell.heightAnchor.constraint(equalToConstant: cellsHeightConstraintConstant).isActive = true
        
        //add loginButton
        let loginButton = UIButton()
        loginButton.backgroundColor = .green
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
        APIManager().getToken(userName: usernameCell.text!, password: passwordCell.text!) { (success, response, responseCode) in
            if responseCode == 401
            {
                let alert = UIAlertController(title:"401 Error", message: response, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            if (success)
            {
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
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 5.0
        textField.placeholder = text
        return textField
    }
}
