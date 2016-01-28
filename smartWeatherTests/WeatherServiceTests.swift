//
//  WeatherServiceTest.swift
//  smartWeather
//
//  Created by Florian on 20/10/15.
//  Copyright © 2015 FH Joanneum. All rights reserved.
//

import Foundation
import XCTest
@testable import smartWeather

class WeatherServiceTest:XCTestCase {
    
    var orgDownloadService: DownloadServiceProtocol?
    var usedDownloadService: DownloadServiceMock?
    
    /*override func setUp() {
        super.setUp()
        usedDownloadService = DownloadServiceMock()
        orgDownloadService = ServiceManager.downloadService
        ServiceManager.downloadService = usedDownloadService!
    }
    
    override func tearDown() {
        super.tearDown()
        ServiceManager.downloadService = orgDownloadService!
    }*/
    
    func testGetUpcomingWeatherForCity() {
        //preapareWeatherForCityRequest()
        
        let expactation = expectationWithDescription("Wait for Weather-API-Request for single city")
        let s = WeatherService()
        let location = Location(position:Geoposition(lat:11, long: 11)) //lat + long sollte nicht beachtet werden, sobald eine CityId angegeben ist
        location.cityId = 2774773 //2774773: Kapfenberg
        
        //self.measureBlock {
        s.getUpcomingWeatherForLocation(location, completionHandler: { (weather:[DayWeather]) -> Void in
            XCTAssertTrue(weather.count > 0)
            let cal = NSCalendar.currentCalendar()
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            var dateIter = NSDate()
            for w in weather {
                XCTAssertEqual("Kapfenberg",w.location.name)
                XCTAssertEqual(formatter.stringFromDate(dateIter),
                    formatter.stringFromDate(w.day))
                dateIter = cal.dateByAddingUnit(.Day, value: 1, toDate: dateIter, options:NSCalendarOptions())!
            }
            expactation.fulfill()
        }) { (error: NSError) -> Void in
            XCTFail(error.description)
            expactation.fulfill()
        }
        self.waitForExpectationsWithTimeout(10) { (error: NSError?) -> Void in
            if(error != nil) {
                XCTFail((error?.description)!)
            }
        }
        //}
    }
    
    
    func testGetUpcomingWeatherForPosition() {
        //preapareWeatherForCityRequest()
        
        let expactation = expectationWithDescription("Wait for Weather-API-Request for location")
        let s = WeatherService()
        //lat 47.453991 - long 15.27019: Kapfenberg
        s.getUpcomingWeatherForLocation(Location(position:Geoposition(lat:47.453991, long: 15.27019)), completionHandler: { (weather:[DayWeather]) -> Void in
            XCTAssertTrue(weather.count > 0)
            let cal = NSCalendar.currentCalendar()
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            var dateIter = NSDate()
            for w in weather {
                XCTAssertEqual("Kapfenberg",w.location.name)
                XCTAssertEqual(formatter.stringFromDate(dateIter),formatter.stringFromDate(w.day))
                dateIter = cal.dateByAddingUnit(.Day, value: 1, toDate: dateIter, options:NSCalendarOptions())!
            }
            expactation.fulfill()
            }) { (error: NSError) -> Void in
                XCTFail(error.description)
                expactation.fulfill()
        }
        waitForExpectationsWithTimeout(10) { (error: NSError?) -> Void in
            if(error != nil) {
                XCTFail((error?.description)!)
            }
        }
    }


    
    func testGetWeatherAroundPositionAll() {
        //preapareNearbyWeatherRequest()
        
        let expactation = expectationWithDescription("Wait for Weather-API-Request for circle around location")
        let s = WeatherService()
        //lat 47.453991 - long 15.27019: Kapfenberg
        s.getWeatherAroundPosition(Geoposition(lat:47.453991, long: 15.27019), maxCnt: 20, restrictToGroup: WeatherGroup.All, completionHandler: { (weather:[DayWeather]) -> Void in
            //14 = 20 lt. Parameter - doppelte Ortsnamen => Kann sich u.U. ändern
            XCTAssertEqual(14, weather.count)
            expactation.fulfill()
        }) { (error: NSError) -> Void in
                XCTFail(error.description)
                expactation.fulfill()
        }
        waitForExpectationsWithTimeout(5) { (error: NSError?) -> Void in
            if(error != nil) {
                XCTFail((error?.description)!)
            }
        }
    }
    
    func testGetWeatherAroundPositionCloudy() {
        //preapareNearbyWeatherRequest()
        
        let expactation = expectationWithDescription("Wait for Weather-API-Request for circle around location")
        let s = WeatherService()
        //lat 47.453991 - long 15.27019: Kapfenberg
        s.getWeatherAroundPosition(Geoposition(lat:47.453991, long: 15.27019), maxCnt: 20, restrictToGroup: WeatherGroup.Cloudy, completionHandler: { (weather:[DayWeather]) -> Void in
            //Test kann je nach Wetter fehlschlagen
            //14 = 20 lt. Parameter - doppelte Ortsnamen => Kann sich u.U. ändern
            XCTAssertTrue(weather.count < 14,"Fehler nur falls nicht in der kompletten Umgebung von Kapfenberg bewölkt")
            //XCTAssertTrue(weather.count > 0,"Fehler nur falls in der kompletten Umgebung von Kapfenberg nicht bewölkt")
            expactation.fulfill()
            }) { (error: NSError) -> Void in
                XCTFail(error.description)
                expactation.fulfill()
        }
        waitForExpectationsWithTimeout(5) { (error: NSError?) -> Void in
            if(error != nil) {
                XCTFail((error?.description)!)
            }
        }
    }
    
    private func preapareWeatherForCityRequest() {
        usedDownloadService!.addPreparedResult("forecast/daily", result: "{\"city\":{\"id\":7872257,\"name\":\"Kapfenberg\",\"coord\":{\"lon\":15.27019,\"lat\":47.453991},\"country\":\"AT\",\"population\":0},\"cod\":\"200\",\"message\":0.0167,\"cnt\":7,\"list\":[{\"dt\":1445508000,\"temp\":{\"day\":283.57,\"min\":272.6,\"max\":286.3,\"night\":272.6,\"eve\":284.21,\"morn\":280.58},\"pressure\":935.67,\"humidity\":89,\"weather\":[{\"id\":500,\"main\":\"Rain\",\"description\":\"light rain\",\"icon\":\"10d\"}],\"speed\":1.12,\"deg\":329,\"clouds\":12},{\"dt\":1445594400,\"temp\":{\"day\":281.14,\"min\":273.12,\"max\":286.36,\"night\":273.5,\"eve\":285.03,\"morn\":273.12},\"pressure\":939.99,\"humidity\":84,\"weather\":[{\"id\":802,\"main\":\"Clouds\",\"description\":\"scattered clouds\",\"icon\":\"03d\"}],\"speed\":0.91,\"deg\":326,\"clouds\":32},{\"dt\":1445680800,\"temp\":{\"day\":279.23,\"min\":272.67,\"max\":283.53,\"night\":272.67,\"eve\":283.1,\"morn\":273.5},\"pressure\":943.5,\"humidity\":94,\"weather\":[{\"id\":500,\"main\":\"Rain\",\"description\":\"light rain\",\"icon\":\"10d\"}],\"speed\":1.15,\"deg\":247,\"clouds\":12,\"rain\":0.33},{\"dt\":1445767200,\"temp\":{\"day\":283.8,\"min\":272.95,\"max\":283.8,\"night\":275.91,\"eve\":278.81,\"morn\":272.95},\"pressure\":931.96,\"humidity\":0,\"weather\":[{\"id\":500,\"main\":\"Rain\",\"description\":\"light rain\",\"icon\":\"10d\"}],\"speed\":0.39,\"deg\":162,\"clouds\":64},{\"dt\":1445853600,\"temp\":{\"day\":282.3,\"min\":273.9,\"max\":282.3,\"night\":278.36,\"eve\":279.54,\"morn\":273.9},\"pressure\":931.12,\"humidity\":0,\"weather\":[{\"id\":501,\"main\":\"Rain\",\"description\":\"moderate rain\",\"icon\":\"10d\"}],\"speed\":0.52,\"deg\":109,\"clouds\":57,\"rain\":10.28},{\"dt\":1445940000,\"temp\":{\"day\":280.37,\"min\":272.34,\"max\":280.37,\"night\":272.34,\"eve\":276.83,\"morn\":277.56},\"pressure\":928.03,\"humidity\":0,\"weather\":[{\"id\":501,\"main\":\"Rain\",\"description\":\"moderate rain\",\"icon\":\"10d\"}],\"speed\":0.28,\"deg\":168,\"clouds\":46,\"rain\":6.91},{\"dt\":1446026400,\"temp\":{\"day\":281.57,\"min\":271.54,\"max\":281.57,\"night\":274.81,\"eve\":277.44,\"morn\":271.54},\"pressure\":927.67,\"humidity\":0,\"weather\":[{\"id\":500,\"main\":\"Rain\",\"description\":\"light rain\",\"icon\":\"10d\"}],\"speed\":1.04,\"deg\":243,\"clouds\":40,\"rain\":0.34}]}")
    }
    
    private func preapareNearbyWeatherRequest() {
        usedDownloadService!.addPreparedResult("find", result: "{\"message\":\"accurate\",\"cod\":\"200\",\"count\":20,\"list\":[{\"id\":7872257,\"name\":\"Kapfenberg\",\"coord\":{\"lon\":15.27019,\"lat\":47.453991},\"main\":{\"temp\":280.2,\"pressure\":1017,\"humidity\":75,\"temp_min\":274.26,\"temp_max\":285.93},\"dt\":1445500974,\"wind\":{\"speed\":0.5,\"deg\":0},\"sys\":{\"country\":\"\"},\"clouds\":{\"all\":20},\"weather\":[{\"id\":801,\"main\":\"Clouds\",\"description\":\"few clouds\",\"icon\":\"02d\"}]},{\"id\":2774773,\"name\":\"Kapfenberg\",\"coord\":{\"lon\":15.29331,\"lat\":47.44458},\"main\":{\"temp\":273.139,\"temp_min\":273.139,\"temp_max\":273.139,\"pressure\":907.95,\"sea_level\":1032.44,\"grnd_level\":907.95,\"humidity\":90},\"dt\":1445501070,\"wind\":{\"speed\":1.12,\"deg\":329.002},\"sys\":{\"country\":\"\"},\"clouds\":{\"all\":12},\"weather\":[{\"id\":801,\"main\":\"Clouds\",\"description\":\"few clouds\",\"icon\":\"02d\"}]},{\"id\":2769236,\"name\":\"Parschlug\",\"coord\":{\"lon\":15.28645,\"lat\":47.4809},\"main\":{\"temp\":280.2,\"pressure\":1017,\"humidity\":75,\"temp_min\":274.26,\"temp_max\":285.93},\"dt\":1445500974,\"wind\":{\"speed\":0.5,\"deg\":0},\"sys\":{\"country\":\"\"},\"clouds\":{\"all\":20},\"weather\":[{\"id\":801,\"main\":\"Clouds\",\"description\":\"few clouds\",\"icon\":\"02d\"}]},{\"id\":2768755,\"name\":\"Pischk\",\"coord\":{\"lon\":15.28333,\"lat\":47.416672},\"main\":{\"temp\":273.139,\"temp_min\":273.139,\"temp_max\":273.139,\"pressure\":907.95,\"sea_level\":1032.44,\"grnd_level\":907.95,\"humidity\":90},\"dt\":1445501070,\"wind\":{\"speed\":1.12,\"deg\":329.002},\"sys\":{\"country\":\"\"},\"clouds\":{\"all\":12},\"weather\":[{\"id\":801,\"main\":\"Clouds\",\"description\":\"few clouds\",\"icon\":\"02d\"}]},{\"id\":2781371,\"name\":\"Bruck an der Mur\",\"coord\":{\"lon\":15.28333,\"lat\":47.416672},\"main\":{\"temp\":273.139,\"temp_min\":273.139,\"temp_max\":273.139,\"pressure\":907.95,\"sea_level\":1032.44,\"grnd_level\":907.95,\"humidity\":90},\"dt\":1445501070,\"wind\":{\"speed\":1.12,\"deg\":329.002},\"sys\":{\"country\":\"\"},\"clouds\":{\"all\":12},\"weather\":[{\"id\":801,\"main\":\"Clouds\",\"description\":\"few clouds\",\"icon\":\"02d\"}]},{\"id\":7872258,\"name\":\"Parschlug\",\"coord\":{\"lon\":15.2916,\"lat\":47.490978},\"main\":{\"temp\":273.139,\"temp_min\":273.139,\"temp_max\":273.139,\"pressure\":907.95,\"sea_level\":1032.44,\"grnd_level\":907.95,\"humidity\":90},\"dt\":1445501070,\"wind\":{\"speed\":1.12,\"deg\":329.002},\"sys\":{\"country\":\"\"},\"clouds\":{\"all\":12},\"weather\":[{\"id\":801,\"main\":\"Clouds\",\"description\":\"few clouds\",\"icon\":\"02d\"}]},{\"id\":7873336,\"name\":\"Bruck an der Mur\",\"coord\":{\"lon\":15.29515,\"lat\":47.403629},\"main\":{\"temp\":278.639,\"temp_min\":278.639,\"temp_max\":278.639,\"pressure\":933.4,\"sea_level\":1031.87,\"grnd_level\":933.4,\"humidity\":82},\"dt\":1445500885,\"wind\":{\"speed\":1.07,\"deg\":333.002},\"sys\":{\"country\":\"\"},\"clouds\":{\"all\":0},\"weather\":[{\"id\":800,\"main\":\"Clear\",\"description\":\"Sky is Clear\",\"icon\":\"01d\"}]},{\"id\":2779339,\"name\":\"Frauenberg\",\"coord\":{\"lon\":15.34206,\"lat\":47.428551},\"main\":{\"temp\":278.639,\"temp_min\":278.639,\"temp_max\":278.639,\"pressure\":933.4,\"sea_level\":1031.87,\"grnd_level\":933.4,\"humidity\":82},\"dt\":1445500885,\"wind\":{\"speed\":1.07,\"deg\":333.002},\"sys\":{\"country\":\"\"},\"clouds\":{\"all\":0},\"weather\":[{\"id\":800,\"main\":\"Clear\",\"description\":\"Sky is Clear\",\"icon\":\"01d\"}]},{\"id\":2770377,\"name\":\"Oberaich\",\"coord\":{\"lon\":15.21667,\"lat\":47.400002},\"main\":{\"temp\":279.52,\"pressure\":1017,\"humidity\":75,\"temp_min\":274.15,\"temp_max\":285.93},\"dt\":1445500974,\"wind\":{\"speed\":0.5,\"deg\":0},\"sys\":{\"country\":\"\"},\"clouds\":{\"all\":20},\"weather\":[{\"id\":741,\"main\":\"Fog\",\"description\":\"fog\",\"icon\":\"50d\"}]},{\"id\":7873340,\"name\":\"Oberaich\",\"coord\":{\"lon\":15.21369,\"lat\":47.394798},\"main\":{\"temp\":279.52,\"pressure\":1017,\"humidity\":75,\"temp_min\":274.15,\"temp_max\":285.93},\"dt\":1445500974,\"wind\":{\"speed\":0.5,\"deg\":0},\"sys\":{\"country\":\"\"},\"clouds\":{\"all\":20},\"weather\":[{\"id\":741,\"main\":\"Fog\",\"description\":\"fog\",\"icon\":\"50d\"}]},{\"id\":2766562,\"name\":\"Sankt Marein im Murztal\",\"coord\":{\"lon\":15.36667,\"lat\":47.466671},\"main\":{\"temp\":278.639,\"temp_min\":278.639,\"temp_max\":278.639,\"pressure\":933.4,\"sea_level\":1031.87,\"grnd_level\":933.4,\"humidity\":82},\"dt\":1445501070,\"wind\":{\"speed\":1.07,\"deg\":333.002},\"sys\":{\"country\":\"\"},\"clouds\":{\"all\":0},\"weather\":[{\"id\":800,\"main\":\"Clear\",\"description\":\"Sky is Clear\",\"icon\":\"01d\"}]},{\"id\":7872260,\"name\":\"Sankt Marein im Mürztal\",\"coord\":{\"lon\":15.37542,\"lat\":47.4585},\"main\":{\"temp\":278.639,\"temp_min\":278.639,\"temp_max\":278.639,\"pressure\":933.4,\"sea_level\":1031.87,\"grnd_level\":933.4,\"humidity\":82},\"dt\":1445501070,\"wind\":{\"speed\":1.07,\"deg\":333.002},\"sys\":{\"country\":\"\"},\"clouds\":{\"all\":0},\"weather\":[{\"id\":800,\"main\":\"Clear\",\"description\":\"Sky is Clear\",\"icon\":\"01d\"}]},{\"id\":7872256,\"name\":\"Frauenberg\",\"coord\":{\"lon\":15.37091,\"lat\":47.42728},\"main\":{\"temp\":280.33,\"pressure\":1017,\"humidity\":75,\"temp_min\":274.26,\"temp_max\":285.93},\"dt\":1445501323,\"wind\":{\"speed\":0.5,\"deg\":0},\"sys\":{\"country\":\"\"},\"clouds\":{\"all\":20},\"weather\":[{\"id\":801,\"main\":\"Clouds\",\"description\":\"few clouds\",\"icon\":\"02d\"}]},{\"id\":2766576,\"name\":\"Sankt Lorenzen im Murztal\",\"coord\":{\"lon\":15.36667,\"lat\":47.48333},\"main\":{\"temp\":280.34,\"pressure\":1017,\"humidity\":75,\"temp_min\":274.26,\"temp_max\":285.93},\"dt\":1445501323,\"wind\":{\"speed\":0.5,\"deg\":0},\"sys\":{\"country\":\"\"},\"clouds\":{\"all\":20},\"weather\":[{\"id\":801,\"main\":\"Clouds\",\"description\":\"few clouds\",\"icon\":\"02d\"}]},{\"id\":2766629,\"name\":\"Sankt Katharein an der Laming\",\"coord\":{\"lon\":15.16319,\"lat\":47.470692},\"main\":{\"temp\":279.65,\"pressure\":1017,\"humidity\":75,\"temp_min\":274.15,\"temp_max\":285.93},\"dt\":1445501323,\"wind\":{\"speed\":0.5,\"deg\":0},\"sys\":{\"country\":\"\"},\"clouds\":{\"all\":20},\"weather\":[{\"id\":741,\"main\":\"Fog\",\"description\":\"fog\",\"icon\":\"50d\"}]},{\"id\":2763672,\"name\":\"Thorl\",\"coord\":{\"lon\":15.21667,\"lat\":47.51667},\"main\":{\"temp\":280.35,\"pressure\":1017,\"humidity\":75,\"temp_min\":274.26,\"temp_max\":285.93},\"dt\":1445501323,\"wind\":{\"speed\":0.5,\"deg\":0},\"sys\":{\"country\":\"\"},\"clouds\":{\"all\":20},\"weather\":[{\"id\":801,\"main\":\"Clouds\",\"description\":\"few clouds\",\"icon\":\"02d\"}]},{\"id\":2768895,\"name\":\"Picheldorf\",\"coord\":{\"lon\":15.18333,\"lat\":47.400002},\"main\":{\"temp\":273.139,\"temp_min\":273.139,\"temp_max\":273.139,\"pressure\":907.95,\"sea_level\":1032.44,\"grnd_level\":907.95,\"humidity\":90},\"dt\":1445500885,\"wind\":{\"speed\":1.12,\"deg\":329.002},\"sys\":{\"country\":\"\"},\"clouds\":{\"all\":12},\"weather\":[{\"id\":801,\"main\":\"Clouds\",\"description\":\"few clouds\",\"icon\":\"02d\"}]},{\"id\":2770996,\"name\":\"Murzhofen\",\"coord\":{\"lon\":15.38333,\"lat\":47.48333},\"main\":{\"temp\":280.33,\"pressure\":1017,\"humidity\":75,\"temp_min\":274.26,\"temp_max\":285.93},\"dt\":1445501323,\"wind\":{\"speed\":0.5,\"deg\":0},\"sys\":{\"country\":\"\"},\"clouds\":{\"all\":20},\"weather\":[{\"id\":801,\"main\":\"Clouds\",\"description\":\"few clouds\",\"icon\":\"02d\"}]},{\"id\":7872259,\"name\":\"Sankt Katharein an der Laming\",\"coord\":{\"lon\":15.14839,\"lat\":47.465061},\"main\":{\"temp\":273.139,\"temp_min\":273.139,\"temp_max\":273.139,\"pressure\":907.95,\"sea_level\":1032.44,\"grnd_level\":907.95,\"humidity\":90},\"dt\":1445501070,\"wind\":{\"speed\":1.12,\"deg\":329.002},\"sys\":{\"country\":\"\"},\"clouds\":{\"all\":12},\"weather\":[{\"id\":801,\"main\":\"Clouds\",\"description\":\"few clouds\",\"icon\":\"02d\"}]},{\"id\":2781370,\"name\":\"Politischer Bezirk Bruck an der Mur\",\"coord\":{\"lon\":15.25,\"lat\":47.533329},\"main\":{\"temp\":280.34,\"pressure\":1017,\"humidity\":75,\"temp_min\":274.26,\"temp_max\":285.93},\"dt\":1445501323,\"wind\":{\"speed\":0.5,\"deg\":0},\"sys\":{\"country\":\"\"},\"clouds\":{\"all\":20},\"weather\":[{\"id\":801,\"main\":\"Clouds\",\"description\":\"few clouds\",\"icon\":\"02d\"}]}]}")
    }
}