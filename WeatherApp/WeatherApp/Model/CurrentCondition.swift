//
//  CurrentCondition.swift
//
//  Create on 8/2/2017
//  Copyright © 2017 GMO Media, Inc. All rights reserved.
//

import Foundation
import ObjectMapper

class CurrentCondition: BaseModel {

    var cloudcover: String?
    var humidity: String?
    var observationTime: String?
    var precipMM: String?
    var pressure: String?
    var tempC: String?
    var tempF: String?
    var visibility: String?
    var weatherCode: String?
    var weatherDesc: [WeatherDesc]?
    var weatherIconUrl: [WeatherDesc]?
    var winddir16Point: String?
    var winddirDegree: String?
    var windspeedKmph: String?
    var windspeedMiles: String?

    override func mapping(map: Map) {
        super.mapping(map: map)
        cloudcover <- map["cloudcover"]
        humidity <- map["humidity"]
        observationTime <- map["observation_time"]
        precipMM <- map["precipMM"]
        pressure <- map["pressure"]
        tempC <- map["temp_C"]
        tempF <- map["temp_F"]
        visibility <- map["visibility"]
        weatherCode <- map["weatherCode"]
        weatherDesc <- map["weatherDesc"]
        weatherIconUrl <- map["weatherIconUrl"]
        winddir16Point <- map["winddir16Point"]
        winddirDegree <- map["winddirDegree"]
        windspeedKmph <- map["windspeedKmph"]
        windspeedMiles <- map["windspeedMiles"]        
    }

}
