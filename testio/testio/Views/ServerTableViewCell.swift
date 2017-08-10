import UIKit

class ServerTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    // MARK: Configure
    
    func configure(with viewModel: ServerCellViewModel) {
        nameLabel.text = viewModel.serverName
        distanceLabel.text = viewModel.distance
    }
}
