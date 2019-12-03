//
//  APIClient.swift
//  WeatherSearch
//
//  Created by Colin Masters on 2019-12-02.
//  Copyright © 2019 Langara. All rights reserved.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case requestFailed
}

enum HTTPMethod: String {
    case get = "GET"
}

struct HTTPHeader {
    let field: String
    let value: String
}

class APIRequest {
    let method: HTTPMethod
    let path: String
    var queryItems: [URLQueryItem]?
    var headers: [HTTPHeader]?
    
    init(method: HTTPMethod, path: String){
        self.method = method
        self.path = path
    }
}

struct APIClient {
    
    typealias APIClientCompletion = (HTTPURLResponse?, Data?, APIError?) -> Void
    
    private let session = URLSession.shared
    private let baseURL = URL(string: "https://api.openweathermap.org/data/2.5/")!
    private let appKey = URLQueryItem(name: "appid", value: "2b5f13fb4770eb617974df479692e9b1")
    
    func request(_ request: APIRequest, _ completion: @escaping APIClientCompletion) {
        var urlComponents = URLComponents()
        urlComponents.scheme = baseURL.scheme
        urlComponents.host = baseURL.host
        urlComponents.path = baseURL.path
        urlComponents.queryItems = request.queryItems
        urlComponents.queryItems?.append(appKey)
        
        guard let url = urlComponents.url?.appendingPathComponent(request.path) else {
            completion(nil, nil, .invalidURL)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        
        request.headers?.forEach({ urlRequest.addValue($0.value, forHTTPHeaderField: $0.field) })
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, nil, .requestFailed)
                return
            }
            completion(httpResponse, data, nil)
        }
        task.resume()
    }
}

