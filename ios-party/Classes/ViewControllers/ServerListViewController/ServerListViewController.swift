//
//  ServerListViewController.swift
//  ios-party
//
//  Created by Lukas on 11/28/20.
//

import UIKit

class ServerListViewController: UIViewController {

    // MARK: - Constants
    struct Constants {
        static let serverHeaderTitle = "SERVER"
        static let distanceHeaderTitle = "DISTANCE"
        
        static let tableViewHeaderHight: CGFloat = 60
    }
    
    // MARK: - Declarations
    internal var dataModel: ServerListDataModel!
    
    // MARK: - Declarations
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        dataModel = ServerListDataModel(delegate: self)
        
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20) // FIXME: looks strange
        
        tableView.registerCellNib(withType: HeaderTableViewCell.self)
        tableView.registerCellNib(withType: ServerListTableViewCell.self)
        tableView.hideEmptyTableViewCells()
    }
    
    // MARK: - IBActions
    @IBAction func onLogoutButtonTap(_ sender: Any) {
        
    }
}
