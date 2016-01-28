//
//  DatabaseServiceProtocol.swift
//  smartWeather
//
//  Created by Florian on 07/11/15.
//  Copyright © 2015 FH Joanneum. All rights reserved.
//

import Foundation

protocol DatabaseServiceProtocol {
    func getLocationFromCityName(location: String) -> Location?
    func getLocationsForCityIDs(cityIDs: [Int]) -> [Location]
    func searchLocationsByNeedle(needle: String, maxResults: Int) -> [Location]
    func updateCitiesList()
}