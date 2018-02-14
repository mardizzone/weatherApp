//
//  Networking.swift
//  weatherApp
//
//  Created by Michael Ardizzone on 2/12/18.
//  Copyright © 2018 Michael Ardizzone. All rights reserved.
//

import Foundation
import Alamofire

class Networking {

    class func dataFromWeatherAPI(searchTerm: String, completionHandler : @escaping (WeatherResponse) -> Void) {
        let params: Parameters = ["q" : searchTerm, "APPID" : "2f643455bd1d9ea00f7cd45f8e5236db", "units" : "imperial" ]
        
        Alamofire.request("https://api.openweathermap.org/data/2.5/weather", method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseData { response in
            switch response.result {
            case .success(let value):
                if let returnedData = parseJSON.parseWeatherData(data: value){
                    completionHandler(returnedData)
                }
            case .failure(let error):
                print(error)
            }
        }
    }

}
