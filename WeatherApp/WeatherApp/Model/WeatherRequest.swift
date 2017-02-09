//
//  WeatherRequest.swift
//  WeatherApp
//
//  Created by Nguyen Hoang Tuan on 2/9/17.
//  Copyright © 2017 NHT. All rights reserved.
//

import Foundation
import ObjectMapper

// http://api.worldweatheronline.com/free/v1/weather.ashx?key=vzkjnx2j5f88vyn5dhvvqkzc&q=London&fx=yes&format=json
class WeatherRequest: BaseModel {
    
    var key: String = "vzkjnx2j5f88vyn5dhvvqkzc"
    var fx: Bool = true
    var format: String = "json"
    var query: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        key <- map["key"]
        fx <- map["fx"]
        format <- map["format"]
        query <- map["q"]
    }
    
}
