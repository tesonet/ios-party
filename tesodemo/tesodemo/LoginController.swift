//
//  ViewController.swift
//  tesodemo
//
//  Created by Vytautas Vasiliauskas on 14/07/2017.
//
//

import UIKit

class LoginController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var formView: UIView!
    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var formCenterConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.backgroundColor = UIColor.appLoginButtonBg
        loginButton.titleLabel?.font = UIFont.applicationFont(.bold, size: 10)
        loginButton.setTitle("LoginButton".localized, for: .normal)
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.layer.cornerRadius = 2.5
        
        usernameField.font = UIFont.applicationFont(.light, size: 10)
        usernameField.delegate = self
        usernameField.attributedPlaceholder = NSAttributedString(
            string: "UsernamePlaceholder".localized,
            attributes: [NSForegroundColorAttributeName: UIColor.appTextFieldPlaceholder])
        
        
        
        passwordField.font = UIFont.applicationFont(.light, size: 10)
        passwordField.delegate = self
        passwordField.attributedPlaceholder = NSAttributedString(
            string: "PasswordPlaceholder".localized,
            attributes: [NSForegroundColorAttributeName: UIColor.appTextFieldPlaceholder])
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillChangeFrame, object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object:nil)
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func loginClicked() {
        LoadingView.sharedInstance().start(text: "LoadingAuthenticating".localized)
        let username = usernameField.text ?? ""
        let password = passwordField.text ?? ""
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        API(APIRouter.Login(username, password)) { (success, json) in
            if success, let json = json as? [String: String], let token = json["token"] {
                SessionManager.sharedInstance.create(token: token)
            } else {
                LoadingView.sharedInstance().stop()
            }
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        let frame: CGRect = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let screenFrame = UIScreen.main.bounds;
        var height = frame.size.height
        if (screenFrame.size.height == frame.size.height){
            height = frame.size.width
        }
        
        let offset = self.view.bounds.height/2 - formView.bounds.height/2 - height - 40
        formCenterConstraint.constant = offset;
        self.view.setNeedsUpdateConstraints();
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            self.logoView.alpha = 0
            self.view.layoutIfNeeded()
        })
    }
    func keyboardWillHide(notification: NSNotification) {
        formCenterConstraint.constant = 36;
        self.view.setNeedsUpdateConstraints();
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            self.logoView.alpha = 1
            self.view.layoutIfNeeded()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameField {
            passwordField.becomeFirstResponder()
        }
        textField.resignFirstResponder()
        return true
    }


}
