//
//  WeatherService.swift
//  WeatherSearch
//
//  Created by Colin Masters on 2019-12-02.
//  Copyright © 2019 Langara. All rights reserved.
//

import Foundation

protocol WeatherSearchDelegate: class {
    func requestFailed(with error: APIError)
    func searchCompleted(with forecast: Forecast)
}

final class WeatherSearchService {
    private weak var delegate: WeatherSearchDelegate?
    private var client = APIClient()
    
    init(delegate: WeatherSearchDelegate){
        self.delegate = delegate
    }
    
    func dailyForecast(searchCity: String, searchCountry: String) {
        let request = APIRequest(method: .get, path: "forecast")
        
        request.queryItems = [
            URLQueryItem(name: "q", value: "\(searchCity),\(searchCountry)"),
            URLQueryItem(name: "units", value: "metric")
        ]
        
        request.headers = [HTTPHeader(field: "Content-Type", value: "application/json")]
        
        client.request(request) { (response, data, error) in
            guard error == nil else {
                self.delegate?.requestFailed(with: error!)
                return
            }
            
            if let data = data {
                if let weatherForecast = try? JSONDecoder().decode(Forecast.self, from: data) {
                    self.delegate?.searchCompleted(with: weatherForecast)
                }
            } else {
                self.delegate?.requestFailed(with: .requestFailed)
            }
        }
    }
}
