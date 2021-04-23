//
//  LoginViewProtocol.swift
//  Servers
//
//  Created by Nikita Khodzhaiev on 17.04.2021.
//

import Foundation

protocol LoginViewProtocol: class {
    func updateUI(isLoading: Bool)
    func show(error: Error)
    func setLoginButton(enabled: Bool)
}
