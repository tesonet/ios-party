//
//  LoginVC.swift
//  party
//
//  Created by Paulius on 07/05/2020.
//  Copyright © 2020 Mediapark. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class LoginVC: UIViewController {
    
    @IBOutlet private var bottomConstrain: NSLayoutConstraint!
    @IBOutlet private var usernameField: UITextField!
    @IBOutlet private var passwordField: UITextField!
    @IBOutlet private var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        adjustBottom(constrain: bottomConstrain)
        dismissKeyboardOnTap()
        //layer.cornerRadius
    }
}
