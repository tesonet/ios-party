//
//  LoadingViewController.swift
//  Testio
//
//  Created by Ernestas Šeputis on 6/26/20.
//  Copyright © 2020 Ernestas Šeputis. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    
    private var username:String!
    private var token:String!
    
    convenience init (token:String)
    {
        self.init()
        self.token = token
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        APIManager().getServers(token: self.token) { (success, serversList) in
            if success
            {
                let serversViewController = ServersViewController.init(servers: serversList!)
                self.navigationController?.pushViewController(serversViewController, animated: true)
            }
        }
    }
    
    fileprivate func setupUI()
    {
        assignbackground()
        let label:UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: 20.0)
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Fetching the list..."
        view.addSubview(label)
        label.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,constant: -130).isActive = true
        label.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 10).isActive = true
        label.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    fileprivate func assignbackground()
    {
        let background = UIImage(named: "Background")

        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = UIView.ContentMode.center
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
}
