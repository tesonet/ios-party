import UIKit

class ServersListTableCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with item: Server) {
        nameLabel.text = item.name
        distanceLabel.text = String(item.distance ?? -1)
    }
}
