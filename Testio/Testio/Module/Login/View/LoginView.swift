//
//  LoginView.swift
//  Testio
//
//  Created by Claus on 27.02.21.
//

import Foundation

protocol LoginView: BaseView {
    var onSuccess: (() -> Void)? { get set }
}
