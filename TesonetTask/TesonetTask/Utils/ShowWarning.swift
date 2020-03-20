//
//  ShowWarning.swift
//  TesonetTask
//
//  Created by Jaroslav Chaninovicz on 2020-03-19.
//  Copyright © 2020 jch. All rights reserved.
//

import UIKit

struct ShowWarning {
    
    static func showWarningWithString(_ string: String) {
        let alert = AlertBuilder.warning(with: string)
        showWarning(alert: alert)
    }
    
    static func showWarning(alert : UIAlertController) {
        for window in UIApplication.shared.windows {
            if let presentedController = window.rootViewController?.presentedViewController {
                presentedController.present(alert, animated: true, completion: nil)
            } else {
                window.rootViewController?.present(alert, animated: true, completion: nil)
            }
                
            break
        }
    }
    
}
