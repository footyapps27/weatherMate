//
//  DBServiceTests.swift
//  WeatherMate
//
//  Created by Samrat on 12/5/16.
//  Copyright © 2016 SMRT. All rights reserved.
//

import Foundation
import XCTest

class DBServiceTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        DBService.sharedInstance.deleteAllCities()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDBServiceSingleton() {
        // This should never give a nil instance
        XCTAssertNotNil(DBService.sharedInstance)
        
        // Should return the same reference
        XCTAssertTrue(DBService.sharedInstance === DBService.sharedInstance)
    }
    
    // Check the DBService
    func testDBServiceForInitialCount() {
        // Initialize the DB
        XCTAssertEqual(DBService.sharedInstance.getAllCities().count, 0)
    }
    
    func testDBServiceForAddingCity() {
        DBService.sharedInstance.addCity("London")
        XCTAssertEqual(DBService.sharedInstance.getAllCities().count, 1)
        DBService.sharedInstance.addCity("Singapore")
        XCTAssertEqual(DBService.sharedInstance.getAllCities().count, 2)
    }
    
    func testDBServiceForSameCityAddition() {
        // Add a city
        DBService.sharedInstance.addCity("London")
        XCTAssertEqual(DBService.sharedInstance.getAllCities().count, 1)
        // Add the same city
        DBService.sharedInstance.addCity("London")
        XCTAssertEqual(DBService.sharedInstance.getAllCities().count, 1)
        // Add a new city
        DBService.sharedInstance.addCity("Singapore")
        XCTAssertEqual(DBService.sharedInstance.getAllCities().count, 2)
    }
    
    func testDBServiceForCityDeletion() {
        // Add a city
        DBService.sharedInstance.addCity("London")
        XCTAssertEqual(DBService.sharedInstance.getAllCities().count, 1)
        // Add a new city
        DBService.sharedInstance.addCity("Singapore")
        XCTAssertEqual(DBService.sharedInstance.getAllCities().count, 2)
        
        DBService.sharedInstance.deleteCity("Singapore")
        XCTAssertEqual(DBService.sharedInstance.getAllCities().count, 1)
    }
    
    func testDBServiceForDeletionOfNonExistingCity() {
        // Add a city
        DBService.sharedInstance.addCity("London")
        XCTAssertEqual(DBService.sharedInstance.getAllCities().count, 1)
        // Add a new city
        DBService.sharedInstance.addCity("Singapore")
        XCTAssertEqual(DBService.sharedInstance.getAllCities().count, 2)
        
        DBService.sharedInstance.deleteCity("Kuala Lumpur")
        XCTAssertEqual(DBService.sharedInstance.getAllCities().count, 2)
    }
}
