//
//  Date+Extension.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 06/09/24.
//

import Foundation

extension Date {
    func longDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: self)
    }
    
    func timeDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        return dateFormatter.string(from: self)
    }
}
