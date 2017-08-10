import UIKit

private let textFieldLeftImagePadding = CGFloat(15)
private let viewCornerRadius = CGFloat(3)

class LoginView: UIView {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    var onLoginTap: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLoginButton()
        setupErrorLabel()
        setupTextFields()
    }
    
    // MARK: Actions
    
    @IBAction func loginTapAction(_ sender: Any) {
        onLoginTap?()
    }
    
    // MARK: Setup
    
    private func setupLoginButton() {
        loginButton.roundCorners(by: viewCornerRadius)
        loginButton.setTitle(__("log_in").capitalized, for: .normal)
    }
    
    private func setupErrorLabel() {
        errorLabel.text = ""
    }
    
    private func setupTextFields() {
        setupLeftView(for: usernameTextField, with: UIImage(named: "UsernameIcon")!)
        setupLeftView(for: passwordTextField, with: UIImage(named: "PasswordIcon")!)
        
        usernameTextField.roundCorners(by: viewCornerRadius)
        passwordTextField.roundCorners(by: viewCornerRadius)
        
        usernameTextField.placeholder = __("username_placeholder")
        passwordTextField.placeholder = __("password_placeholder")
    }
    
    private func setupLeftView(for textField: UITextField, with image: UIImage) {
        let leftImageView = UIImageView(image: image)
        leftImageView.contentMode = .center
        if let size = leftImageView.image?.size {
            leftImageView.frame.size = CGSize(
                width: size.width + (textFieldLeftImagePadding * 2),
                height: size.height
            )
        }
        textField.leftViewMode = .always
        textField.leftView = leftImageView
    }
}
