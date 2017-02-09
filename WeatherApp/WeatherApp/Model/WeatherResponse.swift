//
//  WeatherResponse.swift
//
//  Create on 8/2/2017
//  Copyright © 2017 GMO Media, Inc. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreData

class WeatherResponse: NSManagedObject, Mappable {

    var data: Data?
    
    @NSManaged var city: String?
    @NSManaged var weatherIconUrl: String?
    @NSManaged var observationTime: String?
    @NSManaged var humidity: String?
    @NSManaged var weatherDescription: String?
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: mainContext)
    }
    
    required init?(map: Map) {
        let entity = NSEntityDescription.entity(forEntityName: "Weather", in: mainContext)
        super.init(entity: entity!, insertInto: mainContext)
        
        mapping(map: map)
    }

    func mapping(map: Map) {
        // in case using tool auto gen model
        data <- map["data"]
        
        // in case manual parse
        city <- map["data.request.0.query"]
        weatherIconUrl <- map["data.current_condition.0.weatherIconUrl.0.value"]
        observationTime <- map["data.current_condition.0.observation_time"]
        humidity <- map["data.current_condition.0.humidity"]
        weatherDescription <- map["data.current_condition.0.weatherDesc.0.value"]
    }

}
