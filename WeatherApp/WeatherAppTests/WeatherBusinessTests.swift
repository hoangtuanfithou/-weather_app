//
//  WeatherBusinessTest.swift
//  WeatherApp
//
//  Created by Nguyen Hoang Tuan on 2/13/17.
//  Copyright © 2017 NHT. All rights reserved.
//

import XCTest
import CoreData

@testable import WeatherApp

class WeatherBusinessTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSaveSearchHistory() {
        if let bundle = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundle)
        }
        let weatherRespone = WeatherResponse()
        weatherRespone.city = "London"
        WeatherBusiness.saveSearchHistory(weatherResponse: weatherRespone)
        
        // get
        let savedWeathers = WeatherBusiness.getSearchHistories()
        XCTAssert(savedWeathers.count == 1, "Save 1 items to UserDefault")
    }
    
}
