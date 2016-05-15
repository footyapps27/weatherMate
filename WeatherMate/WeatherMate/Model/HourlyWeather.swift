//
//  HourlyWeather.swift
//  WeatherMate
//
//  Created by Samrat on 10/5/16.
//  Copyright © 2016 SMRT. All rights reserved.
//

import Foundation
import SwiftyJSON

class HourlyWeather {
    
    /*************************************************************/
    // MARK: Instance Variables
    /*************************************************************/
    
    /// The current weather description
    var time : String?
    
    /// The temperature in C
    var temperature_In_C : String?
    
    /// The temperature in C
    var temperature_In_F : String?
    
    /// The humidity %
    var humidityPercentage : String?
    
    /// The current real Feel
    var weatherImageName : String?
    
    /// The description
    var description : String?
    
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
        temperature_In_C = json["tempC"].stringValue
        temperature_In_F = json["tempF"].stringValue
        description = json["weatherDesc"].array?.first?.dictionary!["value"]?.stringValue
        weatherCode = json["weatherCode"].stringValue
        humidityPercentage = json["humidity"].stringValue
        weatherImageName = Utilities.getWeatherImageForCode(Int(weatherCode!)!)
        time = getFormattedTime(json)
    }
    
    /**
     Method to get formatted time string from the JSON received from server. The server is returning time in 0, 100, 200, 330 etc format.
     - parameter json: The response from server
     - returns: The formatted time in 12 hour format. It does NOT take the minutes from the response into account. e.g. 1 PM, 2 PM
     */
    private func getFormattedTime(json: JSON) -> String {
        // Actual value
        let actualValue = Int(json["time"].stringValue)
        // Formatted value
        var formattedValue = Constants.Strings.STR_EMPTY
        // Check if the value is 0
        if(actualValue < 100) {
            // Dividing by 0 will lead to a crash
           formattedValue = "00:00"
        }else {
            // Not taking the minutes potion , since we will be showing the hour time only.
            formattedValue = String(actualValue! / Int(100)) + ":" + "00"
        }
        
        // First change the string to date object
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "H:mm"
        let actualTime = dateFormatter.dateFromString(formattedValue)!
        
        // Now we can change the date to the desired format
        dateFormatter.dateFormat = "h a"
        return dateFormatter.stringFromDate(actualTime)
    }
}