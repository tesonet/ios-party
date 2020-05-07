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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adjustBottom(constrain: bottomConstrain)
        dismissKeyboardOnTap()
    }
}
