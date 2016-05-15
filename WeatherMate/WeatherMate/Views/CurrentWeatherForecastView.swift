//
//  CurrentWeatherForecastView.swift
//  WeatherMate
//
//  Created by Samrat on 9/5/16.
//  Copyright © 2016 SMRT. All rights reserved.
//

import Foundation
import UIKit

class CurrentWeatherForecastView: UIView {
    
    /*************************************************************/
    // MARK: Instance Variables
    /*************************************************************/
    
    @IBOutlet weak var lblTime : UILabel!
    
    @IBOutlet weak var lblMaximumTemperature : UILabel!
    
    @IBOutlet weak var lblHumidityPercentage : UILabel!
    
    @IBOutlet weak var lblForecast : UILabel!
    
    @IBOutlet weak var imgVwTemperatureIcon : UIImageView!
 
    /*************************************************************/
    // MARK: Initializer
    /*************************************************************/
    class func view() -> CurrentWeatherForecastView {
        return NSBundle.mainBundle().loadNibNamed("CurrentWeatherForecastView", owner: nil, options: nil)[0] as! CurrentWeatherForecastView
    }
    
    /**
     Methd to update the view based on the model
     - parameter hourlyWeather: The model according to which the weather will be updated.
     */
    func updateView(hourlyWeather: HourlyWeather) {
        lblTime.text = hourlyWeather.time
        lblMaximumTemperature.text = (hourlyWeather.temperature_In_C)! + Constants.Strings.DEGREE
        lblHumidityPercentage.text = (hourlyWeather.humidityPercentage)! + Constants.Strings.PERCENTAGE
        lblForecast.text = hourlyWeather.description
        imgVwTemperatureIcon.image = UIImage.init(named: hourlyWeather.weatherImageName!)
    }
}