//
//  DateHelper.swift
//  WeatherApp
//
//  Created by Dylan caetano on 05/07/2026.
//

import Foundation

class DateHelper {
    
    static let shared = DateHelper()
    let formatter = DateFormatter()
    
    func convertToTime(_ int: Int) -> String {
        let date = Date(timeIntervalSince1970: Double(int))
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        let string = formatter.string(from: date)
        return string
    }
    
    func convertRegular(_ int: Int) -> String {
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: Date(timeIntervalSince1970: Double(int)))
    }
}
