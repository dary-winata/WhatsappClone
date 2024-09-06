//
//  DateUtils.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 06/09/24.
//

import Foundation

func timeElapsed(_ date: Date) -> String {
    let second = Date().timeIntervalSince(date)
    
    var elapsed: String = ""
    
    if second < 60 {
        elapsed = "Just Now"
    } else if second < 60 * 60 {
        let minute = Int(second/60)
        let minuteText = minute > 1 ? "Mins" : "Min"
        elapsed = "\(minute) \(minuteText) Ago"
    } else if second < 24 * 60 * 60 {
        let days = Int(second/(60*60))
        let daysText = days > 1 ? "Days" : "Day"
        elapsed = "\(days) \(daysText) Ago"
    } else {
        elapsed = date.longDate()
    }
    
    return elapsed
}
