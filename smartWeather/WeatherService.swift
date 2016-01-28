//
//  WeatherService.swift
//  smartWeather
//
//  Created by Florian on 19/10/15.
//  Copyright © 2015 FH Joanneum. All rights reserved.
//

import Foundation

class WeatherService: WeatherServiceProtocol {
    let baseUrl = NSURL(string: "http://api.openweathermap.org/data/2.5/")
    let apiKey = "cdff7a81fad7226b6e3813f6b5a98620"
    
    func getUpcomingWeatherForLocation(location: Location, completionHandler: [DayWeather] -> Void, errorHandler: NSError -> Void) {
        if let cityId = location.cityId {
            getUpcomingWeatherForCity(cityId, completionHandler: completionHandler, errorHandler: errorHandler)
        }
        else {
            getUpcomingWeatherForPosition(location.position, completionHandler: completionHandler, errorHandler: errorHandler)
        }
    }

    func getUpcomingWeatherForCity(cityId:Int, completionHandler: ([DayWeather] -> Void), errorHandler: (NSError -> Void)) {
        if let serviceUrl = NSURL(string: "forecast/daily?id=\(cityId)&appid=\(apiKey)&units=metric", relativeToURL:baseUrl) {
            print("Service URL: \(serviceUrl.absoluteURL)")
            ServiceManager.downloadService.load(serviceUrl, successCallback: {(data: NSData) -> Void in
                let json = JSON(data: data)
                var weather = [DayWeather]()
                if let cityName = json["city"]["name"].string {
                    if let lat = json["city"]["coord"]["lat"].double {
                        if let long = json["city"]["coord"]["lon"].double {
                            let position = Geoposition(lat: lat, long: long)
                            let location = Location(position: position)
                            location.cityId = cityId
                            location.name = cityName
                            
                            for d in json["list"].array! {
                                if let date = d["dt"].double {
                                    let day = DayWeather(location: location)
                                    day.day = NSDate(timeIntervalSince1970: date)
                                    if let code = d["weather"][0]["id"].int {day.code = String(code)}
                                    if let name = d["weather"][0]["main"].string { day.name = name }
                                    if let description = d["weather"][0]["description"].string { day.description = description }
                                    if let temp = d["temp"]["day"].double { day.temp = temp }
                                    if let humi = d["humidity"].double { day.humi = humi }
                                    weather.append(day)
                                }
                            }
                        }
                    }
                    
                }
                completionHandler(weather)
            }, errorCallback: {(error: NSError) -> Void in
                errorHandler(error)
            })
        }
    }
    
    func getUpcomingWeatherForPosition(position:Geoposition, completionHandler: [DayWeather] -> Void, errorHandler: NSError -> Void) {
        if let serviceUrl = NSURL(string: "forecast/daily?lat=\(position.lat)&lon=\(position.long)&appid=\(apiKey)&units=metric", relativeToURL:baseUrl) {
            print("Service URL: \(serviceUrl.absoluteURL)")
            ServiceManager.downloadService.load(serviceUrl, successCallback: {(data: NSData) -> Void in
                let json = JSON(data: data)
                var weather = [DayWeather]()
                if let cityId = json["city"]["id"].int {
                    if let cityName = json["city"]["name"].string {
                        if let lat = json["city"]["coord"]["lat"].double {
                            if let long = json["city"]["coord"]["lon"].double {
                                let position = Geoposition(lat: lat, long: long)
                                let location = Location(position: position)
                                location.cityId = cityId
                                location.name = cityName
                                
                                for d in json["list"].array! {
                                    if let date = d["dt"].double {
                                        let day = DayWeather(location: location)
                                        day.day = NSDate(timeIntervalSince1970: date)
                                        if let code = d["weather"][0]["id"].int {day.code = String(code)}
                                        if let name = d["weather"][0]["main"].string { day.name = name }
                                        if let description = d["weather"][0]["description"].string { day.description = description }
                                        if let temp = d["temp"]["day"].double { day.temp = temp }
                                        if let humi = d["humidity"].double { day.humi = humi }
                                        weather.append(day)
                                    }
                                }
                            }
                        }
                    }
                }
                completionHandler(weather)
                }, errorCallback: {(error: NSError) -> Void in
                    errorHandler(error)
            })
        }

    }
    
    func getWeatherAroundPosition(position: Geoposition, maxCnt: Int, restrictToGroup: WeatherGroup, completionHandler: [DayWeather] -> Void, errorHandler: NSError -> Void) {
        if let serviceUrl = NSURL(string: "find?lat=\(position.lat)&lon=\(position.long)&cnt=\(maxCnt)&appid=\(apiKey)&units=metric", relativeToURL:baseUrl) {
            print("Service URL: \(serviceUrl.absoluteURL)")
            ServiceManager.downloadService.load(serviceUrl, successCallback: {(data: NSData) -> Void in
                let json = JSON(data: data)
                var incluededCityNames = [String]()
                var weather = [DayWeather]()
                do {
                    let regexStr = self.getWeatherIdRegExForWeatherGroup(restrictToGroup)
                    let regex = try NSRegularExpression(pattern: regexStr, options: [])
                    for d in json["list"].array! {
                        if let weatherId = d["weather"][0]["id"].int {
                            if regex.firstMatchInString(String(weatherId), options:[], range: NSRange(location: 0,length:  String(weatherId).characters.count)) != nil {
                                if let cityId = d["id"].int {
                                    if let cityName = d["name"].string {
                                        if let lat = d["coord"]["lat"].double {
                                            if let long = d["coord"]["lon"].double {
                                                if !incluededCityNames.contains(cityName) {
                                                    if let date = d["dt"].double {
                                                        let position = Geoposition(lat: lat, long: long)
                                                        let location = Location(position: position)
                                                        location.cityId = cityId
                                                        location.name = cityName
                                                        
                                                        let day = DayWeather(location: location)
                                                        day.day = NSDate(timeIntervalSince1970: date)
                                                        if let code = d["weather"][0]["id"].int {day.code = String(code)}
                                                        if let name = d["weather"][0]["main"].string { day.name = name }
                                                        if let description = d["weather"][0]["description"].string { day.description = description }
                                                        if let temp = d["main"]["temp"].double { day.temp = temp }
                                                        if let humi = d["humidity"].double { day.humi = humi }
                                                        incluededCityNames.append(cityName)
                                                        weather.append(day)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                } catch let error as NSError {
                    errorHandler(error)
                    return
                }
                completionHandler(weather)
            }, errorCallback: {(error: NSError) -> Void in
                    errorHandler(error)
            })
        }

    }
    
    private func getWeatherIdRegExForWeatherGroup(weather: WeatherGroup) -> String {
        switch(weather) {
            case WeatherGroup.Sunny:
                return "^800$"
            case WeatherGroup.Cloudy:
                return "^80[1-4]$"
            case WeatherGroup.Rainy:
                return "^(5..)|(3..)$"
            case WeatherGroup.Snowy:
                return "^6..$"
            case WeatherGroup.All:
                return ".*"
        }
    }
    
    
}