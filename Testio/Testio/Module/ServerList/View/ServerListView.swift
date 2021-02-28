//
//  ServerListView.swift
//  Testio
//
//  Created by Claus on 27.02.21.
//

import Foundation

protocol ServerListView: BaseView {
    var onLogout: (() -> Void)? { get set }
    var onSelectSortOptions: (() -> Void)? { get set }
    
    func didSelectSortOption(_ option: ServerItemLocalRepositorySortOption)
}
