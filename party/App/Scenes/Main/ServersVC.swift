//
//  ServersVC.swift
//  party
//
//  Created by Paulius on 07/01/2020.
//  Copyright © 2020 Mediapark. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxFeedback

private typealias E = ServersState.Event
private typealias Feedback = (Driver<ServersState>) -> Signal<E>
final class ServersVC: UIViewController {
    
    private let logOutSubject = PublishSubject<Void>()
    private let sortSubject = PublishSubject<Server.SortType>()

    @IBOutlet private var headerView: UIView!
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var sortButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        
        let nib = UINib(nibName: "ServerCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ServerCell")
        
        headerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        headerView.layer.shadowColor = UIColor.black.cgColor
        headerView.layer.shadowOpacity = 0.2
        headerView.layer.shadowRadius = 10

        Driver.system(
            initialState: ServersState(),
            reduce: ServersState.reduce,
            feedback: [general])
            .drive()
            .disposed(by: rx.disposeBag)
        
        sortButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.showSimpleActionSheet(controller: self)
            })
            .disposed(by: rx.disposeBag)
    }
    
    private var general: Feedback {
        return bind(self) { `self`, state in
            
            let fetch = state
                .map { $0.fetch }
                .filterNil()
                .flatMap { _ in
                    API.Servers.Get().request()
                        .map { E.receivedSuccess($0) }
                        .asSignal(onErrorJustReturn: E.receivedError)
                }
            
            let logOut = state
                .map { $0.logout }
                .filterNil()
                .drive(onNext: {
                    UIManager.logout()
                })
            
            let loading = state
                .map { $0.isLoading }
                .drive(onNext: {
                    //TODO: loading
                })
            
            let tappedLogOut = self.logOutSubject
                .map { E.tappedLogout }
                .asSignalOrEmpty()
            
            let cells = state
                .map { $0.servers }
                .drive(self.tableView.rx.items(cellIdentifier: "ServerCell", cellType:
                    ServerCell.self)) { _, item, cell in
                        cell.setup(with: item)
                }
            
            let choosedSort = self.sortSubject
                .map { E.tappedSort(by: $0) }
                .asSignalOrEmpty()
             
            return Bindings(subscriptions: [logOut, cells],
                            events: [fetch, tappedLogOut, choosedSort])
        }
    }
    
    func showSimpleActionSheet(controller: UIViewController) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: Server.SortType.distance.rawValue, style: .default, handler: { [weak self] _ in
            self?.sortSubject.onNext(.distance)
        }))
        
        alert.addAction(UIAlertAction(title: Server.SortType.alphanumerical.rawValue, style: .default, handler: { [weak self] _ in
            self?.sortSubject.onNext(.alphanumerical)
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        self.present(alert, animated: true)
    }
    
    @objc
    private func logOutEventHandler() {
        logOutSubject.onNext(())
    }

    private func setupNavBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        let logoutImg = UIImage(named: "ico-logout")?.withRenderingMode(.alwaysOriginal)
        let logoutButton = UIBarButtonItem(image: logoutImg, style: .plain, target: self, action: #selector(logOutEventHandler))
        let logoImg = UIImage(named: "logo-dark")?.withRenderingMode(.alwaysOriginal)
        let logo = UIBarButtonItem(image: logoImg, style: .plain, target: nil, action: nil)
        navigationItem.setRightBarButton(logoutButton, animated: false)
        navigationItem.setLeftBarButton(logo, animated: false)
    }
}
