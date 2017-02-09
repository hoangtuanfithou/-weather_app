//
//  ViewBusiness.swift
//  WeatherApp
//
//  Created by Nguyen Hoang Tuan on 2/9/17.
//  Copyright © 2017 NHT. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

protocol SearchWeatherDelegate: class {
    func searchWeatherSuccess(weatherResponse: WeatherResponse)
}

class ViewBusiness {
    
//    weak var viewController: ViewController?
    weak var delegate: SearchWeatherDelegate?
    
    // MARK : Search weather
    func searchWeather(query: String) {
        
        let weatherRequest = WeatherRequest()
        weatherRequest.query = query
        
        Alamofire.request(weatherUrl, method: .get, parameters: weatherRequest.toJSON()).responseObject { (response: DataResponse<WeatherResponse>) in
            
            if response.result.isSuccess && response.response?.statusCode == 200,
                let weather = response.result.value {
                print(weather)
                self.delegate?.searchWeatherSuccess(weatherResponse: weather)
            } else if response.result.error?._code == NSURLErrorNotConnectedToInternet {
                
            }
            
        }
        
    }
    
    // MARK : Search history
    func saveSearchHistory(query: String) {
        let userDefault = UserDefaults.standard
        
        if var searchHistories = userDefault.array(forKey: searchHistoryKey) {
            searchHistories.insert(query, at: 0)
            userDefault.set(searchHistories, forKey: searchHistoryKey)
        } else {
            userDefault.set([query], forKey: searchHistoryKey)
        }
        
    }
    
    func getSearchHistories() -> [String] {
        if let searchHistories = UserDefaults.standard.array(forKey: searchHistoryKey) as? [String] {
            let unique = Array(Set(searchHistories))
            return unique
        }
        return []
    }
    
}
