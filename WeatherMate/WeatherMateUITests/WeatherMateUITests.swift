//
//  WeatherMateUITests.swift
//  WeatherMateUITests
//
//  Created by Samrat on 12/5/16.
//  Copyright © 2016 SMRT. All rights reserved.
//

import XCTest

class WeatherMateUITests: XCTestCase {
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAddCity() {
        
        let app = XCUIApplication()
        app.staticTexts["Slide to continue"].swipeLeft()
        delay(4.0) {
            app.alerts["Allow “WeatherMate” to access your location while you use the app?"].collectionViews.buttons["Allow"].tap()
            app.alerts["Error"].collectionViews.buttons["OK"].tap()
            
            app.navigationBars["WeatherMate.CurrentWeatherView"].buttons["Item"].tap()
            
            app.buttons["Plus"].tap()
            
            let app2 = app
            app2.keys["s"].tap()
            
            let collectionViewsQuery = app.alerts["Add new city"].collectionViews
            collectionViewsQuery.textFields["Add city name"]
            app2.keys["i"].tap()
            collectionViewsQuery.textFields["Add city name"]
            app2.keys["n"].tap()
            collectionViewsQuery.textFields["Add city name"]
            app2.keys["g"].tap()
            collectionViewsQuery.textFields["Add city name"]
            app2.keys["a"].tap()
            collectionViewsQuery.textFields["Add city name"]
            app2.keys["p"].tap()
            collectionViewsQuery.textFields["Add city name"]
            app2.keys["o"].tap()
            collectionViewsQuery.textFields["Add city name"]
            app2.keys["r"].tap()
            collectionViewsQuery.textFields["Add city name"]
            app2.keys["e"].tap()
            collectionViewsQuery.textFields["Add city name"]
            collectionViewsQuery.buttons["OK"].tap()
            
            app.staticTexts.elementMatchingType(.Any, identifier: "Result").tap()
            
            //XCTAssert(app.staticTexts.exis)
            //app.staticTexts["30°C"].tap()
        }
        
        
    }
    
    func testAddNewCity() {
        
        let app = XCUIApplication()
        app.staticTexts["Slide to continue"].swipeLeft()
        
        delay(5.0) {
            app.navigationBars["WeatherMate.CurrentWeatherView"].buttons["Item"].tap()
            app.buttons["Plus"].tap()
            
            let app2 = app
            app2.keys["l"].tap()
            
            let collectionViewsQuery = app.alerts["Add new city"].collectionViews
            collectionViewsQuery.textFields["Add city name"]
            
            let oKey = app2.keys["o"]
            oKey.tap()
            collectionViewsQuery.textFields["Add city name"]
            
            let nKey = app2.keys["n"]
            nKey.tap()
            collectionViewsQuery.textFields["Add city name"]
            app2.keys["d"].tap()
            collectionViewsQuery.textFields["Add city name"]
            oKey.tap()
            collectionViewsQuery.textFields["Add city name"]
            nKey.tap()
            collectionViewsQuery.textFields["Add city name"]
            
            let okButton = collectionViewsQuery.buttons["OK"]
            okButton.tap()
            //okButton.tap()
            app.staticTexts["London"].tap()
        }
    }
    
}
