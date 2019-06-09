import UIKit

final class LoginButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 60)
        ])
        
        layer.cornerRadius = 20
        backgroundColor = UIColor.init(red: 160/255, green: 211/255, blue: 66/255, alpha: 1)
        setTitle("Log in", for: .normal)
    }
}
