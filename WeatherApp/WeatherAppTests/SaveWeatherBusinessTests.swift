//
//  SaveWeatherBusinessTests.swift
//  WeatherApp
//
//  Created by Nguyen Hoang Tuan on 2/14/17.
//  Copyright © 2017 NHT. All rights reserved.
//

import XCTest

class SaveWeatherBusinessTests: XCTestCase {
    
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
        SaveWeatherBusiness.saveSearchHistory(weatherResponse: weatherRespone)
        
        // get
        let savedWeathers = SaveWeatherBusiness.getSearchHistories()
        XCTAssert(savedWeathers.count == 1, "Save 1 items to UserDefault")
        
        // save 2nd items
        weatherRespone.city = "London2"
        SaveWeatherBusiness.saveSearchHistory(weatherResponse: weatherRespone)
        XCTAssert(SaveWeatherBusiness.getSearchHistories().count == 2, "Save 2 items to UserDefault")
    }
    
    func testSaveMaxHistories() {
        clearUserDefault()
        
        let weatherRespone = WeatherResponse()
        for i in 1...maxHistoryNumber {
            weatherRespone.city = "London \(i)"
            SaveWeatherBusiness.saveSearchHistory(weatherResponse: weatherRespone)
            XCTAssert(SaveWeatherBusiness.getSearchHistories().count == i, "Save \(i) items to UserDefault")
        }
        XCTAssert(SaveWeatherBusiness.getSearchHistories().count == maxHistoryNumber, "Save \(maxHistoryNumber) items to UserDefault")
    }
    
    func testSaveOverMaxHistories() {
        clearUserDefault()
        
        let weatherRespone = WeatherResponse()
        for i in 1...(maxHistoryNumber + 8) {
            weatherRespone.city = "London \(i)"
            SaveWeatherBusiness.saveSearchHistory(weatherResponse: weatherRespone)
        }
        XCTAssert(SaveWeatherBusiness.getSearchHistories().count == maxHistoryNumber, "Save \(maxHistoryNumber) items to UserDefault")
        XCTAssertFalse(SaveWeatherBusiness.getSearchHistories().count > maxHistoryNumber)
    }
    
    private func clearUserDefault() {
        if let bundle = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundle)
        }
    }
    
    func testGetSearchHistories() {
        clearUserDefault()
        XCTAssert(SaveWeatherBusiness.getSearchHistories().count == 0, "No items to UserDefault")
        
        // save
        let weatherRespone = WeatherResponse()
        weatherRespone.city = "London"
        SaveWeatherBusiness.saveSearchHistory(weatherResponse: weatherRespone)
        
        // get
        let savedWeathers = SaveWeatherBusiness.getSearchHistories()
        XCTAssert(savedWeathers.count == 1, "Save 1 items to UserDefault")
    }

}
