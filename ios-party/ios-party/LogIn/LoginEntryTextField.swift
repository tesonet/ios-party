import UIKit

final class LoginEntryTextField: UIView {
    
    enum `Type` {
        case username
        case password
        
        var iconImage: UIImage? {
            switch self {
            case .username:
                return UIImage(named: "ico-username")
            case .password:
                return UIImage(named: "ico-lock")
            }
        }
        
        var isTextHidden: Bool {
            switch self {
            case .username:
                return false
            case .password:
                return true
            }
        }
        
        var placeholder: String {
            switch self {
            case .username:
                return "Username"
            case .password:
                return "Password"
            }
        }
    }
    
    private let type: `Type`
    
    private lazy var iconImageView: UIImageView = {
        let image = type.iconImage
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = type.isTextHidden
        textField.placeholder = type.placeholder
        textField.textColor = UIColor.init(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.backgroundColor = UIColor.white
        return view
    }()
    
    init(type: `Type`) {
        self.type = type
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 60)
        ])
        
        setupBackgroundView()
        setupIconImageView()
        setupInputTextView()
    }
    
    private func setupBackgroundView() {
        addSubview(backgroundView)
        NSLayoutConstraint.fill(view: self, with: backgroundView)
    }
    
    private func setupIconImageView() {
        addSubview(iconImageView)
        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    private func setupInputTextView() {
        addSubview(inputTextField)
        NSLayoutConstraint.activate([
            inputTextField.centerYAnchor.constraint(equalTo: centerYAnchor),
            inputTextField.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            inputTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 16),
        ])
    }
}
