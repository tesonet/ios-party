//
//  InfoListViewModelProtocol.swift
//  TestProject
//
//  Created by Andrii Popov on 2/24/21.
//

import Foundation

protocol ServersListViewModelProtocol {
    //MARK: - Bindings
    var onUpdateServersList: (() -> ())? { get set }
    
    //MARK: - Data
    var serversCount: Int { get }
    func start()
    func server(at index: Int) -> Server

    //MARK: - UI events
    func displySortingOptions()
    func logOut()
}
