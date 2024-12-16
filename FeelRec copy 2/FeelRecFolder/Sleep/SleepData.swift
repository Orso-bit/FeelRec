//
//  SleepData.swift
//  ProjectML
//
//  Created by Giovanni Jr Di Fenza on 11/12/24.
//

import Foundation

struct SleepDataPoint: Identifiable {
    var id = UUID().uuidString
    var day: String
    var hours: Int
}
