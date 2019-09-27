//
//  ViewController.swift
//  iosparty
//
//  Created by Mantas Skeiverys on 28/09/2019.
//  Copyright © 2019 Mantas Skeiverys. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func clicked(_ sender: Any) {
        let handler = APIHandler()
        //handler.getToken(userName: "tesonet", password: "partyanimal")
        handler.getServers(token: "f9731b590611a5a9377fbd02f247fcdf")
    }
    
    
}

