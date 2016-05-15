//
//  CityController.swift
//  WeatherMate
//
//  Created by Samrat on 11/5/16.
//  Copyright © 2016 SMRT. All rights reserved.
//

import Foundation
import WatchKit

class CityController : WKInterfaceController {
    
    /*************************************************************/
    // MARK: Instance Variables
    /*************************************************************/
    
    /// The temperature label
    @IBOutlet weak var lblTemperature: WKInterfaceLabel!
    
    /// The city label
    @IBOutlet weak var lblCity: WKInterfaceLabel!
    
    /// The max & min label
    @IBOutlet weak var lblMaxMinTemperature: WKInterfaceLabel!
    
    /// The max & min label
    @IBOutlet weak var lblHumidity: WKInterfaceLabel!
    
    /// The image for temperature
    @IBOutlet weak var imgTemperature: WKInterfaceImage!
    
    private var dict : Dictionary<String, AnyObject>?
    
    /*************************************************************/
    // MARK: View Lifecycle
    /*************************************************************/
    
    override func awakeWithContext(context: AnyObject?) {
        // Cast the dictionary as a context
        dict = context as? Dictionary<String, AnyObject>
        // Now update the UI
        lblCity.setText(dict![Constants.WatchKeys.KEY_NAME]! as? String)
        lblTemperature.setText(dict![Constants.WatchKeys.KEY_TEMPERATURE]! as? String)
        lblMaxMinTemperature.setText(dict![Constants.WatchKeys.KEY_MAXMIN_TEMP]! as? String)
        lblHumidity.setText(dict![Constants.WatchKeys.KEY_HUMIDITY]! as? String)
        let data = dict![Constants.WatchKeys.KEY_IMAGE] as! NSData
        imgTemperature.setImage(UIImage.init(data: data))
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
}
