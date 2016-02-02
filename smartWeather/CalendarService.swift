//
//  CalendarService.swift
//  smartWeather
//
//  Created by Florian on 20/10/15.
//  Copyright © 2015 FH Joanneum. All rights reserved.
//

import Foundation
import EventKit

class CalendarService: CalendarServiceProtocol {
    //See: https://www.andrewcbancroft.com/2015/06/17/creating-calendars-with-event-kit-and-swift/
    //https://github.com/andrewcbancroft/EventTracker/tree/ask-for-permission
    
    let eventStore = EKEventStore()
    
    func getCalendarEntryLocations(upcomingDays: Int) throws -> [String] {
        try checkCalendarAuthorizationStatus()
        
        var locations = [String]()
        
        // get all calendars
        let calendars = eventStore.calendarsForEntityType(EKEntityType.Event)
        
        // timerange = now to now + upcomingDays
        let dateStart: NSDate = NSDate()
        let dateEnd: NSDate = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: upcomingDays, toDate: dateStart, options: NSCalendarOptions(rawValue: 0))!
        
        // prepare the calendar request for events
        let predicate = eventStore.predicateForEventsWithStartDate(dateStart, endDate: dateEnd, calendars: calendars)
        let events = eventStore.eventsMatchingPredicate(predicate)
        
        for event in events {
            print(event)
            if event.location != "" {
                locations.append(event.location!)
            }
        }
        
        return locations
    }
    
    private func checkCalendarAuthorizationStatus() throws {
        let status = EKEventStore.authorizationStatusForEntityType(EKEntityType.Event)
        
        switch (status) {
            case EKAuthorizationStatus.NotDetermined:
                // This happens on first-run
                throw CalendarError.PermissionNotDetermined            
            case EKAuthorizationStatus.Restricted, EKAuthorizationStatus.Denied:
                // We need to help them give us permission
                throw CalendarError.PermissionDenied
            case EKAuthorizationStatus.Authorized:
                break
                //return without Exception -> everything OK
        }
    }
}