//
//  CalEvent.swift
//  CalendarScan
//
//  Created by Alexander on 26/05/15.
//  Copyright (c) 2015 marsbroshok. All rights reserved.
//

import Foundation
class EventEntity {
    var persons:[String] = [""]
    var organization: String = ""
    var address: String = ""
    var rawText: String = ""
    var date: NSDate! = NSDate()
    
    init () {}
    
    init (date:NSDate, rawText:String) {
        self.rawText = rawText
        self.date = date
    }
}