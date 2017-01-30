//
//  CurrentWeather.swift
//  Biki
//
//  Created by Firdavsii Majidzoda on 1/29/17.
//  Copyright © 2017 Biki. All rights reserved.
//

import UIKit
import Alamofire

class CurrentWeather {
    
    let BASE_URL = "http://api.openweathermap.org/data/2.5/weather?"
    let LATITUDE = "lat="
    let LONGTITUDE = "&lon="
    let APP_ID = "&appid="
    let API_KEY = "649c8ca7aae4dcc2f681d5712060ec2a"
    
    typealias DownloadComplete = () -> ()
    
    let CURRENT_WEATHER_URL :String!
    
    var _weatherType: String!
    var _currentTemp: Double!
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    
    var currentTemp: Double {
        if _currentTemp == nil {
            _currentTemp = 0.0
        }
        return _currentTemp
    }
    
    init(lat: Double, lon: Double) {
        CURRENT_WEATHER_URL = "\(BASE_URL)\(LATITUDE)\(lat)\(LONGTITUDE)\(lon)\(APP_ID)\(API_KEY)"
    }
    
    func downloadWeatherDetails(completed: @escaping DownloadComplete) {
        //Alamofire download
        let currentWeatherURL = URL(string: CURRENT_WEATHER_URL)!
        
        Alamofire.request(currentWeatherURL).responseJSON { response in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, Any> {
                if let weather = dict["weather"] as? [Dictionary<String, Any>] {
                    if let main = weather[0]["main"] as? String {
                        self._weatherType = main.capitalized
                    }
                }
                
                if let main = dict["main"] as? Dictionary<String, Any> {
                    if let currentTemperature = main["temp"] as? Double {
                        
                        let kelvinToFarenheitPre = (currentTemperature * (9/5) - 459.67)
                        let kelvinToFarenheit = Double(round(10 * kelvinToFarenheitPre/10))
                        
                        self._currentTemp = kelvinToFarenheit
                    }
                }
            }
            completed()
        }
    }
}
