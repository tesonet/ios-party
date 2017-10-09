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
        }
	}
}

extension LoadingViewController : IBaseController {
	internal func resetConstrains() {}
}
