//
//  CompassServiceProtocol.swift
//  smartWeather
//
//  Created by Maderbacher Florian on 06/11/15.
//  Copyright © 2015 FH Joanneum. All rights reserved.
//

import Foundation

protocol CompassServiceProtocol {
    func registerCompass(compassChanged: CompassState -> Void)
    func filterLocations(compassState: CompassState, position: Geoposition, locations: [Location]) -> [Location]
}