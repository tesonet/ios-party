//
//  NibView.swift
//  testio
//
//  Created by Justinas Baronas on 17/08/2019.
//  Copyright © 2019 Justinas Baronas. All rights reserved.
//

import UIKit


/// Custom View with initialised nib setup methods
class NibView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        setupView()
        setupStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        setupView()
        setupStyle()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        xibSetup()
        setupView()
        setupStyle()
    }
    
    /// Setup whole view logic here
    public func setupView() {}
    
    /// Setup whole view style here
    public func setupStyle() {}

}
