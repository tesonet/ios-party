import UIKit

protocol ServersTableFooterDelegate: class {
    func sortWasPressed()
}

final class ServersTableFooterView: UIView {
    
    weak var delegate: ServersTableFooterDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        style()
    }
    
}

// MARK: - Navigation

extension ServersTableFooterView {
    
    @IBAction fileprivate func sortPressed() {
        delegate?.sortWasPressed()
    }
    
}

// MARK: - Private Methods

extension ServersTableFooterView {
    
    fileprivate func style() {
        
    }
    
}
