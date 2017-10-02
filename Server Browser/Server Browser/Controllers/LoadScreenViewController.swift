//
//  LoadScreenViewController.swift
//  Server Browser
//
//  Created by Tanya on 10/1/17.
//  Copyright © 2017 Slava. All rights reserved.
//

import Cocoa

class LoadScreenViewController: NSViewController {
    // MARK: - Outlets
    
    @IBOutlet weak var progressIndicator: NSProgressIndicator!

    // MARK: -
    
    override func viewWillAppear() {
        progressIndicator.startAnimation(nil)
    }
    
    override func viewWillDisappear() {
        progressIndicator.stopAnimation(nil)
    }
}
