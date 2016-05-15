//
//  Singleton.swift
//  WeatherMate
//
//  Created by Samrat on 5/5/16.
//  Copyright © 2016 SMRT. All rights reserved.
//

/*************************************************************/
// MARK: Imported Classes
/*************************************************************/

import Foundation
import SwiftyJSON

public class Singleton {
    
    /*************************************************************/
    // MARK: Singleton
    /*************************************************************/
    public static let sharedInstance = Singleton()
    
    /*************************************************************/
    // MARK: Instance Variables
    /*************************************************************/
    
     /// The current city that is being displayed
    public var currentCity : String?
    
     /// The last response that was received from the server for the current city
    public var currentCityResponse: JSON?
}