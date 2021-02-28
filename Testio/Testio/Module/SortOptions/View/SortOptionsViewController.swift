//
//  SortOptionsViewController.swift
//  Testio
//
//  Created by Claus on 26.02.21.
//

import UIKit

final class SortOptionsViewController: UIAlertController, SortOptionsView {
    
    var onSelectOption: ((ServerItemLocalRepositorySortOption) -> Void)?
    
    override var preferredStyle: UIAlertController.Style {
        .actionSheet
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        title = nil
        message = nil
        
        addAction(.init(title: "By Distance", style: .default, handler: { [weak self]  _ in
            self?.onSelectOption?(.distance)
        }))
        
        addAction(.init(title: "Alphanumerical", style: .default, handler: { [weak self] _ in
            self?.onSelectOption?(.name)
        }))
        
        addAction(.init(title: "Cancel", style: .cancel, handler: nil))
    }
}
