import UIKit
import Just
import MaterialComponents.MaterialActivityIndicator
import SwiftKeychainWrapper

class LoginViewController: UIViewController {
	
	var token: String? = nil
	
	@IBOutlet weak var imgLogo: UIImageView!
	@IBOutlet weak var inputViewName: UIView!
	@IBOutlet weak var inputViewPassw: UIView!
	@IBOutlet weak var btnLogin: UIButton!
	
	@IBOutlet weak var textUsername: UITextField!
	@IBOutlet weak var textPassword: UITextField!
	
	@IBOutlet weak var labelMessage: UILabel!
	
	var _activityIndicator: MDCActivityIndicator? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
		
		imgLogo.alpha = 0 // initially invisible
		inputViewName.alpha = 0
		inputViewPassw.alpha = 0
		btnLogin.alpha = 0
		
		labelMessage.isHidden = true
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.isNavigationBarHidden = true
		showOrHideInputs(show: true)
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		// use saved username/password saved after last login
		
		if let username = KeychainWrapper.standard.string(forKey: Key.username) {
			textUsername.text = username
			textPassword.text = KeychainWrapper.standard.string(forKey: Key.password)
		}
	}
	
	private func showOrHideInputs(show: Bool) {
		let alpha: CGFloat = show ? 1.0 : 0.0
		labelMessage.isHidden = true
		
		UIView.animate(withDuration: 0.4) {
			self.imgLogo.alpha = alpha
			self.inputViewName.alpha = alpha
			self.inputViewPassw.alpha = alpha
			self.btnLogin.alpha = alpha
		}
	}
	
	private func showErrorMessage(_ text: String) {
		DispatchQueue.main.async {
			self.labelMessage.isHidden = false
			self.labelMessage.textColor = UIColor(red: 1.0, green: 0.5, blue: 0.5, alpha: 1.0)
			self.labelMessage.text = text
		}
	}
	
	private func showLoadProgress() {
		DispatchQueue.main.async {
			self.showOrHideInputs(show: false)
			
			if self._activityIndicator == nil {
				self._activityIndicator = MDCActivityIndicator()
				self._activityIndicator?.cycleColors = [.white]
				self._activityIndicator?.sizeToFit()
				
				self.view.addSubview(self._activityIndicator!)
				
				self._activityIndicator?.snp.makeConstraints({ (make) in
					make.centerX.centerY.equalToSuperview()
				})
			}
			
			self._activityIndicator?.startAnimating()
		}
	}
	
	private func hideLoadProgress() {
		DispatchQueue.main.async {
			self._activityIndicator?.stopAnimating()
			self._activityIndicator?.removeFromSuperview()
			self._activityIndicator = nil
			
			self.showOrHideInputs(show: true)
		}
	}
	
	private func closeKeyboard() {
		if textUsername.isFirstResponder {
			textUsername.resignFirstResponder()
		}
		else if textPassword.isFirstResponder {
			textPassword.resignFirstResponder()
		}
	}

	@IBAction func login() {
		closeKeyboard()
		
		guard let url = URL(string: TSURL.loginUrl), let username = textUsername.text, !username.isEmpty, let passw = textPassword.text, !passw.isEmpty else {
			return
		}
		
		let postData: [String : String] = [Key.username : username, Key.password : passw]
		let contentType : [String : String] = ["Content-Type" : "application/json"]
		
		Just.post(url, data: postData, headers: contentType) { [weak self] (result: HTTPResult) in
			if result.ok, let respData = result.content {
				do {
					let jsonResponse = try JSONSerialization.jsonObject(with: respData, options: [])
					debugPrint(jsonResponse)
					
					if let respDict = jsonResponse as? [String: Any], let token = respDict[Key.token] as? String {
						debugPrint("token: \(token)")
						self?.token = token
					}
					else {
						self?.showErrorMessage(NSLocalizedString("Failed to parse response data", comment: ""))
						return
					}
				}
				catch let error {
					debugPrint(error.localizedDescription)
					self?.showErrorMessage(error.localizedDescription)
					return
				}
				
				if let token = self?.token {
					self?.showLoadProgress()

					DispatchQueue.main.asyncAfter(2.0, work: { // delay just for demo..
						self?.hideLoadProgress()
						// save credentials to keychain
						KeychainWrapper.standard.set(username, forKey: Key.username)
						KeychainWrapper.standard.set(passw, forKey: Key.password)
						
						StorageHelper.saveToken(token)
						let ctrl = ListViewController()
						ctrl.token = token
						self?.navigationController?.push(ctrl)
					})
				}
			}
			else {
				if result.statusCode == 401 {
					self?.showErrorMessage(NSLocalizedString("Invalid user name or password", comment: ""))
				}
				else if let error = result.error {
					self?.showErrorMessage(error.localizedDescription)
				}
			}
		}
	}
}
