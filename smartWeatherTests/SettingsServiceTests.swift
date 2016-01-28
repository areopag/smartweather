//
//  WeatherServiceTest.swift
//  smartWeather
//
//  Created by Florian on 20/10/15.
//  Copyright © 2015 FH Joanneum. All rights reserved.
//


import XCTest
@testable import smartWeather

class SettingsServiceTests: XCTestCase {
    //See: https://developer.apple.com/library/mac/documentation/DeveloperTools/Conceptual/testing_with_xcode/chapters/04-writing_tests.html
    //Assertions: http://appleprogramming.com/blog/2013/12/26/xctest-assertions-documentation/
    
    override func setUp() {
        for key in NSUserDefaults.standardUserDefaults().dictionaryRepresentation().keys {
            NSUserDefaults.standardUserDefaults().removeObjectForKey(key)
        }
    }
    
    //MARK: Recent Cities
    func testGetRecentCitiesEmpty() {
        let s = SettingsService()
        XCTAssertEqual(0, s.getRecentCities().count)
    }
    
    func testAddRecentCity() {
        let s = SettingsService()
        s.addRecentCity(5)
        let cities = s.getRecentCities()
        XCTAssertEqual(1,cities.count)
        XCTAssertEqual(5, cities[0])
    }
    
    func testAddRecentCityDuplicate() {
        let s = SettingsService()
        s.addRecentCity(5)
        s.addRecentCity(5)
        let cities = s.getRecentCities()
        XCTAssertEqual(1,cities.count)
        XCTAssertEqual(5, cities[0])
    }
    
    func testRemoveRecentCityEmpty() {
        let s = SettingsService()
        s.removeRecentCity(5)
        let cities = s.getRecentCities()
        XCTAssertEqual(0, cities.count)
    }
    
    func testRemoveRecentCityExisting() {
        let s = SettingsService()
        s.addRecentCity(5)
        s.removeRecentCity(5)
        let cities = s.getRecentCities()
        XCTAssertEqual(0, cities.count)
    }
    
    //MARK: Current City
    func testGetCurrentCityEmpty() {
        let s = SettingsService()
        XCTAssertTrue(s.getCurrentCityLocation() == nil)
    }
    
    func testSetCurrentCityEmpty() {
        let s = SettingsService()
        s.setCurrentCityLocation(nil)
        XCTAssertTrue(s.getCurrentCityLocation() == nil)
    }
    
    func testSetCurrentCityVal() {
        let s = SettingsService()
        let location = Location(position: Geoposition(lat:10.11,long:11.12))
        location.name = "myCity"
        location.cityId = 1099
        s.setCurrentCityLocation(location)
        let saved = s.getCurrentCityLocation()
        XCTAssertEqual("myCity", saved?.name)
        XCTAssertEqual(1099, saved?.cityId)
        XCTAssertEqual(10.11, saved?.position.lat)
        XCTAssertEqual(11.12, saved?.position.long)
    }
    
    func testSetCurrentCityValEmpty() {
        let s = SettingsService()
        let location = Location(position: Geoposition(lat:10.11,long:11.12))
        location.name = "myCity"
        location.cityId = 1099
        s.setCurrentCityLocation(location)

        s.setCurrentCityLocation(nil)
        XCTAssertTrue(s.getCurrentCityLocation() == nil)
    }
    
    //MARK: Nearby Weather
    func testGetNearbyWeatherDefault() {
        let s = SettingsService()
        XCTAssertEqual(WeatherGroup.Snowy,s.getNearbyWeather(WeatherGroup.Snowy))
    }
    
    func testSetNearbyWeatherVal() {
        let s = SettingsService()
        s.setNearbyWeather(WeatherGroup.Rainy)
        XCTAssertEqual(WeatherGroup.Rainy,s.getNearbyWeather(WeatherGroup.Snowy))
    }
    
    
    func testSetNearbyWeatherValPerformance() {
        let s = SettingsService()
        
        self.measureBlock {
            s.setNearbyWeather(WeatherGroup.Rainy)
        }
        
        XCTAssertEqual(WeatherGroup.Rainy,s.getNearbyWeather(WeatherGroup.Snowy))
    }
}
