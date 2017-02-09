//
//  Request.swift
//
//  Create on 8/2/2017
//  Copyright © 2017 GMO Media, Inc. All rights reserved.
//

import Foundation
import ObjectMapper

class Request: BaseModel {

    var query: String?
    var type: String?

    override func mapping(map: Map) {
        super.mapping(map: map)
        query <- map["query"]
        type <- map["type"]        
    }

}
