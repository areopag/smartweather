//
//  CalendarServiceProtocol.swift
//  smartWeather
//
//  Created by Florian on 20/10/15.
//  Copyright © 2015 FH Joanneum. All rights reserved.
//

import Foundation

protocol CalendarServiceProtocol {
    func getCalendarEntryLocations(upcomingDays: Int) throws -> [Location]
}