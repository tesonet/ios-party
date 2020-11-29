//
//  ServerListViewController.swift
//  ios-party
//
//  Created by Lukas on 11/28/20.
//

import UIKit

class ServerListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Constants
    struct Constants {
        static let serverHeaderTitle = "SERVER"
        static let distanceHeaderTitle = "DISTANCE"
    }
    
    // MARK: - Declarations
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20) // FIXME: looks strange
        
        tableView.registerCellNib(withType: HeaderTableViewCell.self)
        tableView.registerCellNib(withType: ServerListTableViewCell.self)
        tableView.hideEmptyTableViewCells()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell: ServerListTableViewCell =
            tableView.dequeueReusableCellWithClass(ServerListTableViewCell.self) as? ServerListTableViewCell else {
            print("WARNING! Could not dequeue `ServerListTableViewCell` from table view.")
            return UITableViewCell()
        }
        
        cell.populate()
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCellWithClass(HeaderTableViewCell.self) as? HeaderTableViewCell else {
            return nil
        }
        
        cell.populate(serverTitle: Constants.serverHeaderTitle, distanceTitle: Constants.distanceHeaderTitle)
        return cell
    }
    
    // MARK: - IBActions
    @IBAction func onLogoutButtonTap(_ sender: Any) {
        
    }
}
