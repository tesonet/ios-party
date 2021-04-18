//
//  ServersViewProtocol.swift
//  Servers
//
//  Created by Nikita Khodzhaiev on 18.04.2021.
//

import UIKit

protocol ServersViewProtocol: class {
    func showSortingMenu(options: [String])
    func reloadUI()
    func show(error: Error)

}
