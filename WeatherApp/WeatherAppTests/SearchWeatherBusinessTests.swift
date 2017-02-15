//
//  SearchWeatherBusinessTest.swift
//  WeatherApp
//
//  Created by Nguyen Hoang Tuan on 2/13/17.
//  Copyright © 2017 NHT. All rights reserved.
//

import XCTest
import CoreData

@testable import WeatherApp

class SearchWeatherBusinessTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSearchValidWeather() {
        let searchExpectation = expectation(description: "server return")
        SearchWeatherBusiness.searchWeather(query: "London") { (weatherResponse) in
            if weatherResponse.city != nil {
                XCTAssert(weatherResponse.city == "London", "Search weather London")
            }
            searchExpectation.fulfill()
        }
        waitForExpectations(timeout: 60) { (error) in
        }
    }
    
    func testSearchNotValidWeather() {
        let searchExpectation = expectation(description: "server return")
        SearchWeatherBusiness.searchWeather(query: "123") { (weatherResponse) in
            XCTAssert(weatherResponse.city == nil, "No valid city")
            searchExpectation.fulfill()
        }
        waitForExpectations(timeout: 60) { (error) in
        }
    }
    
}
