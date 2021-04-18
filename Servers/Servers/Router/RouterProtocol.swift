//
//  RouterProtocol.swift
//  Servers
//
//  Created by Nikita Khodzhaiev on 18.04.2021.
//

import UIKit

protocol RouterProtocol {
    
    var navigationController: UINavigationController? { get set }
    var moduleBuilder: ModuleBuilderProtocol? { get set }
    
    func initialViewController()
    func showServers()
    func popToRoot()
}
