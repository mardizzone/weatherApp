//
//  Models.swift
//  weatherApp
//
//  Created by Michael Ardizzone on 2/12/18.
//  Copyright © 2018 Michael Ardizzone. All rights reserved.
//

import Foundation

struct WeatherResponse : Codable {
    let weather : [WeatherData]
    let name : String
    let main : TempData
}

struct TempData : Codable {
    let temp : Float
}

struct WeatherData : Codable {
    let main : String
    let icon : String
}

class parseJSON {
    class func parseWeatherData(data: Data) -> WeatherResponse? {
        let decoder = JSONDecoder()
        do {
            let weatherData = try decoder.decode(WeatherResponse.self, from: data)
            return weatherData
        } catch {
            print("error trying to convert data to JSON")
            print(error)
            return nil
        }
    }
}
