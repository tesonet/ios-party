//
//  ServerPresenterViewController.swift
//  Testio
//
//  Created by Mindaugas on 28/07/2018.
//  Copyright © 2018 Mindaugas Jucius. All rights reserved.
//

import UIKit

class ServerPresenterViewController: UIViewController, BindableType {
    
    typealias ViewModelType = ServerPresenterViewModel
    
    var viewModel: ViewModelType
    
    init(viewModel: ViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    func bindViewModel() {
        
    }
    
}
