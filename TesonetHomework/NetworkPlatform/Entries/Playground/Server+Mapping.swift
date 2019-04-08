// Created by Paulius Cesekas on 01/04/2019.

import Domain
import ObjectMapper

extension Server: ImmutableMappable {
    public init(map: Map) throws {
        self.init(
            name: try map.value("name"),
            distance: try map.value("distance"))
    }
}
