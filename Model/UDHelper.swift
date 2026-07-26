//
//  UDHelper.swift
//  WeatherApp
//
//  Created by Dylan caetano on 12/07/2026.
//

import Foundation

final class UDHelper: Sendable {
    
    static let shared = UDHelper()
    
    private let key = "Cities"
    private let defaults = UserDefaults.standard
    private init() {}
    
    func addCity(_ string: String) {
        var array = getCities()
        array.append(string)
        defaults.set(array, forKey: key)
    }
    
    func getCities() -> [String] {
        defaults.array(forKey: key) as? [String] ?? []
    }
}
