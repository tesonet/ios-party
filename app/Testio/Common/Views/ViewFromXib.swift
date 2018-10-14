//
//  ViewFromXib.swift
//  Testio
//
//  Created by Julius on 12/10/2018.
//  Copyright © 2018 jp. All rights reserved.
//

import UIKit

class ViewFromXib: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        guard let view = loadViewFromNib() else {
            return
        }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(view)
        
        let leadingConstraint = NSLayoutConstraint(item: self,
                                                   attribute: .leading,
                                                   relatedBy: .equal,
                                                   toItem: view,
                                                   attribute: .leading,
                                                   multiplier: 1.0,
                                                   constant: 0.0)
        
        let topConstraint = NSLayoutConstraint(item: self,
                                               attribute: .top,
                                               relatedBy: .equal,
                                               toItem: view,
                                               attribute: .top,
                                               multiplier: 1.0,
                                               constant: 0.0)
        
        let trailingConstraint = NSLayoutConstraint(item: self,
                                                    attribute: .trailing,
                                                    relatedBy: .equal,
                                                    toItem: view,
                                                    attribute: .trailing,
                                                    multiplier: 1.0,
                                                    constant: 0.0)
        
        let bottomConstraint = NSLayoutConstraint(item: self,
                                                  attribute: .bottom,
                                                  relatedBy: .equal,
                                                  toItem: view,
                                                  attribute: .bottom,
                                                  multiplier: 1.0,
                                                  constant: 0.0)
        
        self.addConstraints([leadingConstraint, topConstraint, trailingConstraint, bottomConstraint])
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        
        guard let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView else {
            return nil
        }
        
        return view
    }
}
