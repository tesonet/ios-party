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

    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var sortButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        
        let nib = UINib(nibName: "ServerCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ServerCell")

        Driver.system(
            initialState: ServersState(),
            reduce: ServersState.reduce,
            feedback: [general])
            .drive()
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
                    //TODO: LogOut
                })
            
            let loading = state
                .map { $0.isLoading }
                .drive(onNext: {
                    //TODO: loading
                })
            
            let cells = state
                .map { $0.servers }
                .drive(self.tableView.rx.items(cellIdentifier: "ServerCell", cellType:
                    ServerCell.self)) { _, item, cell in
                        cell.setup(with: item)
                }
             
            return Bindings(subscriptions: [logOut, cells],
                            events: [fetch])
        }
    }

    private func setupNavBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        let logoutImg = UIImage(named: "ico-logout")?.withRenderingMode(.alwaysOriginal)
        let logoutButton = UIBarButtonItem(image: logoutImg, style: .plain, target: nil, action: nil)
        let logoImg = UIImage(named: "logo-dark")?.withRenderingMode(.alwaysOriginal)
        let logo = UIBarButtonItem(image: logoImg, style: .plain, target: nil, action: nil)
        navigationItem.setRightBarButton(logoutButton, animated: false)
        navigationItem.setLeftBarButton(logo, animated: false)
    }
}
