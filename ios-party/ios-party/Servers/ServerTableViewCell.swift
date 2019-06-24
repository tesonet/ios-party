import UIKit

final class ServerTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: type(of: self))
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.init(red: 102/255, green: 102/255, blue: 102/255, alpha: 1)
        return label
    }()
    
    private lazy var distanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.init(red: 102/255, green: 102/255, blue: 102/255, alpha: 1)
        return label
    }()
    
    var server: ServersViewModel.Server? {
        didSet {
            if let server = server {
                nameLabel.text = server.name
                distanceLabel.text = server.distance
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setupNameLabel()
        setupDistanceLabel()
    }
    
    private func setupNameLabel() {
        addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func setupDistanceLabel() {
        addSubview(distanceLabel)
        
        NSLayoutConstraint.activate([
            distanceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            distanceLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
