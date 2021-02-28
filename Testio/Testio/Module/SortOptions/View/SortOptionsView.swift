//
//  SortOptionsView.swift
//  Testio
//
//  Created by Claus on 27.02.21.
//

import Foundation

protocol SortOptionsView: BaseView {
    var onSelectOption: ((ServerItemLocalRepositorySortOption) -> Void)? { get set }
}
