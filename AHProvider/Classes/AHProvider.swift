/**
 * Copyright © 2017 Ara Hakobyan. All rights reserved.
 */

import Foundation

protocol AHProviderType: class {
    associatedtype Request: AHRequest

    func request<Response: Decodable>(_ request: Request, completion: @escaping (AHResult<Response>) -> Void)
}

open class AHProvider<Request: AHRequest>: AHProviderType {
    
    fileprivate let session: URLSession
    
    public init() {
        self.session = URLSession(configuration: .default)
        URLCache.shared = URLCache(memoryCapacity: 20 * 1024 * 1024, diskCapacity: 100 * 1024 * 1024, diskPath: nil)
    }

    public func request<Response: Decodable>(_ request: Request, completion: @escaping (AHResult<Response>) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = request.baseURL.scheme
        urlComponents.queryItems = request.params?.toQueryItems
        urlComponents.host = request.baseURL.host
        urlComponents.path = request.baseURL.path + "/" + request.path
        
        guard let url = urlComponents.url else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.string
        urlRequest.allHTTPHeaderFields = request.headers
        
        let task = session.dataTask(with: urlRequest) { (data, urlReponse, error) in
            guard let data = data else {
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.failure(AHError.dataMissing))
                    }
                }
                return
            }
            
            guard let jsonAny = try? JSONSerialization.jsonObject(with: data, options: []), let _ = jsonAny as? [String: Any] else {
                DispatchQueue.main.async {
                    completion(.failure(AHError.invalidJsonResponse))
                }
                return
            }
            
            guard let decoded = try? JSONDecoder().decode(Response.self, from: data) else {
                DispatchQueue.main.async {
                    completion(.failure(AHError.responseDecodingFailed))
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(decoded))
            }
        }
        
        task.resume()
    }
}

extension AHProvider {

    public func loadImage(at url: URL, completion: @escaping (AHResult<UIImage>) -> Void) -> URLSessionDataTask {
        let task = session.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.failure(AHError.dataMissing))
                    }
                }

                return
            }

            guard let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(.failure(AHError.invalidImageData))
                }
                return
            }

            DispatchQueue.main.async {
                completion(.success(image))
            }
        }

        task.resume()

        return task
    }
}

extension Dictionary where Key == String, Value == String {
    
    var toQueryItems: [URLQueryItem]? {
        var temp: [URLQueryItem]? = []
        for obj in self {
            let queryItem = URLQueryItem(name: obj.key, value: obj.value)
            temp?.append(queryItem)
        }
        
        return temp
    }
}

