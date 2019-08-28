
import Foundation
import Alamofire
import PromiseKit


extension DataRequest {
    
    static func jsonDataResponseSerializer() -> DataResponseSerializer<Data> {
        return DataResponseSerializer { _, response, data, error in
            
            guard error == nil else { return .failure(error!) }
            
            guard let data = data else {
                return .failure(error! as! AFError)
            }
            
            return .success(data)
        }
    }
    
    @discardableResult
    func responseJsonData<T>(seal: Resolver<T>,
                             queue: DispatchQueue? = nil,
                             mapper: @escaping (_ jsonData: Data) throws -> T) -> Self {
        
        return response(queue: queue,
                        responseSerializer: DataRequest.jsonDataResponseSerializer(),
                        completionHandler: { response in
                            switch response.result {
                            case .success(let jsonData):
                                do {
                                    let result = try mapper(jsonData)
                                    
                                    seal.fulfill(result)
                                } catch {
                                    seal.reject(error)
                                }
                            case .failure(let error):
                                seal.reject(error)
                            }
        })
    }
}
