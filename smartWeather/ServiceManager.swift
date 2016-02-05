//
//  ServiceManager.swift
//  smartWeather
//
//  Created by Robs on 20/10/15.
//  Copyright © 2015 FH Joanneum. All rights reserved.
//
//  For accessing the instanciated Services
//

import Foundation

class ServiceManager {
    //var geoServiceInstance:GeoServiceProtocol
    
    static var weatherService: WeatherServiceProtocol = WeatherService()
    static var calendarService: CalendarServiceProtocol = CalendarService()
    static var settingsService: SettingsServiceProtocol = SettingsService()    
    static var downloadService: DownloadServiceProtocol = DownloadService()
    static var databaseService: DatabaseServiceProtocol = DatabaseService()
}