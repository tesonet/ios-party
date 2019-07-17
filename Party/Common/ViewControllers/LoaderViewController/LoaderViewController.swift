//
//  LoaderViewController.swift
//  Party
//
//  Created by Darius Janavicius on 18/07/2019.
//  Copyright © 2019 tesonet. All rights reserved.
//

import UIKit

class LoaderViewController: BaseViewController {

    // MARK: - Init
    
    override func configureAfterInit() {
        modalTransitionStyle = .crossDissolve
    }
    
    /// Loads an instance from nib.
    ///
    /// - Returns: A new instance of OverlayActivityViewController.
    static func make() -> LoaderViewController {
        let loaderViewController = LoaderViewController(nibName: String.classNameAsString(LoaderViewController.self),
                                                        bundle: nil)
        return loaderViewController
    }

}
