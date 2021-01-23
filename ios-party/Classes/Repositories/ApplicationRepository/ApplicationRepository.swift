//
//  ApplicationRepository.swift
//  ios-party
//
//  Created by Ergin Bilgin on 2021-01-23.
//

import Foundation

protocol ApplicationRepositoryInterface {
    func launchCount() -> Int
    func incrementLaunchCount()
    
    func reset()
}

class ApplicationRepository: ApplicationRepositoryInterface {
    
    // MARK: - Constants
    let kLaunchCountKey = "ApplicationRepository_launchCount"
    
    // MARK: - Methods
    func launchCount() -> Int {
        return UserDefaults.standard.integer(forKey: kLaunchCountKey)
    }
    
    func incrementLaunchCount() {
        let currentCount = launchCount()
        UserDefaults.standard.set(currentCount + 1, forKey: kLaunchCountKey)
    }
    
    func reset() {
        UserDefaults.standard.removeObject(forKey: kLaunchCountKey)
    }
}
