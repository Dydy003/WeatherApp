//
//  APIHelper.swift
//  WeatherApp
//
//  Created by Dylan caetano on 28/06/2026.
//

import Foundation

class ApiHelper {
    
    static let shared = ApiHelper()
    
    private let apiKey = "Votre clé API"
    
    let base = "https://api.openweathermap.org/data/2.5/forecast"
    let units = "&units=metric"
    let lang = "&lang=fr"
    
    var appID: String {
        return "&appid=" + apiKey
    }
    
    func getUrl(coords: String) -> URL? {
        var urlString = base
        urlString += coords
        urlString += lang
        urlString += appID
        print(urlString)
        return URL(string: urlString)
    }
    
    func parseWeather(coods: String) async -> [Forecast] {
        guard let url = getUrl(coords: coods) else { return [] }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let result = try JSONDecoder().decode(ApiResult.self, from: data)
            return result.list
        } catch {
            print(error)
            return []
        }
    }
}
