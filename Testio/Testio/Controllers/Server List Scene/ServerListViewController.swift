//
//  ViewController.swift
//  Testio
//
//  Created by lbartkus on 09/02/2019.
//  Copyright © 2019 lbartkus. All rights reserved.
//

import UIKit

final class ServerListViewController: BaseController {
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.estimatedSectionHeaderHeight = 0
            tableView.estimatedRowHeight = 54
            tableView.rowHeight = UITableView.automaticDimension
        }
    }
    var viewModel: ServerListViewModel?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! {
        didSet {
            activityIndicator.startAnimating()
            activityIndicator.hidesWhenStopped = true
        }
    }
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var contentContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let viewModel = viewModel else { return }
        bindViewModel(viewModel)
    }
    
    func bindViewModel(_ viewModel: ServerListViewModel) {
        tableView.dataSource = viewModel
        viewModel.didFetchServers = { [unowned self] in
            self.tableView.reloadData()
            self.contentContainer.isHidden = false
            self.activityIndicator.stopAnimating()
            self.loadingLabel.isHidden = true
        }
    }
    
    @IBAction func logoutAction() {
        ApiSessionHandler.sharedInstance.logout()
        viewModel?.cleanup()
    }
 
    @IBAction func changeSortAction() {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let distanceAction = UIAlertAction(title: "By Distance", style: .default) { _ in
            self.viewModel?.fetchServers(sortedBy: .distance)
        }
        let alphanumericalAction = UIAlertAction(title: "Alphanumerical", style: .default) { [unowned self] _ in
            self.viewModel?.fetchServers(sortedBy: .name)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        optionMenu.addAction(distanceAction)
        optionMenu.addAction(alphanumericalAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
}

extension ServerListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ServerListViewHeader()
        return header
    }
}
