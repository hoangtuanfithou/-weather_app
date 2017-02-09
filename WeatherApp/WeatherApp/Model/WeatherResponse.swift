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

    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map["data"]        
    }

}
