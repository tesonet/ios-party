//
//  ErrorProtocol.swift
//  Servers
//
//  Created by Nikita Khodzhaiev on 18.04.2021.
//

import Foundation

protocol ErrorProtocol {
    func present(error: Error)
}
