//
//  ServerBrowserWindowController.swift
//  Server Browser
//
//  Created by Tanya on 10/1/17.
//  Copyright © 2017 Slava. All rights reserved.
//

import Cocoa

class ServerBrowserWindowController: NSWindowController {
    // MARK: - Outlets
    
    // ...
    
    // MARK: -
    
    init() {
        super.init(window: nil)
    }
    
    // MARK: - NSWindowController
    
    override var windowNibName: String! {
        return "ServerBrowserWindow"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported.")
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        // ...
    }
    

    
}
