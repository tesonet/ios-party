import UIKit

class ServerListHeaderView: UIView {
    @IBOutlet weak var serverTitleLabel: UILabel!
    @IBOutlet weak var distanceTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupShadow()
        setupTitleLabels()
    }
    
    // MARK: Setup
    
    func setupShadow() {
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 0, height: 10)
        layer.shadowRadius = 7
        layer.shadowOpacity = 0.9
        layer.shadowColor = UIColor(red: 222/255, green: 225/255, blue: 229/255, alpha: 1).cgColor
    }
    
    func setupTitleLabels() {
        serverTitleLabel.text = __("server").uppercased()
        distanceTitleLabel.text = __("distance").uppercased()
    }
}
