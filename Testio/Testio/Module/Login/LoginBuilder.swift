//
//  LoginBuilder.swift
//  Testio
//
//  Created by Claus on 27.02.21.
//

import Foundation

final class LoginBuilder: ServiceFactoryContainer {
    func view() -> LoginView {
        let viewModel = LoginViewModel(apiService: factory.apiService)
        let view = LoginViewController(viewModel: viewModel)
        viewModel.delegate = view
        return view
    }
}
