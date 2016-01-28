//
//  DatabaseServiceTest.swift
//  smartWeather
//
//  Created by Florian on 07/11/15.
//  Copyright © 2015 FH Joanneum. All rights reserved.
//

import Foundation

import XCTest
@testable import smartWeather

class DatabaseServiceTests:XCTestCase {
    func testGetLocationFromCityName() {
        let s = DatabaseService()
        let location = s.getLocationFromCityName("Kapfenberg")
        XCTAssertEqual("Kapfenberg",location?.name)
        //Standardmäßig 7872257, könnte aber auch 2774773 sein, da beide den Namen Kapfenberg haben
        XCTAssertEqual(7872257,location?.cityId)
        XCTAssertEqual(47.453991 ,location?.position.lat)
        XCTAssertEqual(15.27019,location?.position.long)
    }
    
    func testGetLocationsForCityIDs() {
        let s = DatabaseService()
        let locations = s.getLocationsForCityIDs([7872257,2643743,2778067,7873556]) //[Kapfenberg,London,Graz,Birkfeld]
        XCTAssertEqual(4,locations.count)
        if locations.count == 4 {
            //Sortiert nach Alphabeth
            XCTAssertEqual("Birkfeld", locations[0].name)
            XCTAssertEqual("Graz", locations[1].name)
            XCTAssertEqual("Kapfenberg", locations[2].name)
            XCTAssertEqual("London", locations[3].name)
        }
    }
    
    func testUpdateCitiesList() {
        XCTAssertTrue(false,"long running test not active")
        return
        
        //let s = DatabaseService()
        //s.updateCitiesList()
    }
    
    func testReadCitiesList()  {
        let s = DatabaseService()
        s.readCitiesList()
    }
}