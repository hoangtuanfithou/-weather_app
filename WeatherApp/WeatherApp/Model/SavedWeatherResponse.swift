//
//  SavedWeatherResponse.swift
//  WeatherApp
//
//  Created by Nguyen Hoang Tuan on 2/13/17.
//  Copyright © 2017 NHT. All rights reserved.
//

import Foundation
import ObjectMapper

class SavedWeatherResponse: BaseModel {
    
    var weathers: [WeatherResponse]?
    override func mapping(map: Map) {
        weathers <- map["weathers"]
    }
    
}
