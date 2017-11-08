//
//  TSLServerTableViewCell.swift
//  TesonetServersList
//
//  Created by Vitalii Budnik on 11/6/17.
//  Copyright © 2017 Tesonet. All rights reserved.
//

import UIKit
import Reusable

final class TSLServerTableViewCell: UITableViewCell, NibReusable {
	
	@IBOutlet private weak var nameLabel: UILabel!
	
	@IBOutlet private weak var distanceLabel: UILabel!
	
	private var textSizeChangeObserver: NSObjectProtocol?
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		nameLabel.textColor = .serversListCellText
		distanceLabel.textColor = .serversListCellText
		
		configureFonts()
		
		textSizeChangeObserver = NotificationCenter.default.addObserver(forName: .UIContentSizeCategoryDidChange,
																																		object: .none,
																																		queue: .main)
		{ [unowned self] (_) in
			if #available(iOS 11.0, *) {
			} else {
				self.configureFonts()
			}
		}
	}
	
	deinit {
		if let textSizeChangeObserver = textSizeChangeObserver {
			NotificationCenter.default.removeObserver(textSizeChangeObserver,
																								name: .UIContentSizeCategoryDidChange,
																								object: .none)
			self.textSizeChangeObserver = .none
		}
	}
	
	private func configureFonts() {
		nameLabel.font = TSLScaledFont.defalut.font(forTextStyle: .callout)
		distanceLabel.font = TSLScaledFont.defalut.font(forTextStyle: .callout)
		
		if #available(iOS 10.0, *) {
			nameLabel.adjustsFontForContentSizeCategory = true
			distanceLabel.adjustsFontForContentSizeCategory = true
		}
		
	}
	
	func configure(with server: ServerData) {
		nameLabel.text = server.name
		distanceLabel.text = Formatters.distanceFormatter.string(fromDistance: server.distance * 1_000)
	}
	
}
