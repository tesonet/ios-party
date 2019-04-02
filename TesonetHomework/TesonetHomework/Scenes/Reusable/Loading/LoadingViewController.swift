// Created by Paulius Cesekas on 02/04/2019.

import UIKit

class LoadingViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet private(set) weak var indicatorImageView: UIImageView!
    @IBOutlet private(set) weak var titleLabel: UILabel!
    
    // MARK: - Variables
    private var titleText: String?

    // MARK: - Methods -
    class func present(in viewController: UIViewController, withTitle title: String? = nil) -> LoadingViewController {
        let loadingViewController = LoadingViewController()
        loadingViewController.modalPresentationStyle = .overFullScreen
        loadingViewController.modalTransitionStyle = .crossDissolve
        loadingViewController.titleText = title
        viewController.present(
            loadingViewController,
            animated: true)
        return loadingViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateTitle(titleText)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        indicatorImageView.rotate()
    }

    // MARK: - Populate
    func populateTitle(_ title: String?) {
        titleText = title
        titleLabel.text = titleText
    }
}
