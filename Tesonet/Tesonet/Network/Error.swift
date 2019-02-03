import SwiftMessages

enum DataError: Error {
    /// url could not be creaded from given string.
    case urlError(url: String)
    /// No data was received.
    case noDataError
    /// json serialization error.
    case serializationError(reason: String)
    /// Database error.
    case databaseError
    /// Unknown error.
    case unknownError
}

extension DataError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .urlError(let url):
            return NSLocalizedString("Error: " + url + ". 🙀", comment: "")
        case .noDataError:
            return NSLocalizedString("Error: no data.  🙀", comment: "")
        case .serializationError(let reason):
            return NSLocalizedString("Error: " + reason + ". 🙀", comment: "")
        case .databaseError:
            return NSLocalizedString("Error: database. 🙀", comment: "")
        case .unknownError:
            return NSLocalizedString("Error: unknown. 🙀", comment: "")
        }
    }
}
