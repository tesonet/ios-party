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
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var controller: NSFetchedResultsController<Server>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.separatorColor = .darkGray
        
        let nib = UINib(nibName: Cell.serverCell, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: Cell.serverCell)
        
        controller = CDService.instance.fetch(sortBy: .alphanumeric)
        controller.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        debugPrint("Succesfully fetched some objects: ",controller.fetchedObjects?.count ?? 0)
    }
    
    @IBAction func sortButtonPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "By Distance", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Alphanumerical", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction private func logOutButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension ServerListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.serverCell, for: indexPath) as? ServerCell else { return ServerCell() }
        cell.configureCell(withServer: controller.object(at: indexPath))
        return ServerCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return controller.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controller.fetchedObjects?.count ?? 0
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
