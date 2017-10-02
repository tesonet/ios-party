//
//  ServerListViewController.swift
//  Server Browser
//
//  Created by Tanya on 10/1/17.
//  Copyright © 2017 Slava. All rights reserved.
//

import Cocoa

class ServerListViewController: NSViewController, NSTableViewDataSource {
    // MARK: - Outlets
    
    @IBOutlet weak var serversTableView: NSTableView!
    
    // MARK: -
    
    weak var delegate: ServerListViewControllerDelegate?
    var serverList = [Server]()
    
    // MARK: - Actions
    
    @IBAction func logout(_ sender: NSButton) {
        delegate?.serverListViewControllerDidRequestLogout(self)
    }
    
    // MARK: - NSTableViewDataSource
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        guard tableView == serversTableView else {
            return 0
        }
        
        return serverList.count
    }
    
    func tableView(_ tableView: NSTableView,
                   objectValueFor tableColumn: NSTableColumn?,
                   row: Int) -> Any? {
        guard tableView == serversTableView else {
            return 0
        }
        
        let columnIdentifier = tableColumn?.identifier
        if columnIdentifier == "name" {
            return serverList[row].name
        }
        else if columnIdentifier == "distance" {
            return "\(serverList[row].distance) km"
        }
        return nil
    }
}
