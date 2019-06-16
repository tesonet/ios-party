import UIKit

protocol ServersViewDelegate: class {

}

final class ServersView: UIView {
    
    weak var delegate: ServersViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {

    }
}
