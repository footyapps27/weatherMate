//
//  Utilities.swift
//  WeatherMate
//
//  Created by Samrat on 5/5/16.
//  Copyright © 2016 SMRT. All rights reserved.
//

import Foundation
import UIKit
import ICLoader

class Utilities {
    
    /**
     Method to make the customize the navigation bar
     */
    class func makeNavigationBarTransparent() {
        // Sets background to a blank/empty image
        UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarMetrics: .Default)
        // Sets shadow (line below the bar) to a blank image
        UINavigationBar.appearance().shadowImage = UIImage()
        // Sets the translucent background color
        UINavigationBar.appearance().backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        UINavigationBar.appearance().barTintColor = UIColor.clearColor()
    }
    
    /**
     Method to make the customize the tab bar
     */
    class func makeTabBarTransparent() {
        UITabBar.appearance().barTintColor = UIColor.clearColor()
        UITabBar.appearance().tintColor = UIColor.whiteColor()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.1)
    }
    
    /**
     Formats the loader that will be used in the application.
     */
    class func updateLoader() {
        ICLoader.setImageName(Constants.Resources.Images.LOADER_NAME)
        ICLoader.setLabelFontName(UIFont(name: Constants.Resources.Fonts.VARELA_ROUND, size: 10)!.fontName)
    }
    
    /**
     Method to get the index based on the current time
     - returns: Int depicting the index based on current time, e.g. 21, 12 etc.
     */
    class func getIndexForCurrentTime() -> Int {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([ .Hour, .Minute, .Second], fromDate: date)
        return components.hour
    }
    
    /**
     Method to copy the database from the resources file to the documents directory
     */
    class func copyDataBaseToDocumentsDirectory() {
        let fileManager = NSFileManager.defaultManager()
        let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0])
        let destinationSqliteURL = documentsPath.URLByAppendingPathComponent("weatherMate_dB.db")
        let sourceSqliteURL = NSBundle.mainBundle().URLForResource("weatherMate_dB", withExtension: "db")
        
        if !fileManager.fileExistsAtPath(destinationSqliteURL.path!) {
            do {
                try fileManager.copyItemAtURL(sourceSqliteURL!, toURL: destinationSqliteURL)
            } catch _ as NSError {
                
            }
        }
    }
    
    /**
     Method to show an alert with "Ok" action that will dismiss the alert.
     - parameter title:      The title of the alert
     - parameter message:    The alert message
     - parameter controller: The controller on top of which the alert needs to be displayed
     */
    class func showOkAlert(title: String, message: String, controller: UIViewController) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
        }))
        controller.presentViewController(alert, animated: true, completion: nil)
    }
    
     /**
         Method to get the respective weather image name based on the weather code.
         - parameter weatherCode: The weather code that was received from the server
         - returns: The name of the weather image mapped to the weather code.
         */
        class func getWeatherImageForCode(weatherCode: Int) -> String {
        
        switch weatherCode {
        case 113:
            return "Sunny"
        case 116:
            return "Partly_Cloudy"
        case 119, 122:
            return "Cloudy"
        case 143:
            return "Mist"
        case 176, 263, 266, 293, 296, 353:
            return "Light_Rain"
        case 179, 227, 323, 326, 368:
            return "Light_Snow"
        case 182, 185, 317, 320, 362, 365:
            return "Sleet"
        case 200:
            return "Light_Storm"
        case 230:
            return "Blizzard"
        case 248, 260:
            return "Fog"
        case 281, 299, 302, 314, 356:
            return "Rain"
        case 284, 305, 308, 359:
            return "Heavy_Rain"
        case 329, 331:
            return "Snow"
        case 335, 338, 371:
            return "Heavy_Snow"
        case 350, 374, 377:
            return "Hail"
        case 386, 389, 392, 395:
            return "Thunder"
        default:
            return ""
        }
    }
}