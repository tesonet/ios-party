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
    
    func didLoadData() -> Bool
    func setDidLoadData(to didLoadData: Bool)
    
    func reset()
}

class ApplicationRepository: ApplicationRepositoryInterface {
    
    // MARK: - Constants
    let kLaunchCountKey = "ApplicationRepository_launchCount"
    let kDidLoadDataKey = "ApplicationRepository_didLoadData"
    
    // MARK: - Methods
    // MARK: - Launch count
    func launchCount() -> Int {
        return UserDefaults.standard.integer(forKey: kLaunchCountKey)
    }
    
    func incrementLaunchCount() {
        let currentCount = launchCount()
        UserDefaults.standard.set(currentCount + 1, forKey: kLaunchCountKey)
    }
    
    // MARK: Data loading
    func didLoadData() -> Bool {
        return UserDefaults.standard.bool(forKey: kDidLoadDataKey)
    }
    
    func setDidLoadData(to didLoadData: Bool) {
        UserDefaults.standard.set(didLoadData, forKey: kDidLoadDataKey)
    }
    
    // MARK: - Helpers
    func reset() {
        UserDefaults.standard.removeObject(forKey: kLaunchCountKey)
        UserDefaults.standard.removeObject(forKey: kDidLoadDataKey)
    }
}
