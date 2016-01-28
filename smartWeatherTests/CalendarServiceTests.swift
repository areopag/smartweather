//
//  CalendarServiceTests.swift
//  smartWeather
//
//  Created by Florian on 20/10/15.
//  Copyright © 2015 FH Joanneum. All rights reserved.
//

import XCTest
@testable import smartWeather

class CalendarServiceTests: XCTestCase {

    func testGetCalendarEntryLocations() {
        let s = CalendarService()
        do {
            try s.getCalendarEntryLocations(10)
        } catch CalendarError.PermissionDenied {
            XCTFail("Permission denied")
        } catch CalendarError.PermissionNotDetermined {
            XCTFail("Permission not determined")
        } catch { //did not work without this catch
            XCTFail("Something else happened")
        }
    }
    
}