//
//  PersistenceManager.swift
//  weatherApp
//
//  Created by Michael Ardizzone on 2/13/18.
//  Copyright © 2018 Michael Ardizzone. All rights reserved.
//

import Foundation
import UIKit

class PersistenceManager {
    
    class func storeLastSearchedWeatherData(location: String, image: UIImage?, temperature: Int, weatherDescription: String ) {
        UserDefaults.standard.set(location, forKey: "location")
        UserDefaults.standard.set(temperature, forKey: "temperature")
        UserDefaults.standard.set(weatherDescription, forKey: "weatherDescription")
        if let unwrappedImage = image {
            if let imageData = UIImagePNGRepresentation(unwrappedImage) {
                UserDefaults.standard.set(imageData, forKey: "image")
            }
        }
    }
    
    class func retrieveStoredWeatherData() -> [String : Any] {
        var storedData = [String : Any]()
        if let location = UserDefaults.standard.object(forKey: "location") {
            storedData["location"] = location
        }
        if let temperature = UserDefaults.standard.object(forKey: "temperature") {
            storedData["temperature"] = temperature
        }
        if let image = UserDefaults.standard.object(forKey: "image") {
            storedData["image"] = image
        }
        if let weatherDescription = UserDefaults.standard.object(forKey: "weatherDescription") {
            storedData["weatherDescription"] = weatherDescription
        }
        
        return storedData
    }
    
    
}
