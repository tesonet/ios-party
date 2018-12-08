//
//  Storyboard.swift
//  testio
//
//  Created by Edvinas Sabaliauskas on 06/12/2018.
//  Copyright © 2018 Edvinas Sabaliauskas. All rights reserved.
//

import UIKit

enum Storyboard {
    
    /// `Login` storyboard.
    enum Login {
        
        /// Returns `Login` storyboard instance.
        static var storyboard: UIStoryboard {
            return Storyboard.storyboard(withName: "Login")
        }
        
        /// Returns Initial View Controller.
        static var initialVC: UIViewController? {
            return storyboard.instantiateInitialViewController()
        }
    }
    
    /// `Main` storyboard.
    enum Main {
        
        /// Returns `Main` storyboard instance.
        static var storyboard: UIStoryboard {
            return Storyboard.storyboard(withName: "Main")
        }
        
        /// Returns Initial View Controller.
        static var initialVC: UIViewController? {
            return storyboard.instantiateInitialViewController()
        }
    }
    
    static func storyboard(withName: String) -> UIStoryboard {
        return UIStoryboard(name: withName, bundle: nil)
    }
}
