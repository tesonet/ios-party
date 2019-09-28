//
//  LoadingViewController.swift
//  iosparty
//
//  Created by Mantas Skeiverys on 28/09/2019.
//  Copyright © 2019 Mantas Skeiverys. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class LoadingViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    
    var userName = ""
    var password = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.type = .circleStrokeSpin
        activityIndicator.startAnimating()
        loadMainScreen()
    }
    
    private func loadMainScreen(){
        LoginManager.login(userName: userName, password: password) { (success) in
            if success{
                sleep(3)
                self.performSegue(withIdentifier: "mainScreenSegue", sender: self)
            }else{
                self.navigationController?.popToRootViewController(animated: true)
                self.showAlert()
            }
        }
    }
    
    private func showAlert(){
        let alert = UIAlertController(title: "Could not login", message: "Incorrect login information", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
