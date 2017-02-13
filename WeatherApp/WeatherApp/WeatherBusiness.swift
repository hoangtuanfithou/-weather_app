//
//  WeatherBusiness.swift
//  WeatherApp
//
//  Created by Nguyen Hoang Tuan on 2/9/17.
//  Copyright © 2017 NHT. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import SVProgressHUD
import CoreData
import ObjectMapper

class WeatherBusiness {
        
    // MARK : Search weather
    class func searchWeather(query: String, callBack: @escaping (WeatherResponse) -> Void) {
        let weatherRequest = WeatherRequest()
        weatherRequest.query = query
        
        SVProgressHUD.show()
        Alamofire.request(weatherUrl, method: .get, parameters: weatherRequest.toJSON()).responseObject { (response: DataResponse<WeatherResponse>) in
            SVProgressHUD.dismiss()
            if response.result.isSuccess && response.response?.statusCode == 200,
                let weather = response.result.value {
                callBack(weather)
            }
        }
    }
    
    // MARK : Search history using user default
    class func saveSearchHistory(weatherResponse: WeatherResponse) {
        let userDefault = UserDefaults.standard
        if let searchHistories = userDefault.string(forKey: searchHistoryKey),
            let savedWeathers = Mapper<SavedWeatherResponse>().map(JSONString: searchHistories) {
            savedWeathers.weathers?.insert(weatherResponse, at: 0)
            if savedWeathers.weathers?.count ?? 0 > maxHistoryNumber {
                savedWeathers.weathers?.removeLast()
            }
            
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
