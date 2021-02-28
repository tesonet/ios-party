//
//  LoginScrollView.swift
//  Testio
//
//  Created by Claus on 26.02.21.
//

import UIKit

class LoginScrollView: UIScrollView {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        endEditing(true)
    }
    
}
