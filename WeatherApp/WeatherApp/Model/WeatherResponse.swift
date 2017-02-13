//
//  WeatherResponse.swift
//
//  Create on 8/2/2017
//  Copyright © 2017 GMO Media, Inc. All rights reserved.
//

import Foundation
import ObjectMapper

class WeatherResponse: BaseModel {
        
    var city: String?
    var weatherIconUrl: String?
    var observationTime: String?
    var humidity: String?
    var weatherDescription: String?
    
    override func mapping(map: Map) {
        city <- map["data.request.0.query"]
        weatherIconUrl <- map["data.current_condition.0.weatherIconUrl.0.value"]
        observationTime <- map["data.current_condition.0.observation_time"]
        humidity <- map["data.current_condition.0.humidity"]
        weatherDescription <- map["data.current_condition.0.weatherDesc.0.value"]
    }
    
}
