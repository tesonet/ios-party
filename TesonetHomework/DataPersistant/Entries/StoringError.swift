// Created by Paulius Cesekas on 01/04/2019.

import Foundation

public enum StoringError: Error {
    case storageIsNotConfigured
    case storageIsNotWritable
    case entryIsNotSupportedForSelectedStorage
}
