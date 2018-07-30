//
//  HeaderView.swift
//  Tesio App
//
//  Created by Eimantas Kudarauskas on 7/27/18.
//  Copyright © 2018 Eimantas Kudarauskas. All rights reserved.
//

import UIKit

class HeaderView: UIView {

    // MARK: - Outlets
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var serverLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    // For using custom view in code
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // For using custom view in IB
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
