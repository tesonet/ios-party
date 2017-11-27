import UIKit

class ServerCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    func update(server: Server) {
        nameLabel.text = server.name
        distanceLabel.text = String(server.distance) + " km"
    }
}
