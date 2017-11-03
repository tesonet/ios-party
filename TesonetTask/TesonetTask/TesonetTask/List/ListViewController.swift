//
//  ListViewController.swift
//  TesonetTask
//
//  Created by Artyom Belenkov on 10/8/17.
//  Copyright © 2017 abelenkov. All rights reserved.
//

import Cocoa

protocol ListViewControllerDelegate : class {
    var dataHandler : DataHandler {get}
    
    func didRequestLogOut(vc:ListViewController)
    func didRequestLoadData(vc:ListViewController)
}

class ListViewController: NSViewController {
    
    @IBOutlet private weak var headerView: NSView!
    @IBOutlet private weak var tableHeaderViewContainer: NSView!
    private var tableViewHeader: NSView? = TableViewHeader.createFromNib()
    
    @IBOutlet private weak var tableView: NSTableView!
    fileprivate var dataSource : [ServerModel] {
        if let theDelegate = delegate {
            return theDelegate.dataHandler.dataSource
        }
        return []
    }
    
    fileprivate weak var delegate : ListViewControllerDelegate?
    internal weak var containerViewController: ContainerViewController? {
        get {
            return delegate as? ContainerViewController
        }
        set {
            delegate = newValue
        }
    }
    	
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        registerNibs()
    }
    
    private func registerNibs() {
    	tableView.registerNib(cellClass:TableRowView.self)
    }
    
    private func setupViews() {
    	headerView.wantsLayer = true
        headerView.layer?.backgroundColor = NSColor.TNHeaderGrayColor.cgColor
        tableHeaderViewContainer.addSubview(tableViewHeader!)
        tableViewHeader?.fillSuperview()
        tableHeaderViewContainer.needsLayout = true
        
        tableHeaderViewContainer.wantsLayer = true
        let dropShadow = NSShadow()
        dropShadow.shadowColor = NSColor.TNSeparatorGrayColor
        dropShadow.shadowOffset = NSSize.init(width: 0.0, height: 5.0)
        dropShadow.shadowBlurRadius = 20.0
        tableHeaderViewContainer.shadow = dropShadow
    }
    
    @IBAction private func logoutAction(_ sender: NSButton) {
        delegate?.didRequestLogOut(vc: self)
    }
    
}

extension ListViewController : IBaseController {
	internal func resetConstrains() {}
}

extension ListViewController: NSTableViewDelegate, NSTableViewDataSource {
	
    public func numberOfRows(in tableView: NSTableView) -> Int {
        return dataSource.count
    }
    
    public func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
    	return TableRowView.cellHeight
    }
    
    public func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
    	guard let rowView : TableRowView = tableView.makeView(cellClass:TableRowView.self) else {
        	return nil
        }
        if dataSource.count > row {
            let model = dataSource[row]
            rowView.configure(model:model)
        }
        
    	return rowView
    }
    
}
