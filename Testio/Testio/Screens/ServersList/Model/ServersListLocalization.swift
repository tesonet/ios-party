//
//  ServersListLocalization.swift
//  Testio
//
//  Created by Andrii Popov on 3/9/21.
//

import Foundation

struct ServersListLocalization {
    
    struct activity {
        static var fetchingServerList: String {
            NSLocalizedString("serverList.activity.fetchingList", comment: "")
        }
    }
    
    struct sorting {
        static var distance: String {
            NSLocalizedString("serverList.sorting.distance", comment: "")
        }
        static var alphanumerical: String {
            NSLocalizedString("serverList.sorting.alphanumerical", comment: "")
        }
    }
    
    struct server {
        static var formattedDistance: String {
            NSLocalizedString("serverList.server.formattedDostance", comment:"")
        }
    }
}
