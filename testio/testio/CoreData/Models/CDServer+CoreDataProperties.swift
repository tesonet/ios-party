
import Foundation
import CoreData


extension CDServer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDServer> {
        return NSFetchRequest<CDServer>(entityName: "CDServer")
    }

    @NSManaged public var name: String
    @NSManaged public var distance: Int32
}
