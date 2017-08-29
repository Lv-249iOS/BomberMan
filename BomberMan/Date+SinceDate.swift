//
//  Date+SinceDate.swift
//  BomberMan
//
//  Created by Zhanna Moskaliuk on 8/29/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import Foundation

extension Date {
    
    func timeSince() -> String {
        let date = self
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.second, .minute, .hour, .day, .weekOfYear]
        let now = NSDate()
        let earliest = now.earlierDate(date as Date)
        let latest = (earliest == now as Date) ? date : now as Date
        
        let components = calendar.dateComponents(unitFlags, from: earliest as Date,  to: latest as Date)
        if (components.weekOfYear! >= 2) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMMM yyyy"
            let usLocale = Locale(identifier: "en_US")
            dateFormatter.locale = usLocale
            return dateFormatter.string(from: self)
        } else if (components.weekOfYear! >= 1) {
            return "1 week ago"
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1) {
            return "1 days ago"
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1) {
            return "1 hour ago"
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1) {
            return "1 minute ago"
        } else {
            return "just now"
        }
    }
    
}
