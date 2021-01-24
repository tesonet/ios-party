//
//  ServerListViewController.swift
//  ios-party
//
//  Created by Ergin Bilgin on 2021-01-24.
//

import UIKit

class ServerListViewController: BaseViewController,
                                ServerListDataModelDelegate,
                                UITableViewDataSource,
                                UITableViewDelegate {
    
    // MARK: - Declarations
    var dataModel: ServerListDataModelInterface!
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Dependencies
    var authorization: AuthorizationInterface = Authorization.shared
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataModel = ServerListDataModel(delegate: self)
        registerTableViewCells()
    }
    
    // MARK: - UI Actions
    @IBAction func onSortButtonTap(_ sender: Any) {
        present(sortAlertController(), animated: true)
    }
    
    @IBAction func onLogoutButtonTap(_ sender: Any) {
        authorization.logout()
    }

    // MARK: - ServerListDataModelDelegate
    func serverListDataModel(didSortServerList: ServerListDataModelInterface) {
        tableView.reloadData()
    }
    
    // MARK: - Helpers
    func sortAlertController() -> UIAlertController {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let distanceAction = UIAlertAction(title: ServerSortType.distance.title(),
                                           style: .default,
                                           handler: { [weak self] _ in
                                            self?.dataModel.sortServerList(by: .distance)
                                           })
        
        let alphanumericalAction = UIAlertAction(title: ServerSortType.alphanumerical.title(),
                                                 style: .default,
                                                 handler: { [weak self] _ in
                                                  self?.dataModel.sortServerList(by: .alphanumerical)
                                                 })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(distanceAction)
        alertController.addAction(alphanumericalAction)
        alertController.addAction(cancelAction)
        
        return alertController
    }
}
