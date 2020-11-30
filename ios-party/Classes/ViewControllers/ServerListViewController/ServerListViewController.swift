//
//  ServerListViewController.swift
//  ios-party
//
//  Created by Lukas on 11/28/20.
//

import UIKit

class ServerListViewController: UIViewController, LoadingIndicator {

    // MARK: - Constants
    struct Constants {
        static let serverHeaderTitle = "SERVER"
        static let distanceHeaderTitle = "DISTANCE"
        
        static let tableViewHeaderHight: CGFloat = 60
        static let tableViewSeperatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    // MARK: - Declarations
    internal var dataModel: ServerListDataModel!
    
    var loadingIndicatorView: UIActivityIndicatorView?
    var viewToDisplayIndicator: UIView {
        return super.view
    }
    
    // MARK: - Declarations
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        dataModel = ServerListDataModel(delegate: self)
        
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.separatorInset = Constants.tableViewSeperatorInset
        
        tableView.registerCellNib(withType: HeaderTableViewCell.self)
        tableView.registerCellNib(withType: ServerListTableViewCell.self)
        tableView.hideEmptyTableViewCells()
    }
    
    // MARK: - IBActions
    @IBAction func onLogoutButtonTap(_ sender: Any) {
        
    }
    
    @IBAction func onSortButtonTap(_ sender: Any) {
        showSortOptions()
    }
    
    private func showSortOptions() {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let sortByDistance = UIAlertAction(title: "By Distance", style: .default) { [weak self] action in
            self?.dataModel.set(sortType: .byDistance)
        }
        
        let sortByAlphanumeric = UIAlertAction(title: "Alphanumerical", style: .default) { [weak self] action in
            self?.dataModel.set(sortType: .byAlphanumeric)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(sortByDistance)
        alert.addAction(sortByAlphanumeric)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}
