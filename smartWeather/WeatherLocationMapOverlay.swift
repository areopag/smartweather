//
//  WeatherLocationMapOverlay.swift
//  smartWeather
//
//  Created by Florian on 22/10/15.
//  Copyright © 2015 FH Joanneum. All rights reserved.
//

import Foundation
import MapKit

class WeatherLocationMapOverlay: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    
    init(locationName: String, weatherName: String, coordinate: Geoposition) {
        self.title = locationName
        self.subtitle = weatherName
        self.coordinate = CLLocationCoordinate2D(latitude: coordinate.lat, longitude: coordinate.long)
        
        super.init()
    }
}