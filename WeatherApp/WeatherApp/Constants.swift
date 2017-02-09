//
//  Constants.swift
//  WeatherApp
//
//  Created by Nguyen Hoang Tuan on 2/9/17.
//  Copyright © 2017 NHT. All rights reserved.
//

import UIKit
import Foundation

let searchHistoryKey = "SearchHistory"
let maxHistoryNumber = 10
let weatherUrl = "http://api.worldweatheronline.com/free/v1/weather.ashx"
let appDelegate = UIApplication.shared.delegate as! AppDelegate
let mainContext = appDelegate.persistentContainer.viewContext
