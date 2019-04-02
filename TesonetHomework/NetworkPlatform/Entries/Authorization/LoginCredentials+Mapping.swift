// Created by Paulius Cesekas on 02/04/2019.

import Domain
import ObjectMapper

extension LoginCredentials: BaseMappable {
    public mutating func mapping(map: Map) {
        username >>> map["username"]
        password >>> map["password"]
    }
}
