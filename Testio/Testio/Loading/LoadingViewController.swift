//
//  LoadingViewController.swift
//  Testio
//
//  Created by Mindaugas on 27/07/2018.
//  Copyright © 2018 Mindaugas Jucius. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController, BindableType {

    typealias ViewModelType = LoadingViewModel

    var viewModel: LoadingViewModel
    
    @IBOutlet private var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet private var loadingTextLabel: UILabel!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    init(viewModel: ViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
    }

    func bindViewModel() {
        
    }

}

extension LoadingViewController {
    
    private func setupAppearance() {
        loadingIndicator.activityIndicatorViewStyle = .whiteLarge
        loadingIndicator.startAnimating()
        
        loadingTextLabel.textColor = .white
        loadingTextLabel.text = NSLocalizedString("LOADING_STATUS", comment: "")
    }
    
}
