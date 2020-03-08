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
  var servers: [ServerDescriptor] = ServerStorage.shared.list

  private let distanceFormatter = NumberFormatter()

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return servers.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

    if let serverCell = cell as? ServerCell {
      let item = servers[indexPath.row]
      serverCell.serverLabel.text = item.name
      let distance = distanceFormatter.string(from: NSNumber(value: item.distance))
      serverCell.distanceLabel.text = (distance ?? "-") + " km"
    }

    return cell

  }

  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return headerView
  }

  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return headerView.frame.height
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }

  override func viewWillAppear(_ animated: Bool) {

    super.viewWillAppear(animated)

    guard let navigation = navigationController else { return }
    navigation.isToolbarHidden = false

    guard let toolbar = navigation.toolbar else { return }
    toolbar.barStyle = .blackTranslucent
    toolbar.barTintColor = UIColor(named: "toolbar-color")

  }

  @IBAction func didClickSort(_ sender: Any) {

    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

    alert.addAction(UIAlertAction(
      title: "By Distance",
      style: .default,
      handler: didClickSortByDistance
    ))

    alert.addAction(UIAlertAction(
      title: "Alphanumerical",
      style: .default,
      handler: didClickSortAlphanumerical
    ))

    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    (parent ?? self).present(alert, animated: true)

  }

  func didClickSortByDistance(_: UIAlertAction) {
    servers.sort { $0.distance < $1.distance }
    tableView.reloadData()
  }

  func didClickSortAlphanumerical(_: UIAlertAction) {
    servers.sort { $0.name < $1.name }
    tableView.reloadData()
  }

  @IBAction func didClickLogout(_ sender: UIBarButtonItem) {

    CredentialStorage.shared.clearAllCredentials()
    ServerStorage.shared.clearStorage()

    MainStoryboardController.shared.switchToSplashViewController()

  }

}
