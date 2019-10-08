//
//  ErrorHandlerViewController.swift
//  AtlasTest
//
//  Created by Irina  Shupikova on 9/29/19.
//  Copyright © 2019 krokus. All rights reserved.
//

import Foundation
import UIKit

class ErrorHandlerViewController: UIViewController, ErrorHandlerDelegate, UIViewControllerTransitioningDelegate, LayoutObservable {
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak private var okButton: UIButton!

    @IBOutlet weak private var topImageHeight: NSLayoutConstraint!
    @IBOutlet weak private var titleLabelHeight: NSLayoutConstraint!
    @IBOutlet weak private var titleLabelTopSpace: NSLayoutConstraint!
    @IBOutlet weak private var descriptionLabelTopSpace: NSLayoutConstraint!
    @IBOutlet weak private var descriptionLabelHeight: NSLayoutConstraint!
    @IBOutlet weak private var descriptionLabelBottomSpace: NSLayoutConstraint!
    @IBOutlet weak private var okButtonHeight: NSLayoutConstraint!
    @IBOutlet weak private var okButtonBottomSpace: NSLayoutConstraint!
    let horizontalMargin: CGFloat = 16.0
    var layoutObserver: LayoutObserver?

    var onDone : (() -> Void)?
    var error: AppError?

    func onError(_ error: AppError) {
        self.error = error
    }

    @IBAction private func okTapped(_ sender: UIButton) {
        ErrorHandler.processedError = nil
        if let completion = onDone {
            dismiss(animated: true) {
                completion()
            }
            return
        }
        dismiss(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.cornerRadius = 16.0
        view.layer.masksToBounds = true
        okButton.layer.masksToBounds = true

    }

    override func viewWillAppear(_ animated: Bool) {
        setup(error: error)
        configureView()
        super.viewWillAppear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setup(error: AppError?) {
        if let errorTitle = error?.title {
            titleLabel.text = errorTitle
        }
        if let errorDescription = error?.description {
            descriptionLabel.text = errorDescription
        }
        if error?.severity == .fatal {
            okButton.setTitle(NSLocalizedString("Try again", comment: "Fatal error" ), for: .normal)
        } else {
            okButton.setTitle(NSLocalizedString("OK", comment: "Recoverable error" ), for: .normal)
        }
    }

    func configureView() {
        if #available(iOS 10.0, *) {
            titleLabel.adjustsFontForContentSizeCategory = true
            descriptionLabel.adjustsFontForContentSizeCategory = true
        } else {
            titleLabel.adjustsFontSizeToFitWidth = true
            descriptionLabel.adjustsFontSizeToFitWidth = true
        }
        titleLabel.preferredMaxLayoutWidth = titleLabel.frame.size.width
        descriptionLabel.preferredMaxLayoutWidth = descriptionLabel.frame.size.width
        titleLabel.sizeToFit()
        descriptionLabel.sizeToFit()
        titleLabelHeight.constant = (titleLabel.text != nil && titleLabel.text!.isEmpty) ? CGFloat(0.0) : titleLabel.frame.size.height
        descriptionLabelTopSpace.constant = (titleLabel.text != nil && titleLabel.text!.isEmpty) ? CGFloat(0.0) : CGFloat(16.0)
        descriptionLabelHeight.constant = descriptionLabel.frame.size.height

        view.layoutSubviews()
        layoutObserver?.layoutDidChange()
    }

    @objc public override var preferredContentSize: CGSize {
        get {
            //width is 300 by default
            let contentWidth = UIScreen.main.bounds.width - 2 * horizontalMargin
            
            //calculate height
            var contentHeight = topImageHeight.constant
                contentHeight += titleLabelTopSpace.constant
                contentHeight += titleLabelHeight.constant
                contentHeight += descriptionLabelTopSpace.constant
                contentHeight += descriptionLabelHeight.constant
                contentHeight += descriptionLabelBottomSpace.constant
                contentHeight += okButtonHeight.constant
                contentHeight += okButtonBottomSpace.constant < 0 ? -okButtonBottomSpace.constant : okButtonBottomSpace.constant
            return CGSize(width: contentWidth, height: contentHeight)
        }
        set {
            super.preferredContentSize = newValue
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Transitioning delegate methods
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return ModalPresentationController(presentedViewController: presented, presenting: presented)
    }

}
