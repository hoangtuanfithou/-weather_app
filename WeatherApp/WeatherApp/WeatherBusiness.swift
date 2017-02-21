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
import RealmSwift
import CloudKit

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
        switch dataUsing {
        case .CloudKit:
            saveSearchHistoryCloudKit(weatherResponse: weatherResponse)
        case .Realm:
            saveSearchHistoryRealm(weatherResponse: weatherResponse)
        case .CoreData:
            saveSearchHistoryCoreData(weatherResponse: weatherResponse)
        case .UserDefault:
            saveSearchHistoryUserDefault(weatherResponse: weatherResponse)
        default:
            break
        }
    }
    
    class func getSearchHistories(callBack: CmCallback? = nil) -> [WeatherResponse] {
        switch dataUsing {
        case .CloudKit:
            return getSearchHistoriesCloudKit(callBack)
        case .Realm:
            return getSearchHistoriesRealm()
        case .CoreData:
            return getSearchHistoriesCoreData()
        case .UserDefault:
            return getSearchHistoriesUserDefault()
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

    private class func getSearchHistoriesUserDefault() -> [WeatherResponse] {
        if let searchHistories = UserDefaults.standard.string(forKey: searchHistoryKey),
            let savedWeathers = Mapper<SavedWeatherResponse>().map(JSONString: searchHistories),
            let weathers = savedWeathers.weathers {
            return weathers
        }
        return []
    }
    
    private class func saveSearchHistoryUserDefault(weatherResponse: WeatherResponse) {
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
    
    // MARK : Search history using Core Data
    private class func getSearchHistoriesCoreData() -> [WeatherResponse] {
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

    private class func saveSearchHistoryCoreData(weatherResponse: WeatherResponse) {        
//        mainContext.insert(weatherResponse)
        appDelegate.saveContext()
    }
    
    // MARK : Search history using Realm
    private class func saveSearchHistoryRealm(weatherResponse: WeatherResponse) {
        let realm = try! Realm() // swiftlint:disable:this force_try
        try! realm.write() { // swiftlint:disable:this force_try
            weatherResponse.createdDate = Date()
            realm.add(weatherResponse)
        }
    }
    
    private class func getSearchHistoriesRealm() -> [WeatherResponse] {
        let realm = try! Realm() // swiftlint:disable:this force_try
        let weathers = realm.objects(WeatherResponse.self).sorted(byKeyPath: "createdDate", ascending: false)
        return Array(weathers)
    }

    // MARK : Search history using CloudKit
    private class func saveSearchHistoryCloudKit(weatherResponse: WeatherResponse) {
        CKContainer.default().accountStatus { accountStatus, error in
            if accountStatus == .noAccount {
                let alert = UIAlertController(title: "Sign in to iCloud", message: "Sign in to your iCloud account to write records. On the Home screen, launch Settings, tap iCloud, and enter your Apple ID. Turn iCloud Drive on. If you don't have an iCloud account, tap Create a new Apple ID.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                appDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
            } else {
                doSaveToCloudKit(weatherResponse: weatherResponse)
            }
        }
    }
    
    private class func getSearchHistoriesCloudKit(_ callBack: CmCallback? = nil) -> [WeatherResponse] {
        let query = CKQuery(recordType: "Weather", predicate: NSPredicate(value: true))
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let records = records {
                var weathers = [WeatherResponse]()
                for record in records {
                    let weather = WeatherResponse()
                    weather.city = record["city"] as? String
                    weather.weatherIconUrl = record["weatherIconUrl"] as? String
                    weather.observationTime = record["observationTime"] as? String
                    weather.humidity = record["humidity"] as? String
                    weather.weatherDescription = record["weatherDescription"] as? String
                    weathers.append(weather)
                }
                callBack?(true, weathers)
            }
        }
        return []
    }
    
    private class func doSaveToCloudKit(weatherResponse: WeatherResponse) {
        // Code if user has account here...
        let recordId = CKRecordID(recordName: Date().description)
        let record = CKRecord(recordType: "Weather", recordID: recordId)
        record["city"] = weatherResponse.city as CKRecordValue?
        record["weatherIconUrl"] = weatherResponse.weatherIconUrl as CKRecordValue?
        record["observationTime"] = weatherResponse.observationTime as CKRecordValue?
        record["humidity"] = weatherResponse.humidity as CKRecordValue?
        record["weatherDescription"] = weatherResponse.weatherDescription as CKRecordValue?
        record["createdDate"] = Date() as CKRecordValue?
        
        let container = CKContainer.default()
        let privateDatabase = container.privateCloudDatabase
        privateDatabase.save(record) { (record, error) in
            if let error = error {
                debugPrint(error.localizedDescription + "insert error")
            }
        }
    }
    
}
