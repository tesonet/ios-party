//
//  LoadingViewController.swift
//  TesonetTask
//
//  Created by Artyom Belenkov on 10/9/17.
//  Copyright © 2017 abelenkov. All rights reserved.
//

import Cocoa

protocol LoadingViewControllerDelegate : class {
    func didLoadData(vc:LoadingViewController)
    func didFailLoadData(vc:LoadingViewController)
}

class LoadingViewController: NSViewController {
	
    @IBOutlet private weak var progressTextField: NSTextField!
    @IBOutlet private weak var activityIndicator: NSImageView!
    
    @IBOutlet fileprivate weak var backgroundHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var backgroundWidthConstraint: NSLayoutConstraint!
    
    internal weak var delegate: LoadingViewControllerDelegate?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressTextField.stringValue = NSLocalizedString("cProgressTextFieldText", comment: "")
    }
    
    override func viewDidAppear() {
		super.viewDidAppear()
        activityIndicator.spinClockwise(timeToRotate: 4.0)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
        	self.activityIndicator.stopAnimations()
            self.performSegue(withIdentifier:"listViewControllerSegue", sender: self)
            self.delegate?.didLoadData(vc: self)
        }
	}
}

extension LoadingViewController : IBaseController {
	internal func resetConstrains() {
    	backgroundHeightConstraint.isActive = false
        backgroundWidthConstraint.isActive = false
    }
}
