//
//  ServerListViewController.swift
//  Party
//
//  Created by Darius Janavicius on 17/07/2019.
//  Copyright © 2019 tesonet. All rights reserved.
//

import UIKit

class ServerListViewController: BaseViewController, Alertable, LoaderDisplaying {

    // MARK: - UI Components
    
    @IBOutlet weak private var tableView: UITableView!
    
    // MARK: - States
    
    var dataModel: ServerListDataModel!
    
    // MARK: - Override superclass
    
    override func configureAfterInit() {
        dataModel = ServerListDataModel(delegate: self,
                                        apiClient: ApiClient.shared)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerCellNib(withType: ServerCell.self)
        
        dataModel.loadData()
    }
    
    // MARK: - Actions
    
    @IBAction private func logout(_ sender: Any) {
        LogoutController(source: self).logout()
    }
    
    @IBAction func showSortingOptions(_ sender: Any) {
        let actionSheet = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        let sortByDistanceAction = UIAlertAction(title: "By Distance",
                                                 style: .default) { [weak self] _ in
                                                    self?.dataModel.sort(by: .distance)
        }
        
        let sortAlphanumericalAction = UIAlertAction(title: "Alphanumerical",
                                                     style: .default) { [weak self] _ in
                                                        self?.dataModel.sort(by: .alphanumerical)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: nil)
        actionSheet.addAction(sortByDistanceAction)
        actionSheet.addAction(sortAlphanumericalAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
}

// MARK: -

extension ServerListViewController: ServerListDataModelDelegate {
    
    // MARK: - ServerListDataModelDelegate
    
    func serverListDataModelDidStartLoading(_ dataModel: ServerListDataModel) {
        showLoader()
    }
    
    func serverListDataModelDidSortData(_ dataModel: ServerListDataModel) {
        tableView.reloadData()
    }
    
    func serverListDataModelDidLoad(_ dataModel: ServerListDataModel) {
        // add delay just to see loader before data is loaded. :)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.dismissLoader { 
                self?.tableView.reloadData()
            }
        }
    }
    
    func serverListDataModel(_ dataModel: ServerListDataModel, didFailWithError error: Error) {
        showErrorAlert(message: error.localizedDescription)
    }
}

// MARK: -

extension ServerListViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return dataModel.data[indexPath.row].cellInstance(in: tableView)
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataModel.data[indexPath.row].cellHeight
    }
}
