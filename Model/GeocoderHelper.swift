//
//  GeocoderHelper.swift
//  WeatherApp
//
//  Created by Dylan caetano on 07/07/2026.
//

import Foundation
import CoreLocation
import MapKit

final class GeocoderHelper: @unchecked Sendable {
    
    static let shared = GeocoderHelper()
    
    func toLocation(_ city: String) async -> CLLocation? {
        guard let request = MKGeocodingRequest(addressString: city) else {
            return nil
        }
        do {
            let mapItems = try await request.mapItems
            return mapItems.first?.location
        } catch {
            return nil
        }
    }
    
    func toString(_ coords: CLLocation) async -> String {
       guard let request = MKReverseGeocodingRequest(location: coords) else {
            return ""
        }
        do {
            let mapItems = try await request.mapItems
            guard let item = mapItems.first else { return "" }
            return item.addressRepresentations?.cityName ?? ""
        } catch {
            return ""
        }
    }
}
