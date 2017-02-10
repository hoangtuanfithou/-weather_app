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
import SVProgressHUD
import CoreData
import ObjectMapper

protocol SearchWeatherDelegate: class {
    func searchWeatherSuccess(weatherResponse: WeatherResponse)
}

class ViewBusiness {
    
    weak var delegate: SearchWeatherDelegate?
    
    // MARK : Search weather
    func searchWeather(query: String) {
        
        let weatherRequest = WeatherRequest()
        weatherRequest.query = query
        
        SVProgressHUD.show()
        Alamofire.request(weatherUrl, method: .get, parameters: weatherRequest.toJSON()).responseObject { (response: DataResponse<WeatherResponse>) in
            SVProgressHUD.dismiss()
            if response.result.isSuccess && response.response?.statusCode == 200,
                let weather = response.result.value {
                self.delegate?.searchWeatherSuccess(weatherResponse: weather)
            }
        }
        
    }
    
    // MARK : Search history using user default
    func saveSearchHistory(weatherResponse: WeatherResponse) {
        switch dataUsing {
        case .CoreData:
            saveSearchHistoryCoreData(weatherResponse: weatherResponse)
        case .UserDefault:
            saveSearchHistoryUserDefault(weatherResponse: weatherResponse)
        default:
            break
        }
    }
    
    func getSearchHistories() -> [WeatherResponse] {
        switch dataUsing {
        case .CoreData:
            return getSearchHistoriesCoreData()
        case .UserDefault:
            return getSearchHistoriesCoreData()
        default:
            return []
        }
    }
    
    // MARK : Search history using user default
    private class SavedWeatherResponse: BaseModel {
        var weathers: [WeatherResponse]?
        override func mapping(map: Map) {
            weathers <- map["weathers"]
        }
    }

    private func getSearchHistoriesUserDefault() -> [WeatherResponse] {
        if let searchHistories = UserDefaults.standard.string(forKey: searchHistoryKey),
            let savedWeathers = Mapper<SavedWeatherResponse>().map(JSONString: searchHistories),
            let weathers = savedWeathers.weathers {
            return weathers
        }
        return []
    }
    
    private func saveSearchHistoryUserDefault(weatherResponse: WeatherResponse) {
        let userDefault = UserDefaults.standard
        if let searchHistories = userDefault.string(forKey: searchHistoryKey),
            let savedWeathers = Mapper<SavedWeatherResponse>().map(JSONString: searchHistories) {
            savedWeathers.weathers?.insert(weatherResponse, at: 0)
            
            userDefault.set(savedWeathers.toJSONString(), forKey: searchHistoryKey)
        } else {
            let savedWeathers = SavedWeatherResponse()
            savedWeathers.weathers = [weatherResponse]
            let weatherString = savedWeathers.toJSONString()
            userDefault.set(weatherString, forKey: searchHistoryKey)
        }
    }
    
    // MARK : Search history using Core Data
    private func getSearchHistoriesCoreData() -> [WeatherResponse] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Weather")
        let sortDescriptor = NSSortDescriptor(key: "createdDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchLimit = maxHistoryNumber
        do {
            let fetchedEntities = try mainContext.fetch(fetchRequest)
            if let weathers = fetchedEntities as? [WeatherResponse] {
                return weathers
            }
        } catch {
            return []
        }
        return []
    }

    private func saveSearchHistoryCoreData(weatherResponse: WeatherResponse) {
        mainContext.insert(weatherResponse)
        appDelegate.saveContext()
    }

    // MARK : Search history using Realm
}
