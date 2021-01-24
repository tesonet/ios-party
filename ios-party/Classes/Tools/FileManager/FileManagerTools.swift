//
//  FileManagerTools.swift
//  ios-party
//
//  Created by Ergin Bilgin on 2021-01-23.
//

import Foundation

class FileManagerTools {
    
    // MARK: - Methods
    static func documentsDirectoryPath() -> String? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard !paths.isEmpty else {
            log("No paths found for document directory")
            return nil
        }
        let documentsDirectory = paths[0]
        return documentsDirectory.path
    }
    
    static func excludeFileFromICloudBackup(filePath: String) {
        var fileURL = URL(fileURLWithPath: filePath)
        
        var resourceValues = URLResourceValues()
        resourceValues.isExcludedFromBackup = true
        
        do {
            try fileURL.setResourceValues(resourceValues)
        } catch {
            log("ERROR! Could not set resource values for database file: \(error)")
        }
    }
}
