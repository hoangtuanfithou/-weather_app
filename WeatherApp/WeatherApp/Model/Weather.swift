//
//  Weather.swift
//
//  Create on 8/2/2017
//  Copyright © 2017 GMO Media, Inc. All rights reserved.
//

import Foundation
import ObjectMapper

class Weather: BaseModel {

    var date: String?
    var precipMM: String?
    var tempMaxC: String?
    var tempMaxF: String?
    var tempMinC: String?
    var tempMinF: String?
    var weatherCode: String?
    var weatherDesc: [WeatherDesc]?
    var weatherIconUrl: [WeatherDesc]?
    var winddir16Point: String?
    var winddirDegree: String?
    var winddirection: String?
    var windspeedKmph: String?
    var windspeedMiles: String?

    override func mapping(map: Map) {
        super.mapping(map: map)
        date <- map["date"]
        precipMM <- map["precipMM"]
        tempMaxC <- map["tempMaxC"]
        tempMaxF <- map["tempMaxF"]
        tempMinC <- map["tempMinC"]
        tempMinF <- map["tempMinF"]
        weatherCode <- map["weatherCode"]
        weatherDesc <- map["weatherDesc"]
        weatherIconUrl <- map["weatherIconUrl"]
        winddir16Point <- map["winddir16Point"]
        winddirDegree <- map["winddirDegree"]
        winddirection <- map["winddirection"]
        windspeedKmph <- map["windspeedKmph"]
        windspeedMiles <- map["windspeedMiles"]        
    }

}
