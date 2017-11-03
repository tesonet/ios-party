//
//  LoginController.swift
//  ios-party
//
//  Created by Ilya Vlasov on 8/4/17.
//  Copyright © 2017 Ilya Vlasov. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift
import SVProgressHUD

class LoginController: UIViewController {
    @IBOutlet weak var usernameField: IVTextField!
    
    @IBOutlet weak var passwordField: IVTextField!
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var loadingLabel: UILabel!
    var userParams = [String:Any]()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func login(_ sender: Any) {
        userParams = ["username" : usernameField.text!, "password" : passwordField.text!]
        ConnectionManager.sharedInstance.requestToken(withParams: userParams)
    }
    
    //    MARK: VC - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        ConnectionManager.sharedInstance.delegate = self
        DataManager.sharedInstance.delegate = self
        Utilities.sharedInstance.setupLoader()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.logo.alpha = 1.0
        self.usernameField.alpha = 1.0
        self.passwordField.alpha = 1.0
        self.loginBtn.alpha = 1.0
        self.loadingLabel.alpha = 0.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //    MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "loginsegue") {
            let controller = segue.destination as! ServersController
            let realm = try! Realm()
            let servers = Array(realm.objects(Server.self))
            controller.servers = servers
        }
        
    }

}
    //    MARK: Extensions
extension LoginController : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        //
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}

extension LoginController : ConnectionManagerDelegate {
    func connectionManagerDidRecieveObject(responseObject: Any) {
       
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.167, animations: {
                self.logo.alpha = 0.0
                self.usernameField.alpha = 0.0
                self.passwordField.alpha = 0.0
                self.loginBtn.alpha = 0.0
                self.loadingLabel.alpha = 1.0
                
            }) { (finished) in
                if finished {
                    
                    SVProgressHUD.show()
                }
            }
        }
        
        
        DispatchQueue.global(qos: .background).async {
            ConnectionManager.sharedInstance.requestServers()
        }
        
    }
}

extension LoginController : SyncProtocol {
    func syncFinished() {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            self.loadingLabel.alpha = 0.0
        }
        self.performSegue(withIdentifier: "loginsegue", sender: self)
    }
}
