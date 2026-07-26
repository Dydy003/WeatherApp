//
//  HourCell.swift
//  WeatherApp
//
//  Created by Dylan caetano on 29/06/2026.
//

import UIKit

class HourCell: UICollectionViewCell {
    
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    var forecast: Forecast!
    
    func setup(_ newForecast: Forecast) {
//       contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 10
        self.forecast = newForecast
        self.timeLbl.text = DateHelper.shared.convertToTime(forecast.dt)
        self.tempLbl.text = "\(Int(forecast.main.temp))°C"
        icon.image = nil
        ImageDownloader().download(forecast.weather.first!.icon, completion: { data in
            DispatchQueue.main.async {
                if data != nil {
                    self.icon.image = UIImage(data: data!)
                }
            }
        })
    }
}
