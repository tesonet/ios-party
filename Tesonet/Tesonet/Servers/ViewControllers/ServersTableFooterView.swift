import UIKit
import RxSwift
import RxCocoa

protocol ServersTableFooterDelegate: class {
    func sortWasPressed()
}

final class ServersTableFooterView: UIView {
    weak var delegate: ServersTableFooterDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

// MARK: - Navigation

extension ServersTableFooterView {
    @IBAction fileprivate func sortPressed() {
        delegate?.sortWasPressed()
    }
}
