//
//  ModuleBuilderProtocol.swift
//  Servers
//
//  Created by Nikita Khodzhaiev on 22.04.2021.
//

import UIKit

protocol ModuleBuilderProtocol {
    var isLoggedIn: Bool { get }
    
    func createLoginModule(router: RouterProtocol) -> UIViewController
    func createServersModule(router: RouterProtocol) -> UIViewController
    func createTransitionAnimator() -> TransitionAnimator
}
