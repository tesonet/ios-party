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
        LoginManager.login(userName: userName, password: password) { (success, reason) in
            if success{
                //Sleeping just to simulate the loading screen :)
                sleep(3)
                self.performSegue(withIdentifier: Constants.MAIN_SCREEN_SEGUE, sender: self)
            }else{
                self.navigationController?.popToRootViewController(animated: true)
                self.showAlert(message: reason)
            }
        }
    }
    
    private func showAlert(message: String){
        let alert = UIAlertController(title: "Could not login", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
