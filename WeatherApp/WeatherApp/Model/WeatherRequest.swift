//
//  WeatherRequest.swift
//  WeatherApp
//
//  Created by Nguyen Hoang Tuan on 2/9/17.
//  Copyright © 2017 NHT. All rights reserved.
//

import Foundation
import ObjectMapper

class WeatherRequest: BaseModel {
    
    var key: String = requestKey
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
