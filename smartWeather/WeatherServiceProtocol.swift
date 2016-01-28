//
//  WeatherServiceProtocol.swift
//  smartWeather
//
//  Created by Florian on 20/10/15.
//  Copyright © 2015 FH Joanneum. All rights reserved.
//

import Foundation

protocol WeatherServiceProtocol {
    func getUpcomingWeatherForLocation(location: Location, completionHandler: [DayWeather] -> Void, errorHandler: NSError -> Void)
    func getWeatherAroundPosition(position: Geoposition, maxCnt: Int, restrictToGroup: WeatherGroup,  completionHandler: [DayWeather] -> Void, errorHandler: NSError -> Void)
}

enum WeatherGroup: String {
    case Sunny
    case Rainy
    case Cloudy
    case Snowy
    case All
}