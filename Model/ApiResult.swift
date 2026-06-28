//
//  ApiResult.swift
//  WeatherApp
//
//  Created by Dylan caetano on 28/06/2026.
//

import SwiftUI

struct ApiResult: Decodable {
    var list: [Forecast]
}

struct Forecast: Decodable {
    let dt: Int
    let main: Main
    let weather: Weather
    let dt_txt: String
}

struct Main: Decodable {
    var temp: Double
    var feels_like: Double
    var temp_min: Double
    var temp_max: Double
}

struct Weather: Decodable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}

/*
 "list":[{"dt":1782669600,
 "main":{"temp":303.59,
 "feels_like":303.91,
 "temp_min":303.59,
 "temp_max":303"
 
 weather":
 [{"id":500,
 "main":"Rain",
 "description":"légère pluie",
 "icon":"10d"}],"dt_txt":"2026-06-28 18:00:00"},336}}
 */
