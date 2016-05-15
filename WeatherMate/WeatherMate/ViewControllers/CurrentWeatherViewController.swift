//
//  CurrentWeatherViewController.swift
//  WeatherMate
//
//  Created by Samrat on 18/4/16.
//  Copyright © 2016 SMRT. All rights reserved.
//
/*************************************************************/
// MARK: Imported Classes
/*************************************************************/
import UIKit
import Foundation
import CoreLocation
import ICLoader
import PureLayout
import Social
import QuartzCore
import SwiftyJSON

class CurrentWeatherViewController: BaseViewController {
    
    /*************************************************************/
    // MARK: Instance Variables
    /*************************************************************/
    
    /// The location manager for getting the user's current location
    private let locationManager = CLLocationManager()
    
    /// The label with the current city's name
    @IBOutlet weak var lblCity : UILabel!
    
    /// The description & real feel e.g Partly Cloudy. Real Feel 42
    @IBOutlet weak var lblDescriptionAndRealFeel : UILabel!
    
    /// The actual temperature
    @IBOutlet weak var lblTemperature : UILabel!
    
    /// Time when the values were last updated
    @IBOutlet weak var lblLastUpdated : UILabel!
    
    /// The temperature icon.
    @IBOutlet weak var imgVwTemperatureIcon : UIImageView!
    
    /// The temperature icon.
    @IBOutlet weak var imgVwTemperatureBackground : UIImageView!
    
    /// The temperature icon.
    @IBOutlet weak var btnFacebook : UIButton!
    
    /// The temperature icon.
    @IBOutlet weak var btnTwitter : UIButton!
    
    /// The forecast for the next hour
    @IBOutlet weak var vwFirstHour : UIView!
    
    /// The forecast for the second hour
    @IBOutlet weak var vwSecondHour : UIView!
    
    // Model for current weather
    var modelCurrentWeather : CurrentWeather?
    
    /*************************************************************/
    // MARK: View Lifecycle
    /*************************************************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CurrentWeatherViewController.refreshViewForSelectedCity(_:)), name:"CitySelected", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CurrentWeatherViewController.refreshViewForNewCity(_:)), name:"NewCityAdded", object: nil)
        
        // Round the corners
        btnFacebook.layer.cornerRadius = 17
        btnFacebook.clipsToBounds = true
        
        btnTwitter.layer.cornerRadius = 17
        btnTwitter.clipsToBounds = true
        
        // Hide all the elements. This will be shown when the location is retrieved.
        hideAllUIElements()
        
        // Request for location
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    /*************************************************************/
    // MARK: Actions
    /*************************************************************/
    @IBAction func shareInFacebook() {
        
        // Create the request
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
            let facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            facebookSheet.setInitialText("WeatherMate: Share on Facebook")
            
            //get screenshot of screen
            if let image = getScreenShot() {
                facebookSheet.addImage((image))
            }
            
            // Present the controller
            self.presentViewController(facebookSheet, animated: true, completion: nil)
            
        } else {
            Utilities.showOkAlert("Error", message: "Please login to your Facebook account to share.", controller: self)
        }
    }
    
    @IBAction func shareInTwitter() {
     
        // Create the request
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter){
            let twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            twitterSheet.setInitialText("WeatherMate: Share on Twitter")
            
            if let image = getScreenShot() {
                twitterSheet.addImage((image))
            }
            // Present the controller
            self.presentViewController(twitterSheet, animated: true, completion: nil)
            
        } else {
            Utilities.showOkAlert("Error", message: "Please login to your Twitter account to share.", controller: self)
        }
    }
    
    /*************************************************************/
    // MARK: Helper Methods
    /*************************************************************/
    
    /**
     Call the backend to get the updated values
     */
    private func callWeatherService() {
        
        // Call the servce to get the updated values
        if let currentCity = Singleton.sharedInstance.currentCity {
            
            // Add the city to dB
            DBService.sharedInstance.addCity(currentCity)
            
            // Call the service
            WeatherService.sharedInstance.getWeatherUpdatesForCity(currentCity, onCompletion: { (data, error) in
                
                if(error == nil) {
                    
                    // Dismiss the loader
                    ICLoader.dismiss()
                    
                    // Create the model for the current screen
                    self.modelCurrentWeather = CurrentWeather.init(json: data)
                    
                    // Store the response for the next screens
                    Singleton.sharedInstance.currentCityResponse = data
                    
                    // Update the UI in the main thread
                    dispatch_async(dispatch_get_main_queue()) {
                        self.displayUIElements()
                    }
                } else {
                    Utilities.showOkAlert("Error", message: "Something went wrong. Please try again.", controller: self)
                }
            })
        }
    }
    
    /**
     Hides all the labels & imageviews(apart from background view).
     */
    private func hideAllUIElements() {
        lblCity.text = Constants.Strings.STR_EMPTY
        lblTemperature.text = Constants.Strings.STR_EMPTY
        lblLastUpdated.text = Constants.Strings.STR_EMPTY
        lblDescriptionAndRealFeel.text = Constants.Strings.STR_EMPTY
        imgVwTemperatureIcon.hidden = true
        imgVwTemperatureBackground.hidden = true
        vwFirstHour.hidden = true
        vwSecondHour.hidden = true
        btnFacebook.hidden = true
        btnTwitter.hidden = true
    }
    
    /**
     Displays the various UI elements with their updated values
     */
    private func displayUIElements() {
        lblCity.text = modelCurrentWeather?.city
        lblTemperature.text = (modelCurrentWeather?.temperature_In_C)! + Constants.Strings.DEGREE
        lblLastUpdated.text = Constants.Strings.STR_EMPTY
        lblDescriptionAndRealFeel.text = getFormattedDescriptionAndRealFeelValue()
        imgVwTemperatureIcon.image = UIImage.init(named: (modelCurrentWeather?.weatherImageName)!)
        imgVwTemperatureIcon.hidden = false
        imgVwTemperatureBackground.hidden = false
        vwFirstHour.hidden = false
        vwSecondHour.hidden = false
        btnFacebook.hidden = false
        btnTwitter.hidden = false
        addUpcomingForecastViews()
        
    }
    
    /**
     Method to get the formatted description string that will be displayed
     - returns: The formatted description string with "description" & "real feel"
     */
    private func getFormattedDescriptionAndRealFeelValue() -> String {
        return (modelCurrentWeather?.description)! + ". " + "Real Feel: " + (modelCurrentWeather?.realFeel_In_C)! + Constants.Strings.DEGREE
    }
    
    /**
     Method to add the upcoming forecast views.
     */
    private func addUpcomingForecastViews() {
        let upcomingWeather = UpcomingWeather.init(json: Singleton.sharedInstance.currentCityResponse!)
        let hourlyForecast = upcomingWeather.nextWeekForecast?.first?.hourlyForecast
        
        // TODO: The vw should not be hidden, rather it should have details of next day
        if(Utilities.getIndexForCurrentTime() + 2 <= 23) {
            // Add the first hour view first
            var hourVw = CurrentWeatherForecastView.view()
            hourVw.updateView((hourlyForecast?[Utilities.getIndexForCurrentTime() + 1])!)
            vwFirstHour.addSubview(hourVw)
            hourVw.autoPinEdgesToSuperviewEdges()
            
            // Now add the second hour
            hourVw = CurrentWeatherForecastView.view()
            hourVw.updateView((hourlyForecast?[Utilities.getIndexForCurrentTime() + 2])!)
            vwSecondHour.addSubview(hourVw)
            hourVw.autoPinEdgesToSuperviewEdges()
        }else {
            vwFirstHour.hidden = true
            vwSecondHour.hidden = true
        }
        
    }
    
    /**
     Selector for updating the current view
     - parameter notification: The notification object
     */
    dynamic private func refreshViewForSelectedCity(notification: NSNotification) {
        ICLoader.present()
        self.slideMenuController()?.closeLeft()
        Singleton.sharedInstance.currentCity = notification.object as? String
        callWeatherService()
    }
    
    /**
     Selector for updating the current view
     - parameter notification: The notification object
     */
    dynamic private func refreshViewForNewCity(notification: NSNotification) {
        ICLoader.present()
        self.slideMenuController()?.closeLeft()
        
        self.modelCurrentWeather = CurrentWeather.init(json: Singleton.sharedInstance.currentCityResponse!)
        // Update the UI in the main thread
        dispatch_async(dispatch_get_main_queue()) {
            self.displayUIElements()
        }
    }
    
    /**
     Method to get the screenshot of the current screen
     - returns: If the window allows then the current image, else nil.
     */
    private func getScreenShot() -> UIImage? {
        if let window = UIApplication.sharedApplication().keyWindow {
            UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0);
            window.drawViewHierarchyInRect(window.bounds, afterScreenUpdates: false)
            let image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            return image
        }else {
            return nil
        }
    }
}

/*************************************************************/
// MARK: Extension - CLLocationManagerDelegate
/*************************************************************/
extension CurrentWeatherViewController : CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        // Check if the user has allowed the location usage permission
        if status == .AuthorizedWhenInUse || status == .AuthorizedAlways {
            // Display the loader
            ICLoader.present()
            
            if #available(iOS 9.0, *) {
                locationManager.requestLocation()
            } else {
                // Fallback on earlier versions
                locationManager.startUpdatingLocation()
            }
        } else if (status == .Denied) {
            
            if (DBService.sharedInstance.getAllCities().count > 0) {
                ICLoader.present()
                Singleton.sharedInstance.currentCity = DBService.sharedInstance.getAllCities().first
                callWeatherService()
            } else {
                ICLoader.dismiss()
                Utilities.showOkAlert("Error", message: "Kindly add a location using the left menu to proceed.", controller: self)
            }
            
        }
        else {
            
            if (DBService.sharedInstance.getAllCities().count > 0) {
                ICLoader.present()
                Singleton.sharedInstance.currentCity = DBService.sharedInstance.getAllCities().first
                callWeatherService()
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            // Get the city from the location
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) in
                
                if (error != nil)
                {
                    //Utilities.showOkAlert("Error", message: "Unabale to determine current location", controller: self)
                    return
                }
                else
                {
                    if placemarks!.count > 0
                    {
                        // Retrieve the current city from the placemarks
                        let arrPlacemarks: NSArray = placemarks!
                        let placeMark = arrPlacemarks.firstObject as! CLPlacemark
                        
                        // Save the city
                        if let city = placeMark.addressDictionary?[Constants.Strings.KEY_CITY] as? String{
                            Singleton.sharedInstance.currentCity = city
                        }
                        
                        // Important to stop updating further. Drains the battery if not stopped.
                        self.locationManager.stopUpdatingLocation()
                        
                        // Call the service
                        self.callWeatherService()
                    } else
                    {
                        Utilities.showOkAlert("Error", message: "Could not retrieve current location", controller: self)
                    }
                }
            })
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        self.locationManager.stopUpdatingLocation()
        if (DBService.sharedInstance.getAllCities().count > 0) {
            Singleton.sharedInstance.currentCity = DBService.sharedInstance.getAllCities().first
            callWeatherService()
        }else {
            ICLoader.dismiss()
            Utilities.showOkAlert("Error", message: "Unable to determine current location. Kindly add a city using the left menu.", controller: self)
        }
    }
}