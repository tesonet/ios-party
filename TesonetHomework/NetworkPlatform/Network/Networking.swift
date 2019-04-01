// Created by Paulius Cesekas on 01/04/2019.

import RxSwift
import RxAlamofire
import ObjectMapper

protocol Networking {
    func getItem<T: ImmutableMappable>(_ path: String,
                                       parameters: [String: Any]?,
                                       headers: [String: String]?) -> Observable<T>
    func getList<T: ImmutableMappable>(_ path: String,
                                       parameters: [String: Any]?,
                                       headers: [String: String]?) -> Observable<[T]>
    func postItem<T: ImmutableMappable>(_ path: String,
                                        parameters: [String: Any]?,
                                        headers: [String: String]?) -> Observable<T>
    func putItem<T: ImmutableMappable>(_ path: String,
                                       parameters: [String: Any]?,
                                       headers: [String: String]?) -> Observable<T>
    func deleteItem<T: ImmutableMappable>(_ path: String,
                                          parameters: [String: Any]?,
                                          headers: [String: String]?) -> Observable<T>
}
