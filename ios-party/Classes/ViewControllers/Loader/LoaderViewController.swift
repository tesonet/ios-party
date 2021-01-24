//
//  LoaderViewController.swift
//  ios-party
//
//  Created by Ergin Bilgin on 2021-01-23.
//

import UIKit

class LoaderViewController: BaseViewController,
                            LoaderDataModelDelegate {

    // MARK: - Declarations
    var dataModel: LoaderDataModelInterface!
    @IBOutlet weak var loadingMessageLabel: UILabel!
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        dataModel = LoaderDataModel(delegate: self)
        
        loadingMessageLabel.text = R.string.localizable.loading_message()
        
        // No large spinner in assets, no large spinner in the app. :]
        showActivityIndicator()
        dataModel.startDataLoad()
    }
    
    // MARK: - LoaderDataModelDelegate
    func loaderDataModel(didFinishLoading dataModel: LoaderDataModelInterface) {
        hideActivityIndicator()
    }
    
    func loaderDataModel(didFailLoading dataModel: LoaderDataModelInterface) {
        hideActivityIndicator()
        // FIXME: display alert
    }
}
