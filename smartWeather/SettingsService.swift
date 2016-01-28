//
//  SettingsService.swift
//  smartWeather
//
//  Created by Florian on 20/10/15.
//  Copyright © 2015 FH Joanneum. All rights reserved.
//

import Foundation

class SettingsService : SettingsServiceProtocol {
    //See: http://www.codingexplorer.com/nsuserdefaults-a-swift-introduction/
    
    private func getSettings() -> NSUserDefaults {
        return NSUserDefaults.standardUserDefaults()
    }
    
    //MARK: Recent Cities
    func getRecentCities() -> [Int] {
        let settings = getSettings()
        var cities = [Int]()
        let recent = settings.arrayForKey("rencentCities")
        if(recent != nil) {
            for city in recent! {
                if(city is Int) {
                    cities.append(city as! Int)
                }
            }
        }
        return cities
    }
    
    private func saveRecentCities(cities: [Int]) {
        let settings = getSettings()
        settings.setObject(cities, forKey: "rencentCities")
    }
    
    func addRecentCity(cityId: Int) {
        var cities = getRecentCities()
        if(cities.indexOf(cityId) < 0) {
            cities.append(cityId)
        }
        saveRecentCities(cities)
    }
    
    func removeRecentCity(cityId: Int) {
        var cities = getRecentCities()
        let cityIndex = cities.indexOf(cityId)
        if(cityIndex >= 0) {
            cities.removeAtIndex(cityIndex!)
        }
        saveRecentCities(cities)
    }
    
    //MARK: Current City
    func setCurrentCityLocation(location: Location?) {
        let settings = getSettings()
        
        if location != nil {
            if location!.name == nil || location!.cityId == nil {
                print("CurrentCityLocation not saved: Name or CityId not defined")
                //Zum Speichern des Ortes muss dieser immer vollständig sein
                //-> Ansonsten wird er das nächste mal einfach per GEO-Position ermittelt
                return
            }
            
            settings.setInteger(location!.cityId!, forKey: "currentCityId")
            settings.setValue(location!.name!, forKey: "currentCityName")
            settings.setDouble(location!.position.lat, forKey: "currentCityLat")
            settings.setDouble(location!.position.long, forKey: "currentCityLong")
        }
        else {
            settings.removeObjectForKey("currentCityId")
            settings.removeObjectForKey("currentCityName")
            settings.removeObjectForKey("currentCityLat")
            settings.removeObjectForKey("currentCityLong")
        }
    }
    
    func getCurrentCityLocation() -> Location? {
        let settings = getSettings()
        if let long = settings.objectForKey("currentCityLong") as? Double {
            if let lat = settings.objectForKey("currentCityLat") as? Double {
                let position = Geoposition(lat:lat, long:long)
                let location = Location(position: position)
                location.cityId = settings.objectForKey("currentCityId") as? Int
                location.name = settings.objectForKey("currentCityName") as? String
                return location
            }
        }
        return nil
    }
    
    //MARK: Nearby Weather
    func setNearbyWeather(weatherGroup: WeatherGroup) {
        let settings = getSettings()
        settings.setObject(weatherGroup.rawValue, forKey: "nearbyWeather")
    }
    
    func getNearbyWeather(defaultWeatherGroup: WeatherGroup) -> WeatherGroup {
        let settings = getSettings()
        if let weatherCode = settings.objectForKey("nearbyWeather") {
            if weatherCode is String {
                if let group = WeatherGroup(rawValue: weatherCode as! String) {
                    return group
                }
            }
        }
        return defaultWeatherGroup
    }
}