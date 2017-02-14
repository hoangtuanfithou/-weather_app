//
//  SaveWeathersBusiness.swift
//  WeatherApp
//
//  Created by Nguyen Hoang Tuan on 2/14/17.
//  Copyright © 2017 NHT. All rights reserved.
//

import Foundation
import ObjectMapper

class SaveWeatherBusiness {
    
    // MARK : Search history using user default
    class func saveSearchHistory(weatherResponse: WeatherResponse) {
        let userDefault = UserDefaults.standard
        if let searchHistories = userDefault.string(forKey: searchHistoryKey),
            let savedWeathers = Mapper<SavedWeatherResponse>().map(JSONString: searchHistories),
            let weathers = savedWeathers.weathers {
            
            // remove duplicate
            var uniqueWeathers = weathers.filter({ (weather) -> Bool in
                return weather.city != weatherResponse.city
            })
            
            // insert
            uniqueWeathers.insert(weatherResponse, at: 0)
            
            let limitWeathers = Array(uniqueWeathers.prefix(maxHistoryNumber))
            
            // save
            savedWeathers.weathers = limitWeathers
            userDefault.set(savedWeathers.toJSONString(), forKey: searchHistoryKey)
        } else {
            let savedWeathers = SavedWeatherResponse()
            savedWeathers.weathers = [weatherResponse]
            let weatherString = savedWeathers.toJSONString()
            userDefault.set(weatherString, forKey: searchHistoryKey)
        }
    }
    
    class func getSearchHistories() -> [WeatherResponse] {
        if let searchHistories = UserDefaults.standard.string(forKey: searchHistoryKey),
            let savedWeathers = Mapper<SavedWeatherResponse>().map(JSONString: searchHistories),
            let weathers = savedWeathers.weathers {
            return weathers
        }
        return []
    }

}
