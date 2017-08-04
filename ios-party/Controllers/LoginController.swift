//
//  LoginController.swift
//  ios-party
//
//  Created by Ilya Vlasov on 8/4/17.
//  Copyright © 2017 Ilya Vlasov. All rights reserved.
//

import UIKit

class LoginController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension LoginController : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        //
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
