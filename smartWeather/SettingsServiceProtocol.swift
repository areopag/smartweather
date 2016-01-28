//
//  SettingsServiceProtocol.swift
//  smartWeather
//
//  Created by Florian on 20/10/15.
//  Copyright © 2015 FH Joanneum. All rights reserved.
//

import Foundation

protocol SettingsServiceProtocol
{
    //MARK: Recent Cities
    func getRecentCities() -> [Int]
    func addRecentCity(cityId: Int)
    func removeRecentCity(cityId: Int)
    
    //MARK: Current City Location
    func setCurrentCityLocation(location: Location?) throws
    func getCurrentCityLocation() -> Location?
    
    //MARK: Nearby Weather
    func setNearbyWeather(weatherGroup: WeatherGroup)
    func getNearbyWeather(defaultWeatherGroup: WeatherGroup) -> WeatherGroup
}