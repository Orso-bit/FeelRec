//
//  AddData.swift
//  ProjectML
//
//  Created by Giovanni Jr Di Fenza on 12/12/24.
//

import SwiftUI

struct AddData: View {
    // Added ObservedObject to share data between views
    @ObservedObject var sleepModel: SleepModel
    @State private var week = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    @State private var selectedWeekDay: String?
    @State private var currentTime = Date() // Add this for time selection
    @Binding var isAdding: Bool
    
    var body: some View {
        NavigationStack {
                Form {
                    Section("Days of the Week") {
                        ForEach(week, id: \.self) { day in
                            Button(action: {
                                selectedWeekDay = day
                            }) {
                                HStack {
                                    Text(day)
                                    Spacer()
                                    if selectedWeekDay == day {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                            .foregroundColor(.primary)
                        }
                    }
                    
                    Section(header: Text("How much did you sleep?")) {
                        DatePicker(selectedWeekDay ?? "", selection: $currentTime, displayedComponents: .hourAndMinute)
                            .foregroundColor(.gray)
                            .onChange(of: currentTime) { newValue in
                                if let day = selectedWeekDay {
                                    sleepModel.updateSleepTime(for: day, time: newValue)
                            }
                        }
                    }
                    Section(header:
                                HStack {
                        Text("About Sleep")
                            .font(.system(size: 20))
                            .bold()
                        Image(systemName: "bed.double.fill")
                            .font(.system(size: 20))
                            .foregroundColor(Color.green)
                    }
                    )  {
                        InfoSleepView()
                    }
                }
            
            .navigationBarTitle("Sleep", displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    isAdding = false
                }) {
                    Text("Cancel")
                },
                trailing: Button("Save") {
                    isAdding = false
                }
            )
        }
    }
}

// Update preview
#Preview {
    AddData(sleepModel: SleepModel(), isAdding: .constant(true))
}
