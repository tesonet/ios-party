//
//  TableManager.swift
//  TesonetTask
//
//  Created by Jaroslav Chaninovicz on 2020-03-19.
//  Copyright © 2020 jch. All rights reserved.
//

import UIKit

extension Array where Element: Equatable {
    
    mutating func removeObject(_ object: Element) {
        if let index = self.firstIndex(of: object) {
            self.remove(at: index)
        }
    }
    
    mutating func removeObjectsInArray(_ array: [Element]) {
        for object in array {
            self.removeObject(object)
        }
    }
    
}

class TableViewManager: NSObject {
    
    var tableView: UITableView! {
        get {
            return tableViewController.tableView
        }
    }
    
    let tableViewController = MainTableViewController()
    var data = [CellItem]()
    var sections = [TableSection]()
    
    var hideSlidingIndicators = false {
        didSet {
            tableView.showsVerticalScrollIndicator = !hideSlidingIndicators
            tableView.showsHorizontalScrollIndicator = !hideSlidingIndicators
        }
    }
    
    var deselectCellsOnClick = true
    
    var tableWithSection : Bool {
        return !sections.isEmpty
    }
    
    fileprivate var lastContentOffset: CGFloat = 0
    weak var delegate: TableManagerDelegate?
    
    override init() {
        super.init()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = .zero
        tableView.separatorInset = .zero
        tableView.layoutMargins = .zero
        let footer = UIView()
        footer.backgroundColor = .clear
        footer.isHidden = true
        tableView.tableFooterView = footer
    }
    
    func addCellItem(_ item: CellItem?) {
        if let item = item {
            registerCellItem(item)
            data.append(item)
        }
    }
    
    func addSections(_ sections: [TableSection]) {
        for section in sections {
            
            tableView.register(UINib(nibName: section.sectionModel.reuseIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: section.sectionModel.reuseIdentifier)
            
            section.items.forEach { (item) in
                registerCellItem(item)
            }
            
            self.sections.append(section)
        }
    }
    
    func addCells(_ items: [CellItem]?) -> Void {
        if let items = items {
            
            if items.isEmpty {
                self.tableView.reloadData()
                return
            }
            
            for item in items {
                registerCellItem(item)
                data.append(item)
            }
        }
        
        self.tableView.reloadData()
    }
    
    func addCellItemWithAnimationAtIndex(_ item: CellItem,
                                         atIndex: Int,
                                         animation: UITableView.RowAnimation = .fade,
                                         completion: CompletionVoidAction = nil) {
        registerCellItem(item)
        
        data.insert(item, at: atIndex)
        guard let index = data.firstIndex(of: item) else {
            return
        }
        
        if tableView.numberOfRows(inSection: 0) >= index {
            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)
            tableView.beginUpdates()
            tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: animation)
            tableView.endUpdates()
            CATransaction.commit()
        }
    }
    
    func removeCells(_ items: [CellItem]?) -> Void {
        if let items = items {
            self.data.removeObjectsInArray(items)
        }
    }
    
    func removeCellsAnimated(_ items: [CellItem]?) -> Void {
        
        guard let items = items else {
            return
        }
        
        for item in items {
            self.removeItemWithAnimation(item)
        }
    }
    
    internal func registerCellItem(_ item: CellItem) {
        if item.loadFromNib == true {
            tableView.register(UINib(nibName: item.xibName, bundle: nil), forCellReuseIdentifier: item.reuseIdentifier)
        } else {
            tableView.register(item.cellClass, forCellReuseIdentifier: item.reuseIdentifier)
        }
    }
    
    func addCellsWithAnimations(_ items: [CellItem]?, withAnimation: UITableView.RowAnimation = .fade, afterIndex: Int? = nil) -> Void {
        guard let items = items else {
            return
        }
        
        guard !items.isEmpty else {
            return
        }
        
        var position = self.data.count
        
        if let afterIndex = afterIndex {
            position = afterIndex + 1
            self.data.insert(contentsOf: items, at: position)
        } else {
            self.data.append(contentsOf: items)
        }
        
        var indexPaths = [IndexPath]()
        
        for (index, item) in items.enumerated() {
            registerCellItem(item)
            
            let indexPath = IndexPath(row: position + index, section: 0)
            indexPaths.append(indexPath)
        }
        
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: indexPaths, with: withAnimation)
        self.tableView.endUpdates()
    }
    
    func removeCellsWithAnimation(_ items: [CellItem]?,
                                  withAnimation: UITableView.RowAnimation = .fade,
                                  completionBlock: CompletionVoidAction = nil) {
        
        guard let items = items else {
            return
        }
        
        guard !items.isEmpty else {
            return
        }
        
        var indexPaths = [IndexPath]()
        var itemsToRemove = [CellItem]()
        
        for item in items {
            if let index = data.firstIndex(of: item) {
                itemsToRemove.append(item)
                let indexPath = IndexPath(row: index, section: 0)
                indexPaths.append(indexPath)
            }
        }
        
        for item in itemsToRemove {
            if let index = data.firstIndex(of: item) {
                data.remove(at: index)
            }
        }
        
        CATransaction.begin()
        CATransaction.setCompletionBlock(completionBlock)
        self.tableView.beginUpdates()
        tableView.deleteRows(at: indexPaths, with: withAnimation)
        self.tableView.endUpdates()
        CATransaction.commit()
    }
    
    func checkIfItemExistInTable(_ item: CellItem) -> Bool {
        return data.contains(item)
    }
    
    func removeItemWithAnimation(_ item: CellItem, animation: UITableView.RowAnimation = .fade, completionBlock: CompletionVoidAction = nil) {
        if let index = data.firstIndex(of: item) {
            data.remove(at: index)
            CATransaction.begin()
            CATransaction.setCompletionBlock(completionBlock)
            tableView.beginUpdates()
            tableView.deleteRows(at: [IndexPath(item: index, section: 0)], with: animation)
            tableView.endUpdates()
            CATransaction.commit()
        }
    }
    
}

extension TableViewManager: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if deselectCellsOnClick {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        guard tableWithSection == true else {
            if data.isEmpty {
                return
            }
            
            delegate?.cellClicked(data[indexPath.row])
            return
        }
        
        delegate?.cellClicked(sections[indexPath.section].items[indexPath.row])
    }
    
}

extension TableViewManager: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableWithSection ? sections.count : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableWithSection ? sections[section].items.count : data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item: CellItem = tableWithSection ? sections[indexPath.section].items[indexPath.row] : data[indexPath.row]
        item.tableManager = self
        let cell = tableView.dequeueReusableCell(withIdentifier: item.reuseIdentifier, for: indexPath) as UITableViewCell
        item.loadCell(cell)
        
        return cell
    }
    
    @objc(tableView: heightForRowAtIndexPath:) func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item: CellItem = tableWithSection ? sections[indexPath.section].items[indexPath.row] : data[indexPath.row]
        return item.getCellHeight(tableView)
    }
    
    @objc func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard tableWithSection == false else {
            let sectionObject = sections[section].sectionModel
            
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: sectionObject.reuseIdentifier) else {
                return nil
            }
            
            sectionObject.loadView(header)
            
            return header
        }
        
        let header = UIView()
        header.backgroundColor = UIColor.clear
        header.isHidden = true
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableWithSection ? sections[section].sectionModel.getHeight() : 0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

}

