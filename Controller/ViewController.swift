//
//  ViewController.swift
//  WeatherApp
//
//  Created by Dylan caetano on 28/06/2026.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var imageLabel: UIImageView!
    @IBOutlet weak var buttonStackView: UIStackView!
    
    var manager: CLLocationManager = CLLocationManager()
    var forecasts: [Forecast] = []
    var lastknownCoords: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLocation()
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        setupFlowLayout()
    }
    
    func setupUI() {
        container.layer.cornerRadius = 25
        
        imageLabel.clipsToBounds = false
        imageLabel.layer.shadowColor = UIColor.blue.cgColor
        imageLabel.layer.shadowOpacity = 0.3
        imageLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
        imageLabel.layer.shadowRadius = 5
        
        for case let button as UIButton in buttonStackView.arrangedSubviews {
            applyGlass(to: button, title: button.currentTitle ?? "Ajouter")
        }
    }
    
    private func applyGlass(to button: UIButton, title: String) {
        var config = UIButton.Configuration.glass()
        config.title = title
        config.cornerStyle = .capsule
        button.configuration = config
    }
    
    private func groupButtonsInGlassContainer() {
        guard let parent = buttonStackView.superview else { return }

        let glassContainer = UIVisualEffectView(effect: UIGlassContainerEffect())
        glassContainer.translatesAutoresizingMaskIntoConstraints = false

        parent.insertSubview(glassContainer, aboveSubview: buttonStackView)
        buttonStackView.removeFromSuperview()
        glassContainer.contentView.addSubview(buttonStackView)
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: glassContainer.contentView.topAnchor),
            buttonStackView.bottomAnchor.constraint(equalTo: glassContainer.contentView.bottomAnchor),
            buttonStackView.leadingAnchor.constraint(equalTo: glassContainer.contentView.leadingAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: glassContainer.contentView.trailingAnchor)
        ])
    }
    
    func setupFirst() {
        imageLabel.image = nil
        descLabel.text = ""
        cityLabel.text = ""
        tempLabel.text = ""
        if let first = forecasts.first {
            ImageDownloader().download(first.weather.first!.icon) { d in
                DispatchQueue.main.async {
                    if let data = d {
                        self.imageLabel.image = UIImage(data: data)
                    }
                }
            }
            descLabel.text = first.weather.first!.description
            tempLabel.text = "\(Int(first.main.temp))°C"
            if let last = lastknownCoords {
                Task {
                    let city = await GeocoderHelper.shared.toString(last)
                    await MainActor.run {
                        self.cityLabel.text = city
                    }
                }
            }
        }
    }
    
    
    @IBAction func addCity(_ sender: Any) {
        AlertHelper.shared.addCity(self) { [weak self] city in
            guard let self, !city.trimmingCharacters(in: .whitespaces).isEmpty else { return }
            UDHelper.shared.addCity(city)
            self.loadWeather(for: city)
        }
    }
    
    @IBAction func changeCity(_ sender: Any) {
        AlertHelper.shared.allCities(self) { [weak self] city in
            self?.loadWeather(for: city)
        }
    }
    
    func loadWeather(for city: String) {
        Task {
            guard let loc = await GeocoderHelper.shared.toLocation(city) else {
                await MainActor.run {
                    AlertHelper.shared.error(self, "Ville introuvable")
                }
                return
            }
            let coords = loc.coordinate
            let str = "?lat=\(coords.latitude)&lon=\(coords.longitude)"
            let forecast = await ApiHelper.shared.parseWeather(coods: str)
            
            await MainActor.run {
                self.lastknownCoords = loc
                self.forecasts = forecast
                self.tableView.reloadData()
                self.collectionView.reloadData()
                self.setupFirst()
            }
        }
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
        self.lastknownCoords = loc
        
        let coords = loc.coordinate
        let str = "?lat=\(coords.latitude)&lon=\(coords.longitude)"
        
        Task {
            let forecast = await ApiHelper.shared.parseWeather(coods: str)
            
            await MainActor.run {
                self.forecasts = forecast
                self.tableView.reloadData()
                self.collectionView.reloadData()
                self.setupFirst()
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Daily") as? DailyCell {
            cell.setup(forecasts[indexPath.row])
            return cell
        }
        let cell = UITableViewCell()
        let forecast = forecasts[indexPath.row]
        var configuration = cell.defaultContentConfiguration()
        configuration.text = forecast.weather.first?.description ?? "Aucune donnée"
        cell.contentConfiguration = configuration
        return cell
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func setupFlowLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 80)
        collectionView.collectionViewLayout = layout
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if forecasts.count < 8 {
            return forecasts.count
        }
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Hour", for: indexPath) as! HourCell
        cell.setup(forecasts[indexPath.item])
        return cell
    }
}
