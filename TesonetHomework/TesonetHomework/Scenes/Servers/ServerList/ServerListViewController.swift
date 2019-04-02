// Created by Paulius Cesekas on 02/04/2019.

import UIKit
import Domain
import NetworkPlatform
import RxSwift
import RxCocoa

class ServerListViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private lazy var loadingViewController: LoadingViewController = {
        return LoadingViewController(state: L10n.Login.loading)
    }()

    // MARK: - Methods -
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Setup
    private func setupUI() {
        setupLoading()
    }

    private func setupLoading() {
        showLoading(animated: false)
    }
    
    // MARK: - Helpers
    private func showLoading(animated: Bool) {
        if let presentedViewController = presentedViewController as? LoadingViewController {
            loadingViewController = presentedViewController
        }
        loadingViewController.updateState(L10n.ServerList.loading)
        guard !loadingViewController.isBeingPresented else {
            return
        }
        
        navigationController?.present(
            loadingViewController,
            animated: animated)
    }

    private func hideLoading() {
        loadingViewController.dismiss(animated: true)
    }
}
