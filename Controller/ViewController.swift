//
//  ViewController.swift
//  WeatherApp
//
//  Created by Dylan caetano on 28/06/2026.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    var manager: CLLocationManager = CLLocationManager()
    var forecasts: [Forecast] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewDidLoad")
        setupLocation()
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    func setupLocation() {
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateLocation appelée")
        
        manager.stopUpdatingLocation()
        
        guard let loc = locations.first else { return }
        
        let coords = loc.coordinate
        let str = "?lat=\(coords.latitude)&lon=\(coords.longitude)"
        
        Task {
            let forecast = await ApiHelper.shared.parseWeather(coods: str)
            
            await MainActor.run {
                self.forecasts = forecast
            }
        }
    }
}


