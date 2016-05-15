//
//  WeatherService.swift
//  WeatherMate
//
//  Created by Samrat on 4/5/16.
//  Copyright © 2016 SMRT. All rights reserved.
//

/*************************************************************/
// MARK: Imported Classes
/*************************************************************/
import Foundation
import SwiftyJSON
import Alamofire

class WeatherService {
    
    /*************************************************************/
    // MARK: Singleton
    /*************************************************************/
    static let sharedInstance = WeatherService()
    
    /*************************************************************/
    // MARK: Alias & Constants
    /*************************************************************/
    typealias ServiceResponse = (JSON, NSError?) -> Void
    
    let baseURL = Constants.WebService.BASE_URL
    
    /*************************************************************/
    // MARK: Public Methods
    /*************************************************************/
    
    /**
     Method to get all the weather forecast for a particular city.
     - parameter cityName:     The name of the city
     - parameter onCompletion: The completion block with the positive/negative response
     */
    func getWeatherUpdatesForCity(cityName: String, onCompletion:ServiceResponse) {
        
        // Add the pre requisite parameters
        let parameterDictionary = getParameterDictionaryForWeatherUpdatesService(cityName)
        
        // Create the get request
        Alamofire.request(.GET, baseURL, parameters: parameterDictionary)
            .responseJSON { response in
                
                switch response.result {
                    
                case .Success(let data):
                    // Allow Swiftify to parse the data received
                    let json = JSON(data)
                    // Finally return the data to the caller
                    onCompletion(json,nil)
                    
                case .Failure(let error):
                    onCompletion(nil,error)
                }
        }
    }
    
    /*************************************************************/
    // MARK: Private Methods
    /*************************************************************/
    
    /**
     Add all the necessary parameters for getting the weather updates for a particular city
     - parameter city:     The name of the city
     - returns: The dictionary with the list of parameters for getting the forecast service.
     */
    private func getParameterDictionaryForWeatherUpdatesService(city: String) -> Dictionary<String, String> {
        
        return [Constants.WebService.STR_KEY_CITY : city,
                Constants.WebService.STR_KEY_NUMBER_OF_DAYS : "10",
                Constants.WebService.STR_KEY_TIME_INTERVAL: "1",
                Constants.WebService.STR_KEY : Constants.WebService.FREE_WEATHER_API_KEY,
                Constants.WebService.STR_KEY_FORMAT : Constants.WebService.STR_VALUE_JSON]
    }
}