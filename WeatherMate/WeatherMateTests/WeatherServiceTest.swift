//
//  WeatherServiceTest.swift
//  WeatherMate
//
//  Created by Samrat on 12/5/16.
//  Copyright © 2016 SMRT. All rights reserved.
//

import Foundation
import XCTest
import SwiftyJSON
@testable import WeatherMate

class WeatherServiceTest : XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testWeatherServiceSingleton() {
        // This should never give a nil instance
        XCTAssertNotNil(DBService.sharedInstance)
        
        // Should return the same reference
        XCTAssertTrue(DBService.sharedInstance === DBService.sharedInstance)
    }
    
    func testEmptyCityName() {
        let expectation = expectationWithDescription("Swift Expectations")
        
        WeatherService.sharedInstance.getWeatherUpdatesForCity("") { (data, error) in
            
            XCTAssertTrue(data["data"]["error"].exists())
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(5.0, handler:nil)
    }
    
    func testCorrectCityName() {
        let expectation = expectationWithDescription("Swift Expectations")
        
        WeatherService.sharedInstance.getWeatherUpdatesForCity("Singapore") { (data, error) in
            
            XCTAssertFalse(data["data"]["error"].exists())
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(5.0, handler:nil)
    }
    
}