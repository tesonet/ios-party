//
//  TSLServersListSortFloatingView.swift
//  TesonetServersList
//
//  Created by Vitalii Budnik on 11/8/17.
//  Copyright © 2017 Tesonet. All rights reserved.
//

import UIKit
import Reusable

protocol TSLServersListSortFloatingViewDelegate: AnyObject {
	
	func tslServersListSortFloatingView(
		_ view: TSLServersListSortFloatingView,
		didSelect sortField: TSLServersListDataSource.SortField)
	
	func present(
		_ viewControllerToPresent: UIViewController,
		animated flag: Bool,
		completion: (() -> Void)?)
	
}

final class TSLServersListSortFloatingView: UIView, NibOwnerLoadable {
	
	weak var delegate: TSLServersListSortFloatingViewDelegate?
	
	@IBOutlet private weak var sortTextlabel: UILabel!
	// MARK: - Lifecycle
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.loadNibContent()
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		sortTextlabel.text = "SORT.LABEL TEXT".localized(using: "ServersList")
		sortTextlabel.font = TSLScaledFont.defalut.font(forTextStyle: .callout)
	}
	
	// MARK: - Action
	
	@IBAction private func controlDidPress(_ sender: UIControl) {
		showAlert()
	}
	
	// MARK: - Alert
	
	private func hide() {
		UIView.animate(
			withDuration: 0.2,
			animations: { [unowned self] in
				self.alpha = 0.0
		},
			completion: { [unowned self] (_) in
				self.isHidden = true
		})
	}

	private func show() {
		self.isHidden = false
		UIView.animate(withDuration: 0.2) { [unowned self] in
				self.alpha = 1.0
		}
	}
	
	private func showAlert() {
		
		let alertController = buildAlertController()
		
		hide()
		
		delegate?.present(alertController, animated: true, completion: .none)
		
	}
	
	private func buildAlertController() -> UIAlertController {
		
		let availableSortFields: [TSLServersListDataSource.SortField] = TSLServersListDataSource.SortField.all
		
		let alertController = UIAlertController(title: .none,
																						message: .none,
																						preferredStyle: .actionSheet)
		
		availableSortFields.forEach { (sortField) in
			
			let action = UIAlertAction(title: sortField.humanDescription,
																 style: .default) { [unowned self] (_) in
																	self.delegate?.tslServersListSortFloatingView(self, didSelect: sortField)
			}
			
			alertController.addAction(action)
			
			self.show()
			
		}
		
		let cancelAction = UIAlertAction(title: "CANCEL".localized(),
																		 style: .cancel) { [unowned self] (_) in
																			self.show()
		}
		
		alertController.addAction(cancelAction)
		
		alertController.preferredAction = cancelAction
		
		return alertController
		
	}
	
}
