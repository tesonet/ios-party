//
//  ServerSectionModel.swift
//  TesonetTask
//
//  Created by Jaroslav Chaninovicz on 2020-03-19.
//  Copyright © 2020 jch. All rights reserved.
//

import UIKit

class ServerSectionModel: SectionViewModel {
    
    override func createIdentifier() -> String {
        return String(describing: ServersSection.self)
    }
    
    override func getViewClass() -> AnyClass {
        return ServersSection.self
    }
    
}
