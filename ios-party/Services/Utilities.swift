//
//  Utilities.swift
//  ios-party
//
//  Created by Ilya Vlasov on 8/8/17.
//  Copyright © 2017 Ilya Vlasov. All rights reserved.
//

import UIKit
import Security
import KeychainSwift
import SVProgressHUD

private let utilities = Utilities()

class Utilities: NSObject {
    class var sharedInstance : Utilities {
        return utilities
    }
    
    let keychain = KeychainSwift()
    
    func setupLoader() {
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.setRingRadius(72.0)
        SVProgressHUD.setRingThickness(4.0)
        SVProgressHUD.setForegroundColor(UIColor.white)
        SVProgressHUD.setMinimumSize(CGSize(width:145.0,height:145.0))
        SVProgressHUD.setRingNoTextRadius(72.0)
    }
}

extension UIImage{
    
    func resizeImageWith(newSize: CGSize) -> UIImage {
        
        let horizontalRatio = newSize.width / size.width
        let verticalRatio = newSize.height / size.height
        
        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    
}


