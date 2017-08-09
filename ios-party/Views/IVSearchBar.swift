//
//  IVSearchBar.swift
//  ios-party
//
//  Created by Ilya Vlasov on 8/9/17.
//  Copyright © 2017 Ilya Vlasov. All rights reserved.
//

import UIKit

class IVSearchBar: UISearchBar {

    var preferredFont: UIFont!
    var preferredTextColor: UIColor!
    
    init(frame: CGRect, font: UIFont, textColor: UIColor) {
        super.init(frame: frame)
        
        self.frame = frame
        preferredFont = font
        preferredTextColor = textColor
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}
