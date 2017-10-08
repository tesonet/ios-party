//
//  LoginToListSegue.swift
//  TesonetTask
//
//  Created by Artyom Belenkov on 10/8/17.
//  Copyright © 2017 abelenkov. All rights reserved.
//

import Cocoa

class LoginToListSegue: NSStoryboardSegue {
	
    override func perform() {
        let sourceViewController = self.sourceController as! IBaseController
        let destinationViewController = self.destinationController as! IBaseController
        let containerViewController = sourceViewController.controller.parent!
        
        containerViewController.insertChildViewController(destinationViewController.controller, at: 1)
        let targetSize = destinationViewController.controller.view.frame.size
        let targetWidth = destinationViewController.controller.view.frame.size.width
        let targetHeight = destinationViewController.controller.view.frame.size.height
        
        sourceViewController.controller.view.wantsLayer = true
		destinationViewController.controller.view.wantsLayer = true
        containerViewController.view.wantsLayer = true
        
        sourceViewController.resetConstrains()
        sourceViewController.controller.updateViewConstraints()
        containerViewController.transition(from: sourceViewController.controller, to: destinationViewController.controller,
    		options: NSViewControllerTransitionOptions.crossfade, completionHandler: nil)
        sourceViewController.controller.view.animator().setFrameSize(targetSize)
		destinationViewController.controller.view.animator().setFrameSize(targetSize)
        
        let currentFrame = containerViewController.view.window?.frame
        let currentRect = NSRectToCGRect(currentFrame!)
        let horizontalChange = (targetWidth - containerViewController.view.frame.size.width)/2
		let verticalChange = (targetHeight - containerViewController.view.frame.size.height)/2
        
        let newWindowRect = NSMakeRect(currentRect.origin.x - horizontalChange,
    		currentRect.origin.y - verticalChange, targetWidth, targetHeight)
        containerViewController.view.window?.setFrame(newWindowRect, display: true, animate: true)
        containerViewController.removeChildViewController(at: 0)
    }
}
