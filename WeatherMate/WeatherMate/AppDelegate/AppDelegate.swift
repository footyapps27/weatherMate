//
//  AppDelegate.swift
//  WeatherMate
//
//  Created by Samrat on 18/4/16.
//  Copyright © 2016 SMRT. All rights reserved.
//

import UIKit
import WatchConnectivity

@available(iOS 9.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    /// The session variable that will be used to communicate with the watch
    var session: WCSession? {
        didSet {
            if let session = session {
                session.delegate = self
                session.activateSession()
            }
        }
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // Initialize the WCSession
        if #available(iOS 9, *) {
            if WCSession.isSupported() {
                session = WCSession.defaultSession()
            }
        }
        
        // Copy database to documents directory
        Utilities.copyDataBaseToDocumentsDirectory()
        
        // Cutomize the navigation bar & tab bar
        Utilities.makeNavigationBarTransparent()
        Utilities.makeTabBarTransparent()
        Utilities.updateLoader()
        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

/*************************************************************/
// MARK: Watch WCSessionDelegate
/*************************************************************/
@available(iOS 9.0, *)
extension AppDelegate: WCSessionDelegate {
    
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        
        // The array that will be sent to the watch for displaying
        var arrData = Array<Dictionary<String,AnyObject>>()
        
        // Create a loop
        for item in DBService.sharedInstance.getAllCities() {
            
            // Call the service one after another
            WeatherService.sharedInstance.getWeatherUpdatesForCity(item, onCompletion: { (data, error) in
                
                if error == nil {
                    // Parse the response and create the model
                    let model = CurrentWeather.init(json: data)
                    let upcomingWeather = UpcomingWeather.init(json: data)
                    let hourlyForecast = upcomingWeather.nextWeekForecast?.first?.hourlyForecast
                    
                    // Now time to add the dictioanry
                    var dict = Dictionary<String, AnyObject>()
                    
                    dict[Constants.WatchKeys.KEY_NAME] = model.city
                    dict[Constants.WatchKeys.KEY_MAXMIN_TEMP] = self.getFormattedMaxMinValue(upcomingWeather)
                    dict[Constants.WatchKeys.KEY_HUMIDITY] = (hourlyForecast?[Utilities.getIndexForCurrentTime()].humidityPercentage)! + Constants.Strings.PERCENTAGE
                    dict[Constants.WatchKeys.KEY_TEMPERATURE] = (model.temperature_In_C)! + Constants.Strings.DEGREE
                    dict[Constants.WatchKeys.KEY_IMAGE] = UIImagePNGRepresentation(UIImage(named: model.weatherImageName!)!)
                    
                    arrData.append(dict)
                }
                // Added the below portion since we have to wait for all the service calls to end
                if(arrData.count == DBService.sharedInstance.getAllCities().count) {
                    dispatch_async(dispatch_get_main_queue()) {
                        replyHandler([Constants.WatchKeys.KEY_CITIES: arrData])
                    }
                }
            })
        }
    }
    
    /**
     Method to get te formatted minimum and maximum value.
     - parameter upcomingWeather: The upcoming weather that was parsed from the server
     - returns: The formatted value (Max / Min), e.g. 30°C/23°C
     */
    func getFormattedMaxMinValue(upcomingWeather: UpcomingWeather) -> String {
        let weekForecast = upcomingWeather.nextWeekForecast!
        return weekForecast[0].maximumTemperature_In_C! + Constants.Strings.DEGREE + "/"  + weekForecast[0].minimumTemperature_In_C! + Constants.Strings.DEGREE
        
    }
}
