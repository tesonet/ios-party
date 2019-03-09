import Foundation

enum DataError: Error {
    /// Token error
    case tokenError
    /// Servers data error.
    case noDataError
}

extension DataError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .tokenError:
            return NSLocalizedString("Token could not be retrieved. 🙀", comment: "")
        case .noDataError:
            return NSLocalizedString("Servers data could not be retrieved  🙀", comment: "")
        }
    }
}
