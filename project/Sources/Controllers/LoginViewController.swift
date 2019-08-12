import UIKit
import Just

class LoginViewController: UIViewController {
	
	var token: String? = nil
	
	@IBOutlet weak var imgLogo: UIImageView!
	@IBOutlet weak var inputViewName: UIView!
	@IBOutlet weak var inputViewPassw: UIView!
	@IBOutlet weak var btnLogin: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
		imgLogo.alpha = 0 // initially invisible
		inputViewName.alpha = 0
		inputViewPassw.alpha = 0
		btnLogin.alpha = 0
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.isNavigationBarHidden = true
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		showOrHideInputs(show: true)
	}
	
	private func showOrHideInputs(show: Bool) {
		let alpha: CGFloat = show ? 1.0 : 0.0
		
		UIView.animate(withDuration: 0.4) {
			self.imgLogo.alpha = alpha
			self.inputViewName.alpha = alpha
			self.inputViewPassw.alpha = alpha
			self.btnLogin.alpha = alpha
		}
	}
	
	@IBAction func login() {
		let postData: [String : String] = ["username" : "tesonet", "password" : "partyanimal"]
		
		if let url = URL(string: TSURL.loginUrl) {
			let contentType : [String : String] = ["Content-Type" : "application/json"]
			
			Just.post(url, data: postData, headers: contentType) { result in
				if result.ok, let respData = result.content {

					do {
						let jsonResponse = try JSONSerialization.jsonObject(with: respData, options: [])
						print(jsonResponse)
						
						// dict object is expected
						
						if let respDict = jsonResponse as? [String: Any], let token = respDict["token"] as? String {
							print("token: \(token)")
							self.token = token
						}
						else {
							return
							// todo: show user error here
						}
					}
					catch let error {
						print("Error", error)
						
						// todo: show user error here
						return
					}
					
					DispatchQueue.main.async {
						let ctrl = ListViewController()
						ctrl.token = self.token
						self.navigationController?.push(ctrl)
					}
				}
				else if let error = result.error {
					print(error.localizedDescription)
					// todo: show user error here
				}
			}
		}
	}
}
