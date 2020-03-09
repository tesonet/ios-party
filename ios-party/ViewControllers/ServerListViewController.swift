//
//  ServerListViewController.swift
//  ios-party
//
//  Created by Joseph on 3/7/20.
//  Copyright © 2020 Juozas Valancius. All rights reserved.
//

import UIKit

final class ServerListViewController: UITableViewController {

  enum Sort {
    case server
    case distance
    case name
  }

  @IBOutlet weak var headerView: UIView!
  var servers: [ServerDescriptor] = ServerStorage.shared.list

  private let distanceFormatter = NumberFormatter()
  private var sort: Sort = .server
  private var sortIsAscending = true

  override func viewDidLoad() {
    super.viewDidLoad()
    refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
  }

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

  @objc
  func didPullToRefresh() {
    let loader = DataLoader.shared
    if !loader.isLoading { loader.beginListLoadSequence(delegate: self) }
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

    if sort == .distance { sortIsAscending = !sortIsAscending }
    else { sortIsAscending = true }
    sort = .distance

    if sortIsAscending { servers.sort { $0.distance < $1.distance } }
    else { servers.sort { $0.distance > $1.distance } }

    tableView.reloadData()

  }

  func didClickSortAlphanumerical(_: UIAlertAction) {

    if sort == .name { sortIsAscending = !sortIsAscending }
    else { sortIsAscending = true }
    sort = .name

    let direction: ComparisonResult
    if sortIsAscending { direction = .orderedAscending }
    else { direction = .orderedDescending }

    servers.sort { $0.name.localizedStandardCompare($1.name) == direction }

    tableView.reloadData()

  }

  @IBAction func didClickLogout(_ sender: UIBarButtonItem?) {
    performLogout()
  }

  /// Returns a new view controller (the splash view controller)
  @discardableResult
  private func performLogout() -> UIViewController {

    DataLoader.shared.cancelAnyTasks()
    CredentialStorage.shared.clearAllCredentials()
    ServerStorage.shared.clearStorage()

    return MainStoryboardController.shared.switchToSplashViewController()

  }

}

extension ServerListViewController: DataLoaderDelegate {

  func presentSuccess() {
    servers = ServerStorage.shared.list
    sort = .server
    sortIsAscending = true
    refreshControl?.endRefreshing()
    tableView.reloadData()
  }

  func presentError(_ error: Error) {

    if (error as? HTTPError)?.code == 401 || error is ApplicationDataError {
      let nextVC = performLogout()
      nextVC.showErrorMessage("Please Log In Again.")
    } else {
      showErrorMessage(error.localizedDescription)
      refreshControl?.endRefreshing()
    }

  }

}
