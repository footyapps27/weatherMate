//
//  LeftMenuViewController.swift
//  WeatherMate
//
//  Created by Samrat on 7/5/16.
//  Copyright © 2016 SMRT. All rights reserved.
//

import Foundation
import UIKit
import ICLoader
import SwiftyJSON

class LeftMenuViewController : UIViewController{
    
    var arrCities : Array<String>?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        arrCities = DBService.sharedInstance.getAllCities()
        tableView.reloadData()
    }
    
    /*************************************************************/
    // MARK: Actions
    /*************************************************************/
    @IBAction func addNewCity() {
        // Show the input screen here
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Add new city", message: "Enter the city name", preferredStyle: .Alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.placeholder = "Add city name"
        })
        
        //3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            
            ICLoader.present()
            // Call the service
            WeatherService.sharedInstance.getWeatherUpdatesForCity(textField.text!, onCompletion: { (data, error) in
                
                if(error == nil) {
                    if(data["data"]["error"].exists()) {
                        
                        Utilities.showOkAlert("Error", message: "Invalid city name", controller: self)
                    }else {
                        
                        Singleton.sharedInstance.currentCity = textField.text!
                        Singleton.sharedInstance.currentCityResponse = data
                        DBService.sharedInstance.addCity(textField.text!)
                        
                        // Save the data in Singleton
                        self.tableView.reloadData()
                        // Update the existing view using notification
                        NSNotificationCenter.defaultCenter().postNotificationName("NewCityAdded", object: nil)
                    }
                    // Dismiss the loader
                    ICLoader.dismiss()
                }else {
                    Utilities.showOkAlert("Error", message: "Something went wrong. Please try again.", controller: self)
                }
            })
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action) -> Void in
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    /**
     Method to delete a city present in the table
     - parameter button: The button that was tapped.
     */
    func deleteCity(button: UIButton) {
        let cityName = arrCities![button.tag]
        DBService.sharedInstance.deleteCity(cityName)
        arrCities = DBService.sharedInstance.getAllCities()
        tableView.reloadData()
    }
}

/*************************************************************/
// MARK: Extension For TableView
/*************************************************************/
extension LeftMenuViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCities!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LeftMenuCell", forIndexPath: indexPath) as? LeftMenuCell
        
        cell?.btnDelete.tag = indexPath.row
        
        cell?.btnDelete.addTarget(self, action: #selector(LeftMenuViewController.deleteCity(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        cell?.lblCityName!.text = arrCities![indexPath.row]
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        // Throw the notification here
        NSNotificationCenter.defaultCenter().postNotificationName("CitySelected", object: arrCities![indexPath.row])
    }
}