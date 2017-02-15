//
//  SearchWeatherBusiness.swift
//  WeatherApp
//
//  Created by Nguyen Hoang Tuan on 2/9/17.
//  Copyright © 2017 NHT. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper
import SVProgressHUD
import CoreData

class SearchWeatherBusiness {
        
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
    
}
