//
//  ServerListHeaderView.swift
//  ios-party
//
//  Created by Ergin Bilgin on 2021-01-24.
//

import UIKit

class ServerListHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - Constants
    let kShadowOpacity: Float = 0.1
    let kShadowOffset = CGSize(width: 0, height: 15)
    let kShadowRadius: CGFloat = 15

    // MARK: - Declarations
    // MARK: - Outlets
    @IBOutlet weak var serverLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    // MARK: - Methods
    override func awakeFromNib() {
        serverLabel.text = R.string.localizable.server_header()
        distanceLabel.text = R.string.localizable.distance_header()
        
        layer.shadowOpacity = kShadowOpacity
        layer.shadowOffset = kShadowOffset
        layer.shadowRadius = kShadowRadius
    }
}
