//
//  GeoServiceProtocol.swift
//  smartWeather
//
//  Created by Florian on 21/10/15.
//  Copyright © 2015 FH Joanneum. All rights reserved.
//

import Foundation
import CoreLocation

protocol GeoServiceProtocol {
    func getCurrentPosition(completionHandler: Geoposition -> Void, errorHandler: NSError -> Void)
}