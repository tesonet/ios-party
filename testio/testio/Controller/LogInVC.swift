//
//  LogInVC.swift
//  testio
//
//  Created by Valentinas Mirosnicenko on 11/2/18.
//  Copyright © 2018 Valentinas Mirosnicenko. All rights reserved.
//

import UIKit
import SpinnerView
import SwiftKeychainWrapper

class LogInVC: UIViewController {
    
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var spinnerView: SpinnerView!
    @IBOutlet private weak var loginStatusLabel: UILabel!
    
    private let tapGesture: UITapGestureRecognizer = {
        var tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 1
        return tap
    }()
    
    private enum ToggleSwitch: CGFloat {
        case on = 1.0
        case off = 0.0
        
        var oposite:ToggleSwitch {
            if self == .on {
                return .off
            } else {
                return .on
            }
        }
    }
    
    private enum LoginStatus: String {
        case attemptLogin = "Attempting to Log-in..."
        case loginFailed = "Authentication issue. Please double-check your username and password and try again"
        case loginSucceeded = "Log-in succeeded"
        case fetchingServers = "Fetching server list..."
        case failedToFetchServers = "Failed to fetch servers"
        case succesfullyFetchedServers = "Succesfully fetched servers"
        case savingServerList = "Saving server list..."
        case serversSavedSuccesfully = "Server list saved succesfully"
        case failedToSaveServers = "Unable to download a server list. Please try again later."
        case completed = "Completed!"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.bool(forKey: USER_LOGGED_IN) { presentServersListVC(inSeconds: 0.0) }
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        view.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
        tapGesture.addTarget(self, action: #selector(dismissKeyboardOnTap(_:)))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        setStackAlpha(toggleSwitch: .on) { (success) in
            if success {
                
            }
        }
        
        if let username = KeychainWrapper.standard.string(forKey: MY_USERNAME), let password = KeychainWrapper.standard.string(forKey: MY_PASSWORD) {
            debugPrint("Found some saved credentials. Should use?")
            restoreCredentialsAlert(username: username, password: password)
        }
        
    }
    
    @IBAction private func attemptLoginButtonPressed(_ sender: Any) {
        
        view.resignFirstResponder()
        
        guard let username = usernameTextField.text, let password = passwordTextField.text else {
            defaultErrorAlert(message: "Fatal Error with UI Initialization.")
            return
        }
        
        guard username != "", password != "" else {
            defaultErrorAlert(message: "Please make sure both username and password fields are not empty.")
            return
        }
        
        setStackAlpha(toggleSwitch: .off) { (done) in
            if done {
                self.spinnerView.start()
                self.loginStatusLabel.text = LoginStatus.attemptLogin.rawValue
                
                self.attemptLogin(username: username, password: password, completion: { (status) in
                    
                    if status == LoginStatus.loginSucceeded {
                        self.loginStatusLabel.text = LoginStatus.fetchingServers.rawValue
                        
                        self.fetchServers(completion: { (status, servers) in
                            
                            if status == LoginStatus.succesfullyFetchedServers {
                                self.loginStatusLabel.text = LoginStatus.savingServerList.rawValue
                                
                                guard let servers = servers else {
                                    self.loginStatus(result: false, message: .failedToSaveServers)
                                    return
                                }
                                
                                self.saveServers(servers: servers, completion: { (status) in
                                    
                                    if status == LoginStatus.serversSavedSuccesfully {
                                        self.loginStatusLabel.text = LoginStatus.completed.rawValue
                                        
                                        if self.credentialsDidChange(username: username, password: password) {
                                            self.savePasswordAlert(username: username, password: username, completion: { (success) in
                                                if success {
                                                    self.loginStatus(result: true)
                                                }
                                            })
                                        } else {
                                            self.loginStatus(result: true)
                                        }
                                        
                                        UserDefaults.standard.set(true, forKey: USER_LOGGED_IN)
                                        
                                    } else {
                                        self.loginStatus(result: false, message: LoginStatus.failedToSaveServers)
                                    }
                                })
                            } else {
                                self.loginStatus(result: false, message: LoginStatus.failedToFetchServers)
                            }
                        })
                    } else {
                        self.loginStatus(result: false, message: LoginStatus.loginFailed)
                    }
                })
            }
        }
    }
    
    private func attemptLogin(username: String, password: String, completion: @escaping (_ loginStatus: LoginStatus) -> ()) {
        self.loginStatusLabel.text = LoginStatus.attemptLogin.rawValue
        DataService.instance.attemptLogin(username: username, password: password) { (success) in
            if success {
                completion(.loginSucceeded)
            } else {
                completion(.loginFailed)
            }
        }
        
    }
    
    private func fetchServers(completion: @escaping (_ loginStatus: LoginStatus, _ servers: NSArray?) -> ()) {
        DataService.instance.fetchServers { (servers) in
            if let servers = servers {
                completion(.succesfullyFetchedServers,servers)
            } else {
                completion(.failedToFetchServers,nil)
            }
        }
    }
    
    private func saveServers(servers: NSArray, completion: @escaping (_ loginStatus: LoginStatus) -> ()) {
        processServerList(servers: servers) { (success) in
            if success {
                completion(.serversSavedSuccesfully)
            } else {
                completion(.failedToSaveServers)
            }
        }
    }
    
    private func loginStatus(result: Bool, message: LoginStatus? = nil) {
        if result {
            spinnerView.stop(success: result)
            clearTextFields()
            presentServersListVC(inSeconds: 1.0)
        } else {
            spinnerView.stop(success: result)
            setStackAlpha(toggleSwitch: .on, completion: { (completed) in
                self.defaultErrorAlert(message: message?.rawValue ?? "Something went wrong here...")
            })
        }
    }
    
    
    private func processServerList(servers: NSArray, completion: (_ success: Bool) -> ()) {
        
        for server in servers {
            
            // Is JSON a dict?
            guard let json = server as? Dictionary<String,Any> else { continue }
            debugPrint("json is a valid dictionary with data: ",json)
            
            // Do we get valid distance and name?
            guard let distance = json[Schema.Server.distance] as? Int, let name = json[Schema.Server.name] as? String else { continue }
            debugPrint("distance to server is \(distance), name of the server is \(name)")
            
            // Do we already have this server?
            guard !CDService.instance.recordExists(serverName: name) else { continue }
            debugPrint("Such server does not exist in persistent storage")
            
            // Let's store it!
            let server = Server(context: CDService.instance.context)
            server.distance = Int16(distance)
            server.name = name
            debugPrint("Storing a server,", server)
            CDService.instance.save()
            
        }
        completion(true)
        
    }
    
    private func setStackAlpha(toggleSwitch: ToggleSwitch, completion: @escaping (_ completed: Bool) -> ()) {
        self.loginStatusLabel.alpha = toggleSwitch.oposite.rawValue
        UIView.animate(withDuration: 0.5, animations: {
            self.stackView.alpha = toggleSwitch.rawValue
        }) { (_) in
            completion(true)
        }
        
    }
    
    private func presentServersListVC(inSeconds: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + inSeconds) {
            if let serverListVC = self.storyboard?.instantiateViewController(withIdentifier: StoryboardID.serverListVC) as? ServerListVC {
                self.present(serverListVC, animated: true, completion: nil)
            }
        }
    }
    
    private func clearTextFields() {
        self.usernameTextField.text = ""
        self.passwordTextField.text = ""
    }
    
    private func credentialsDidChange(username: String, password: String) -> Bool {
        if username == KeychainWrapper.standard.string(forKey: MY_USERNAME) && password == KeychainWrapper.standard.string(forKey: MY_PASSWORD) {
            return false
        }
        return true
    }
    
    private func credentialsSaved(username: String, password:String) -> Bool {
        let usernameSaved: Bool = KeychainWrapper.standard.set(username, forKey: MY_USERNAME)
        let passwordSaved: Bool = KeychainWrapper.standard.set(password, forKey: MY_PASSWORD)
        if usernameSaved && passwordSaved { return true }
        return false
    }
    
    private func restoreCredentials(username: String, password: String) {
        if usernameTextField.textContentType == .username { usernameTextField.text = username }
        if passwordTextField.textContentType == .password { passwordTextField.text = password }
    }
    
    private func savePasswordAlert(username: String, password: String, completion: @escaping (_ success: Bool) -> ()) {
        let alert = UIAlertController(title: "Dear User,",
                                      message: "Would you like to store your new password in Key-Chain?",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Save Password", style: .default, handler: { (_) in
            _ = self.credentialsSaved(username: username, password: password)
            completion(true)
        }))
        
        alert.addAction(UIAlertAction(title: "Next Time", style: .cancel, handler: { (_) in
            completion(true)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func restoreCredentialsAlert(username:String, password: String) {
        let alert = UIAlertController(title: "Dear User",
                                      message: "Would you like to use credentials stored in Key-Chain?",
                                      preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Use Key-Chain", style: .default, handler: { (_) in
            self.restoreCredentials(username: username, password: password)
        }))
        
        alert.addAction(UIAlertAction(title: "No Thanks", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Delete Credentials", style: .destructive, handler: { (_) in
            KeychainWrapper.standard.removeObject(forKey: MY_USERNAME)
            KeychainWrapper.standard.removeObject(forKey: MY_PASSWORD)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension LogInVC: UIGestureRecognizerDelegate {
    
    @objc private func dismissKeyboardOnTap(_ tapGesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
}

extension LogInVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
