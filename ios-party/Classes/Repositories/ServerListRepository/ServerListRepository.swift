//
//  ServerListRepository.swift
//  ios-party
//
//  Created by Ergin Bilgin on 2021-01-23.
//

import Foundation
import GRDB

protocol ServerListRepositoryInterface {
    func serverList() -> [ServerEntity]
    func setServerList(serverList: [ServerEntity])
    func removeAllServers()
}

class ServerListRepository: ServerListRepositoryInterface {
    
    // MARK: - Constants
    let kDatabaseFileName = "database.sqlite"
    let bundleDatabaseFileName: String = "database"
    let bundleDatabaseFileExtension: String = "sqlite"
    
    // MARK: - Declarations
    static var shared: ServerListRepositoryInterface = ServerListRepository()
    
    let databasePath: String?
    var dbQueue: DatabaseQueue?
    
    // MARK: - Methods
    init() {
        databasePath = FileManagerTools.documentsDirectoryPath()?.appending("/\(kDatabaseFileName)")
        prepareRepository()
        
        guard let databasePath = databasePath else {
            return
        }
        
        do {
            dbQueue = try DatabaseQueue(path: databasePath)
        } catch {
            log("\(error)")
        }
    }
    
    func serverList() -> [ServerEntity] {
        var serverList: [ServerEntity] = []
        
        do {
            try dbQueue?.read { database in
                try serverList = ServerEntity.fetchAll(database)
            }
        } catch {
            log("\(error)")
        }
        
        return serverList
    }
    
    func setServerList(serverList: [ServerEntity]) {
        removeAllServers()
        
        for server in serverList {
            do {
                try _ = dbQueue?.write { database in
                    try server.insert(database)
                }
            } catch {
                log("\(error)")
            }
        }
    }
    
    func removeAllServers() {
        do {
            try _ = dbQueue?.write { database in
                try ServerEntity.deleteAll(database)
            }
        } catch {
            log("\(error)")
        }
    }
    
    // MARK: - Helpers
    func prepareRepository() {
        guard let databasePath = databasePath else {
            log("ERROR! Could not get database path.")
            return
        }
        
        guard FileManager.default.fileExists(atPath: databasePath) == false else {
            return
        }
        
        guard let bundleDBFilePath: String = Bundle.main.path(forResource: bundleDatabaseFileName,
                                                              ofType: bundleDatabaseFileExtension) else {
            log("ERROR! Could not create bundle file path with file name: \(bundleDatabaseFileName).\(bundleDatabaseFileExtension)")
            return
        }
        
        do {
            try FileManager.default.copyItem(atPath: bundleDBFilePath, toPath: databasePath)
            FileManagerTools.excludeFileFromICloudBackup(filePath: databasePath)
        } catch {
            log("ERROR!: \(error)")
        }
    }
}
