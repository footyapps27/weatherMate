//
//  DBService.swift
//  WeatherMate
//
//  Created by Samrat on 11/5/16.
//  Copyright © 2016 SMRT. All rights reserved.
//

import Foundation
import SQLite

class DBService {
    
    /*************************************************************/
    // MARK: Instance variables
    /*************************************************************/
    
    /// Location where the dB will be copied
    let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0])
    
    /*************************************************************/
    // MARK: Singleton
    /*************************************************************/
    
    /// Singleton instance for accessing the DBService
    static let sharedInstance = DBService()
    
    
    /*************************************************************/
    // MARK: Public Methods
    /*************************************************************/
    /**
     Add a city to the favorites. This will check if the city already exists.
     - parameter cityName: The city that will be added to the favorites
     */
    func addCity(cityName: String) {
        
        // Check if the city already exists
        if !getAllCities().contains(cityName) {
            do {
                let db = try Connection(documentsPath.absoluteString + "weatherMate_dB.db")
                let cities = Table("City")
                let name = Expression<String?>("NAME")
                let insert = cities.insert(name <- cityName)
                try db.run(insert)
            }catch {
                
            }
        }
    }
    
    /**
     Delete a city from the database. Checks if the city is present in dB or not.
     - parameter cityName: The city name that needs to be deleted.
     */
    func deleteCity(cityName: String) {

        // Check if the city already exists
        if getAllCities().contains(cityName) {
            do {
                let db = try Connection(documentsPath.absoluteString + "weatherMate_dB.db")
                let cities = Table("City")
                let name = Expression<String?>("NAME")
                let city = cities.filter(name == cityName)
                try db.run(city.delete())
            }catch {
                
            }
        }
    }
    
    /**
     Get all the cities that are currently present in the dB
     - returns: The array containing the city names
     */
    func getAllCities() -> Array<String> {
        // Initialize the array
        var arrCities = Array<String>()
        
        do {
            let db = try Connection(documentsPath.absoluteString + "weatherMate_dB.db")
            let cities = Table("City")
            let name = Expression<String?>("NAME")
            
            for city in try db.prepare(cities) {
                arrCities.append(city[name]!)
            }
        }catch {
            
        }
        return arrCities
    }
    
    func deleteAllCities() {
        do {
            let db = try Connection(documentsPath.absoluteString + "weatherMate_dB.db")
            let cities = Table("City")
            try db.run(cities.delete())
        }catch {
            
        }
    }
    /*************************************************************/
    // MARK: Private Methods
    /*************************************************************/
    /**
     Get the path for the documents directory
     - returns: The documents directory path as a string
     */
    private func getDocumentDirectoryPath() -> String {
        let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0])
        return documentsPath.absoluteString
    }
}