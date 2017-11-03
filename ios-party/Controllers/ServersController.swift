//
//  ServersController.swift
//  ios-party
//
//  Created by Ilya Vlasov on 8/4/17.
//  Copyright © 2017 Ilya Vlasov. All rights reserved.
//

import UIKit

class ServersController: UIViewController {
    var servers = [Server]()
    var filteredServers = [Server]()
    
    var shouldShowSearchResults = false
    
    @IBOutlet weak var serversTable: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
        serversTable.register(UINib.init(nibName: "ServerCell", bundle: Bundle.main), forCellReuseIdentifier: "servercell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        serversTable.tableHeaderView = searchController.searchBar
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredServers = servers.filter { server in
            return server.name.lowercased().contains(searchText.lowercased())
        }
        
        serversTable.reloadData()
    }
    

}

extension ServersController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}

extension ServersController : UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
     
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //
    }
}

extension ServersController : UITableViewDelegate   {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return self.filteredServers.count
        }
        return self.servers.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension ServersController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "servercell", for: indexPath) as! ServerCell
        let server: Server
        if searchController.isActive && searchController.searchBar.text != "" {
            server = filteredServers[indexPath.row]
        } else {
            server = servers[indexPath.row]
        }
        cell.nameLabel.text = server.name
        cell.distanceLabel.text = "\(server.distance) km"
        return cell
    }
}
