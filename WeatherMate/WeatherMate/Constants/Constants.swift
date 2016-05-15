//
//  Constants.swift
//  WeatherMate
//
//  Created by Samrat on 18/4/16.
//  Copyright © 2016 SMRT. All rights reserved.
//

import Foundation

/**
 *  File for holding all the constants of the project.
 */
struct Constants {
    
    struct Resources {
        static let BACKGROUND_VIDEO_NAME = "BackgroundVideo"
        static let BACKGROUND_VIDEO_TYPE = "mp4"
        
        // Image names
        struct Images {
            static let LOADER_NAME = "Loader"
        }
        
        struct Fonts {
            static let VARELA_ROUND = "Varela Round"
        }
    }
    
    struct WebService {
        static let BASE_URL = "https://api.worldweatheronline.com/premium/v1/weather.ashx"
        static let FREE_WEATHER_API_KEY =  "c3432f3cbc5d4c808c5141553161105" //"866523910bc349c6976135733160405"
        static let STR_KEY = "key"
        static let STR_KEY_FORMAT = "format"
        static let STR_VALUE_JSON = "json"
        static let STR_KEY_CITY = "q"
        static let STR_KEY_NUMBER_OF_DAYS = "num_of_days"
        static let STR_KEY_TIME_INTERVAL = "tp"
        static let STR_VALUE_TIME_INTERVAL = "1"
    }
    
    struct Strings {
        static let STR_EMPTY = ""
        static let KEY_CITY = "City"
        static let DEGREE = "°C"
        static let PERCENTAGE = "%"
    }
    
    struct WatchKeys {
        static let KEY_NAME = "name"
        static let KEY_MAXMIN_TEMP = "maxMinTemp"
        static let KEY_HUMIDITY = "humidity"
        static let KEY_TEMPERATURE = "temperature"
        static let KEY_IMAGE = "image"
        static let KEY_CITIES = "cities"
    }
    
}