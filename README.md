<img width="5120" height="2560" alt="Git" src="https://github.com/user-attachments/assets/536b4145-028e-4e00-8cd0-d1bf34f44a9b" />

# WeatherApp

Application météo iOS développée en Swift / UIKit. Affiche les prévisions de la position actuelle de l'utilisateur ou de villes enregistrées, avec les prévisions horaires et sur 5 jours.

## Fonctionnalités

- Géolocalisation automatique au lancement
- Prévisions horaires (carrousel horizontal)
- Prévisions sur 5 jours (liste verticale)
- Recherche de ville par nom
- Sauvegarde et sélection des villes favorites
- Icônes météo téléchargées depuis l'API
- Interface Liquid Glass (iOS 26+)

## Technologies

- Swift/UIKit

## Architecture

Le projet suit le pattern **MVC**.

```
WeatherApp/
├── Controller/
│   └── ViewController.swift      # Écran principal, delegates table/collection
├── Model/
│   ├── ApiHelper.swift           # Construction d'URL et appels API
│   ├── ApiResult.swift           # Modèles Codable (Forecast, Main, Weather)
│   ├── GeocoderHelper.swift      # Ville ↔ coordonnées
│   ├── ImageDownloader.swift     # Téléchargement des icônes météo
│   ├── DateHelper.swift          # Formatage des dates
│   ├── UDHelper.swift            # Gestion UserDefaults
│   └── AlertHelper.swift         # Alertes et action sheets
└── View/
    ├── HourCell.swift            # Cellule prévision horaire
    └── DailyCell.swift           # Cellule prévision journalière
```

Les helpers sont implémentés en singletons (`static let shared`) pour centraliser chaque responsabilité.

## Installation

**Prérequis :** Xcode 26+, iOS 27.0 minimum

1. Créer un compte sur [OpenWeatherMap](https://openweathermap.org/api) et récupérer une clé API

2. Créer le fichier `Secrets.swift` à la racine du projet :

```swift
enum Secrets {
    static let weatherApi = "VOTRE_CLE_API"
}
```

> Ce fichier est ignoré par git (`.gitignore`) pour ne pas exposer la clé.

3. Ouvrir `WeatherApp.xcodeproj` et lancer sur simulateur ou appareil

## API

Endpoint utilisé : `api.openweathermap.org/data/2.5/forecast`

Renvoie les prévisions par tranches de 3h sur 5 jours. Paramètres : `lat`, `lon`, `lang=fr`, `units=metric`.

## Auteur

Dylan CAETANO
