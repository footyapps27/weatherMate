//
//  CurrentWeather.swift
//  WeatherMate
//
//  Created by Samrat on 10/5/16.
//  Copyright © 2016 SMRT. All rights reserved.
//

import Foundation
import SwiftyJSON

class CurrentWeather {
    
    /*************************************************************/
    // MARK: Instance Variables
    /*************************************************************/
    
    /// The city for which the current weather is being displayed
    var city : String?
    
    /// The current weather description
    var description : String?
    
    /// The current weather temperature
    var temperature_In_C : String?
    
    /// The current weather temperature
    var temperature_In_F : String?
    
    /// The current real Feel
    var realFeel_In_C : String?
    
    /// The current real Feel
    var realFeel_In_F : String?
    
    /// The current real Feel
    var weatherImageName : String?
    
    /// The current real Feel
    private var weatherCode : String?
    
    /*************************************************************/
    // MARK: Initializer
    /*************************************************************/
    init(json: JSON) {
        // Set the instance variables here
        initializeVariables(json)
    }
    
    /*************************************************************/
    // MARK: Helper Methods
    /*************************************************************/
    
    /**
     Method to initialize the instance variables
     - parameter json: The complete JSON object that was received from the server
     */
    private func initializeVariables(json: JSON) {
        // Get the city
        city = getCityName(json)
        
        let currentCondition : [String: JSON] = (json["data"]["current_condition"].arrayValue.first?.dictionaryValue)!
        
        // Description
        description = currentCondition["weatherDesc"]?.arrayValue.first?.dictionaryValue["value"]?.stringValue
        
        // Temperatures
        temperature_In_C = currentCondition["temp_C"]?.stringValue
        
        // Temperatures
        temperature_In_F = currentCondition["temp_F"]?.stringValue
        
        // Temperatures
        realFeel_In_C = currentCondition["FeelsLikeC"]?.stringValue
        
        // Temperatures
        realFeel_In_F = currentCondition["FeelsLikeF"]?.stringValue
        
        // Get the weather code
        weatherCode = currentCondition["weatherCode"]?.stringValue
        
        // Now set the image based on the code
        weatherImageName = Utilities.getWeatherImageForCode(Int(weatherCode!)!)
    }
    
    /**
     Method to parse the city name received from server response
     - parameter json: The JSON received from the server
     - returns: The city name.
     */
    private func getCityName(json: JSON) -> String {
        // This contains the city plus country name
        let city = json["data"]["request"].arrayValue.first?.dictionaryValue["query"]?.stringValue
        // Remove the country name
        if city?.characters.count > 0 {
            let strings = city!.componentsSeparatedByString(",")
            return strings.first!
        }
        return ""
    }
    
}
