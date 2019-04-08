// Created by Paulius Cesekas on 02/04/2019.

import Foundation
import NetworkPlatform

extension WebServiceConstants.Config: APIConfig {
    var endpoint: String {
        return "http://playground.tesonet.lt/"
    }
}
