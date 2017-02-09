//
//  WeatherResponse.swift
//
//  Create on 8/2/2017
//  Copyright © 2017 GMO Media, Inc. All rights reserved.
//

import Foundation
import ObjectMapper

class WeatherResponse: BaseModel {

    var data: Data?
    
    var city: String?
    var weatherIconUrl: String?
    var observationTime: String?
    var humidity: String?
    var weatherDescription: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map["data"] // in case using tool auto gen model
        
        // in case manual parse
        city <- map["data.request.0.query"]
        weatherIconUrl <- map["data.currentCondition.0.weatherIconUrl.0.value"]
        observationTime <- map["data.currentCondition.0.observationTime"]
        humidity <- map["data.currentCondition.0.humidity"]
        weatherDescription <- map["data.currentCondition.0.weatherDesc.0.value"]
    }

}
