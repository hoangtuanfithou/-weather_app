//
//  WeatherDesc.swift
//
//  Create on 8/2/2017
//  Copyright © 2017 GMO Media, Inc. All rights reserved.
//

import Foundation
import ObjectMapper

class WeatherDesc: BaseModel {

    var value: String?

    override func mapping(map: Map) {
        super.mapping(map: map)
        value <- map["value"]        
    }

}
