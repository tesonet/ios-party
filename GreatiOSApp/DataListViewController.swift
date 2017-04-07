//
//  DataListViewController.swift
//  GreatiOSApp
//
//  Created by Domas on 4/7/17.
//  Copyright © 2017 Sonic Team. All rights reserved.
//

import UIKit

class DataListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var data: [DataItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor.clear
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func logoutButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: {});
    }
}

extension DataListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DataTableViewCell
        
        cell.titleLabel.text = data[indexPath.row].name
        cell.valueLabel.text = String(data[indexPath.row].distance) + " km"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

