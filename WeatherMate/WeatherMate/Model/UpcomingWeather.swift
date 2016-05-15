//
//  UpcomingWeather.swift
//  WeatherMate
//
//  Created by Samrat on 10/5/16.
//  Copyright © 2016 SMRT. All rights reserved.
//

import Foundation
import SwiftyJSON

class UpcomingWeather {
    
    /*************************************************************/
    // MARK: Instance Variables
    /*************************************************************/
    
    // Containing the next 5-30 days forecast
    var nextWeekForecast : Array<DateWeather>?
    
    /*************************************************************/
    // MARK: Initializer
    /*************************************************************/
    init(json: JSON) {
        // Initialize the array
        nextWeekForecast = Array()
        
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
        // Get the array containing the forecast data
        let forecast = json["data"]["weather"].array
        // Loop through the array & parse the respective items
        for item in forecast! {
            let dateForecast = DateWeather.init(json: item)
            nextWeekForecast?.append(dateForecast)
        }
    }
}
