//
//  AlertHelper.swift
//  WeatherApp
//
//  Created by Dylan caetano on 12/07/2026.
//

import Foundation
import UIKit

final class AlertHelper: Sendable {
    
    static let shared = AlertHelper()
    
    func addCity(_ controller: UIViewController, completion: ((String) -> Void)?) {
        let alert = UIAlertController(title: "Ajouter une ville", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Nom de ville"
        }
        let ok = UIAlertAction(title: "Valider", style: .default) { action in
            if let tf = alert.textFields?.first {
                if let text = tf.text, text != "" {
                    completion?(text)
                }
            }
        }
        let cancel = UIAlertAction(title: "Annuler", style: .cancel, handler: nil)
        alert.addAction(ok)
        alert.addAction(cancel)
        controller.present(alert, animated: true, completion: nil)
    }
    
    func allCities(_ controller: UIViewController, completion: ((String) -> Void)?) {
        let array = UDHelper.shared.getCities()
        
        guard !array.isEmpty else {
            error(controller, "Aucune ville enregistrée. Ajoutes-en une d'abord.")
            return
        }
        let alert = UIAlertController(title: "Choisissez une ville", message: nil, preferredStyle: .actionSheet)
        array.forEach { city in
            let act = UIAlertAction(title: city, style: .default) { action in
                completion?(city)
            }
            alert.addAction(act)
        }
        alert.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: nil))
        
        if let popover = alert.popoverPresentationController {
            popover.sourceView = controller.view
            popover.sourceRect = CGRect(x: controller.view.bounds.midX,
                                        y: controller.view.bounds.midY,
                                        width: 0, height: 0)
        }
        
        controller.present(alert, animated: true, completion: nil)
    }
    
    func error(_ controller: UIViewController, _ message: String) {
        let alert = UIAlertController(title: "Erreur", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }
}
