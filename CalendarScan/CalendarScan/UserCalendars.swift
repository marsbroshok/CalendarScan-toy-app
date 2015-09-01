//
//  UserCalendars.swift
//  CalendarScan
//
//  Created by Alexander on 26/05/15.
//  Copyright (c) 2015 marsbroshok. All rights reserved.
//

import Foundation
import EventKit
import EventKitUI


class UserCalendars  {
    var rawEvents = [EventEntity]()
    
    func getCalendarEvents() {
        let eventStore = EKEventStore()
        
        switch EKEventStore.authorizationStatusForEntityType(EKEntityType.Event){
            
        case .Authorized:
            extractEventEntityCalendarsOutOfStore(eventStore)
        case .Denied:
            displayAccessDenied()
        case .NotDetermined:
            self.displayAskAccess()
            eventStore.requestAccessToEntityType(EKEntityType.Event, completion:
                {[weak self] (granted: Bool, error: Optional<NSError>) -> Void in
                    if granted{
                        self!.extractEventEntityCalendarsOutOfStore(eventStore)
                    } else {
                        self!.displayAccessDenied()
                    }
                })
        case .Restricted:
            displayAccessRestricted()
        }
    }
    
    func extractEventEntityCalendarsOutOfStore(eventStore: EKEventStore){
        
        let calendarTypes = [
            "Local",
            "CalDAV",
            "Exchange",
            "Subscription",
            "Birthday",
        ]
        
        let calendars = eventStore.calendarsForEntityType(EKEntityType.Event) 
        
        for calendar in calendars{
            print("Calendar title = \(calendar.title)")
            print("Calendar type = \(calendarTypes[Int(calendar.type.rawValue)])")
            
            let color = UIColor(CGColor: calendar.CGColor)
            print("Calendar color = \(color)")
            
            if calendar.allowsContentModifications{
                print("This calendar allows modifications")
            } else {
                print("This calendar does not allow modifications")
            }
            
            readEventsFrom(calendar, fromEventStore: eventStore)
            
            print("--------------------------")
            
        }
        
    }
    
    func readEventsFrom(calendar: EKCalendar, fromEventStore:EKEventStore){
        // The event starts from today, right now
        let startDate = NSDate()
        let endDate = startDate.dateByAddingTimeInterval(24 * 60 * 60)
        
        // Create the predicate that we can later pass to the
        // event store in order to fetch the events
        let searchPredicate = fromEventStore.predicateForEventsWithStartDate(
            startDate,
            endDate: endDate,
            calendars: [calendar])
        
        // Fetch all the events
        if let events = fromEventStore.eventsMatchingPredicate(searchPredicate) as? [EKEvent] {
            if events.count == 0{
                print("No events could be found")
            } else {
                
                // Go through all the events and get their information
                for event in events
                {
                    print("Event title = \(event.title)")
                    print("Event location = \(event.location)")
                    print("Event notes = \(event.notes)")
                    print("Event start date = \(event.startDate)")
                    print("Event end date = \(event.endDate)")
                    var rawEvent = ""
                    rawEvent+="\(event.title). "
                    if let location = event.location { rawEvent+="\(location). " }
                    if let notes = event.notes { rawEvent+="\(notes). " }
                    let eventToParse = EventEntity(date: event.startDate, rawText: rawEvent)
                    self.rawEvents += [eventToParse]
                }
            }
        }
        
    }
    
    func displayAskAccess(){
        print("Ask for access to the event store is denied.")
    }
    
    func displayAccessDenied(){
        print("Access to the event store is denied.")
    }
    
    func displayAccessRestricted(){
        print("Access to the event store is restricted.")
    }
    
}