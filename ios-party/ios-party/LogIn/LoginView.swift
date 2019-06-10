import UIKit

protocol LoginViewDelegate: class {
    func didTapLogin(with username: String, and password: String, in viewController: LoginView)
}

final class LoginView: UIView {
    
    weak var delegate: LoginViewDelegate?
    
    lazy private var backgroundImage: UIImageView = {
        let image = UIImage(named: "login-screen")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy private var logoImageView: UIImageView = {
        let image = UIImage(named: "logo-white")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy private var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 16
        stackView.distribution = .fill
        return stackView
    }()
    
    lazy private var usernameInputField: LoginEntryTextField = {
        let inputField = LoginEntryTextField(type: .username)
        inputField.translatesAutoresizingMaskIntoConstraints = false
        return inputField
    }()
    
    lazy private var passwordInputField: LoginEntryTextField = {
        let inputField = LoginEntryTextField(type: .password)
        inputField.translatesAutoresizingMaskIntoConstraints = false
        return inputField
    }()
    
    lazy private var loginButton: LoginButton = {
        let button = LoginButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setupBackground()
        setupLogo()
        setupStackView()
        setupInputFields()
    }
    
    private func setupBackground() {
        addSubview(backgroundImage)
        NSLayoutConstraint.activate([
            backgroundImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            backgroundImage.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    private func setupLogo() {
        addSubview(logoImageView)
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: topAnchor, constant: 120),
            logoImageView.widthAnchor.constraint(equalToConstant: 130),
            logoImageView.heightAnchor.constraint(equalToConstant: 34),
            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    private func setupStackView() {
        addSubview(contentStackView)
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: logoImageView.topAnchor, constant: 200),
            contentStackView.widthAnchor.constraint(equalToConstant: 300),
            contentStackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    private func setupInputFields() {
        contentStackView.addArrangedSubview(usernameInputField)
        contentStackView.addArrangedSubview(passwordInputField)
        contentStackView.addArrangedSubview(loginButton)
    }
    
    @objc private func loginButtonTapped() {
        delegate?.didTapLogin(
            with: usernameInputField.value,
            and: passwordInputField.value,
            in: self
        )
    }
}
