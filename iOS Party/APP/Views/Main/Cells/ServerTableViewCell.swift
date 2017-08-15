//
//  TableViewCell.swift
//  iOS Party
//
//  Created by Justas Liola on 15/08/2017.
//  Copyright © 2017 JL. All rights reserved.
//

import UIKit

final class ServerTableViewCell: UITableViewCell {

    @IBOutlet private var titleLabel:    UILabel!
    @IBOutlet private var distanceLabel: UILabel!
    
    func setup(with server: ServerData) {
        titleLabel   .text = server.name
        distanceLabel.text = server.distance.km
    }

}

private extension Int {
    var km: String {
        return "\(self) km"
    }
}
