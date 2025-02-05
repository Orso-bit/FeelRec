//
//  DateFormatter.swift
//  FeelRec2
//
//  Created by Giovanni Jr Di Fenza on 01/02/25.
//

import Foundation

struct DateFormatter {
    static func currentTime() -> String {
        let date = Date()
        let calendar = Calendar.current
        
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        
        let formattedHour = String(format: "%02d", hour)
        let formattedMinute = String(format: "%02d", minute)
        
        return "\(day)/\(month)/\(year) \(formattedHour):\(formattedMinute)"
    }
    
    static func formattedDate(_ date: Date) -> String {
        let formatter = Foundation.DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        return formatter.string(from: date)
    }
}
