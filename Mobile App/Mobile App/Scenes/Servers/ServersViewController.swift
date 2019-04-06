//
//  ServersViewController.swift
//  Mobile App
//
//  Created by Justas Liola on 06/04/2019.
//  Copyright © 2019 Justin. All rights reserved.
//

import UIKit
import RxFeedback
import RxCocoa
import RxSwift

private typealias E = ServersState.Event
private typealias C = ServersState.Command
private typealias Feedback = (Driver<ServersState>) -> Signal<E>

final class ServersViewController: UIViewController {
    
    @IBOutlet private var logOutButton: UIButton!
    @IBOutlet private var tableView: UITableView!
    
    private lazy var loadingVC: UIViewController = ServersLoadingViewController.createFrom(storyboard: .servers)
    
    private let repository = ServerRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Driver.system(
            initialState: ServersState(),
            reduce: ServersState.reduce,
            feedback: tappedLogOut, loadingFeedback, fetchedData, tableFeedback)
            .drive()
            .disposed(by: rx.disposeBag)
    }
    
    //MARK: - Feedbacks
    
    private var tappedLogOut: Feedback {
        return bind(self) { `self`, state in
            
            let tappedLogin = self.logOutButton
                .rx.tap
                .map { E.tappedLogOut }
                .asSignal(onErrorSignalWith: .empty())
            
            let logOut = state
                .map { $0.command }
                .flatMap { command -> Driver<()> in
                    guard case .logOut? = command else { return .empty() }
                    return .just(())
                }
                .drive(onNext: { _ in
                    LoginService.logOutUser()
                })
            
            return Bindings(subscriptions: [logOut], events: [tappedLogin])
        }
    }
    
    private var loadingFeedback: Feedback {
        return bind(self) { `self`, state in
            
            let loadingAnimation = state
                .map { $0.isLoading }
                .drive(onNext: { [unowned self] isLoading in
                    if isLoading {
                        self.showLoading()
                    } else {
                        self.hideLoading()
                    }
                })
            
            return Bindings(subscriptions: [loadingAnimation], events: [Signal<E>]())
        }
    }
    
    private var fetchedData: Feedback {
        return bind(self) { `self`, state in
            
            let fetchedData = self.repository.items
                .map { E.fetchedServers($0) }
                .asSignal(onErrorSignalWith: .empty())

            return Bindings(subscriptions: [], events: [fetchedData])
        }
    }
    
    private var tableFeedback: Feedback {
        return bind(self) { `self`, state in
            
            let table = state
                .map { $0.servers }
                .drive(self.tableView.rx.items(cellIdentifier: "ServerTableViewCell", cellType: ServerTableViewCell.self)) { row, server, cell in
                    cell.setup(with: server)
                }

            return Bindings(subscriptions: [table], events: [Signal<E>]())
        }
    }
    
    //MARK: - UI
    
    private func showLoading() {
        addChild(loadingVC)
        view.addSubview(loadingVC.view)
        loadingVC.didMove(toParent: self)
    }
    
    private func hideLoading() {
        loadingVC.willMove(toParent: nil)
        loadingVC.removeFromParent()
        loadingVC.view.removeFromSuperview()
    }
    
}
