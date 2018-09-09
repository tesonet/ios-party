//
//  ProgressViewController.swift
//  testio
//
//  Created by Tesonet on 09/09/2018.
//  Copyright © 2018 Tesonet. All rights reserved.
//

import Foundation
import UIKit

class ProgressViewController: UIViewController {
    private let backgroundView = UIImageView(image: UIImage(named: "bg"))
    private let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    private let subtitleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backgroundView.contentMode = .scaleAspectFill
        
        self.activityIndicatorView.hidesWhenStopped = true
        
        self.subtitleLabel.textAlignment = .center
        self.subtitleLabel.numberOfLines = 0
        self.subtitleLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        self.subtitleLabel.textColor = .white
        self.subtitleLabel.text = NSLocalizedString("Fetching the list...", comment: "")
        
        self.view.addSubview(self.backgroundView)
        self.view.addSubview(self.activityIndicatorView)
        self.view.addSubview(self.subtitleLabel)
        
        self.makeConstriants()
    }
    
    private func makeConstriants() {
        self.backgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        self.subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.backgroundView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.backgroundView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.backgroundView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.backgroundView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.activityIndicatorView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        self.activityIndicatorView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        self.activityIndicatorView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.activityIndicatorView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        let layoutGuide = UILayoutGuide()
        
        self.view.addLayoutGuide(layoutGuide)
        
        layoutGuide.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        layoutGuide.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        layoutGuide.topAnchor.constraint(equalTo: self.activityIndicatorView.bottomAnchor).isActive = true
        layoutGuide.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.subtitleLabel.centerYAnchor.constraint(equalTo: layoutGuide.centerYAnchor).isActive = true
        self.subtitleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.subtitleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
    
    func startAnimating() {
        self.activityIndicatorView.startAnimating()
    }
    
    func stopAnimating() {
        self.activityIndicatorView.stopAnimating()
    }
}
