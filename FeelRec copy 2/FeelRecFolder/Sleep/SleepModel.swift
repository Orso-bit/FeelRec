//
//  SleepModel.swift
//  ProjectML
//
//  Created by Giovanni Jr Di Fenza on 12/12/24.
//

import Foundation

class SleepModel: ObservableObject {
    // published is useful to make the var observable so when it changes, it will change in the other views with the name of observableobject  
    @Published var sleepTimes: [String: Date] = [:]
    
    func updateSleepTime(for day: String, time: Date) {
        sleepTimes[day] = time
    }
    
    func getSleepHours(for day: String) -> Double {
        guard let time = sleepTimes[day] else { return 0 }
        let components = Calendar.current.dateComponents([.hour, .minute], from: time)
        let hours = Double(components.hour ?? 0)
        let minutes = Double(components.minute ?? 0) / 60.0
        return hours + minutes
    }
}
