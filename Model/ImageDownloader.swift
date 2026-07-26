//
//  ImageDownloader.swift
//  WeatherApp
//
//  Created by Dylan caetano on 05/07/2026.
//

import Foundation

class ImageDownloader {
    
    let base = "https://openweathermap.org/img/wn/"
    let end = "@2x.png"
    
    func imageURl(_ code: String) -> URL? {
        return URL(string:base + code + end)
    }
    
    func download(_ code: String, completion: ((Data?) -> Void)?) {
        if let url = imageURl(code) {
            URLSession.shared.dataTask(with: url) { d, _, _ in
                completion?(d)
            }.resume()
        } else {
            completion?(nil)
        }
    }
    
    
}
