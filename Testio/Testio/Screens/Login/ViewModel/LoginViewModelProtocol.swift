//
//  InfoListViewModelProtocol.swift
//  TestProject
//
//  Created by Andrii Popov on 2/24/21.
//

import Foundation

protocol LoginViewModelProtocol {
    //MARK: - Bindings
    
    
    //MARK: - Data
    func start()

    
    //MARK: - UI events
    func login(username: String, password: String)
}
