//
//  LoadingViewController.swift
//  TesonetTask
//
//  Created by Artyom Belenkov on 10/9/17.
//  Copyright © 2017 abelenkov. All rights reserved.
//

import Cocoa

class LoadingViewController: NSViewController {
	
    @IBOutlet private weak var progressTextField: NSTextField!
    @IBOutlet private weak var activityIndicator: NSImageView!
    
    @IBOutlet fileprivate weak var backgroundHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var backgroundWidthConstraint: NSLayoutConstraint!
    
    internal weak var containerViewController: ContainerViewController?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressTextField.stringValue = NSLocalizedString("cProgressTextFieldText", comment: "")
    }
    
    override func viewDidAppear() {
		super.viewDidAppear()
        activityIndicator.spinClockwise(timeToRotate: 4.0)
	}
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        self.activityIndicator.stopAnimations()
    }
}

extension LoadingViewController : IBaseController {
	internal func resetConstrains() {
    	backgroundHeightConstraint.isActive = false
        backgroundWidthConstraint.isActive = false
    }
}
