//
//  BaseModel.swift
//  TravelRankingShare
//
//  Created by 長尾 昇太 on 2016/07/05.
//  Copyright © 2016年 GMO Media, Inc. All rights reserved.
//

import ObjectMapper

class BaseModel: Mappable {
    
    init() {
        // Request function
    }
    
    required init?(map: Map) {
        // Mappable request function
    }
    
    func mapping(map: Map) {
        // Mappable request function
    }
    
}
