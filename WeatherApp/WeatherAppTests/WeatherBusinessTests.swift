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
        clearUserDefault()
        
        let weatherRespone = WeatherResponse()
        weatherRespone.city = "London1"
        WeatherBusiness.saveSearchHistory(weatherResponse: weatherRespone)
        
        // get
        let savedWeathers = WeatherBusiness.getSearchHistories()
        XCTAssert(savedWeathers.count == 1, "Save 1 items to UserDefault")
        
        // save 2nd items
        weatherRespone.city = "London2"
        WeatherBusiness.saveSearchHistory(weatherResponse: weatherRespone)
        XCTAssert(WeatherBusiness.getSearchHistories().count == 2, "Save 2 items to UserDefault")
    }
    
    func testSaveMaxHistories() {
        clearUserDefault()
        
        let weatherRespone = WeatherResponse()
        for i in 1...maxHistoryNumber {
            weatherRespone.city = "London \(i)"
            WeatherBusiness.saveSearchHistory(weatherResponse: weatherRespone)
            XCTAssert(WeatherBusiness.getSearchHistories().count == i, "Save \(i) items to UserDefault")
        }
        XCTAssert(WeatherBusiness.getSearchHistories().count == maxHistoryNumber, "Save \(maxHistoryNumber) items to UserDefault")
    }
    
    func testSaveOverMaxHistories() {
        clearUserDefault()
        
        let weatherRespone = WeatherResponse()
        for i in 1...(maxHistoryNumber + 8) {
            weatherRespone.city = "London \(i)"
            WeatherBusiness.saveSearchHistory(weatherResponse: weatherRespone)
        }
        XCTAssert(WeatherBusiness.getSearchHistories().count == maxHistoryNumber, "Save \(maxHistoryNumber) items to UserDefault")
    }
    
    private func clearUserDefault() {
        if let bundle = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundle)
        }
    }
    
    func testGetSearchHistories() {
        clearUserDefault()
        XCTAssert(WeatherBusiness.getSearchHistories().count == 0, "No items to UserDefault")

        // save
        let weatherRespone = WeatherResponse()
        weatherRespone.city = "London"
        WeatherBusiness.saveSearchHistory(weatherResponse: weatherRespone)
        
        // get
        let savedWeathers = WeatherBusiness.getSearchHistories()
        XCTAssert(savedWeathers.count == 1, "Save 1 items to UserDefault")        
    }
    
    func testSearchWeather() {
        WeatherBusiness.searchWeather(query: "London") { (weatherResponse) in
            XCTAssert(weatherResponse.city == "London", "Search weather London")
        }
    }
    
}
