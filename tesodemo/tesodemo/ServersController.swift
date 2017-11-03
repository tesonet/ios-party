//
//  ServersController.swift
//  tesodemo
//
//  Created by Vytautas Vasiliauskas on 16/07/2017.
//
//

import UIKit

class ServersController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var toolbarView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerLeftLabel: UILabel!
    @IBOutlet weak var headerRightLabel: UILabel!
    var servers: [ServerModel] = []
    var isFirstLoad: Bool = true
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "ServerCell", bundle: nil), forCellReuseIdentifier: "ServerCell")
        tableView.separatorColor = UIColor.appSeparator
        tableView.rowHeight = ServerCell.height()
        
        toolbarView.backgroundColor = UIColor.appToolbarBg
        
        headerLeftLabel.font = UIFont.applicationFont(.light, size: 9)
        headerLeftLabel.textColor = UIColor.appListHeader
        headerLeftLabel.text = "ServersNameHeader".localized
        
        headerRightLabel.font = UIFont.applicationFont(.light, size: 9)
        headerRightLabel.textColor = UIColor.appListHeader
        headerRightLabel.text = "ServersDistanceHeader".localized
        
        headerView.backgroundColor = UIColor.white
        headerView.layer.shadowColor = UIColor.appShadow.cgColor
        headerView.layer.shadowOpacity = 1
        headerView.layer.shadowRadius = 30
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchServers), name: SessionManager.notificationKeyForCreatedSession, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !SessionManager.sharedInstance.isActive {
            self.performSegue(withIdentifier: "LoginControllerSegue", sender: nil)
        } else if isFirstLoad {
            fetchServers()
        }
        isFirstLoad = false
    }

    func fetchServers() {
        LoadingView.sharedInstance().start(text: "LoadingFetchingList".localized)
        API(.RetrieveServers()) {[weak self] (success, json) in
            self?.dismiss(animated: false, completion: nil)
            LoadingView.sharedInstance().stop()
            guard let weakSelf = self else { return }
            weakSelf.servers.removeAll()
            if success, let array = json as? [[String: Any]] {
                for obj in array {
                    weakSelf.servers.append(ServerModel(json: obj))
                }
            }
            weakSelf.tableView.reloadData()
        }
    }
    
    @IBAction func logoutClicked() {
        SessionManager.sharedInstance.destroy()
        self.performSegue(withIdentifier: "LoginControllerAnimatedSegue", sender: nil)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return servers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServerCell", for: indexPath) as! ServerCell
        cell.setup(server: servers[indexPath.row])
        return cell
    }
}
