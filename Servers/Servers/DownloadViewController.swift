//
//  DownloadViewController.swift
//  Servers
//
//  Created by Rimantas Lukosevicius on 10/06/2018.
//  Copyright © 2018 Rimantas Lukosevicius. All rights reserved.
//

import UIKit
import SVProgressHUD

class DownloadViewController: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setContainerView(self.view)
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.setForegroundColor(UIColor.white)
        
        SVProgressHUD.show()
    }
}
