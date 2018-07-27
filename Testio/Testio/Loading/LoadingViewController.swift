//
//  LoadingViewController.swift
//  Testio
//
//  Created by Mindaugas on 27/07/2018.
//  Copyright © 2018 Mindaugas Jucius. All rights reserved.
//

import UIKit
import RxSwift

class LoadingViewController: UIViewController, BindableType {

    typealias ViewModelType = LoadingViewModelType

    var viewModel: LoadingViewModelType
    
    private let disposeBag = DisposeBag()
    
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
        rx.methodInvoked(#selector(UIViewController.viewDidAppear(_:)))
            .take(1)
            .debug("hip", trimOutput: true)
            .flatMap { _ in
                self.viewModel.load.execute(())
            }
            .subscribe()
            .disposed(by: disposeBag)
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
