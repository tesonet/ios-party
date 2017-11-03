//
//  ServersListTableViewController.swift
//  ServersList
//
//  Created by Tomas Stasiulionis on 15/10/2017.
//  Copyright © 2017 Tomas Stasiulionis. All rights reserved.
//

import UIKit

class ServersListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TesonetAPIDelegate {
    
    
    @IBOutlet weak var serversListTableView: UITableView!
    
    var servers = [Server]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableViewHeader()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func logout(_ sender: Any) {
        let api = TesonetAPI.sharedInstance
        
        api.cleanAuthorizationToken()
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    func setupTableViewHeader(){
        let headerView = ServersTableViewHeader.instanceFromNib()
        
        self.serversListTableView.tableHeaderView = headerView
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.servers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ServerTableViewCell = tableView.dequeueReusableCell(withIdentifier: "serverCell", for: indexPath) as! ServerTableViewCell

        cell.serverName.text = self.servers[indexPath.row].name
        cell.serverDistance.text = "\(self.servers[indexPath.row].distance) km"

        return cell
    }
    
}
