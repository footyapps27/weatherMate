//
//  DateWeather.swift
//  WeatherMate
//
//  Created by Samrat on 10/5/16.
//  Copyright © 2016 SMRT. All rights reserved.
//

import Foundation
import SwiftyJSON

class DateWeather {
    
    /*************************************************************/
    // MARK: Instance Variables
    /*************************************************************/
    
    /// The current weather description
    var date : String?
    
    /// The maximum temperature in C
    var maximumTemperature_In_C : String?
    
    /// The minimum temperature in C
    var minimumTemperature_In_C : String?
    
    /// The maximum temperature in F
    var maximumTemperature_In_F : String?
    
    /// The minimum temperature in F
    var minimumTemperature_In_F : String?
    
    /// The associated weather image
    var weatherImageName : String?
    
    // Containing the next 5 days forecast
    var hourlyForecast : Array<HourlyWeather>?
    
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
        // Initialize the array
        hourlyForecast = Array<HourlyWeather>()
        // Populate the array now
        getHourlyForecast(json)
        // Initialize the other variables
        date = getFormattedDate(json)
        maximumTemperature_In_C = json["maxtempC"].stringValue
        minimumTemperature_In_C = json["mintempC"].stringValue
        maximumTemperature_In_F = json["maxtempF"].stringValue
        minimumTemperature_In_F = json["mintempF"].stringValue
        // Since the API is not providing any weather code for the hour prediction, we take from the hourly prediction the value for 1 PM
        weatherImageName = hourlyForecast![13].weatherImageName
    }
    
    /**
     Method to get the formatted date that will be displayed in the view.
     - parameter json: The JSON received from the server. This will have the date in the format - 2016-01-31.
     - returns: The formatted date format in the form 31/01
     */
    private func getFormattedDate(json: JSON) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let date : NSDate = dateFormatter.dateFromString(json["date"].stringValue)!
        dateFormatter.dateFormat = "dd/MM"
        return dateFormatter.stringFromDate(date)
    }

    /**
     Method to get the hourly forecast for this date
     - parameter json: The JSON object that was received from the server
     */
    private func getHourlyForecast(json: JSON) {
        // Get the array containing the forecast data
        let forecast = json["hourly"].array
        // Loop through the array & parse the respective items
        for item in forecast! {
            let hourForecast = HourlyWeather.init(json: item)
            hourlyForecast?.append(hourForecast)
        }
    }
}