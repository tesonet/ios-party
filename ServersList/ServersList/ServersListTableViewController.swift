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
    
    func downloadedInfo(info: NSArray) {
        for server in info{
            if let serverDictionary = server as? NSDictionary{
                servers.append(Server(name: serverDictionary.object(forKey: "name") as! String, distance:serverDictionary.object(forKey: "distance") as! Int ))
            }
            
        }
        self.serversListTableView!.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableViewHeader()
    
        let api = TesonetAPI.sharedInstance
        api.delegate = self;
        api.getServers()
    }
    
    func setupTableViewHeader(){
        
        let headerView = ServersTableViewHeader.instanceFromNib()
    
        self.serversListTableView.tableHeaderView = headerView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.servers.count
    }

    @IBAction func logout(_ sender: Any) {
        let api = TesonetAPI.sharedInstance
        
        api.cleanAuthorizationToken()
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ServerTableViewCell = tableView.dequeueReusableCell(withIdentifier: "serverCell", for: indexPath) as! ServerTableViewCell

        cell.serverName.text = self.servers[indexPath.row].name
        cell.serverDistance.text = "\(self.servers[indexPath.row].distance) km"

        return cell
    }
    
}
