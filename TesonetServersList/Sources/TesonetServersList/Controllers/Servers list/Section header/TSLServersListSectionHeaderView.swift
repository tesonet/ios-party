//
//  TSLServersListSectionHeaderView.swift
//  TesonetServersList
//
//  Created by Vitalii Budnik on 11/6/17.
//  Copyright © 2017 Tesonet. All rights reserved.
//

import UIKit
import Reusable

class TSLServersListSectionHeaderView: UITableViewHeaderFooterView, NibReusable {
	
	@IBOutlet private weak var serverNameLabel: UILabel!
	@IBOutlet private weak var distanceLabel: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		let backgroundView = UIView()
		backgroundView.backgroundColor = .serversListHeaderBackground
		self.backgroundView = backgroundView
		
		serverNameLabel.textColor = .serversListHeaderText
		serverNameLabel.font = TSLScaledFont.defalut.font(forTextStyle: .caption2)
		
		distanceLabel.textColor = .serversListHeaderText
		distanceLabel.font = TSLScaledFont.defalut.font(forTextStyle: .caption2)
		
		localize()
		
		configureShadow()
		
	}
	
	private func configureShadow() {
		layer.shadowColor = #colorLiteral(red: 0.8862745098, green: 0.8980392157, blue: 0.9098039216, alpha: 1)
		layer.shadowOpacity = 0.65
		layer.shadowRadius = 7.0
		layer.shadowOffset = CGSize(width: 0.0, height: 15.0)
	}
	
	private func localize() {
		let tableName = "ServersList"
		serverNameLabel.text = "HEADER.SERVER NAME".localized(using: tableName).uppercased()
		distanceLabel.text = "HEADER.DISTANCE".localized(using: tableName).uppercased()
	}
	
}
