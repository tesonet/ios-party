//
//  BindableType.swift
//  Testio
//
//  Created by Mindaugas on 27/07/2018.
//  Copyright © 2018 Mindaugas Jucius. All rights reserved.
//

import UIKit

protocol BindableType {
    associatedtype ViewModelType
    
    var viewModel: ViewModelType { get }
    
    func bindViewModel()
}

extension BindableType where Self: UIViewController {
    
    func setupForViewModel() {
        loadViewIfNeeded()
        bindViewModel()
    }
}
