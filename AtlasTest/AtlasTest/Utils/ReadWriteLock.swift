//
//  ReadWriteLock.swift
//  AtlasTest
//
//  Created by Irina  Shupikova on 9/29/19.
//  Copyright © 2019 krokus. All rights reserved.
//

import Foundation

final class ReadWriteLock {
    private var rwlock: pthread_rwlock_t = {
        var rwlock = pthread_rwlock_t()
        pthread_rwlock_init(&rwlock, nil)
        return rwlock
    }()
    
    func writeLock() {
        pthread_rwlock_wrlock(&rwlock)
    }
    
    func readLock() {
        pthread_rwlock_rdlock(&rwlock)
    }
    
    func unlock() {
        pthread_rwlock_unlock(&rwlock)
    }
}
