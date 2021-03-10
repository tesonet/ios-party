//
//  ServersListModel.swift
//  Testio
//
//  Created by Andrii Popov on 3/10/21.
//

import Foundation

struct ServersListModel {
    let sortingOptions: [SortingOption] = [.distance, .alphanumerical]
    let authorizationData: AuthorizationData
}
