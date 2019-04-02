// Created by Paulius Cesekas on 02/04/2019.

import UIKit

class LoadingViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet private(set) weak var indicatorImageView: UIImageView!
    @IBOutlet private(set) weak var stateLabel: UILabel!
    
    // MARK: - Variables
    private var state: String?

    // MARK: - Methods -
    convenience init(state: String? = nil) {
        self.init()
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        self.state = state
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateState(state)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        indicatorImageView.rotate()
    }

    // MARK: - Populate
    func updateState(_ state: String?) {
        guard isViewLoaded else {
            return
        }
        
        self.state = state
        stateLabel.text = state
    }
}
