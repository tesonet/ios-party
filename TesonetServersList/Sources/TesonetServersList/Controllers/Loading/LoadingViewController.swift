//
//  LoadingViewController.swift
//  TesonetServersList
//
//  Created by Vitalii Budnik on 11/7/17.
//  Copyright © 2017 Tesonet. All rights reserved.
//

import UIKit
import Reusable
import NVActivityIndicatorView

final class LoadingViewController: TSLBaseViewController, StoryboardBased {
	
	private let transitionManager: TSLTransitionManager = TSLTransitionManager()
	
	@IBOutlet private weak var activityIndicatorView: NVActivityIndicatorView!
	@IBOutlet private weak var textLabel: UILabel!
	
	var loadDescriptor: String? {
		get {
			return textLabel.text
		}
		set {
			textLabel.text = newValue
		}
	}
	
	override var prefersStatusBarHidden: Bool {
		return true
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.hidesKeyboardOnTap = false
		activityIndicatorView.startAnimating()
		textLabel.font = TSLScaledFont.defalut.font(forTextStyle: .callout)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		activityIndicatorView.stopAnimating()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		segue.source.modalPresentationStyle = .custom
		segue.source.transitioningDelegate = transitionManager
	}
	
}
