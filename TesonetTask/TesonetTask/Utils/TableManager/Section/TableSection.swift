//
//  TableSection.swift
//  TesonetTask
//
//  Created by Jaroslav Chaninovicz on 2020-03-19.
//  Copyright © 2020 jch. All rights reserved.
//

import UIKit

struct TableSection {
    var items: [CellItem]
    var sectionModel: SectionViewModel
}

class SectionViewModel {
    
    weak var view: UITableViewHeaderFooterView?
    var viewClass: AnyClass!
    var reuseIdentifier: String!
    
    init() {
        reuseIdentifier = createIdentifier()
        viewClass = getViewClass()
    }
    
    internal func loadView(_ view: UITableViewHeaderFooterView) {}
    
    internal func getViewClass() -> AnyClass {
        return UITableViewHeaderFooterView.self
    }
    
    internal func createIdentifier() -> String {
        return "UITableViewHeaderFooterView"
    }
    
    func getHeight() -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

class SectionView: UITableViewHeaderFooterView {}
