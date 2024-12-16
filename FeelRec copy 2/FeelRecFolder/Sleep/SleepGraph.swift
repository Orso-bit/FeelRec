//
//  SleepGraph.swift
//  ProjectML
//
//  Created by Giovanni Jr Di Fenza on 11/12/24.
//

import Charts
import SwiftUI

struct SleepGraph: View {
    @Binding var week: [String]
    @Binding var currentTime: Date
    @ObservedObject var sleepModel: SleepModel
    @State private var isAdding = false
    
    var data: [SleepDataPoint] {
        return week.map { day in
            SleepDataPoint(
                day: String(day.prefix(3)),
                // I'm calling the func in SleepModel after calling in var sleepModel
                hours: Int(sleepModel.getSleepHours(for: day))
            )
        }
    }
    var body: some View {
        ZStack {
            Color("Color 1")
                .ignoresSafeArea()
            ZStack {
                RoundedRectangle(cornerRadius: 13)
                    .foregroundStyle(Color.color)
                VStack {
                    HStack {
                        Text("Sleep")
                            .bold()
                            .offset(x: -90,y: 1)
                        Button("Add data") {
                            isAdding.toggle()
                        }
                        .backgroundStyle(Color.color)
                        .popover(isPresented: $isAdding) {
                            AddData(sleepModel: sleepModel, isAdding: $isAdding)
                        }
                        .offset(x: 90,y: 1)
                    }
                    Divider()
                        .frame(width: 350)
                        .offset(y: 3)
                    Chart {
                        ForEach(data) { d in
                            BarMark(x: PlottableValue.value("Day", d.day), y: PlottableValue.value("Hours", d.hours))
                                .foregroundStyle(Color.color2)
                        }
                    }
                    .frame(width: 300, height: 200)
                    .padding()
                }
            }
            .frame(width: 350, height: 300)
            .padding()
        }
    }
}
struct SleepGraphPreview: View {
    @State private var week = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    @State private var currentTime = Date()
    @StateObject private var sleepModel = SleepModel()
    
    var body: some View {
        SleepGraph(week: $week, currentTime: $currentTime, sleepModel: sleepModel)
    }
}

#Preview {
    SleepGraphPreview()
}
