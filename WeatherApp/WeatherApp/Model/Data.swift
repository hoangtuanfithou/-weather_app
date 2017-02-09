//
//  Data.swift
//
//  Create on 8/2/2017
//  Copyright © 2017 GMO Media, Inc. All rights reserved.
//

import Foundation
import ObjectMapper

class Data: BaseModel {

    var currentCondition: [CurrentCondition]?
    var request: [Request]?
    var weather: [Weather]?

    override func mapping(map: Map) {
        super.mapping(map: map)
        currentCondition <- map["current_condition"]
        request <- map["request"]
        weather <- map["weather"]        
    }

}
