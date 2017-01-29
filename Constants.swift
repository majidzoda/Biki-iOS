//
//  Constants.swift
//  Biki
//
//  Created by Francely peralta on 1/28/17.
//  Copyright © 2017 Biki. All rights reserved.
//

import Foundation

let BASE_URL = "http://api.openweathermap.org/data/2.5/weather?"
let LATITUDE = "lat="
let LONGTITUDE = "&lon="
let APP_ID = "&appid="
let API_KEY = "649c8ca7aae4dcc2f681d5712060ec2a"

typealias DownloadComplete = () -> ()

let CURRENT_WEATHER_URL = "\(BASE_URL)\(LATITUDE)40.763194\(LONGTITUDE)-73.978891\(APP_ID)\(API_KEY)"
