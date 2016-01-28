//
//  CurrentWeather.swift
//  smartWeather
//
//  Created by Florian on 19/10/15.
//  Copyright © 2015 FH Joanneum. All rights reserved.
//

import Foundation

class DayWeather {
    var location: Location
    var day: NSDate = NSDate()
    var code: String = ""
    var name: String = ""
    var description: String = ""
    var temp: Double = 0.0
    var humi: Double = 0.0
    
    init(location: Location) {
        self.location = location
    }
}