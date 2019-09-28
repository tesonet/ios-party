//
//  ListScreenViewController.swift
//  iosparty
//
//  Created by Mantas Skeiverys on 28/09/2019.
//  Copyright © 2019 Mantas Skeiverys. All rights reserved.
//

import Foundation
import UIKit

class ListScreenViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var logoutButton: UIImageView!
    
    var serverList = [Server]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadServers()
        tableView.dataSource = self
        sortButton.centerTextAndImage(spacing: 6)
        setupLogoutButton()
    }
    
    
    private func loadServers(){
        ServerManager.getServers { (servers) in
            for server in servers{
                self.serverList.append(server)
            }
            self.tableView.reloadData()
        }
    }
    
    private func sort(by newOrder: order){
        if newOrder == .alphanumerical{
            serverList = serverList.sorted(by: { (server1, server2) -> Bool in
                return server1.name < server2.name
            })
        }else if newOrder == .distance{
            serverList = serverList.sorted(by: { (server1, server2) -> Bool in
                return server1.distance < server2.distance
            })
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serverList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "serverTableCell", for: indexPath) as! ServerListCell
        let server = serverList[indexPath.row]
        cell.serverLabel.text = server.name
        cell.distanceLabel.text = String(server.distance)
        
        return cell
    }
    
    @IBAction func sortClicked(_ sender: Any) {
        showSortActionSheet()
    }
    
    private func setupLogoutButton(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(logoutButtonTapped(tapGestureRecognizer:)))
        logoutButton.isUserInteractionEnabled = true
        logoutButton.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func logoutButtonTapped(tapGestureRecognizer: UITapGestureRecognizer){
        navigationController?.popToRootViewController(animated: true)
    }
    
    private func showSortActionSheet(){
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let sortAlphanumericallyAction = UIAlertAction(title: "Alphanumerical", style: .default) { (action) in
            self.sort(by: .alphanumerical)
        }
        let sortByDistanceAction = UIAlertAction(title: "By Distance", style: .default) { (action) in
            self.sort(by: .distance)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        actionSheet.addAction(sortAlphanumericallyAction)
        actionSheet.addAction(sortByDistanceAction)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
}

final class ServerListCell : UITableViewCell{
    @IBOutlet weak var serverLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
}

enum order {
    case alphanumerical, distance
}
