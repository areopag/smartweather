//
//  ServiceManager.swift
//  smartWeather
//
//  Created by Florian on 20/10/15.
//  Copyright © 2015 FH Joanneum. All rights reserved.
//

import Foundation

class ServiceManager {
    //var geoServiceInstance:GeoServiceProtocol
    
    static var weatherService: WeatherServiceProtocol = WeatherService()
    static var calendarService: CalendarServiceProtocol = CalendarService()
    static var settingsService: SettingsServiceProtocol = SettingsService()    
    static var downloadService: DownloadServiceProtocol = DownloadService()
    static var compassService: CompassServiceProtocol = CompassService()
    static var databaseService: DatabaseServiceProtocol = DatabaseService()
}