// Created by Paulius Cesekas on 01/04/2019.

import Domain
import ObjectMapper

extension Login: ImmutableMappable {
    public init(map: Map) throws {
        self.init(
            token: try map.value("token"))
    }
}

extension Login: BaseMappable {
    public mutating func mapping(map: Map) {
        token >>> map["token"]
    }
}
