import UIKit

class ServersTableCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        style()
    }
    
    func configure(with item: Server) {
        nameLabel.text = item.name
        distanceLabel.text = String(item.distance)
    }
}

// MARK: Private Methods

extension ServersTableCell {
    
    fileprivate func style() {
        
    }
    
}


