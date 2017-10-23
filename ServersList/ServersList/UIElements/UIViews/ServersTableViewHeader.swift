//
//  ServersTableViewHeader.swift
//  ServersList
//
//  Created by Tomas Stasiulionis on 22/10/2017.
//  Copyright © 2017 Tomas Stasiulionis. All rights reserved.
//

import UIKit

class ServersTableViewHeader: UIView {
    
    /*
     * Initiates ServerTableViewHeader from ServersTableViewHeader.xib
     */
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "ServersTableViewHeader", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }

}
