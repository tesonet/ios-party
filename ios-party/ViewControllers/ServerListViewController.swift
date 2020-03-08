//
//  ServerListViewController.swift
//  ios-party
//
//  Created by Joseph on 3/7/20.
//  Copyright © 2020 Juozas Valancius. All rights reserved.
//

import UIKit

final class ServerListViewController: UITableViewController {

  @IBOutlet weak var headerView: UIView!
  var servers = [ServerListResponseItem]()

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return servers.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    let item = servers[indexPath.row]
    cell.textLabel?.text = item.name
    cell.detailTextLabel?.text = "\(item.distance) km"
    return cell
  }

  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return headerView
  }

  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return headerView.frame.height
  }

}
