//
//  Forecast.swift
//  WeatherSearch
//
//  Created by Colin Masters on 2019-12-02.
//  Copyright © 2019 Langara. All rights reserved.
//

import Foundation

struct Forecast: Codable {
    var cnt: Int?
    var city: City
    var list: [Overview]?
}

struct City: Codable {
    var name: String?
}

struct Overview: Codable {
    var dt: Int?
    var dt_text: String?
    var main: Main?
    var weather: [Weather]?
    var clouds: Clouds?
}

struct Main: Codable {
    var temp: Double?
    var temp_min: Double?
    var temp_max: Double?
    var pressure: Double?
}

struct Weather: Codable {
    var main: String?
    var description: String?
    var icon: String?
}

struct Clouds: Codable {
    var speed: Double?
    var deg: Int?
}
