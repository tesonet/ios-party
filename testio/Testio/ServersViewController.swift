//
//  ServersViewController.swift
//  testio
//
//  Created by Karolis Misiūra on 18/11/2017.
//  Copyright © 2017 Karolis Misiura. All rights reserved.
//

import UIKit
import CoreData

class ServersViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var accessToken: String?
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Server> = {
        let fetchRequest = Server.serverFetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "distance", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: ContextManager.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logoutButton = UIBarButtonItem()
        logoutButton.title = "logout"
        logoutButton.target = self
        logoutButton.action = #selector(logout)
        self.navigationItem.rightBarButtonItem = logoutButton
        
        let sortButton = UIBarButtonItem()
        sortButton.title = "sort"
        sortButton.target = self
        sortButton.action = #selector(sort)
        self.toolbarItems = [sortButton]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isToolbarHidden = false
        if let token = self.accessToken {
            API.serverList(access: token, completion: { (error, serverList) in
                if let error = error {
                    self.handle(error: error)
                } else if let serverList = serverList {
                    Server.importServers(serverList)
                    try? self.fetchedResultsController.performFetch()
                    self.tableView.reloadData()
                }
            })
        }
        
        try? self.fetchedResultsController.performFetch()
        self.tableView.reloadData()
    }
    
    func handle(error: Error) {
        if let error = error as? APIError {
            if error == APIError.unauthorized {
                let errorMessage = UIAlertController(title: "Sesion Expired", message: "Your session has expired, please login.", preferredStyle: UIAlertControllerStyle.alert)
                errorMessage.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
                    self.logout()
                }))
                self.present(errorMessage, animated: true, completion: nil)
            }
        }
    }
    
    @objc func logout() {
        let keychain = KeychainSwift()
        keychain.delete(LoginViewController.KeychainTokenKey)
        self.dismiss(animated: true, completion: nil)
    }
    
    func sortByName() {
        self.fetchedResultsController.fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        try? self.fetchedResultsController.performFetch()
        self.tableView.reloadData()
    }
    
    func sortByDistance() {
        self.fetchedResultsController.fetchRequest.sortDescriptors = [NSSortDescriptor(key: "distance", ascending: true)]
        try? self.fetchedResultsController.performFetch()
        self.tableView.reloadData()
    }
    
    @objc func sort() {
        let actionSheet = UIAlertController(title: "How would you like to sort it?", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let action1 = UIAlertAction(title: "By Distance", style: UIAlertActionStyle.default, handler: { (action) in
            self.sortByDistance()
        })
        
        let action2 = UIAlertAction(title: "By Name", style: UIAlertActionStyle.default, handler: { (action) in
            self.sortByName()
        })
        
        let action3 = UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel, handler: { (action) in })
        
        actionSheet.addAction(action1)
        actionSheet.addAction(action2)
        actionSheet.addAction(action3)
        
        self.present(actionSheet, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Fetched results controller delegate
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = self.fetchedResultsController.sections {
            return sections.count
        }
        
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let section = self.fetchedResultsController.sections?[section] {
            return section.numberOfObjects
        }
        
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellid")
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "cellid")
        }

        let server = self.fetchedResultsController.object(at: indexPath)
        cell!.textLabel?.text = server.name!
        cell!.detailTextLabel?.text = String(server.distance)

        return cell!
    }
}
