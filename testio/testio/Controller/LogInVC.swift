//
//  LogInVC.swift
//  testio
//
//  Created by Valentinas Mirosnicenko on 11/2/18.
//  Copyright © 2018 Valentinas Mirosnicenko. All rights reserved.
//

import UIKit

class LogInVC: UIViewController {
    
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet weak var stackView: UIStackView!
    
    private enum ToggleSwitch: CGFloat {
        case on = 1.0
        case off = 0.0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        setStackAlpha(toggleSwitch: .on) { (success) in
            if success {
                return
            }
        }
        
    }
    
    @IBAction private func attemptLoginButtonPressed(_ sender: Any) {
        
        guard textFieldsValid(inView: self.view) else {
            defaultErrorAlert(message: "Please fill both username and password fields.")
            return
        }
        
        DataService.instance.attemptLogin(username: usernameTextField.text ?? "", password: passwordTextField.text ?? "") { (success) in
            debugPrint("attempt login status: ",success)
            if success {
                self.setStackAlpha(toggleSwitch: .off, completion: { (completed) in
                    if completed {
                        DataService.instance.fetchServers(completion: { (servers) in
                            guard let servers = servers else { return }
                            debugPrint("<-- Party Animal Response Result Value -->")

                            self.storeServers(servers: servers, completion: { (success) in
                                if success {
                                    debugPrint("Succesfully stored servers")
                                    self.clearTextFields()
                                    self.teleportToParalelUniverse()
                                }
                            })                            
                        })
                    }
                })
            } else {
                self.setStackAlpha(toggleSwitch: .on, completion: { (completed) in
                    self.defaultErrorAlert(message: "Username or password incorrect. Please try again.")
                })
            }
            
        }
        
    }
    
    private func storeServers(servers: NSArray, completion: (_ success: Bool) -> ()) {
        
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
        
        UIView.animate(withDuration: 0.5, animations: {
            self.stackView.alpha = toggleSwitch.rawValue
        }) { (_) in
            completion(true)
        }
        
    }
    
    private func teleportToParalelUniverse() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
            if let serverListVC = self.storyboard?.instantiateViewController(withIdentifier: StoryboardID.serverListVC) as? ServerListVC {
                self.present(serverListVC, animated: true, completion: nil)
            }
        }
    }
    
    private func clearTextFields() {
        self.usernameTextField.text = ""
        self.passwordTextField.text = ""
    }
    
}
