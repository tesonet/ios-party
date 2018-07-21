import Foundation

enum DataError: Error, CustomStringConvertible {
    /// url could not be creaded from given string.
    case urlError(reason: String)
    /// No data was received.
    case noDataError(reason: String)
    /// json parsing error.
    case serializationError(reason: String)
    
    /// A description of the error.
    var description: String {
        switch self {
        case let .urlError(reason):
            return reason
        case let .noDataError(reason):
            return reason
        case let .serializationError(reason):
            return reason
        }
    }
}

enum HTTPError: Error, CustomStringConvertible {
    /// 401 response code
    case error401(reason: String)
    // Add more status codes if required
    
    /// A description of the error.
    var description: String {
        switch self {
        case let .error401(reason):
            return reason
        }
    }
    
    /// HTTP response code.
    var statusCode: String {
        switch self {
        case .error401(_):
            return "401"
        }
    }
}
