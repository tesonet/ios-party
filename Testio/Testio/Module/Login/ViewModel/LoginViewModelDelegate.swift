//
//  LoginViewModelDelegate.swift
//  Testio
//
//  Created by Claus on 27.02.21.
//

import Foundation

protocol LoginViewModelDelegate: class {
    func didStartLogin()
    func didFinishLoginWithError(error: String)
    func didFinishLoginWithSuccess()
}
