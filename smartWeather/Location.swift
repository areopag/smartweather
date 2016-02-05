//
//  Location.swift
//  smartWeather
//
//  Created by Florian on 22/10/15.
//  Copyright © 2015 FH Joanneum. All rights reserved.
//

import Foundation

class Location {
    var position: Geoposition
    var cityId: Int? = nil
    var name: String? = nil
    var details: String
    var country: String
    
    init() {
        self.position = Geoposition(lat: 0, long: 0)
        self.details = ""
        self.country = ""
    }
    
    init(position: Geoposition) {        
        self.position = position
        self.details = ""
        self.country = ""
    }
}