//
//  AlertControllerFactory+Sort.swift
//  ios-party
//
//  Created by Lukas on 11/30/20.
//

import UIKit

extension AlertControllerFactory {
    
    static func sortAlertController(actionHandler: @escaping (serverListSortType) -> ()) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let sortByDistance = UIAlertAction(title: Constants.Sort.byDistanceTitle, style: .default) { action in
            actionHandler(.byDistance)
        }
        
        let sortByAlphanumeric = UIAlertAction(title: Constants.Sort.byAlphanumericTitle, style: .default) { action in
            actionHandler(.byAlphanumeric)
        }
        
        let cancelAction = UIAlertAction(title: Constants.genericCancel, style: .cancel)
        
        alert.addAction(sortByDistance)
        alert.addAction(sortByAlphanumeric)
        alert.addAction(cancelAction)
        
        return alert
    }
}
