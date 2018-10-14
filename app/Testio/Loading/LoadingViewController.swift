//
//  LoadingViewController.swift
//  Testio
//
//  Created by Julius on 14/10/2018.
//  Copyright © 2018 jp. All rights reserved.
//

import UIKit

class LoadingViewController: ViewController {
    @IBOutlet weak var spinnerView: CircularSpinner!
    @IBOutlet weak var retryButton: UIButton!
    let serversRepository = ServersRepository()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        update()
    }
    
    func update() {
        serversRepository.updateServersList().done {
            Router.navigate(.serversList)
        }.catch { [weak self] error in
            if (error as NSError).code == 401 {
                AuthManager.shared.logout()
                Router.navigate(.loginWithMessage("Your session has expired"))
            } else {
                self?.showMessage(error.localizedDescription, type: .error)
                self?.spinnerView.isHidden = true
                self?.retryButton.isHidden = false
            }
        }
    }
    
    @IBAction func onRetryButtonTap(_ sender: Any) {
        update()
    }
}
