//
//  ServerSectionViewHeader.swift
//  Party
//
//  Created by Darius Janavicius on 18/07/2019.
//  Copyright © 2019 tesonet. All rights reserved.
//

import UIKit

class ServerSectionViewHeader: UITableViewHeaderFooterView {

    // MARK: - UI Components
    
    @IBOutlet weak private var shadowView: UIView!
    
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()

        shadowView.dropShadow()
    }
}
