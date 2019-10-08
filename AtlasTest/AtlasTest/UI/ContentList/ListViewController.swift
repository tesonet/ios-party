//
//  ListViewController.swift
//  AtlasTest
//
//  Created by Irina  Shupikova on 9/29/19.
//  Copyright © 2019 krokus. All rights reserved.
//

import Foundation
import UIKit

// MARK: - ListViewController protocol
protocol ListViewController: AnyObject {
    func reloadUI()
    func setLoadingStartedUI()
    func setLoadingStoppedUI()
}

// MARK: - ServerSelectCell
class ServerSelectCell: UITableViewCell {
    @IBOutlet private var nameLabel: UILabel?
    @IBOutlet private var distanceLabel: UILabel?
    
    var name: String? {
        didSet {
            nameLabel?.text = name ?? ""
        }
    }
    var distance: Double? {
        didSet {
            distanceLabel?.text = String("\(distance ?? 0.0)") + " km."
        }
    }
    
    static func reuseIdentifier() -> String {
        return "ServerSelectCell"
    }
}

// MARK: - ServersTableHeader
class ServersTableHeader:  UITableViewCell  {
    @IBOutlet weak var serverLabel: UILabel?
    @IBOutlet weak var distanceLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func reuseIdentifier() -> String {
        return "ServersTableHeader"
    }
}

// MARK: - AppListViewController
class AppListViewController: UIViewController, ListViewController {
    @IBOutlet private var serversTableView: UITableView!
    @IBOutlet private var headerView: UIView!
    @IBOutlet private var logoutButton: UIButton!
    @IBOutlet private var sortButton: UIButton!
    unowned private var viewModel: ListViewModel?
    private var loadingViewController:LoadingViewController?
    
    static func makeAppListViewController(viewModel: ListViewModel) -> UIViewController? {
        guard let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LIST") as? AppListViewController else { return nil }
        newViewController.viewModel = viewModel
        return newViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        headerView.addShadow(color: UIColor.black, opacity: 0.5, radius: 15, scale: true)
        viewModel?.getServers()
        reloadUI()
    }
    
    @IBAction private func logoutButtonTapped(_ sender: UIButton) {
        viewModel?.logout()
    }
    
    @IBAction private func sortButtonTapped(_ sender: UIButton) {
        displayActions()
    }
    
    func reloadUI() {
        serversTableView.reloadData()
    }
       
    func setLoadingStartedUI() {
        displayLoadingIndicator()
    }
       
    func setLoadingStoppedUI() {
        dismissLoadingIndicator()
    }
}

// MARK: - private methods for AppListViewController
private extension AppListViewController {
    func setInitUI() {
        
    }
    
    func displayActions() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let sortByDistance = UIAlertAction(title: "By Distance", style: .default) { [weak self] UIAlertAction in
            self?.viewModel?.sortServersByDistance()
            self?.reloadUI()
        }
        alert.addAction(sortByDistance)
        let sortByName = UIAlertAction(title: "Alphanumerical", style: .default) { [weak self] UIAlertAction in
            self?.viewModel?.sortServersByName()
            self?.reloadUI()
        }
        alert.addAction(sortByName)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            UIAlertAction in
        }
        alert.addAction(cancelAction)
        present(alert, animated: true) { [weak self] in self?.reloadUI() }
    }
    
    func displayLoadingIndicator() {
        LoadingViewController.present(from: self, animated: true)
    }
    
    func dismissLoadingIndicator() {
        LoadingViewController.tryToDismiss()
    }
}

// MARK: - UITableViewDelegate
extension AppListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let  headerCell = tableView.dequeueReusableCell(withIdentifier: AppConstants.ServersList.serversTableHeaderId) as? ServersTableHeader else { return nil }
        headerCell.serverLabel?.text = AppConstants.ServersList.tableServerTitle
        headerCell.distanceLabel?.text = AppConstants.ServersList.tableDistanceTitle
        return headerCell
    }
}

// MARK: - UITableViewDataSource
extension AppListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.servers.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newCell = tableView.dequeueReusableCell(withIdentifier: ServerSelectCell.reuseIdentifier(), for: indexPath) as? ServerSelectCell ?? ServerSelectCell(style: .default, reuseIdentifier: ServerSelectCell.reuseIdentifier())
        let server = viewModel?.servers[indexPath.row]
        newCell.name = server?.name ?? ""
        newCell.distance = server?.distance ?? 0.0
        return newCell
    }
}


