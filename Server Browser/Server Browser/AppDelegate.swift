//
//  AppDelegate.swift
//  Server Browser
//
//  Created by Tanya on 10/1/17.
//  Copyright © 2017 Slava. All rights reserved.
//

import Cocoa

@NSApplicationMain

class AppDelegate: NSObject, NSApplicationDelegate {
    var mainWindowController: ServerBrowserWindowController!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        mainWindowController = ServerBrowserWindowController()
        mainWindowController.showWindow(nil)
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}
