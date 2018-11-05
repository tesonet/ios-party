//
//  ServerListVC.swift
//  testio
//
//  Created by Valentinas Mirosnicenko on 11/2/18.
//  Copyright © 2018 Valentinas Mirosnicenko. All rights reserved.
//

import UIKit
import CoreData

class ServerListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var controller: NSFetchedResultsController<Server>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.separatorColor = .darkGray
        
        let nib = UINib(nibName: Cell.serverCell, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: Cell.serverCell)
        
        attemptFetch(soryBy: Schema.Server.name)
        controller.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        debugPrint("Succesfully fetched some objects: ",controller.fetchedObjects?.count ?? 0)
    }
    
    @IBAction func sortButtonPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "By Distance", style: .default, handler: { (_) in
            debugPrint("Sorting by distance")
            self.attemptFetch(soryBy: Schema.Server.distance)
        }))
        alert.addAction(UIAlertAction(title: "Alphanumerical", style: .default, handler: { (_) in
            debugPrint("Alphanumeric sorting")
            self.attemptFetch(soryBy: Schema.Server.name)
        }))
        
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction private func logOutButtonPressed(_ sender: Any) {
        DataService.instance.logOut { (success) in
            if success {
                if let servers = self.controller.fetchedObjects {
                    CDService.instance.delete(objects: servers)
                }
                UserDefaults.standard.set(false, forKey: USER_LOGGED_IN)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    private func attemptFetch(soryBy: String) {
        controller = CDService.instance.fetch(sortBy: soryBy) as? NSFetchedResultsController<Server>
        tableView.reloadData()
    }
    
}

extension ServerListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.serverCell, for: indexPath) as? ServerCell else { return ServerCell() }
        cell.configureCell(withServer: controller.object(at: indexPath))
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return controller.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = controller.sections {
            let section = sections[section]
            return section.numberOfObjects
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
}

extension ServerListVC: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch(type) {
            
        case.insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
            
        case.update:
            if let indexPath = indexPath {
                guard let cell = tableView.cellForRow(at: indexPath) as? ServerCell else { return }
                cell.configureCell(withServer: controller.object(at: indexPath) as! Server)
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
            break
            
        case.delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
            
        case.move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
}
