//
//  InfoListViewController.swift
//  TestProject
//
//  Created by Andrii Popov on 2/22/21.
//

import UIKit

final class ServersListViewController: UIViewController, StoryboardInstantiable {
    
    @IBOutlet private weak var infoBarView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomBarView: UIView!
    
    var viewModel: ServersListViewModelProtocol!
    private let activityView = LoadingActivityView.instantiate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        runActivity()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.start()
    }
    
    private func setupUI() {
        setupActivityView()
        setupInfoBarView()
        setupTableView()
    }
    
    private func setupActivityView() {
        view.addSubview(activityView)
        NSLayoutConstraint.activate([
            activityView.topAnchor.constraint(equalTo: view.topAnchor),
            activityView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            activityView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            activityView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupInfoBarView() {
        infoBarView.layer.shadowColor = ServersListConstants.infoBarView.colors.shadow.cgColor
        infoBarView.layer.shadowOffset = ServersListConstants.infoBarView.geometry.shadowOffset
        infoBarView.layer.shadowRadius = ServersListConstants.infoBarView.geometry.shadowRadius
        infoBarView.layer.shadowOpacity = ServersListConstants.infoBarView.geometry.shadowOpacity
    }
    
    private func setupTableView() {
        ServerTableViewCell.register(in: tableView)
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomBarView.bounds.height, right: 0)
        tableView.scrollIndicatorInsets = tableView.contentInset
    }
    
    private func setupBindings() {
        viewModel.onUpdateServersList = { [weak self] in
            self?.activityView.hide()
            self?.tableView.reloadData()
        }
    }
    
    private func runActivity() {
        activityView.updateMessage(ServersListLocalization.activity.fetchingServerList)
        activityView.animate()
    }
}

extension ServersListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.serversCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ServerTableViewCell.dequeueReusableCell(in: tableView, for: indexPath)
        cell.update(with: viewModel.server(at: indexPath.row))
        return cell
    }
}

extension ServersListViewController {
    @IBAction func displaySortingOptions(_ sender: Any) {
        viewModel.displySortingOptions()
    }
    
    @IBAction func logOut(_ sender: Any) {
        viewModel.logOut()
    }
}
