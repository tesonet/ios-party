// Created by Paulius Cesekas on 06/04/2019.

import UIKit
import Domain

class ServerListCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var distanceLabel: UILabel!
    @IBOutlet private weak var separatorView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    // MARK: - Setup
    private func setupUI() {
        setupNameLabel()
        setupDistanceLabel()
        setupSeparator()
    }
    
    private func setupNameLabel() {
        nameLabel.font = UIFont.Cell.title
        nameLabel.textColor = UIColor.Cell.title
    }
    
    private func setupDistanceLabel() {
        distanceLabel.font = UIFont.Cell.value
        distanceLabel.textColor = UIColor.Cell.value
    }
    
    private func setupSeparator() {
        separatorView.backgroundColor = UIColor.Cell.separator
    }
    
    // MARK: - Populate
    func populate(_ server: Server) {
        nameLabel.text = server.name
        distanceLabel.text = L10n.ServerList.Cell.distance(server.distance)
    }
}
