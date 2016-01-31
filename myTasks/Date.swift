//
//  Date.swift
//  myTasks
//
//  Created by Trevor Griffin on 12/23/15.
//  Copyright © 2015 TREVOR E GRIFFIN. All rights reserved.
//

import Foundation

class Date {
    
    class func from (year year:Int, month: Int, day: Int) -> NSDate {
        let components = NSDateComponents()
        components.year = year
        components.month = month
        components.day = day
        
        let gregorianCalendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)
        
        let date = gregorianCalendar!.dateFromComponents(components)
        
        return date!
    }
    
    class func dateToString(date internaldate: NSDate) -> String {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        
        
        let dateString = dateStringFormatter.stringFromDate(internaldate)
        
        return dateString
    }
    
    
}