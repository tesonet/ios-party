// Created by Paulius Cesekas on 07/04/2019.

import UIKit

class ServerListHeader: UITableViewHeaderFooterView {
    // MARK: - Constants
    private let shadowRadius: CGFloat = 15
    
    // MARK: - Outlets
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var distanceLabel: UILabel!
    @IBOutlet private weak var shadowView: UIView!

    // MARK: - Methods -
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        contentView.backgroundColor = UIColor.secondary
        layer.masksToBounds = false
        setupShadow()
        setupNameLabel()
        setupDistanceLabel()
    }
    
    private func setupShadow() {
        shadowView.backgroundColor = UIColor.secondary
        shadowView.layer.shadowColor = UIColor.shadow.cgColor
        shadowView.layer.shadowOpacity = 1
        shadowView.layer.shadowOffset = .zero
        shadowView.layer.shadowRadius = shadowRadius
    }
    
    private func setupNameLabel() {
        nameLabel.font = UIFont.header
        nameLabel.textColor = UIColor.header
        nameLabel.text = L10n.ServerList.Header.name
    }
    
    private func setupDistanceLabel() {
        distanceLabel.font = UIFont.header
        distanceLabel.textColor = UIColor.header
        distanceLabel.text = L10n.ServerList.Header.distance
    }
}
