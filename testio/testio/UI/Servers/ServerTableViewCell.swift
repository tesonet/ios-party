
import UIKit


class ServerTableViewCell: UITableViewCell {

    static let id = "serverTableViewCell"
    static let nib = UINib(nibName: "ServerTableViewCell", bundle: nil)
    
    @IBOutlet weak var serverLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var server: Server? {
        didSet {
            serverLabel.text = server?.name
            distanceLabel.text = "\(server?.distance ?? 0) km"
        }
    }
}
