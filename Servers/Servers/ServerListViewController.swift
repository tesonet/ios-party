//
//  ServerListViewController.swift
//  Servers
//
//  Created by Rimantas Lukosevicius on 11/06/2018.
//  Copyright © 2018 Rimantas Lukosevicius. All rights reserved.
//

import UIKit
import CoreData

class ServerListViewController: UIViewController, UITableViewDataSource {
    @IBOutlet var tableView : UITableView?
    
    var fetchResultsController : NSFetchedResultsController<Server>?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let fetchedObjects = self.fetchResultsController?.fetchedObjects {
            return fetchedObjects.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServerCell") as! ServerCell
        
        let server : Server = self.fetchResultsController?.sections![indexPath.section].objects![indexPath.row] as! Server
        
        cell.nameLabel.text = server.name
        cell.distanceLabel.text = String(format: "%.1f km.", server.distance)
        
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<Server>(entityName: "Server")
        
        var sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [ sortDescriptor ]
        
        let frc = NSFetchedResultsController(fetchRequest: request,
                                             managedObjectContext: context,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        
        self.fetchResultsController = frc
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        reloadTableContent()
    }
    
    func reloadTableContent() {
        try! self.fetchResultsController?.performFetch()
        
        tableView?.reloadData()
    }
}
